import Foundation
import SwiftUI
import SwiftData

@MainActor final class GameViewModel: ObservableObject {
    @Published private(set) var world = World()
    @Published var error: String?
    @Published var loadFailure = false
    @Published var busy = false
    @Published var offlineSummary: String?
    @Published var showReport = false
    @Published var feedbackToken = 0
    @Published var active = true
    @Published private(set) var forecast: Money = 0
    private var forecastGeneration = 0
    private let store: SaveStore
    let feedback = FeedbackService()
    init(container: ModelContainer) {
        store = SaveStore(container: container)
        do { world = try store.load() ?? World(); try store.save(world); feedback.apply(world.settings); refreshForecast() }
        catch { loadFailure = true; self.error = error.localizedDescription }
    }
    func perform(sound: String = "purchase", _ action: (inout World) throws -> Void) {
        guard !busy, !loadFailure else { return }
        do {
            var copy = world; try action(&copy); try store.save(copy); world = copy
            refreshForecast(); feedback.apply(copy.settings); feedback.play(sound, settings: copy.settings)
        } catch { self.error = error.localizedDescription }
    }
    func sync(offline: Bool) async {
        guard !busy, !loadFailure, world.introComplete else { return }
        busy = true
        let initial = world; let now = Date()
        do {
            let result = try await Task.detached(priority: .userInitiated) { () -> (World, Int) in
                var copy = initial; var count = 0
                while true {
                    try Task.checkCancellation()
                    let n = try Engine.catchUp(&copy, now: now, offline: offline)
                    count += n; if n == 0 { break }
                }
                return (copy, count)
            }.value
            if result.1 > 0 {
                try store.save(result.0); world = result.0; refreshForecast()
                if offline {
                    let delta = result.0.cash - initial.cash
                    offlineSummary = "\(result.1) journée(s) simulée(s) · trésorerie \(euros(delta)). Rendement d’absence : \(Int(world.offlineYield * 100)) %, charges maintenues."
                    feedback.play("notification", settings: world.settings)
                }
            }
        } catch { self.error = error.localizedDescription }
        busy = false
    }
    func advance(days: Int = 1) async {
        guard !busy, !loadFailure else { return }
        busy = true; let initial = world; let now = Date()
        do {
            let result = try await Task.detached(priority: .userInitiated) { () -> World in
                var copy = initial; try Engine.manual(&copy, days: days, now: now); return copy
            }.value
            try store.save(result); world = result; refreshForecast(); feedbackToken += 1; showReport = true
            feedback.play("success", settings: world.settings)
        } catch { self.error = error.localizedDescription }
        busy = false
    }
    func finishIntro(name: String, avatar: String) {
        perform(sound: "success") { w in w.name = String(name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(30)); if w.name.isEmpty { w.name = "Alex" }; w.avatar = avatar; w.introComplete = true; w.lastSimulated = Date() }
    }
    func recover() {
        do { world = try store.recoverPrevious(); loadFailure = false; error = nil; refreshForecast() } catch { self.error = error.localizedDescription }
    }
    func reset() {
        guard !busy else { return }
        do { let fresh = World(); try store.save(fresh); world = fresh; refreshForecast(); loadFailure = false; error = nil; feedback.apply(fresh.settings); Task { _ = try? await feedback.notifications(enabled: false) } }
        catch { self.error = error.localizedDescription }
    }
    func setting(_ key: WritableKeyPath<Settings, Bool>, value: Bool) { perform(sound: "click") { $0.settings[keyPath: key] = value } }
    func setNotifications(_ enabled: Bool) async {
        do { let allowed = try await feedback.notifications(enabled: enabled); setting(\.notifications, value: allowed); if enabled && !allowed { error = "Les notifications ne sont pas autorisées. Vous pouvez les activer dans Réglages iOS." } }
        catch { self.error = error.localizedDescription }
    }
    func pause() { active = false; feedback.apply({ var s = world.settings; s.music = false; return s }()) }
    func resume() { active = true; feedback.apply(world.settings) }
    private func refreshForecast() {
        forecastGeneration += 1
        let generation = forecastGeneration; let snapshot = world
        Task {
            let estimate = await Task.detached(priority: .utility) { () -> Money in
                var copy = snapshot
                return (try? Engine.advance(&copy).profit) ?? 0
            }.value
            if generation == forecastGeneration { forecast = estimate }
        }
    }
    func value(_ amount: Money) -> String { euros(amount, compact: world.settings.compactNumbers) }
}
