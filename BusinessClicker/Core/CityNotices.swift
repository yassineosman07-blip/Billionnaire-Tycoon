import Foundation

public enum CityNoticeTarget: Equatable, Sendable { case business(Int), property(Int), event(Int) }
public struct CityNotice: Identifiable, Equatable, Sendable {
    public var id: String; public var title: String; public var symbol: String
    public var target: CityNoticeTarget; public var priority: Int
}
public struct DailyEventRoll: Codable, Equatable, Sendable {
    public var day: Int; public var event: Int?
}
public enum CityStatus {
    public static func notices(_ w: World) -> [CityNotice] {
        var result: [CityNotice] = []
        for b in w.businesses {
            let stock = b.id == 0 ? w.ingredients.map(\.quantity).min() ?? 0 : b.stockUnits ?? 40
            if stock < 10 {
                result.append(.init(id: "business-\(b.id)", title: stock == 0 ? "Stocks épuisés" : "Stocks bas", symbol: "shippingbox.fill", target: .business(b.id), priority: 0))
            } else if let day = b.supplyDay {
                result.append(.init(id: "business-\(b.id)", title: "Livraison J\(day)", symbol: "truck.box.fill", target: .business(b.id), priority: 2))
            } else if b.id == 0, let day = w.orders.map(\.due).min() {
                result.append(.init(id: "business-0", title: "Livraison J\(day)", symbol: "truck.box.fill", target: .business(0), priority: 2))
            }
        }
        for p in w.properties {
            if let due = p.due {
                result.append(.init(id: "property-\(p.id)", title: "Travaux · \(max(0,due-w.day)) j", symbol: "hammer.fill", target: .property(p.id), priority: 1))
            } else if w.reports.last?.notes.contains(where: { $0.contains("Travaux terminés") && $0.contains(Catalog.properties[p.id].name) }) == true {
                result.append(.init(id: "property-\(p.id)", title: "Travaux terminés", symbol: "checkmark.seal.fill", target: .property(p.id), priority: 1))
            } else if !p.occupied {
                result.append(.init(id: "property-\(p.id)", title: "À louer", symbol: "key.fill", target: .property(p.id), priority: 3))
            }
        }
        if let event = w.events.first(where: { !$0.resolved }) {
            result.append(.init(id: "event-\(event.id)", title: "Une opportunité", symbol: "sparkles", target: .event(event.id), priority: 1))
        }
        return result.sorted { $0.priority == $1.priority ? $0.id < $1.id : $0.priority < $1.priority }
    }
}
extension Engine {
    /// One saved roll per simulated day, including days on which nothing happens.
    @discardableResult public static func rollDailyEvent(_ w: inout World, probability: Double = 0.4) -> Int? {
        if let roll = w.dailyEventRolls.first(where: { $0.day == w.day }) { return roll.event }
        var eventID: Int?
        let eligible = Catalog.story.filter { definition in
            definition.eligible(w) && !w.events.contains { $0.key == "template-\(definition.id)" && (definition.oneShot || w.day-$0.day < 45) }
        }
        if probability.isFinite, sample(seed:w.seed,day:w.day,salt:770) < min(1,max(0,probability)), !eligible.isEmpty {
            let index = min(eligible.count-1,Int(sample(seed:w.seed,day:w.day,salt:771)*Double(eligible.count)))
            let definition=eligible[index];let id=w.identifier();eventID=id
            w.events.append(StoryEvent(id:id,key:"template-\(definition.id)",day:w.day,title:definition.title,text:definition.text))
        }
        w.dailyEventRolls.append(DailyEventRoll(day:w.day,event:eventID))
        if w.dailyEventRolls.count>730 { w.dailyEventRolls.removeFirst(w.dailyEventRolls.count-730) }
        return eventID
    }
}
