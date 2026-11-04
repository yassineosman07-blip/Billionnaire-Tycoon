import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var confirmReset = false
    @State private var name = ""
    private func binding(_ key: WritableKeyPath<Settings, Bool>) -> Binding<Bool> { Binding(get: { game.world.settings[keyPath: key] }, set: { game.setting(key, value: $0) }) }
    private func volume(_ label: String, _ key: WritableKeyPath<Settings, Double?>, fallback: Double) -> some View {
        VStack(alignment: .leading) { Text(label).font(.caption).foregroundStyle(.secondary); Slider(value: Binding(get: { game.world.settings[keyPath: key] ?? fallback }, set: { value in game.perform(sound: "click") { $0.settings[keyPath: key] = value } }), in: 0...1, step: 0.05) }
    }
    var body: some View {
        Screen {
            Panel("Votre personnage") {
                TextField("Prénom", text: $name).textFieldStyle(.roundedBorder)
                Button("Enregistrer le prénom") { game.perform(sound: "click") { w in let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines); guard !trimmed.isEmpty else { throw GameError.invalid("Saisissez un prénom.") }; w.name = String(trimmed.prefix(30)) } }
                HStack { ForEach(["person.crop.circle.fill", "person.crop.square.fill", "person.circle.fill"], id: \.self) { icon in Button { game.perform(sound: "click") { $0.avatar = icon } } label: { Portrait(person: icon == "person.crop.square.fill" ? 20 : icon == "person.circle.fill" ? 24 : 33, size: 64).padding(3).overlay { if game.world.avatar == icon { RoundedRectangle(cornerRadius: 15).stroke(Palette.mint, lineWidth: 2) } } }.accessibilityLabel("Choisir le portrait \(icon)") } }
            }
            Panel("Audio & sensations") {
                Toggle("Musique d’ambiance", isOn: binding(\.music)); Toggle("Effets sonores", isOn: binding(\.sound)); Toggle("Vibrations", isOn: binding(\.haptics))
                Toggle("Ambiances des boutiques", isOn: Binding(get: { game.world.settings.shopAmbience ?? true }, set: { value in game.perform(sound: "click") { $0.settings.shopAmbience = value } }))
                volume("Volume musique", \.musicVolume, fallback: 0.25)
                volume("Volume effets", \.effectsVolume, fallback: 0.6)
                volume("Volume boutiques", \.ambienceVolume, fallback: 0.3)
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
            NavigationLink("Crédits des ressources") { MediaCreditsView() }
            Panel("Business Clicker · 1.2") { Text("Illustrations vectorielles, effets et ambiance créés pour ce projet. Noms et marques fictifs. La carte représente une ville imaginaire.").font(.caption).foregroundStyle(.secondary) }
        }.navigationTitle("Paramètres").onAppear { name = game.world.name }
            .confirmationDialog("Recommencer depuis Tasty Crousty ?", isPresented: $confirmReset, titleVisibility: .visible) {
                Button("Effacer la progression et recommencer", role: .destructive) { game.reset() }
            } message: { Text("Toutes vos entreprises, relations et acquisitions seront réinitialisées. Cette action est définitive dans le jeu.") }
    }
}
