import SwiftUI

struct CharacterView: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View {
        Screen {
            VStack(spacing: 16) {
                Portrait(person: game.portraitID, size: 180)
                Text(game.world.name).font(.largeTitle.bold())
                Text("Un nouveau départ. Votre propre histoire.").font(.subheadline).foregroundStyle(.secondary)
            }.frame(maxWidth: .infinity).padding(.vertical)
            Panel("Votre situation") {
                LineItem(label: "Date", value: "Jour \(game.world.day)")
                LineItem(label: "Trésorerie", value: game.value(game.world.cash))
                LineItem(label: "Fortune nette", value: game.value(game.world.netWorth))
                LineItem(label: "Dettes", value: game.value(game.world.debt))
                LineItem(label: "Réputation", value: "\(Int(game.world.reputation)) / 100")
                LineItem(label: "Statut social", value: "\(game.world.status)")
            }
            Panel("Ce que vous construisez") {
                LineItem(label: "Établissements", value: "\(game.world.businesses.count)")
                LineItem(label: "Propriétés", value: "\(game.world.properties.count)")
                LineItem(label: "Biens personnels", value: "\(game.world.collectionCount)")
                LineItem(label: "Contacts connus", value: "\(game.world.social.known.count)")
                LineItem(label: "Situation", value: game.world.partner.map { "\(game.world.married ? "Marié" : "En couple") · \(game.world.personName($0))" } ?? "Célibataire")
                LineItem(label: "Enfants", value: "\(game.world.children)")
            }
            Panel("Votre parcours") {
                LineItem(label: "Clients servis", value: "\(game.world.totalCustomers)")
                LineItem(label: "Bénéfices cumulés", value: game.value(game.world.lifetimeProfit))
                LineItem(label: "Objectifs obtenus", value: "\(Engine.goals(game.world).filter { game.world.claimed.contains($0.id) }.count)")
                LineItem(label: "Actions restantes", value: "\(Engine.actionsRemaining(game.world)) / 3")
                LineItem(label: "Actions réservées aujourd’hui", value: "\(Engine.reservations(game.world, day: game.world.day))")
            }
            NavigationLink { ActionsView() } label: { Label("Actions · une rencontre peut tout changer", systemImage: "sparkles").frame(maxWidth: .infinity) }
            HStack { NavigationLink("Finances") { StatisticsView() }; NavigationLink("Relations") { LifeView() } }
            NavigationLink("Personnaliser mon personnage") { SettingsView() }
        }.navigationTitle("Mon personnage").navigationBarTitleDisplayMode(.inline)
    }
}
struct ActionsView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var confirmation: SocialActivity?
    @State private var shown: ActionRecord?
    var body: some View {
        Screen {
            Panel {
                HStack { Text("Chaque rencontre commence par un pas.").font(.title2.bold()); Spacer(); Image(systemName: "sparkles").font(.largeTitle).foregroundStyle(Palette.mint) }
                LineItem(label: "Actions restantes", value: "\(Engine.actionsRemaining(game.world)) / 3")
                Text("Une action par tentative, même sans événement. Les points reviennent au prochain jour du jeu. Les rendez-vous déjà prévus réservent leurs points.").font(.caption).foregroundStyle(.secondary)
            }
            ForEach(SocialActivity.allCases) { activity in
                Panel {
                    HStack(spacing: 20) {
                        ZStack { Circle().fill((activity == .dating ? Color.pink : Color.orange).opacity(0.2)); Image(systemName: activity == .dating ? "heart.text.clipboard.fill" : "wineglass.fill").font(.system(size: 38)).foregroundStyle(activity == .dating ? .pink : .orange) }.frame(width: 84, height: 84)
                        VStack(alignment: .leading, spacing: 8) { Text(activity.rawValue).font(.title3.bold()); Text(activity == .dating ? "Des profils fictifs. Une vraie place dans votre histoire." : "Une conversation, une connaissance… ou une sortie tranquille.").font(.caption).foregroundStyle(.secondary) }
                    }
                    Text(activity == .dating ? "45 % nouvelle connaissance · 10 % conversation · 5 % opportunité · 40 % sans événement." : "30 % connaissance · 10 % conversation · 10 % investisseur · 5 % trouvaille de 100 € · 5 % opportunité · 40 % sans événement.").font(.caption).foregroundStyle(.secondary)
                    ActionButton(title: "\(activity == .dating ? "Chercher une rencontre" : "Sortir au bar") · 1 action", symbol: activity == .dating ? "heart.fill" : "door.left.hand.open", accent: activity == .dating ? .pink : .orange) { confirmation = activity }.disabled(Engine.actionsRemaining(game.world) == 0)
                }
            }
            Text("Activités gratuites, sans abonnement ni connexion. Une catégorie sans résultat éligible devient une sortie sans événement ; la rencontre d’un investisseur n’accorde aucun argent automatiquement.").font(.caption).foregroundStyle(.secondary)
            if let shown { outcome(shown) }
            if !game.world.social.records.isEmpty {
                Text("Vos dernières sorties").font(.title3.bold())
                ForEach(game.world.social.records.reversed().filter { $0.id != shown?.id }) { record in outcome(record) }
            }
        }.navigationTitle("Actions")
        .confirmationDialog(confirmation?.rawValue ?? "Confirmer", isPresented: Binding(get: { confirmation != nil }, set: { if !$0 { confirmation = nil } }), titleVisibility: .visible) {
            if let activity = confirmation {
                Button("Utiliser une action · gratuit") {
                    var record: ActionRecord?
                    let saved = game.perform(sound: "notification") { record = try Engine.socialAction(&$0, activity: activity) }
                    if saved { shown = record }; confirmation = nil
                }
            }
        } message: { Text("Le résultat n’est pas garanti. La tentative sera sauvegardée et ne pourra pas être relancée.") }
    }
    private func outcome(_ r: ActionRecord) -> some View {
        Panel("Jour \(r.day) · \(r.activity.rawValue)") {
            if let p = r.person { HStack { Portrait(person: p); Text(game.world.personName(p)).font(.headline) } }
            Text(r.text).font(.subheadline)
            if r.amount > 0 { Label("\(game.value(r.amount)) déjà crédités", systemImage: "checkmark.circle.fill").foregroundStyle(Palette.mint) }
        }
    }
}
