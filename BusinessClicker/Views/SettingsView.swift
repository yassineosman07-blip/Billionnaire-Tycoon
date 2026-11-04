import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var confirmReset = false
    @State private var name = ""
    private func binding(_ key: WritableKeyPath<Settings, Bool>) -> Binding<Bool> { Binding(get: { game.world.settings[keyPath: key] }, set: { game.setting(key, value: $0) }) }
    var body: some View {
        Screen {
            Panel("Votre personnage") {
                TextField("Prénom", text: $name).textFieldStyle(.roundedBorder)
                Button("Enregistrer le prénom") { game.perform(sound: "click") { w in let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines); guard !trimmed.isEmpty else { throw GameError.invalid("Saisissez un prénom.") }; w.name = String(trimmed.prefix(30)) } }
                HStack { ForEach(["person.crop.circle.fill", "person.crop.square.fill", "person.circle.fill"], id: \.self) { icon in Button { game.perform(sound: "click") { $0.avatar = icon } } label: { Image(systemName: icon).font(.title).foregroundStyle(game.world.avatar == icon ? Palette.mint : Palette.accent).padding(8) }.accessibilityLabel("Choisir le portrait \(icon)") } }
            }
            Panel("Audio & sensations") {
                Toggle("Musique d’ambiance", isOn: binding(\.music)); Toggle("Effets sonores", isOn: binding(\.sound)); Toggle("Vibrations", isOn: binding(\.haptics))
            }
            Panel("À votre rythme") {
                Toggle("Réduire les animations", isOn: binding(\.reducedMotion)); Toggle("Montants compacts", isOn: binding(\.compactNumbers))
                Toggle("Rappel quotidien à 19 h", isOn: Binding(get: { game.world.settings.notifications }, set: { enabled in Task { await game.setNotifications(enabled) } }))
                Text("L’heure suit le fuseau de votre iPhone. Les préférences de taille de texte et de réduction du mouvement d’iOS sont respectées.").font(.caption).foregroundStyle(.secondary)
            }
            Panel("Sauvegarde locale") {
                Label("Progression enregistrée après chaque action", systemImage: "externaldrive.fill.badge.checkmark").font(.subheadline)
                Text("SwiftData conserve votre partie sur cet iPhone. Aucun compte, serveur, publicité ou achat intégré. Une copie de l’état précédent permet la récupération en cas d’erreur de lecture.").font(.caption).foregroundStyle(.secondary)
                Button("Recommencer une partie", role: .destructive) { confirmReset = true }
            }
            Panel("Business Clicker · 1.0") { Text("Illustrations vectorielles, effets et ambiance créés pour ce projet. Noms et marques fictifs. La carte représente une ville imaginaire.").font(.caption).foregroundStyle(.secondary) }
        }.navigationTitle("Paramètres").onAppear { name = game.world.name }
            .confirmationDialog("Recommencer depuis Tasty Crousty ?", isPresented: $confirmReset, titleVisibility: .visible) {
                Button("Effacer la progression et recommencer", role: .destructive) { game.reset() }
            } message: { Text("Toutes vos entreprises, relations et acquisitions seront réinitialisées. Cette action est définitive dans le jeu.") }
    }
}
