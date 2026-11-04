import SwiftUI
import Charts

struct HomeView: View {
    @EnvironmentObject private var game: GameViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        Screen {
            HStack {
                VStack(alignment: .leading, spacing: 6) { Text("CHAQUE JOUR COMPTE").font(.caption2.weight(.bold)).tracking(2).foregroundStyle(Palette.accent); Text("À vous de jouer, \(game.world.name). ").font(.title2.weight(.bold)) }
                Spacer(); Portrait(person: game.portraitID, size: 52)
            }
            Panel {
                HStack { Label("TRÉSORERIE", systemImage: "wallet.bifold.fill").font(.caption.weight(.semibold)).tracking(1).foregroundStyle(.secondary); Spacer(); Text("JOUR \(game.world.day)").font(.caption.weight(.bold)).padding(8).background(Palette.accent.opacity(0.16), in: Capsule()) }
                Text(game.value(game.world.cash)).font(.system(size: 43, weight: .semibold, design: .rounded)).minimumScaleFactor(0.4).lineLimit(1)
                HStack { Text(game.world.gameDate, format: .dateTime.day().month(.wide).year()); Spacer(); Label("30 min = 1 jour", systemImage: "clock") }.font(.caption).foregroundStyle(.secondary)
                MoneyStack(token: game.feedbackToken, reduced: reduceMotion || game.world.settings.reducedMotion) { Task { await game.advance() } }
                Text("Le prochain service commence ici.").font(.subheadline).foregroundStyle(.secondary).frame(maxWidth: .infinity)
                ActionButton(title: "Passer au lendemain", symbol: "sunrise.fill") { Task { await game.advance() } }
                HStack { Button("Avancer 7 jours") { Task { await game.advance(days: 7) } }; Spacer(); NavigationLink("Historique") { ReportView() } }.font(.caption)
            }
            Panel {
                HStack { Metric(label: "Fortune nette", value: game.value(game.world.netWorth), symbol: "diamond"); Metric(label: "Bénéfice prévu", value: game.value(game.forecast)) }
                Divider()
                HStack { Metric(label: "Entreprises", value: "\(game.world.businesses.count) établissements", symbol: "building.2"); Metric(label: "Réputation", value: "\(Int(game.world.reputation)) / 100", symbol: "star") }
            }
            NavigationLink { BusinessDetailView(id: 0) } label: {
                Panel {
                    HStack { IconBadge(symbol: Catalog.businesses[0].symbol, color: Palette.mint); VStack(alignment: .leading, spacing: 4) { Text("Tasty Crousty").font(.headline); Text("Votre point de départ. Votre première réussite.").font(.caption).foregroundStyle(.secondary) }; Spacer(); Image(systemName: "arrow.up.right") }
                    let lowest = game.world.ingredients.map(\.quantity).min() ?? 0
                    Label(lowest < 10 ? "Stocks bas · préparez le prochain service" : "Prêt pour le prochain service", systemImage: lowest < 10 ? "exclamationmark.triangle" : "checkmark.circle").font(.caption).foregroundStyle(lowest < 10 ? .orange : Palette.mint)
                }
            }.buttonStyle(.plain)
            if !game.world.boosts.isEmpty { Panel("Votre élan du moment") { ForEach(game.world.boosts) { b in LineItem(label: b.name, value: "+\(Int((b.factor - 1) * 100)) % · \(b.until - game.world.day) j") } } }
            let pending = game.world.events.filter { !$0.resolved }
            if !pending.isEmpty { Panel("Une occasion à saisir") { ForEach(pending.prefix(2)) { event in NavigationLink { EventDetailView(id: event.id) } label: { HStack { Text(event.title); Spacer(); Image(systemName: "chevron.right") }.font(.subheadline) } } } }
            HStack { NavigationLink { StatisticsView() } label: { Label("Finances", systemImage: "chart.xyaxis.line") }; Spacer(); NavigationLink { GoalsView() } label: { Label("Objectifs", systemImage: "flag.fill") } }.font(.subheadline).padding(.horizontal, 8)
            Text("Pas de prestige. Chaque progrès reste le vôtre.").font(.caption).foregroundStyle(.secondary).frame(maxWidth: .infinity)
        }.navigationTitle("Votre nouveau départ").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { NavigationLink { SettingsView() } label: { Image(systemName: "slider.horizontal.3") }.accessibilityLabel("Paramètres") } }
    }
}
struct ReportView: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View {
        Screen {
            if game.world.reports.isEmpty { ContentUnavailableView("Le premier jour vous attend", systemImage: "sunrise", description: Text("Terminez un service pour consulter son bilan.")) }
            ForEach(game.world.reports.reversed()) { report in
                Panel("Jour \(report.id)\(report.offline ? " · absence" : "")") {
                    LineItem(label: "Chiffre d’affaires", value: game.value(report.revenue))
                    LineItem(label: "Dépenses d’exploitation", value: game.value(report.costs))
                    LineItem(label: "Dont commandes de stocks", value: game.value(report.stockPurchases))
                    LineItem(label: "Loyers", value: game.value(report.rent))
                    LineItem(label: "Récompense quotidienne", value: game.value(report.reward))
                    Divider(); LineItem(label: "Bénéfice net", value: game.value(report.profit))
                    LineItem(label: "Variation pendant la simulation", value: game.value(report.cashChange))
                    LineItem(label: "Solde de clôture", value: game.value(report.closing))
                    LineItem(label: "Clients servis", value: "\(report.customers)")
                    ForEach(Array(report.notes.enumerated()), id: \.offset) { _, text in Text(text).font(.caption).foregroundStyle(.secondary) }
                }
            }
        }.navigationTitle("Bilans quotidiens")
    }
}
struct StatisticsView: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View {
        Screen {
            Panel("L’histoire de votre trésorerie") {
                if game.world.reports.isEmpty { Text("Votre graphique apparaîtra après le premier service.").foregroundStyle(.secondary) }
                else { Chart(Array(game.world.reports.suffix(30))) { r in
                    AreaMark(x: .value("Jour", r.id), y: .value("Solde", number(r.closing))).foregroundStyle(Palette.accent.opacity(0.15))
                    LineMark(x: .value("Jour", r.id), y: .value("Solde", number(r.closing))).foregroundStyle(Palette.accent).interpolationMethod(.monotone)
                }.frame(height: 200).chartYAxis { AxisMarks(position: .leading) }.accessibilityLabel("Trésorerie des trente dernières journées") }
            }
            Panel("Votre fortune, en détail") {
                LineItem(label: "Trésorerie", value: game.value(game.world.cash)); LineItem(label: "Entreprises", value: game.value(game.world.businessValue))
                LineItem(label: "Immobilier", value: game.value(game.world.propertyValue)); LineItem(label: "Biens personnels", value: game.value(game.world.personalValue))
                LineItem(label: "Dettes", value: game.value(game.world.debt)); Divider(); LineItem(label: "Fortune nette", value: game.value(game.world.netWorth))
                Button("Rembourser les dettes avec le solde disponible") { game.perform { try Engine.repay(&$0) } }.disabled(game.world.debt <= 0 || game.world.cash <= 0)
            }
            Panel("Activité") {
                LineItem(label: "Bénéfices cumulés", value: game.value(game.world.lifetimeProfit)); LineItem(label: "Clients servis", value: "\(game.world.totalCustomers)")
                LineItem(label: "Commandes", value: "\(game.world.totalOrders)"); LineItem(label: "Synergies", value: "+\(Int((game.world.synergy - 1) * 100)) %")
                Text("Les achats de stocks sont payés à la commande puis rattachés au bilan du service, sans seconde déduction. La variation pendant la simulation exclut les actions préparatoires. Les investissements sont valorisés séparément. Fenêtre d’historique : 730 jours.").font(.caption).foregroundStyle(.secondary)
            }
        }.navigationTitle("Finances")
    }
}
struct GoalsView: View {
    @EnvironmentObject private var game: GameViewModel
    var body: some View { Screen {
        Panel("L’objectif du jour") { Text("Servir 15 clients").font(.title3.bold()); Text("10 € versés automatiquement à la clôture, une seule fois par journée.").font(.subheadline).foregroundStyle(.secondary) }
        ForEach(Engine.goals(game.world)) { goal in Panel {
            HStack { IconBadge(symbol: game.world.claimed.contains(goal.id) ? "checkmark.seal.fill" : "flag.fill"); VStack(alignment: .leading) { Text(goal.title).font(.headline); Text(goal.progress).font(.caption).foregroundStyle(.secondary) } }
            if game.world.claimed.contains(goal.id) { Label("Récompense obtenue", systemImage: "checkmark").foregroundStyle(Palette.mint) }
            else { Button("Recevoir \(game.value(goal.reward))") { game.perform(sound: "success") { try Engine.claim(&$0, key: goal.id) } }.disabled(!goal.complete) }
        } }
    }.navigationTitle("Objectifs & succès") }
}
