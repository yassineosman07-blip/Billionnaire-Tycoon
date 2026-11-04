import Foundation

public typealias Money = Decimal
public func money(_ value: Double) -> Money { Decimal(string: String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), value)) ?? 0 }
public func cents(_ value: Money) -> Money {
    var input = value; var output = Decimal(); NSDecimalRound(&output, &input, 2, .bankers); return output
}
public func number(_ value: Money) -> Double { NSDecimalNumber(decimal: value).doubleValue }
public func euros(_ value: Money, compact: Bool = false) -> String {
    let n = number(value)
    if compact {
        for (limit, suffix) in [(1e12, " Bn€"), (1e9, " Md€"), (1e6, " M€"), (1e3, " k€")] where abs(n) >= limit {
            return String(format: "%.1f", locale: Locale(identifier: "fr_FR"), n / limit) + suffix
        }
    }
    let f = NumberFormatter(); f.numberStyle = .currency; f.locale = Locale(identifier: "fr_FR"); f.currencyCode = "EUR"
    return f.string(from: NSDecimalNumber(decimal: value)) ?? "— €"
}
/// Exponential progression indicator; ordinary accounts use Decimal and checked bounds.
public struct Magnitude: Codable, Equatable, Sendable {
    public var mantissa: Double
    public var exponent: Int
    public init(_ value: Double) {
        guard value.isFinite, value > 0 else { mantissa = 0; exponent = 0; return }
        exponent = Int(floor(log10(value))); mantissa = value / pow(10, Double(exponent))
    }
    public mutating func multiply(by factor: Double) {
        guard factor.isFinite, factor > 0, mantissa > 0 else { return }
        let log = log10(mantissa) + log10(factor)
        let shift = Int(floor(log)); mantissa = pow(10, log - Double(shift)); exponent += shift
    }
    public var label: String { String(format: "%.2f × 10^%d", mantissa, exponent) }
}
public struct District: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var popularity: Double; public var wealth: Double
    public var installation: Money; public var rent: Money; public var competition: Double; public var unlock: Money
}
public struct BusinessDefinition: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var sector: String; public var symbol: String
    public var price: Money; public var revenue: Money; public var costs: Money; public var unlock: Money
    public var district: Int
}
public struct Business: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var level = 1; public var employees = 0; public var training = 0
    public var manager = false; public var reputation = 10.0; public var lastRevenue: Money = 0; public var lastCosts: Money = 0
}
public struct Ingredient: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var unit: String; public var quantity: Int; public var unitCost: Money
    public var alert = 10; public var quality = 1.0
}
public struct Product: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var price: Money; public var referencePrice: Money
    public var recipe: [Int: Int]; public var popularity: Double; public var preparationMinutes: Int
    public var enabled = true
}
public struct Supplier: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var factor: Double; public var quality: Double
    public var delay: Int; public var minimum: Int; public var reliability: Double
}
public struct Order: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var ingredient: Int; public var quantity: Int; public var due: Int; public var cost: Money; public var supplier: Int
}
public struct PropertyDefinition: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var kind: String; public var district: Int; public var area: Int
    public var price: Money; public var marketRent: Money; public var charges: Money
}
public struct Property: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var acquired: Int; public var purchase: Money; public var askingRent: Money
    public var condition = 55.0; public var renovations = 0; public var occupied = false
    public var due: Int?; public var workStarted: Int?; public var renovationSpent: Money = 0
    public var rents: Money = 0; public var charges: Money = 0
}
public struct Sale: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var day: Int; public var purchase: Money
    public var renovation: Money; public var charges: Money; public var rents: Money; public var proceeds: Money
    public var profit: Money { proceeds + rents - purchase - renovation - charges }
}
public struct Luxury: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var category: String; public var symbol: String; public var price: Money
    public var status: Int
}
public struct PersonDefinition: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var name: String; public var role: String; public var personality: String
    public var preference: String; public var symbol: String; public var unlockDay: Int
}
public struct Relationship: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var trust: Int; public var affinity: Int; public var mood = 50; public var lastInteraction = -1
}
public struct Message: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var person: Int; public var day: Int; public var text: String; public var answered = false
}
public struct Appointment: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var person: Int; public var day: Int; public var prepared: Bool; public var resolved = false
}
public struct StoryEvent: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var key: String; public var day: Int; public var title: String; public var text: String
    public var resolved = false; public var choice: Int?; public var result: String?
}
public struct Boost: Codable, Identifiable, Equatable, Sendable { public var id: Int; public var name: String; public var until: Int; public var factor: Double }
public struct DailyReport: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var revenue: Money; public var costs: Money; public var rent: Money; public var reward: Money
    public var stockPurchases: Money = 0
    public var cashChange: Money; public var closing: Money; public var customers: Int; public var offline: Bool; public var notes: [String]
    public var profit: Money { revenue + rent + reward - costs }
}
public struct Settings: Codable, Equatable, Sendable {
    public var music = true; public var sound = true; public var haptics = true; public var reducedMotion = false
    public var compactNumbers = false; public var notifications = false
    public init() {}
}
public struct World: Codable, Equatable, Sendable {
    public var version = 1; public var seed: UInt64 = 28419; public var nextID = 1000
    public var name = "Alex"; public var avatar = "person.crop.circle.fill"; public var introComplete = false
    public var day = 1; public var cash: Money = 100; public var debt: Money = 0; public var reputation = 10.0
    public var lastSimulated: Date; public var offlineYield = 0.5
    public var opening = 11; public var closing = 19; public var supplier = 0
    public var businesses = [Business(id: 0)]; public var ingredients: [Ingredient]; public var products: [Product]
    public var pendingStockCosts: Money = 0
    public var orders: [Order] = []; public var properties: [Property] = []; public var sales: [Sale] = []
    public var luxuries: [Int] = []; public var relationships: [Relationship]; public var messages: [Message] = []
    public var appointments: [Appointment] = []; public var events: [StoryEvent] = []; public var boosts: [Boost] = []
    public var reports: [DailyReport] = []; public var claimed: [String] = []; public var settings = Settings()
    public var partner: Int?; public var married = false; public var children = 0; public var lastFamilyDay = -1
    public var totalCustomers = 0; public var totalOrders = 0; public var totalUpgrades = 0; public var totalSocial = 0
    public var innovation = 0; public var market = 0; public var lifetimeProfit: Money = 0
    public init(now: Date = Date()) {
        lastSimulated = now
        ingredients = [Ingredient(id: 0, name: "Poulet", unit: "portion", quantity: 20, unitCost: 1.2), Ingredient(id: 1, name: "Riz", unit: "portion", quantity: 30, unitCost: 0.4), Ingredient(id: 2, name: "Sauce", unit: "dose", quantity: 30, unitCost: 0.3), Ingredient(id: 3, name: "Légumes", unit: "portion", quantity: 20, unitCost: 0.6)]
        products = [Product(id: 0, name: "Crousty original", price: 8, referencePrice: 8, recipe: [0: 1, 1: 1, 2: 1], popularity: 1, preparationMinutes: 4), Product(id: 1, name: "Bowl du jardin", price: 7, referencePrice: 7, recipe: [1: 1, 2: 1, 3: 1], popularity: 0.8, preparationMinutes: 3)]
        relationships = Catalog.people.map { Relationship(id: $0.id, trust: $0.id < 2 ? 50 : 10, affinity: $0.id < 2 ? 45 : 10) }
        messages = [Message(id: 900, person: 0, day: 1, text: "Un nouveau départ ne se construit pas en un jour. Je crois en toi. Passe me voir demain ?")]
    }
    public mutating func identifier() -> Int { nextID += 1; return nextID }
    public var businessValue: Money { businesses.reduce(0) { $0 + Catalog.businesses[$1.id].price * money(pow(1.12, Double($1.level - 1))) } }
    public var propertyValue: Money { properties.reduce(0) { $0 + propertyValue($1) } }
    public func propertyValue(_ p: Property) -> Money { cents(Catalog.properties[p.id].price * money(1 + Double(p.renovations) * 0.16)) }
    public var personalValue: Money { luxuries.reduce(0) { $0 + Catalog.luxuries[$1].price } }
    public var netWorth: Money { cash + businessValue + propertyValue + personalValue - debt }
    public var gameDate: Date { Calendar(identifier: .gregorian).date(byAdding: .day, value: day - 1, to: Date(timeIntervalSince1970: 1767225600))! }
    public var status: Int { luxuries.reduce(0) { $0 + Catalog.luxuries[$1].status } }
    public var synergy: Double {
        let sectors = Set(businesses.map { Catalog.businesses[$0.id].sector })
        return 1 + (sectors.contains("Logistique") && sectors.contains("Restauration") ? 0.15 : 0) + (sectors.contains("Cloud") && sectors.contains("Technologie") ? 0.2 : 0) + (sectors.contains("Énergie") ? 0.08 : 0) + (businesses.contains { $0.id == 8 } ? 0.1 : 0)
    }
}
public enum GameError: Error, LocalizedError {
    case invalid(String), insufficientFunds, locked
    public var errorDescription: String? {
        switch self { case .invalid(let message): return message; case .insufficientFunds: return "Trésorerie insuffisante."; case .locked: return "Les conditions de déblocage ne sont pas encore remplies." }
    }
}
