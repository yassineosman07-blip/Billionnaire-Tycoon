import SwiftUI

struct EmpireView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var sector = "Tous"
    @State private var search = ""
    var filtered: [BusinessDefinition] { Catalog.businesses.filter { (sector == "Tous" || $0.sector == sector) && (search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)) } }
    var body: some View {
        Screen {
            Text("Une adresse. Puis une autre. Votre réseau grandit.").foregroundStyle(.secondary)
            Panel {
                HStack { Metric(label: "Votre réseau", value: "\(game.world.businesses.count) établissements", symbol: "building.2.fill"); Metric(label: "Synergies", value: "+\(Int((game.world.synergy - 1) * 100)) %", symbol: "link") }
                Text("Chaque adresse possède son équipe, ses stocks, ses prix et son résultat. Les cafés d’un même quartier partagent une partie de leur clientèle.").font(.caption).foregroundStyle(.secondary)
            }
            Picker("Secteur", selection: $sector) { Text("Tous les secteurs").tag("Tous"); ForEach(Array(Set(Catalog.businesses.map(\.sector))).sorted(), id: \.self) { Text($0).tag($0) } }
            ForEach(filtered) { d in
                Panel(d.name) {
                    let branches = game.world.businesses.filter { $0.definitionID == d.id }
                    HStack { IconBadge(symbol: d.symbol); VStack(alignment: .leading, spacing: 5) { Text(d.sector).font(.caption).foregroundStyle(.secondary); Text("\(branches.count) établissement(s)").font(.headline) } }
                    if !branches.isEmpty {
                        LineItem(label: "Résultat consolidé du dernier jour", value: game.value(branches.reduce(0) { $0 + $1.lastRevenue - $1.lastCosts }))
                        ForEach(branches) { b in NavigationLink { BusinessDetailView(id: b.id) } label: {
                            HStack { VStack(alignment: .leading) { Text(b.name).font(.subheadline.bold()); Text("\(Catalog.districts[b.districtID].name) · niveau \(b.level)").font(.caption).foregroundStyle(.secondary) }; Spacer(); Image(systemName: "chevron.right") }
                        }.buttonStyle(.plain) }
                    }
                    NavigationLink { OpenBusinessView(type: d.id) } label: { Label(branches.isEmpty ? "Ouvrir cet établissement" : "Ouvrir une nouvelle adresse", systemImage: "plus.circle.fill") }
                }
            }
            Panel("L’horizon continue") {
                LineItem(label: "Innovation permanente", value: "Niveau \(game.world.innovation) / 100")
                Button("Investir en R&D · \(game.value(money(1000 * pow(1.5, Double(game.world.innovation)))))") { game.perform { try Engine.innovate(&$0) } }.disabled(game.world.innovation >= 100)
                LineItem(label: "Marchés internationaux", value: "\(game.world.market) / 3")
                Text("Premier marché : 5 M€ de fortune nette et 250 000 € de frais. Les seuils suivants sont multipliés par dix.").font(.caption).foregroundStyle(.secondary)
                Button("Ouvrir un nouveau marché") { game.perform { try Engine.expand(&$0) } }.disabled(game.world.market >= 3)
            }
        }.navigationTitle("Votre empire").searchable(text: $search, prompt: "Type d’activité")
    }
}
struct OpenBusinessView: View {
    @EnvironmentObject private var game: GameViewModel
    @Environment(\.dismiss) private var dismiss
    let type: Int
    var suggestedDistrict: Int? = nil
    var suggestedPlot: Int? = nil
    @State private var district = 0
    @State private var plot = -1
    @State private var name = ""
    @State private var confirm = false
    private var d: BusinessDefinition { Catalog.businesses[type] }
    private var total: Money { d.price + Catalog.districts[district].installation + cents(d.price * 0.05) }
    var body: some View {
        Screen {
            Panel(d.name) {
                IconBadge(symbol: d.symbol)
                TextField("Nom de cette adresse", text: $name).textFieldStyle(.roundedBorder)
                Picker("Quartier", selection: $district) { ForEach(Catalog.districts) { Text($0.name).tag($0.id) } }
                Picker("Parcelle", selection: $plot) { Text("Choisir un emplacement").tag(-1); ForEach(Engine.availablePlots(game.world, district: district), id: \.self) { Text("Parcelle \($0 % 24 + 1)").tag($0) } }
                LineItem(label: "Acquisition", value: game.value(d.price)); LineItem(label: "Installation", value: game.value(Catalog.districts[district].installation))
                LineItem(label: "Fonds de roulement et stocks initiaux", value: game.value(cents(d.price * 0.05)))
                Divider(); LineItem(label: "Total à payer", value: game.value(total)); LineItem(label: "Solde après ouverture", value: game.value(game.world.cash - total))
                LineItem(label: "Fortune requise", value: game.value(max(d.unlock, Catalog.districts[district].unlock)))
                Text("Nouvelle équipe, niveau 1 et stocks propres. Chaque parcelle ne peut accueillir qu’un établissement. Les secteurs avancés nécessitent un marché international.").font(.caption).foregroundStyle(.secondary)
                ActionButton(title: "Confirmer l’ouverture", symbol: "building.2.fill") { confirm = true }.disabled(plot < 0 || game.world.cash < total)
            }
        }.navigationTitle("Une nouvelle adresse")
            .onAppear { district = suggestedDistrict ?? d.district; name = d.name; plot = suggestedPlot ?? Engine.availablePlots(game.world, district: district).first ?? -1 }
            .onChange(of: district) { _, value in let available = Engine.availablePlots(game.world, district: value); plot = suggestedPlot.flatMap { available.contains($0) ? $0 : nil } ?? available.first ?? -1 }
            .confirmationDialog("Ouvrir \(name) pour \(game.value(total)) ?", isPresented: $confirm, titleVisibility: .visible) {
                Button("Ouvrir et enregistrer") { if game.perform(sound: "success", { _ = try Engine.openBusiness(&$0, type: type, district: district, name: name, plot: plot) }) { dismiss() } }
            }
    }
}
struct BusinessDetailView: View {
    @EnvironmentObject private var game: GameViewModel
    let id: Int
    private var definition: BusinessDefinition { Catalog.businesses[business?.definitionID ?? id] }
    private var business: Business? { game.world.businesses.first { $0.id == id } }
    var body: some View {
        Screen {
            HStack { IconBadge(symbol: definition.symbol); VStack(alignment: .leading) { Text(definition.sector.uppercased()).font(.caption).tracking(2).foregroundStyle(Palette.accent); Text(Catalog.districts[business?.districtID ?? definition.district].name).font(.subheadline).foregroundStyle(.secondary) } }
            if let b = business {
                Panel("Un peu mieux, chaque jour") {
                    HStack { Metric(label: "Niveau", value: "\(b.level) / 100", symbol: "arrow.up.right"); Metric(label: "Valeur estimée", value: game.value(definition.price * money(pow(1.12, Double(b.level - 1)))), symbol: "diamond") }
                    ProgressView(value: Double(b.level), total: 100)
                    LineItem(label: "Dernier chiffre d’affaires", value: game.value(b.lastRevenue)); LineItem(label: "Dernières charges", value: game.value(b.lastCosts))
                    LineItem(label: "Réputation", value: "\(Int(b.reputation)) / 100")
                    ActionButton(title: b.level >= 100 ? "Niveau maximum atteint" : "Améliorer · \(game.value(Engine.upgradeCost(b)))", symbol: "arrow.up") { game.perform { try Engine.upgrade(&$0, id: id) } }.disabled(b.level >= 100)
                }
                if id == 0 { FoodTruckControls() } else { BranchControls(id: id) }
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
        }.navigationTitle(business?.name ?? definition.name).navigationBarTitleDisplayMode(.inline)
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

struct BranchControls: View {
    @EnvironmentObject private var game: GameViewModel
    let id: Int
    @State private var name = ""
    @State private var price = 1.0
    @State private var opening = 9
    @State private var closing = 17
    @State private var quantity = 40
    private var business: Business? { game.world.businesses.first { $0.id == id } }
    var body: some View {
        if let b = business {
            Panel("Cette adresse, vos décisions") {
                TextField("Nom", text: $name).textFieldStyle(.roundedBorder)
                Stepper("Tarif de référence ×\(price, specifier: "%.2f")", value: $price, in: 0.5...2, step: 0.05)
                Stepper("Ouverture : \(opening) h", value: $opening, in: 0...(closing - 1))
                Stepper("Fermeture : \(closing) h", value: $closing, in: (opening + 1)...24)
                Button("Enregistrer les paramètres") { game.perform { try Engine.configureBusiness(&$0, id: id, name: name, multiplier: price, opening: opening, closing: closing) } }
                Text("Un prix plus élevé réduit la demande. Chaque établissement possède une réserve indépendante de fournitures.").font(.caption).foregroundStyle(.secondary)
            }.onAppear { name = b.name; price = b.priceMultiplier ?? 1; opening = b.openingHour ?? 9; closing = b.closingHour ?? 17 }
            Panel("Réserve de cette adresse") {
                LineItem(label: "Unités disponibles", value: "\(b.stockUnits ?? 40)")
                if let due = b.supplyDay { Text("\(b.supplyQuantity ?? 0) unités commandées · livraison jour \(due)").font(.caption).foregroundStyle(Palette.mint) }
                else {
                    Stepper("Commande : \(quantity) unités", value: $quantity, in: 10...1000, step: 10)
                    Button("Commander · \(game.value(Engine.businessStockCost(b, quantity: quantity)))") { game.perform { try Engine.orderBusinessStock(&$0, id: id, quantity: quantity) } }
                }
                Text("Livraison au début du service du lendemain. Le manager commande automatiquement des fournitures si la trésorerie le permet.").font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
