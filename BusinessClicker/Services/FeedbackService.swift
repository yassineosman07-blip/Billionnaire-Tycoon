import AVFoundation
import AudioToolbox
import UIKit
import UserNotifications

@MainActor final class FeedbackService {
    private var musicPlayer: AVAudioPlayer?
    private var ambiencePlayer: AVAudioPlayer?
    private var players: [String: AVAudioPlayer] = [:]
    private var shop: Int?
    private var lastEffect: TimeInterval = 0
    private var variation = 0
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        for name in ["click", "click1", "click2", "purchase", "success", "notification", "error", "enter"] {
            if let url = Bundle.main.url(forResource: name, withExtension: "wav"), let player = try? AVAudioPlayer(contentsOf: url) { player.prepareToPlay(); players[name] = player }
        }
    }
    func apply(_ settings: Settings) {
        if settings.music {
            if musicPlayer == nil, let url = Bundle.main.url(forResource: "ambience", withExtension: "wav") {
                musicPlayer = try? AVAudioPlayer(contentsOf: url); musicPlayer?.numberOfLoops = -1
            }
            musicPlayer?.setVolume(Float(settings.musicVolume ?? 0.25) * 0.4, fadeDuration: 0.2); musicPlayer?.play()
        } else { musicPlayer?.pause() }
        if settings.shopAmbience ?? true, shop != nil { ambiencePlayer?.setVolume(Float(settings.ambienceVolume ?? 0.3) * 0.45, fadeDuration: 0.2); ambiencePlayer?.play() }
        else { ambiencePlayer?.pause() }
    }
    func enterShop(_ id: Int, settings: Settings) {
        if shop != id {
            let previous = ambiencePlayer; previous?.setVolume(0, fadeDuration: 0.2)
            Task { try? await Task.sleep(for: .milliseconds(220)); previous?.stop() }
            shop = id
            if let url = Bundle.main.url(forResource: "shop-\(id / 2)", withExtension: "wav") {
                ambiencePlayer = try? AVAudioPlayer(contentsOf: url); ambiencePlayer?.numberOfLoops = -1; ambiencePlayer?.prepareToPlay()
            }
            play("enter", settings: settings)
        }
        apply(settings)
    }
    func leaveShop(settings: Settings) {
        shop = nil; let previous = ambiencePlayer; previous?.setVolume(0, fadeDuration: 0.2)
        Task { try? await Task.sleep(for: .milliseconds(220)); if shop == nil { previous?.pause() } }
    }
    func pause() { musicPlayer?.pause(); ambiencePlayer?.pause() }
    func play(_ name: String, settings: Settings) {
        let now = Date.timeIntervalSinceReferenceDate
        guard name != "click" || now - lastEffect > 0.055 else { return }; lastEffect = now
        if settings.haptics {
            if name == "error" { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
            else if name == "success" || name == "purchase" { UINotificationFeedbackGenerator().notificationOccurred(.success) }
            else { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
        }
        guard settings.sound else { return }
        let key: String
        if name == "click" { variation += 1; key = ["click", "click1", "click2"][variation % 3] } else { key = name }
        guard let player = players[key] else { return }
        player.volume = Float(settings.effectsVolume ?? 0.6); player.currentTime = 0; player.play()
    }
    func notifications(enabled: Bool) async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily"])
        guard enabled else { return false }
        guard try await center.requestAuthorization(options: [.alert, .sound]) else { return false }
        let content = UNMutableNotificationContent(); content.title = "Votre empire vous attend"; content.body = "Un nouveau service, une nouvelle occasion de grandir."
        var date = DateComponents(); date.hour = 19
        try await center.add(UNNotificationRequest(identifier: "daily", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: date, repeats: true)))
        return true
    }
}
