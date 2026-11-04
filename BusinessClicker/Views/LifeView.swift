import SwiftUI

struct LifeView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var selection = "Contacts"
    var body: some View {
        Screen {
            Text("La réussite se partage.").foregroundStyle(.secondary)
            Panel {
                HStack { IconBadge(symbol: game.world.avatar); VStack(alignment: .leading) { Text(game.world.name).font(.title3.bold()); Text(game.world.partner.map { "\(game.world.married ? "Marié avec" : "En couple avec") \(Catalog.people[$0].name)" } ?? "Un nouveau chapitre à écrire").font(.caption).foregroundStyle(.secondary) } }
                if game.world.children > 0 { Text("\(game.world.children) enfant(s) · dépenses familiales quotidiennes : \(game.value(Decimal(game.world.children * 8 + 3)))").font(.caption) }
                if !game.world.luxuries.isEmpty { HStack { ForEach(Array(game.world.luxuries.suffix(4)), id: \.self) { id in Image(systemName: Catalog.luxuries[id].symbol).foregroundStyle(Palette.accent).padding(10).background(Palette.accent.opacity(0.1), in: Circle()).accessibilityLabel(Catalog.luxuries[id].name) } } }
            }
            Picker("Vie", selection: $selection) { ForEach(["Contacts", "Messages", "Agenda", "Événements"], id: \.self) { Text($0).tag($0) } }.pickerStyle(.segmented)
            switch selection {
            case "Messages":
                ForEach(game.world.messages.reversed()) { message in
                    Panel(Catalog.people[message.person].name + " · jour \(message.day)") {
                        Text(message.text).font(.subheadline)
                        if message.answered { Label("Réponse envoyée", systemImage: "checkmark").font(.caption).foregroundStyle(Palette.mint) }
                        else { HStack { Button("Avec plaisir !") { game.perform(sound: "notification") { try Engine.reply(&$0, message: message.id, warm: true) } }; Spacer(); Button("Merci, à bientôt") { game.perform { try Engine.reply(&$0, message: message.id, warm: false) } } }.font(.caption) }
                    }
                }
            case "Agenda":
                if game.world.appointments.isEmpty { ContentUnavailableView("Du temps pour les autres", systemImage: "calendar", description: Text("Programmez une rencontre depuis une fiche de contact.")) }
                ForEach(game.world.appointments.sorted { $0.day > $1.day }) { appointment in Panel {
                    Label("\(Catalog.people[appointment.person].name) · jour \(appointment.day)", systemImage: appointment.resolved ? "checkmark.circle.fill" : "calendar").font(.headline)
                    Text(appointment.resolved ? "Rencontre terminée · consultez votre bilan." : (appointment.prepared ? "Dossier préparé. Vous mettez toutes les chances de votre côté." : "Rencontre spontanée. Le résultat dépendra de l’échange.")).font(.caption).foregroundStyle(.secondary)
                } }
            case "Événements":
                if game.world.events.isEmpty { ContentUnavailableView("La ville s’éveille", systemImage: "sparkles", description: Text("Les premières occasions se présenteront dès le troisième jour.")) }
                ForEach(game.world.events.reversed()) { event in NavigationLink { EventDetailView(id: event.id) } label: { Panel { HStack { Text(event.title).font(.headline); Spacer(); Image(systemName: event.resolved ? "checkmark.circle" : "chevron.right") }; Text(event.result ?? event.text).font(.caption).foregroundStyle(.secondary) } }.buttonStyle(.plain) }
            default:
                ForEach(Catalog.people) { person in
                    if person.unlockDay <= game.world.day { NavigationLink { PersonDetailView(id: person.id) } label: {
                        Panel { HStack { IconBadge(symbol: person.symbol, color: person.id < 2 ? Palette.mint : Palette.accent); VStack(alignment: .leading, spacing: 5) { Text(person.name).font(.headline); Text(person.role).font(.caption).foregroundStyle(.secondary) }; Spacer(); Text("\(game.world.relationships[person.id].affinity)").font(.subheadline.monospacedDigit()).foregroundStyle(Palette.accent); Image(systemName: "heart.fill").font(.caption).foregroundStyle(Palette.accent) } }
                    }.buttonStyle(.plain) }
                    else { HStack { Image(systemName: "lock.fill"); Text("Une rencontre à venir · jour \(person.unlockDay)") }.font(.caption).foregroundStyle(.secondary).padding(.horizontal) }
                }
            }
        }.navigationTitle("Votre vie")
    }
}
struct PersonDetailView: View {
    @EnvironmentObject private var game: GameViewModel
    let id: Int
    @State private var activity = "Repas"
    @State private var days = 1
    @State private var prepared = true
    var person: PersonDefinition { Catalog.people[id] }
    var relationship: Relationship { game.world.relationships[id] }
    var body: some View {
        Screen {
            Image(systemName: person.symbol).font(.system(size: 90)).foregroundStyle(Palette.accent).frame(maxWidth: .infinity).padding()
            Panel(person.role) {
                Text("\(person.personality) · aime : \(person.preference.lowercased())").foregroundStyle(.secondary)
                LineItem(label: "Confiance", value: "\(relationship.trust) / 100"); ProgressView(value: Double(relationship.trust), total: 100)
                LineItem(label: "Affinité", value: "\(relationship.affinity) / 100"); ProgressView(value: Double(relationship.affinity), total: 100).tint(Palette.mint)
                LineItem(label: "Humeur", value: "\(relationship.mood) / 100")
            }
            Panel("Un moment ensemble") {
                Picker("Activité", selection: $activity) { ForEach(["Repas", "Culture", "Sport", "Affaires"], id: \.self) { Text($0).tag($0) } }
                Button(relationship.lastInteraction == game.world.day ? "Vous vous êtes vus aujourd’hui" : "Partager un moment · 5 €") { game.perform { try Engine.interact(&$0, person: id, activity: activity) } }.disabled(relationship.lastInteraction == game.world.day)
                Text("Une interaction par jour. Respecter ses préférences renforce l’affinité.").font(.caption).foregroundStyle(.secondary)
            }
            Panel("Prendre rendez-vous") {
                Stepper("Dans \(days) jour(s)", value: $days, in: 1...30)
                Toggle("Préparer la rencontre · 15 €", isOn: $prepared)
                Button("Inscrire à l’agenda") { game.perform { try Engine.schedule(&$0, person: id, inDays: days, prepared: prepared) } }
            }
            if id >= 2 {
                Panel("Écrire une histoire ensemble") {
                    Text("Confiance 65 et affinité 70 requises. Une étape par journée. Le mariage coûte 500 €, accueillir un enfant 250 € ; les charges familiales sont quotidiennes.").font(.caption).foregroundStyle(.secondary)
                    Button(game.world.partner == nil ? "Proposer une vie de couple" : (game.world.married ? "Accueillir un enfant" : "Se marier")) { game.perform(sound: "success") { try Engine.family(&$0, person: id) } }.disabled(game.world.partner != nil && game.world.partner != id || game.world.children >= 5)
                }
            }
        }.navigationTitle(person.name)
    }
}
struct EventDetailView: View {
    @EnvironmentObject private var game: GameViewModel
    let id: Int
    var body: some View {
        Screen {
            if let event = game.world.events.first(where: { $0.id == id }) {
                Image(systemName: "sparkles").font(.system(size: 70)).foregroundStyle(Palette.accent).frame(maxWidth: .infinity).padding()
                Text(event.title).font(.largeTitle.bold()); Text("JOUR \(event.day)").font(.caption).tracking(2).foregroundStyle(.secondary)
                Panel { Text(event.text).font(.title3).lineSpacing(5)
                    if let result = event.result { Label(result, systemImage: "checkmark.seal.fill").font(.subheadline).foregroundStyle(Palette.mint) }
                    else {
                        ActionButton(title: "Préparer une réponse · \(game.value(event.participationCost))", symbol: "doc.text") { game.perform { try Engine.choose(&$0, event: id, option: 0) } }
                        Text(event.consequence).font(.caption).foregroundStyle(.secondary)
                        Button("Échanger simplement · gratuit") { game.perform { try Engine.choose(&$0, event: id, option: 1) } }
                        Text("Réputation +0,5.").font(.caption).foregroundStyle(.secondary)
                        Button("Décliner cette fois") { game.perform { try Engine.choose(&$0, event: id, option: 2) } }
                    }
                }
            }
        }.navigationTitle("Une nouvelle occasion").navigationBarTitleDisplayMode(.inline)
    }
}
