import Foundation

public enum SocialActivity: String, Codable, CaseIterable, Identifiable, Sendable {
    case dating = "Site de rencontre", bar = "Aller au bar"
    public var id: String { rawValue }
}
public enum ActionOutcome: String, Codable, Sendable { case quiet, acquaintance, conversation, investor, foundMoney, opportunity }
public struct ActionRecord: Codable, Identifiable, Equatable, Sendable {
    public var id: Int; public var day: Int; public var activity: SocialActivity; public var outcome: ActionOutcome
    public var person: Int?; public var amount: Money; public var text: String
}
public struct LegacyPerson: Codable, Equatable, Sendable { public var id: Int; public var name: String; public var role: String }
public struct SocialState: Codable, Equatable, Sendable {
    public var legacyPeople: [LegacyPerson]?
    public var known: [Int]; public var budgetDay = 1; public var used = 0
    public var records: [ActionRecord] = []
    public init(known: [Int] = [0, 1, 2, 3]) { self.known = known }
}
extension Engine {
    public static func reservations(_ w: World, day: Int) -> Int { w.appointments.filter { $0.day == day }.count }
    public static func actionsRemaining(_ w: World) -> Int { max(0, 3 - (w.social.budgetDay == w.day ? w.social.used : 0) - reservations(w, day: w.day)) }
    static func useAction(_ w: inout World) {
        if w.social.budgetDay != w.day { w.social.budgetDay = w.day; w.social.used = 0 }
        w.social.used += 1
    }
    /// Fixed probability partitions; ineligible categories become quiet, never a hidden reroll.
    @discardableResult public static func socialAction(_ w: inout World, activity: SocialActivity) throws -> ActionRecord {
        guard actionsRemaining(w) > 0 else { throw GameError.invalid("Vous avez utilisé ou réservé vos trois actions du jour.") }
        let id = w.identifier(); useAction(&w)
        let roll = sample(seed: w.seed, day: w.day, salt: id)
        var outcome: ActionOutcome
        if activity == .dating { outcome = roll < 0.40 ? .quiet : roll < 0.85 ? .acquaintance : roll < 0.95 ? .conversation : .opportunity }
        else { outcome = roll < 0.40 ? .quiet : roll < 0.70 ? .acquaintance : roll < 0.80 ? .conversation : roll < 0.90 ? .investor : roll < 0.95 ? .foundMoney : .opportunity }
        var person: Int?; var amount: Money = 0
        var text = activity == .bar ? "Une sortie tranquille. Rien de particulier aujourd’hui." : "Aucun nouvel échange cette fois. Prenez votre temps."
        switch outcome {
        case .acquaintance:
            let candidates = Catalog.people.filter { !w.social.known.contains($0.id) && $0.id >= 4 && $0.id != 4 }
            if !candidates.isEmpty {
                person = candidates[min(candidates.count - 1, Int(sample(seed: w.seed, day: w.day, salt: id + 800) * Double(candidates.count)))].id
                w.social.known.append(person!)
                text = "Vous faites connaissance avec \(w.personName(person!)). Un premier échange, une nouvelle histoire à construire."
            } else { outcome = .quiet }
        case .conversation:
            let eligible = activity == .dating ? w.social.known.filter { $0 >= 4 } : w.social.known
            if let p = eligible.first {
                person = p; w.relationships[p].trust = min(100, w.relationships[p].trust + 3)
                w.relationships[p].affinity = min(100, w.relationships[p].affinity + 3)
                text = "Une conversation agréable avec \(w.personName(p)). Confiance et affinité +3."
            } else { outcome = .quiet }
        case .investor:
            if !w.social.known.contains(4) {
                person = 4; w.social.known.append(4)
                text = "Sofia s’intéresse à votre projet. Vous échangez vos coordonnées. Un financement demandera un dossier et votre accord."
            } else { outcome = .quiet }
        case .foundMoney:
            amount = 100; credit(amount, in: &w); text = "Au retour du bar, vous trouvez 100 € par terre. Une petite chance dans votre nouveau départ."
        case .opportunity:
            let eventID = w.identifier()
            w.events.append(StoryEvent(id: eventID, key: "action-\(id)", day: w.day, title: activity == .bar ? "Une invitation du quartier" : "Un rendez-vous à préparer", text: "Votre échange ouvre une occasion de participer à la vie locale. Vous pouvez préparer votre réponse, discuter simplement ou décliner."))
            text = "Une nouvelle occasion vous attend dans Vie → Événements."
        case .quiet: break
        }
        if let person {
            let messageID = w.identifier(); w.messages.append(Message(id: messageID, person: person, day: w.day, text: "Ravi de notre échange. Au plaisir de prendre de vos nouvelles !"))
        }
        w.totalSocial += 1
        let record = ActionRecord(id: id, day: w.day, activity: activity, outcome: outcome, person: person, amount: amount, text: text)
        w.social.records.append(record); return record
    }
    static func validateRevision(_ w: World) throws {
        let plots = w.businesses.compactMap(\.plot)
        guard w.businesses.count <= 120, plots.count == w.businesses.count, Set(plots).count == plots.count,
              w.businesses.allSatisfy({ b in
                  Catalog.districts.indices.contains(b.districtID) && (b.districtID * 24..<(b.districtID + 1) * 24).contains(b.plot ?? -1) &&
                  (b.stockExpenses == nil || !b.stockExpenses!.isNaN && b.stockExpenses! >= 0 && b.stockExpenses! <= maximumBalance) &&
                  (b.supplyDay == nil || (1...10_000_100).contains(b.supplyDay!)) &&
                  (b.stockUnits == nil || (0...1_000_000_000).contains(b.stockUnits!)) && (b.supplyQuantity == nil || (1...1_000_000_000).contains(b.supplyQuantity!)) &&
                  (b.priceMultiplier == nil || b.priceMultiplier!.isFinite && (0.5...2).contains(b.priceMultiplier!)) &&
                  (0...23).contains(b.openingHour ?? w.opening) && (1...24).contains(b.closingHour ?? w.closing) && (b.openingHour ?? w.opening) < (b.closingHour ?? w.closing)
              }),
              [w.settings.musicVolume, w.settings.effectsVolume, w.settings.ambienceVolume].compactMap { $0 }.allSatisfy({ $0.isFinite && (0...1).contains($0) }),
              w.messages.allSatisfy({ w.social.known.contains($0.person) }), w.appointments.allSatisfy({ w.social.known.contains($0.person) }),
              Set(w.social.known).count == w.social.known.count, [0, 1, 2, 3].allSatisfy(w.social.known.contains), w.social.known.allSatisfy(Catalog.people.indices.contains),
              (1...w.day).contains(w.social.budgetDay), (0...3).contains(w.social.used),
              Set(w.social.records.map(\.id)).count == w.social.records.count,
              w.social.records.allSatisfy({ (1...w.day).contains($0.day) && $0.id <= w.nextID && ($0.person == nil || w.social.known.contains($0.person!)) && $0.amount >= 0 && $0.amount <= 100 }),
              Set(w.ownedItems.map(\.id)).count == w.ownedItems.count,
              w.ownedItems.allSatisfy({ item in Catalog.luxuries.indices.contains(item.definition) && ShopCatalog.shops.contains(where: { $0.id == item.shop }) && item.paid >= 0 })
        else { throw GameError.invalid("Établissements ou données de la refonte invalides.") }
    }
}

extension World {
    public func person(_ id: Int) -> PersonDefinition {
        var p = Catalog.people[id]
        if let legacy = social.legacyPeople?.first(where: { $0.id == id }) { p.name = legacy.name; p.role = legacy.role }
        return p
    }
    public func personName(_ id: Int) -> String { person(id).name }
}
