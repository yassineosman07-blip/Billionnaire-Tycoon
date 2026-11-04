import SwiftUI

struct EmpireView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var sector = "Tous"
    @State private var search = ""
    var filtered: [BusinessDefinition] { Catalog.businesses.filter { (sector == "Tous" || $0.sector == sector) && (search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)) } }
    var body: some View {
        Screen {
            Text("D’un food truck à un monde de possibilités.").foregroundStyle(.secondary)
            Panel {
                HStack { Metric(label: "Votre empire", value: "\(game.world.businesses.count) entreprises", symbol: "building.2.fill"); Metric(label: "Synergies actives", value: "+\(Int((game.world.synergy - 1) * 100)) %", symbol: "link") }
                Text("Logistique + restauration : +15 % · Cloud + technologie : +20 % · Énergie : +8 % · Écho Publicité : +10 %.").font(.caption).foregroundStyle(.secondary)
            }
            Picker("Secteur", selection: $sector) { Text("Tous les secteurs").tag("Tous"); ForEach(Array(Set(Catalog.businesses.map(\.sector))).sorted(), id: \.self) { Text($0).tag($0) } }.pickerStyle(.menu)
            ForEach(filtered) { d in NavigationLink { BusinessDetailView(id: d.id) } label: {
                Panel {
                    HStack { IconBadge(symbol: d.symbol); VStack(alignment: .leading, spacing: 5) { Text(d.name).font(.headline); Text(d.sector + " · " + Catalog.districts[d.district].name).font(.caption).foregroundStyle(.secondary) }; Spacer() }
                    if let b = game.world.businesses.first(where: { $0.id == d.id }) {
                        HStack { Text("Niveau \(b.level)").font(.caption.weight(.semibold)).foregroundStyle(Palette.mint); Spacer(); Text("\(game.value(b.lastRevenue - b.lastCosts)) / dernier jour").font(.caption) }
                        ProgressView(value: Double(b.level), total: 100).tint(Palette.accent)
                    } else {
                        HStack { Text(game.value(d.price + Catalog.districts[d.district].installation)).font(.subheadline.bold()); Spacer(); Image(systemName: game.world.netWorth >= d.unlock && (d.id < 32 || game.world.market > 0) ? "arrow.up.right" : "lock.fill").foregroundStyle(.secondary) }
                    }
                }
            }.buttonStyle(.plain) }
            Panel("L’horizon continue") {
                LineItem(label: "Innovation permanente", value: "Niveau \(game.world.innovation) / 100")
                Button("Investir en R&D · \(game.value(money(1000 * pow(1.5, Double(game.world.innovation)))))") { game.perform { try Engine.innovate(&$0) } }.disabled(game.world.innovation >= 100)
                LineItem(label: "Marchés internationaux", value: "\(game.world.market) / 3")
                Text("Premier marché : 5 M€ de fortune nette, puis ×10. Coût de départ : 250 000 €, puis ×10. Les secteurs avancés nécessitent une expansion.").font(.caption).foregroundStyle(.secondary)
                Button("Ouvrir un nouveau marché") { game.perform { try Engine.expand(&$0) } }.disabled(game.world.market >= 3)
            }
        }.navigationTitle("Votre empire").searchable(text: $search, prompt: "Trouver une entreprise")
    }
}
struct BusinessDetailView: View {
    @EnvironmentObject private var game: GameViewModel
    let id: Int
    private var definition: BusinessDefinition { Catalog.businesses[id] }
    private var business: Business? { game.world.businesses.first { $0.id == id } }
    var body: some View {
        Screen {
            HStack { IconBadge(symbol: definition.symbol); VStack(alignment: .leading) { Text(definition.sector.uppercased()).font(.caption).tracking(2).foregroundStyle(Palette.accent); Text(Catalog.districts[definition.district].name).font(.subheadline).foregroundStyle(.secondary) } }
            if let b = business {
                Panel("Un peu mieux, chaque jour") {
                    HStack { Metric(label: "Niveau", value: "\(b.level) / 100", symbol: "arrow.up.right"); Metric(label: "Valeur estimée", value: game.value(definition.price * money(pow(1.12, Double(b.level - 1)))), symbol: "diamond") }
                    ProgressView(value: Double(b.level), total: 100)
                    LineItem(label: "Dernier chiffre d’affaires", value: game.value(b.lastRevenue)); LineItem(label: "Dernières charges", value: game.value(b.lastCosts))
                    LineItem(label: "Réputation", value: "\(Int(b.reputation)) / 100")
                    ActionButton(title: b.level >= 100 ? "Niveau maximum atteint" : "Améliorer · \(game.value(Engine.upgradeCost(b)))", symbol: "arrow.up") { game.perform { try Engine.upgrade(&$0, id: id) } }.disabled(b.level >= 100)
                }
                if id == 0 { FoodTruckControls() }
                Panel("Votre équipe") {
                    LineItem(label: "Employés · 12 €/jour chacun", value: "\(b.employees) / 30")
                    HStack { Button("Recruter · 60 €") { game.perform { try Engine.hire(&$0, id: id, manager: false) } }.disabled(b.employees >= 30); Spacer(); Button("Réduire l’équipe") { game.perform { try Engine.fire(&$0, id: id) } }.disabled(b.employees == 0) }
                    LineItem(label: "Formation", value: "\(b.training) / 10")
                    Button("Former · \(game.value(Decimal(100 * (b.training + 1))))") { game.perform { try Engine.train(&$0, id: id) } }.disabled(b.employees == 0 || b.training >= 10)
                    Divider()
                    if b.manager {
                        Label("Manager actif · 18 €/jour", systemImage: "person.badge.shield.checkmark.fill").foregroundStyle(Palette.mint)
                        Text(id == 0 ? "Commande automatiquement 40 portions au minimum, puis une quantité adaptée au niveau, quand un stock passe sous 20, si la trésorerie le permet. Les commandes sont livrées à leur date prévue." : "Supervise l’activité : productivité +10 %.").font(.caption).foregroundStyle(.secondary)
                        Button("Reprendre la gestion manuelle") { game.perform { w in if let index = w.businesses.firstIndex(where: { $0.id == id }) { w.businesses[index].manager = false } } }
                    } else { Button("Recruter un manager · 300 €") { game.perform { try Engine.hire(&$0, id: id, manager: true) } } }
                }
                Panel("Synergies") { Text("Multiplicateur global : ×\(game.world.synergy, specifier: "%.2f")").font(.headline); Text("Les complémentarités entre vos secteurs s’appliquent automatiquement. La recherche et les nouveaux marchés renforcent la croissance au-delà du niveau 100.").font(.caption).foregroundStyle(.secondary) }
            } else {
                Panel("Une nouvelle aventure") {
                    Text("Développez une activité dans le secteur \(definition.sector.lowercased()) et faites grandir votre présence à \(Catalog.districts[definition.district].name).")
                    LineItem(label: "Acquisition", value: game.value(definition.price)); LineItem(label: "Installation", value: game.value(Catalog.districts[definition.district].installation))
                    LineItem(label: "CA journalier de référence", value: game.value(definition.revenue)); LineItem(label: "Charges de référence", value: game.value(definition.costs + Catalog.districts[definition.district].rent))
                    LineItem(label: "Fortune requise", value: game.value(definition.unlock))
                    if id >= 32 { Text("Une expansion internationale est requise.").font(.caption).foregroundStyle(.secondary) }
                    ActionButton(title: "Acquérir cette entreprise", symbol: "plus") { game.perform(sound: "success") { try Engine.buyBusiness(&$0, id: id) } }
                }
            }
        }.navigationTitle(definition.name).navigationBarTitleDisplayMode(.inline)
    }
}
struct FoodTruckControls: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var quantity = 20
    var body: some View {
        Panel("Votre menu") {
            ForEach(game.world.products) { product in
                VStack(alignment: .leading, spacing: 8) {
                    Toggle(product.name, isOn: Binding(get: { game.world.products[product.id].enabled }, set: { value in game.perform(sound: "click") { $0.products[product.id].enabled = value } }))
                    Stepper("Prix : \(game.value(product.price))", value: Binding(get: { number(game.world.products[product.id].price) }, set: { value in game.perform(sound: "click") { $0.products[product.id].price = money(value) } }), in: 1...100, step: 0.5)
                    LineItem(label: "Coût ingrédients / marge brute", value: "\(game.value(Engine.recipeCost(product, world: game.world))) / \(game.value(product.price - Engine.recipeCost(product, world: game.world)))")
                    Text(product.recipe.sorted(by: { $0.key < $1.key }).map { "\($0.value) × \(game.world.ingredients[$0.key].name)" }.joined(separator: " · ")).font(.caption).foregroundStyle(.secondary)
                    Text("Préparation : \(product.preparationMinutes) min · Popularité : \(Int(product.popularity * 100)) % · Satisfaction : \(Int(min(100, max(0, 90 * number(product.referencePrice / product.price))))) %").font(.caption).foregroundStyle(.secondary)
                }; Divider()
            }
        }
        Panel("Horaires du service") {
            Stepper("Ouverture : \(game.world.opening) h", value: Binding(get: { game.world.opening }, set: { value in game.perform(sound: "click") { $0.opening = value } }), in: 0...(game.world.closing - 1))
            Stepper("Fermeture : \(game.world.closing) h", value: Binding(get: { game.world.closing }, set: { value in game.perform(sound: "click") { $0.closing = value } }), in: (game.world.opening + 1)...24)
            Text("Un service plus long augmente la capacité et les charges. Les prix modifient la demande ; chaque vente consomme réellement ses ingrédients.").font(.caption).foregroundStyle(.secondary)
        }
        Panel("Stocks & fournisseurs") {
            Picker("Fournisseur", selection: Binding(get: { game.world.supplier }, set: { value in game.perform(sound: "click") { $0.supplier = value } })) { ForEach(Catalog.suppliers) { Text($0.name).tag($0.id) } }
            let supplier = Catalog.suppliers[game.world.supplier]
            Text("Livraison \(supplier.delay) j · minimum \(supplier.minimum) unités · fiabilité \(Int(supplier.reliability * 100)) % · qualité \(Int(supplier.quality * 100)) %").font(.caption).foregroundStyle(.secondary)
            Stepper("Quantité commandée : \(quantity)", value: $quantity, in: 10...200, step: 10)
            ForEach(game.world.ingredients) { ingredient in
                VStack(alignment: .leading, spacing: 6) {
                    HStack { Text(ingredient.name).fontWeight(.medium); Spacer(); Text("\(ingredient.quantity) \(ingredient.unit)s").foregroundStyle(ingredient.quantity < ingredient.alert ? .orange : Palette.mint) }
                    Button("Commander · \(game.value(ingredient.unitCost * Decimal(quantity) * money(supplier.factor)))") { game.perform { try Engine.order(&$0, ingredient: ingredient.id, quantity: quantity, supplier: supplier.id) } }.font(.caption)
                }
            }
            ForEach(game.world.orders) { order in Text("\(order.quantity) \(game.world.ingredients[order.ingredient].name) · livraison jour \(order.due)").font(.caption).foregroundStyle(.secondary) }
            if game.world.cash < 20 { Button("Avance de secours · 40 € à rembourser") { game.perform { try Engine.rescue(&$0) } }; Text("Une fois par jour, ajoutée aux dettes. Utilisez-la pour commander des portions et relancer votre activité.").font(.caption).foregroundStyle(.secondary) }
        }
    }
}
