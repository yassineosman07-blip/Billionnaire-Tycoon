import Foundation

public struct OwnedItem: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var definition: Int; public var shop: Int; public var paid: Money; public var day: Int
}
public struct ShopCategory: Identifiable, Sendable {
    public var id: Int; public var name: String; public var symbol: String; public var items: [Int]
}
public struct Shop: Identifiable, Sendable {
    public var id: Int; public var category: Int; public var name: String; public var subtitle: String
    public var theme: Int; public var priceFactor: Double
    public var offers: [Int] { ShopCatalog.categories[category].items.filter { $0 < 12 || $0 == 12 + id } }
    public func price(_ item: Int) -> Money { cents(Catalog.luxuries[item].price * money(priceFactor)) }
}
public enum ShopCatalog {
    public static let categories: [ShopCategory] = [
        .init(id: 0, name: "Concessionnaires", symbol: "car.fill", items: [3,7,12,13]),
        .init(id: 1, name: "Motos", symbol: "motorcycle.fill", items: [2,14,15]),
        .init(id: 2, name: "Bijouteries", symbol: "diamond.fill", items: [4,16,17]),
        .init(id: 3, name: "Horlogeries", symbol: "clock.fill", items: [1,18,19]),
        .init(id: 4, name: "Mode", symbol: "tshirt.fill", items: [0,20,21]),
        .init(id: 5, name: "Résidences", symbol: "house.fill", items: [5,9,22,23]),
        .init(id: 6, name: "Galeries", symbol: "paintpalette.fill", items: [6,24,25]),
        .init(id: 7, name: "Collections", symbol: "seal.fill", items: [8,26,27]),
        .init(id: 8, name: "Nautisme", symbol: "sailboat.fill", items: [10,28,29]),
        .init(id: 9, name: "Aviation", symbol: "airplane", items: [11,30,31])
    ]
    public static let shops: [Shop] = {
        let names = [["Garage Avenue", "Prestige Motors"], ["Atelier Sillage", "Route Libre"], ["Maison Aster", "Éclat Nocturne"], ["Orbe Atelier", "Temps Moderne"], ["Studio Urbain", "Maison Velours"], ["Habiter", "Rive d’Or Résidences"], ["Galerie Aube", "Cabinet Singularités"], ["Comptoir des Curieux", "Éditions Rares"], ["Escale Marine", "Ondine Yachts"], ["Altitude Aviation", "Horizon Executive"]]
        let moods = [["Béton clair · esprit urbain", "Lumière architecturale · sport & luxe"], ["Acier · atelier mécanique", "Bois · liberté & voyage"], ["Pierre claire · champagne", "Verre noir · rubis"], ["Bois · cuir · précision", "Acier · lumière froide"], ["Streetwear · néons", "Textiles · élégance"], ["Maisons de ville · lumière", "Résidences · raffinement"], ["Espace blanc · art contemporain", "Cabinet feutré · curiosités"], ["Vitrines · histoire", "Éditions · séries limitées"], ["Marina · horizon bleu", "Pont en teck · grand large"], ["Hangar · voyage", "Lounge · aviation privée"]]
        return (0..<20).map { .init(id: $0, category: $0 / 2, name: names[$0 / 2][$0 % 2], subtitle: moods[$0 / 2][$0 % 2], theme: $0, priceFactor: $0 % 2 == 0 ? 1 : 1.08) }
    }()
    public static func repeatable(_ item: Int) -> Bool { [0,1,5,8,9].contains { ShopCatalog.categories[$0].items.contains(item) } }
}
extension World {
    public func owns(_ definition: Int) -> Bool { luxuries.contains(definition) || ownedItems.contains { $0.definition == definition } }
    public var collectionCount: Int { luxuries.count + ownedItems.count }
}
extension Engine {
    @discardableResult public static func purchase(_ w: inout World, item: Int, shop id: Int) throws -> Int {
        guard let shop = ShopCatalog.shops.first(where: { $0.id == id }), shop.offers.contains(item) else { throw GameError.invalid("Article indisponible dans cette boutique.") }
        guard ShopCatalog.repeatable(item) || !w.owns(item) else { throw GameError.invalid("Cette pièce unique est déjà dans votre collection.") }
        let price = shop.price(item); try spend(price, in: &w)
        let identifier = w.identifier(); w.ownedItems.append(OwnedItem(id: identifier, definition: item, shop: id, paid: price, day: w.day)); return identifier
    }
}

extension Engine {
    public static func businessStockCost(_ b: Business, quantity: Int) -> Money { cents(Catalog.businesses[b.definitionID].revenue / 30 * Decimal(quantity) * 0.28) }
    public static func orderBusinessStock(_ w: inout World, id: Int, quantity: Int) throws {
        guard let i = w.businesses.firstIndex(where: { $0.id == id }), id != 0, (1...1_000_000_000).contains(quantity), w.businesses[i].supplyDay == nil else { throw GameError.invalid("Commande déjà en attente ou quantité invalide.") }
        let cost = businessStockCost(w.businesses[i], quantity: quantity); try spend(cost, in: &w)
        w.businesses[i].stockExpenses = (w.businesses[i].stockExpenses ?? 0) + cost
        w.businesses[i].supplyDay = w.day + 1; w.businesses[i].supplyQuantity = quantity
    }
}
