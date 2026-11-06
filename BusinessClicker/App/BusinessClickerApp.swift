import SwiftUI
import SwiftData
import SceneKit

enum GameRuntime {
    static var isUITesting: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("--ui-testing")
        #else
        return false
        #endif
    }
    @MainActor static func prepareScene(_ scene: SCNScene) -> SCNScene {
        guard isUITesting else { return scene }
        scene.rootNode.enumerateHierarchy { node,_ in
            let pose=node.presentation.transform
            node.removeAllActions();node.removeAllAnimations();node.transform=pose
        }
        scene.isPaused=true
        return scene
    }
}

@main struct BusinessClickerApp: App {
    private let container: ModelContainer?
    private let startupError: String?
    init() {
        do {
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-testing") {
                let folder = URL.applicationSupportDirectory.appendingPathComponent("UITests", isDirectory: true)
                try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
                let url = folder.appendingPathComponent("game.store")
                if ProcessInfo.processInfo.arguments.contains("--ui-testing-reset") {
                    for suffix in ["", "-wal", "-shm"] {
                        let file = URL(fileURLWithPath: url.path + suffix)
                        if FileManager.default.fileExists(atPath: file.path) { try FileManager.default.removeItem(at: file) }
                    }
                }
                let schema = Schema(versionedSchema: SaveSchemaV1.self)
                container = try ModelContainer(for: schema, migrationPlan: SaveMigrationPlan.self, configurations: [ModelConfiguration(schema: schema, url: url)])
                startupError = nil
                return
            }
            #endif
            container = try ModelContainer(for: Schema(versionedSchema: SaveSchemaV1.self), migrationPlan: SaveMigrationPlan.self)
            startupError = nil
        } catch { container = nil; startupError = error.localizedDescription }
    }
    var body: some Scene {
        WindowGroup {
            if let container { GameRoot(container: container).preferredColorScheme(.dark).tint(Palette.accent) }
            else { ContentUnavailableView("Sauvegarde indisponible", systemImage: "externaldrive.badge.exclamationmark", description: Text(startupError ?? "Impossible d’ouvrir les données locales. Relancez l’application sans supprimer ses données.")).preferredColorScheme(.dark) }
        }
    }
}
struct GameRoot: View {
    @StateObject private var game: GameViewModel
    @Environment(\.scenePhase) private var phase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var resetCorruptSave = false
    init(container: ModelContainer) { _game = StateObject(wrappedValue: GameViewModel(container: container)) }
    var body: some View {
        Group {
            if game.loadFailure {
                VStack(spacing: 24) {
                    ContentUnavailableView("Sauvegarde à récupérer", systemImage: "externaldrive.badge.exclamationmark", description: Text("Les données existantes sont conservées. Essayez la copie précédente."))
                    Button("Restaurer la copie précédente") { game.recover() }.buttonStyle(.borderedProminent)
                    Button("Recommencer une partie", role: .destructive) { resetCorruptSave = true }
                }
            } else if !game.world.introComplete { IntroductionView() }
            else {
                TabView {
                    NavigationStack { CityView().modifier(CharacterAccess()) }.tabItem { Label("Ville", systemImage: "building.2.crop.circle.fill") }
                    NavigationStack { EmpireView().modifier(CharacterAccess()) }.tabItem { Label("Empire", systemImage: "building.2.fill") }
                    NavigationStack { LifeView().modifier(CharacterAccess()) }.tabItem { Label("Vie", systemImage: "bubble.left.and.bubble.right.fill") }
                    NavigationStack { PatrimonyView().modifier(CharacterAccess()) }.tabItem { Label("Patrimoine", systemImage: "diamond.fill") }
                    NavigationStack { StatisticsView().modifier(CharacterAccess()) }.tabItem { Label("Finances", systemImage: "chart.xyaxis.line") }
                }.toolbarBackground(Palette.background, for: .tabBar)
            }
        }
        .environmentObject(game)
        .buttonStyle(ArcadeButtonStyle())
        .transaction { transaction in
            if reduceMotion || game.world.settings.reducedMotion || GameRuntime.isUITesting { transaction.animation = nil; transaction.disablesAnimations = true }
        }
        .confirmationDialog("Effacer la sauvegarde existante et recommencer ?", isPresented: $resetCorruptSave, titleVisibility: .visible) {
            Button("Effacer et recommencer", role: .destructive) { game.reset() }
        }
        .overlay { if game.busy { ZStack { Color.black.opacity(0.45).ignoresSafeArea(); ProgressView("Simulation en cours…").padding(24).background(Palette.surface, in: RoundedRectangle(cornerRadius: 20)) } } }
        .alert("Information", isPresented: Binding(get: { game.error != nil }, set: { if !$0 { game.error = nil } })) { Button("Compris") { game.error = nil } } message: { Text(game.error ?? "") }
        .alert("Pendant votre absence", isPresented: Binding(get: { game.offlineSummary != nil }, set: { if !$0 { game.offlineSummary = nil } })) { Button("Continuer") { game.offlineSummary = nil } } message: { Text(game.offlineSummary ?? "") }
        .sheet(isPresented: $game.showReport) { NavigationStack { ReportView().toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fermer") { game.showReport = false } } } }.environmentObject(game).preferredColorScheme(.dark) }
        .sheet(item: $game.activeEvent) { presentation in
            EventPopupView(id: presentation.id).environmentObject(game).preferredColorScheme(.dark)
        }
        .onChange(of: game.offlineSummary) { _, value in if value == nil { game.presentNextEvent() } }
        .onChange(of: game.showReport) { _, value in if !value { game.presentNextEvent() } }
        .task { await game.sync(offline: true) }
        .task {
            while !Task.isCancelled {
                do { try await Task.sleep(for: .seconds(15)) } catch { break }
                if game.active { await game.sync(offline: false) }
            }
        }
        .onChange(of: phase) { _, value in
            if value == .active { game.resume(); Task { await game.sync(offline: true) } }
            else { game.pause() }
        }
    }
}
