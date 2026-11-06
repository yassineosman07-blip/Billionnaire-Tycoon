import SwiftUI

struct EventPopupView: View {
    @EnvironmentObject private var game: GameViewModel
    let id: Int
    var body: some View {
        NavigationStack {
            Screen {
                if let event=game.world.events.first(where: { $0.id==id }) {
                    Label("UNE NOUVELLE OCCASION",systemImage:"sparkles").font(.caption.bold()).tracking(2).foregroundStyle(Palette.accent)
                    Text(event.title).font(.largeTitle.bold())
                    Text("Jour \(event.day)").font(.caption).foregroundStyle(.secondary)
                    Panel { Text(event.text).font(.title3).lineSpacing(5) }
                    if !event.resolved {
                        Panel("Votre décision") {
                            ActionButton(title:"Préparer · \(game.value(event.participationCost))",symbol:"doc.text",accent:.orange) { game.resolveEvent(id,option:0) }
                                .disabled(game.world.cash < event.participationCost).accessibilityIdentifier("event-paid-choice")
                            Text(event.consequence).font(.caption).foregroundStyle(.secondary)
                            Button("Échanger simplement · gratuit") { game.resolveEvent(id,option:1) }.accessibilityIdentifier("event-free-choice")
                            Text("Réputation +0,5").font(.caption).foregroundStyle(.secondary)
                            Button("Décliner") { game.resolveEvent(id,option:2) }.accessibilityIdentifier("event-decline")
                        }
                    } else { Text(event.result ?? "Décision enregistrée.") }
                }
            }.navigationTitle("Événement").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement:.confirmationAction) { Button("Plus tard") { game.activeEvent=nil }.accessibilityIdentifier("event-defer") } }
        }.accessibilityIdentifier("daily-event-popup")
    }
}
