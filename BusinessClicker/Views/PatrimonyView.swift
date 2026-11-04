import SwiftUI

struct PatrimonyView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var selection = "Immobilier"
    @State private var category = "Tous"
    private var owned: [Property] { game.world.properties }
    var body: some View {
        Screen {
            Text("Construire. Habiter. Transmettre.").foregroundStyle(.secondary)
            Picker("Patrimoine", selection: $selection) { Text("Immobilier").tag("Immobilier"); Text("Collection").tag("Collection") }.pickerStyle(.segmented)
            if selection == "Immobilier" {
                Panel("Vos fondations") {
                    HStack { Metric(label: "Valeur du portefeuille", value: game.value(game.world.propertyValue), symbol: "building.2"); Metric(label: "Occupation", value: owned.isEmpty ? "—" : "\(owned.filter(\.occupied).count * 100 / owned.count) %", symbol: "key.fill") }
                    LineItem(label: "Loyers cumulés", value: game.value(owned.reduce(0) { $0 + $1.rents }))
                    LineItem(label: "Charges cumulées", value: game.value(owned.reduce(0) { $0 + $1.charges }))
                    LineItem(label: "Travaux en cours", value: "\(owned.filter { $0.due != nil }.count)")
                }
                ForEach(Catalog.properties) { d in NavigationLink { PropertyDetailView(id: d.id) } label: {
                    Panel {
                        HStack { IconBadge(symbol: "house.lodge.fill", color: owned.contains(where: { $0.id == d.id }) ? Palette.mint : Palette.accent); VStack(alignment: .leading, spacing: 5) { Text(d.name).font(.headline); Text("\(d.kind) · \(d.area) m² · \(Catalog.districts[d.district].name)").font(.caption).foregroundStyle(.secondary) } }
                        if let p = owned.first(where: { $0.id == d.id }) {
                            LineItem(label: p.due != nil ? "Travaux · jour \(p.due!)" : (p.occupied ? "Loué" : "Recherche de locataire"), value: game.value(game.world.propertyValue(p)))
                        } else { LineItem(label: "À vendre", value: game.value(d.price)); Text("Loyer de marché : \(game.value(d.marketRent)) / jour").font(.caption).foregroundStyle(.secondary) }
                    }
                }.buttonStyle(.plain) }
                ForEach(game.world.sales.reversed()) { sale in
                    Panel("Revente · \(sale.name)") {
                        LineItem(label: "Jour", value: "\(sale.day)"); LineItem(label: "Achat", value: game.value(sale.purchase))
                        LineItem(label: "Travaux", value: game.value(sale.renovation)); LineItem(label: "Charges cumulées", value: game.value(sale.charges))
                        LineItem(label: "Loyers perçus", value: game.value(sale.rents)); LineItem(label: "Revente nette", value: game.value(sale.proceeds))
                        Divider(); LineItem(label: "Résultat de l’investissement", value: game.value(sale.profit))
                    }
                }
            } else {
                Panel("Votre signature") {
                    HStack { Metric(label: "Collection", value: "\(game.world.collectionCount) objets", symbol: "diamond.fill"); Metric(label: "Statut social", value: "\(game.world.status)", symbol: "sparkles") }
                    NavigationLink { ShoppingDistrictView() } label: { Label("Entrer dans le quartier des boutiques", systemImage: "storefront.fill") }
                    NavigationLink { PersonalCollectionView() } label: { Label("Voir ma collection", systemImage: "diamond.fill") }
                }
                ForEach(ShopCatalog.categories) { category in NavigationLink { ShopCategoryView(category: category.id) } label: {
                    HStack { IconBadge(symbol: category.symbol, color: .orange); Text(category.name).font(.headline); Spacer(); Image(systemName: "chevron.right") }.padding(14).background(Palette.surface, in: RoundedRectangle(cornerRadius: 18))
                }.buttonStyle(.plain) }
            }
        }.navigationTitle("Votre patrimoine")
    }
}
struct PropertyDetailView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var confirmSale = false
    let id: Int
    private var d: PropertyDefinition { Catalog.properties[id] }
    private var property: Property? { game.world.properties.first { $0.id == id } }
    var body: some View {
        Screen {
            Image(systemName: "building.2.crop.circle.fill").font(.system(size: 100, weight: .ultraLight)).foregroundStyle(Palette.accent).frame(maxWidth: .infinity).padding(.vertical, 20)
            Panel("\(d.kind) · \(d.area) m²") {
                LineItem(label: "Quartier", value: Catalog.districts[d.district].name); LineItem(label: "Loyer de référence", value: game.value(d.marketRent))
                LineItem(label: "Entretien journalier", value: game.value(d.charges))
                if let p = property {
                    LineItem(label: "Valeur actuelle", value: game.value(game.world.propertyValue(p))); LineItem(label: "Acquisition", value: "Jour \(p.acquired) · \(game.value(p.purchase))")
                    LineItem(label: "État", value: "\(Int(p.condition)) / 100"); LineItem(label: "Rénovation", value: "\(p.renovations) / 5")
                } else {
                    LineItem(label: "Prix d’achat", value: game.value(d.price))
                    ActionButton(title: "Acheter ce bien", symbol: "key.fill") { game.perform(sound: "success") { try Engine.buyProperty(&$0, id: id) } }
                }
            }
            if let p = property {
                Panel("Gestion locative") {
                    Label(p.due != nil ? "Indisponible pendant les travaux" : (p.occupied ? "Un locataire est installé" : "Recherche automatique de locataire"), systemImage: p.occupied ? "person.fill.checkmark" : "key.fill").font(.subheadline).foregroundStyle(Palette.mint)
                    Stepper("Loyer : \(game.value(p.askingRent)) / jour", value: Binding(get: { number(property?.askingRent ?? 0) }, set: { value in game.perform(sound: "click") { try Engine.setRent(&$0, id: id, rent: money(value)) } }), in: 0...number(d.marketRent * 3), step: max(1, number(d.marketRent) * 0.1))
                    Text("Loyer conseillé après travaux : \(game.value(Engine.marketRent(p))). Un tarif excessif réduit l’occupation. Aucun loyer n’est perçu sans locataire.").font(.caption).foregroundStyle(.secondary)
                    LineItem(label: "Loyers cumulés", value: game.value(p.rents)); LineItem(label: "Charges cumulées", value: game.value(p.charges))
                    LineItem(label: "Revenu net cumulé", value: game.value(p.rents - p.charges))
                }
                Panel("Améliorer les lieux") {
                    if let due = p.due {
                        Text("Rénovation en cours · \(max(0, due - game.world.day)) jour(s) restant(s)").font(.headline)
                        ProgressView(value: Double(game.world.day - (p.workStarted ?? game.world.day)), total: Double(max(1, due - (p.workStarted ?? game.world.day))))
                        Text("Les bénéfices de la rénovation seront appliqués au début du service du jour \(due).").font(.caption).foregroundStyle(.secondary)
                    } else {
                        Text(["Peinture & rafraîchissement", "Cuisine & salle de bains", "Isolation & équipements", "Aménagement intérieur", "Rénovation complète", "Un bien d’exception"][p.renovations]).font(.headline)
                        Text("Durée : \(3 + p.renovations * 2) jours · valeur de base +16 %, loyer de base +10 % par rénovation terminée.").font(.caption).foregroundStyle(.secondary)
                        Button("Rénover · \(game.value(Engine.renovationCost(p)))") { game.perform { try Engine.renovate(&$0, id: id) } }.disabled(p.renovations >= 5)
                    }
                    LineItem(label: "Travaux payés", value: game.value(p.renovationSpent))
                }
                Panel("Arbitrer votre portefeuille") {
                    LineItem(label: "Revente nette estimée", value: game.value(game.world.propertyValue(p) * 0.95))
                    Text("5 % de frais de transaction. Le bilan complet sera conservé dans votre portefeuille.").font(.caption).foregroundStyle(.secondary)
                    Button("Vendre le bien", role: .destructive) { confirmSale = true }.disabled(p.due != nil)
                }
            }
        }.navigationTitle(d.name).navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Vendre définitivement ce bien ?", isPresented: $confirmSale, titleVisibility: .visible) { Button("Confirmer la vente", role: .destructive) { game.perform { try Engine.sellProperty(&$0, id: id) } } }
    }
}
