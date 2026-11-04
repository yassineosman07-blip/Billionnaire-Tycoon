import XCTest
#if canImport(BusinessClickerCore)
@testable import BusinessClickerCore
#else
@testable import BusinessClicker
#endif

final class SimulationTests: XCTestCase {
    let epoch = Date(timeIntervalSince1970: 1800000000)
    func rich() -> World { var w = World(now: epoch); w.cash = 1000000000000000; return w }
    func testInitialStateAndCatalog() throws {
        let w = World(now: epoch); try Engine.validate(w)
        XCTAssertEqual(w.cash, 100); XCTAssertEqual(w.businesses.map(\.id), [0]); XCTAssertEqual(Catalog.businesses.count, 40)
        XCTAssertTrue((30...50).contains(Catalog.people.count)); XCTAssertEqual(w.day, 1); XCTAssertEqual(w.debt, 0)
    }
    func testServiceConsumesRecipeAndPaysCharges() throws {
        var w = World(now: epoch); let rice = w.ingredients[1].quantity
        let r = try Engine.advance(&w)
        XCTAssertGreaterThan(r.revenue, 0); XCTAssertGreaterThan(r.customers, 0); XCTAssertLessThan(w.ingredients[1].quantity, rice)
        XCTAssertEqual(w.ingredients[1].quantity, rice - r.customers); XCTAssertGreaterThan(r.costs, 0)
        XCTAssertEqual(w.cash, 100 + r.revenue + r.reward - r.costs); XCTAssertEqual(w.day, 2)
    }
    func testEmptyStockCannotSell() throws {
        var w = World(now: epoch); for i in w.ingredients.indices { w.ingredients[i].quantity = 0 }
        let r = try Engine.advance(&w); XCTAssertEqual(r.customers, 0); XCTAssertEqual(r.revenue, 0); XCTAssertGreaterThan(r.costs, 0)
    }
    func testHigherPricesReduceDemand() throws {
        var a = rich(); var b = a
        for i in a.ingredients.indices { a.ingredients[i].quantity = 1000; b.ingredients[i].quantity = 1000 }
        for i in b.products.indices { b.products[i].price = 50 }
        let ra = try Engine.advance(&a); let rb = try Engine.advance(&b)
        XCTAssertGreaterThan(ra.customers, rb.customers)
    }
    func testDeterministicSimulation() throws {
        var a = rich(); var b = a
        for _ in 0..<100 { try Engine.advance(&a); try Engine.advance(&b) }
        XCTAssertEqual(a, b)
    }
    func testOrderIsPaidOnceAndDeliveredOnDate() throws {
        var w = rich(); let initial = w.ingredients[0].quantity
        w.products[0].enabled = false; w.products[1].enabled = false
        let cash = w.cash; try Engine.order(&w, ingredient: 0, quantity: 20, supplier: 0)
        XCTAssertEqual(w.cash, cash - 24); XCTAssertEqual(w.ingredients[0].quantity, initial)
        try Engine.advance(&w); XCTAssertEqual(w.ingredients[0].quantity, initial)
        try Engine.advance(&w); XCTAssertEqual(w.ingredients[0].quantity, initial + 20); XCTAssertTrue(w.orders.isEmpty)
        try Engine.advance(&w); XCTAssertEqual(w.ingredients[0].quantity, initial + 20)
    }
    func testInvalidAndUnaffordableOrdersDoNotSpend() {
        var w = World(now: epoch); let initial = w
        XCTAssertThrowsError(try Engine.order(&w, ingredient: 0, quantity: -1, supplier: 0)); XCTAssertEqual(w, initial)
        XCTAssertThrowsError(try Engine.order(&w, ingredient: 0, quantity: 1000, supplier: 0)); XCTAssertEqual(w, initial)
    }
    func testOfflineThreeHoursAndIdempotency() throws {
        var w = World(now: epoch); let now = epoch.addingTimeInterval(3 * 3600)
        XCTAssertEqual(try Engine.catchUp(&w, now: now, offline: true), 6); XCTAssertEqual(w.day, 7)
        let copy = w; XCTAssertEqual(try Engine.catchUp(&w, now: now, offline: true), 0); XCTAssertEqual(w, copy)
    }
    func testOfflineYieldDoesNotReduceExpenses() throws {
        var online = rich(); var offline = online
        let a = try Engine.advance(&online); let b = try Engine.advance(&offline, offline: true)
        XCTAssertEqual(b.revenue, a.revenue * 0.5); XCTAssertEqual(a.costs, b.costs); XCTAssertEqual(a.customers, b.customers)
        XCTAssertEqual(online.ingredients, offline.ingredients)
    }
    func testManualAutomaticCannotDoubleClaimAndPreservesFraction() throws {
        var w = World(now: epoch)
        let now = epoch.addingTimeInterval(1900)
        XCTAssertEqual(try Engine.catchUp(&w, now: now, offline: false), 1); XCTAssertEqual(w.lastSimulated, epoch.addingTimeInterval(1800))
        try Engine.manual(&w, days: 1, now: now); XCTAssertEqual(w.day, 3)
        XCTAssertEqual(try Engine.catchUp(&w, now: now, offline: true), 0)
        XCTAssertEqual(try Engine.catchUp(&w, now: now.addingTimeInterval(1799), offline: true), 0)
        XCTAssertEqual(try Engine.catchUp(&w, now: now.addingTimeInterval(1800), offline: true), 1)
    }
    func testClockRollbackDoesNotGrantIncome() throws {
        var w = World(now: epoch); let old = w
        XCTAssertEqual(try Engine.catchUp(&w, now: epoch.addingTimeInterval(-3600), offline: true), 0); XCTAssertEqual(w, old)
    }
    func testChunkedLongAbsenceMatchesWholeSimulation() throws {
        var a = rich(); var b = a; let now = epoch.addingTimeInterval(1800 * 800)
        while try Engine.catchUp(&a, now: now, offline: true, limit: 100) > 0 {}
        _ = try Engine.catchUp(&b, now: now, offline: true, limit: 1000)
        XCTAssertEqual(a, b); XCTAssertEqual(a.day, 801); XCTAssertEqual(a.reports.count, 730)
    }
    func testPurchaseUpgradeCapAndSynergy() throws {
        var w = rich(); try Engine.buyBusiness(&w, id: 9); XCTAssertEqual(w.synergy, 1.15, accuracy: 0.001)
        let before = w.cash; try Engine.upgrade(&w, id: 0); XCTAssertLessThan(w.cash, before); XCTAssertEqual(w.businesses[0].level, 2)
        w.businesses[0].level = 100; XCTAssertThrowsError(try Engine.upgrade(&w, id: 0))
        try Engine.buyBusiness(&w, id: 9); XCTAssertEqual(w.businesses.filter { $0.definitionID == 9 }.count, 2); XCTAssertThrowsError(try Engine.buyBusiness(&w, id: 39))
        try Engine.expand(&w); try Engine.buyBusiness(&w, id: 39)
    }
    func testManagerOrdersAndPaysSalary() throws {
        var w = rich(); for i in w.ingredients.indices { w.ingredients[i].quantity = 0 }
        try Engine.hire(&w, id: 0, manager: true); let first = try Engine.advance(&w)
        XCTAssertEqual(w.orders.count, 4); XCTAssertEqual(first.costs, 132)
        try Engine.advance(&w); XCTAssertTrue(w.orders.isEmpty); XCTAssertGreaterThan(w.totalCustomers, 0)
    }
    func testEmployeesTrainingAndDismissal() throws {
        var w = rich(); try Engine.hire(&w, id: 0, manager: false); try Engine.train(&w, id: 0)
        XCTAssertEqual(w.businesses[0].training, 1); let r = try Engine.advance(&w); XCTAssertEqual(r.costs, 26)
        try Engine.fire(&w, id: 0); XCTAssertEqual(w.businesses[0].employees, 0)
    }
    func testRenovationIsDelayedBoundedAndAppliedOnce() throws {
        var w = rich(); try Engine.buyProperty(&w, id: 0); let value = w.propertyValue
        try Engine.renovate(&w, id: 0); XCTAssertEqual(w.propertyValue, value); XCTAssertThrowsError(try Engine.renovate(&w, id: 0))
        XCTAssertThrowsError(try Engine.sellProperty(&w, id: 0))
        for _ in 0..<3 { try Engine.advance(&w) }; XCTAssertEqual(w.properties[0].renovations, 0)
        try Engine.advance(&w); XCTAssertEqual(w.properties[0].renovations, 1); XCTAssertGreaterThan(w.propertyValue, value)
        try Engine.advance(&w); XCTAssertEqual(w.properties[0].renovations, 1)
        w.properties[0].renovations = 5; XCTAssertThrowsError(try Engine.renovate(&w, id: 0))
    }
    func testExcessRentVacancyAndFixedCharges() throws {
        var w = rich(); try Engine.buyProperty(&w, id: 0); w.properties[0].occupied = true
        try Engine.setRent(&w, id: 0, rent: Catalog.properties[0].marketRent * 3)
        let report = try Engine.advance(&w)
        XCTAssertFalse(w.properties[0].occupied); XCTAssertEqual(report.rent, 0); XCTAssertEqual(w.properties[0].charges, Catalog.properties[0].charges)
    }
    func testRentBookedOnceAndSaleLedger() throws {
        var w = rich(); try Engine.buyProperty(&w, id: 0); w.properties[0].occupied = true
        let cash = w.cash; let r = try Engine.advance(&w)
        XCTAssertEqual(w.properties[0].rents, r.rent); XCTAssertEqual(w.cash, cash + r.profit)
        let property = w.properties[0]; try Engine.sellProperty(&w, id: 0)
        XCTAssertTrue(w.properties.isEmpty); XCTAssertEqual(w.sales[0].profit, w.sales[0].proceeds + property.rents - property.purchase - property.charges)
    }
    func testSocialInteractionsAppointmentsAndMessagesOnlyOnce() throws {
        var w = rich(); try Engine.interact(&w, person: 0, activity: "Repas"); XCTAssertThrowsError(try Engine.interact(&w, person: 0, activity: "Repas"))
        try Engine.reply(&w, message: 900, warm: true); XCTAssertThrowsError(try Engine.reply(&w, message: 900, warm: true))
        try Engine.schedule(&w, person: 0, inDays: 1, prepared: true)
        XCTAssertThrowsError(try Engine.schedule(&w, person: 0, inDays: 1, prepared: true))
        try Engine.advance(&w); XCTAssertFalse(w.appointments[0].resolved)
        try Engine.advance(&w); XCTAssertTrue(w.appointments[0].resolved)
        let trust = w.relationships[0].trust; try Engine.advance(&w); XCTAssertEqual(trust, w.relationships[0].trust)
    }
    func testFamilyRequiresTrustAndPersists() throws {
        var w = rich(); w.social.known.append(5); XCTAssertThrowsError(try Engine.family(&w, person: 5))
        w.relationships[5].trust = 80; w.relationships[5].affinity = 80
        try Engine.family(&w, person: 5); XCTAssertEqual(w.partner, 5)
        XCTAssertThrowsError(try Engine.family(&w, person: 5)); try Engine.advance(&w)
        try Engine.family(&w, person: 5); XCTAssertTrue(w.married); try Engine.advance(&w)
        try Engine.family(&w, person: 5); XCTAssertEqual(w.children, 1)
        XCTAssertEqual(try SaveCodec.decode(SaveCodec.encode(w)).children, 1)
    }
    func testEventAndGoalRewardsCannotRepeat() throws {
        var w = rich(); for _ in 0..<3 { try Engine.advance(&w) }
        let id = w.events[0].id; try Engine.choose(&w, event: id, option: 0)
        XCTAssertEqual(w.boosts.count, 1); XCTAssertThrowsError(try Engine.choose(&w, event: id, option: 0))
        try Engine.claim(&w, key: "first-service"); XCTAssertThrowsError(try Engine.claim(&w, key: "first-service"))
    }
    func testRescueAndDebtPreventPermanentLock() throws {
        var w = World(now: epoch); w.cash = 0
        try Engine.rescue(&w); XCTAssertEqual(w.cash, 40); XCTAssertEqual(w.debt, 40)
        XCTAssertThrowsError(try Engine.rescue(&w)); try Engine.order(&w, ingredient: 0, quantity: 10, supplier: 0)
        w.cash = 50; try Engine.repay(&w); XCTAssertEqual(w.debt, 0); XCTAssertEqual(w.cash, 10)
    }
    func testSaveRoundTripIncludingHistoryAndInvalidPayloads() throws {
        var w = rich(); try Engine.order(&w, ingredient: 0, quantity: 20, supplier: 0); try Engine.buyProperty(&w, id: 1)
        try Engine.renovate(&w, id: 1); try Engine.advance(&w)
        let data = try SaveCodec.encode(w); XCTAssertEqual(try SaveCodec.decode(data), w)
        XCTAssertThrowsError(try SaveCodec.decode(Data("{}".utf8)))
        w.cash = -1; XCTAssertThrowsError(try SaveCodec.encode(w))
        w = rich(); w.ingredients[0].quantity = -10; XCTAssertThrowsError(try Engine.validate(w))
        w = rich(); w.products[0].recipe = [99: 1]; XCTAssertThrowsError(try Engine.validate(w))
        w = rich(); w.businesses[0].id = 999; XCTAssertThrowsError(try Engine.validate(w))
    }
    func testManyBusinessesPropertiesAndHundredsOfDays() throws {
        var w = rich(); w.market = 1
        for id in 1..<40 { try Engine.buyBusiness(&w, id: id) }
        for id in 0..<16 { try Engine.buyProperty(&w, id: id); try Engine.renovate(&w, id: id) }
        for _ in 0..<400 { try Engine.advance(&w) }
        XCTAssertEqual(w.businesses.count, 40); XCTAssertEqual(w.properties.count, 16)
        XCTAssertTrue(w.properties.allSatisfy { $0.renovations == 1 }); try Engine.validate(w)
        XCTAssertEqual(try SaveCodec.decode(SaveCodec.encode(w)), w)
    }
    func testLargeMagnitudeAndAccountingBounds() throws {
        var m = Magnitude(1e200); m.multiply(by: 1e200); XCTAssertEqual(m.exponent, 400); XCTAssertTrue(m.mantissa.isFinite)
        var w = rich(); w.cash = Engine.maximumBalance; try Engine.advance(&w)
        XCTAssertLessThanOrEqual(w.cash, Engine.maximumBalance); try Engine.validate(w)
    }
    func testStockPurchasesAreReportedWithoutDoubleDeduction() throws {
        var w = rich(); let before = w.cash
        try Engine.order(&w, ingredient: 0, quantity: 20, supplier: 0)
        XCTAssertEqual(w.pendingStockCosts, 24)
        let r = try Engine.advance(&w)
        XCTAssertEqual(r.stockPurchases, 24); XCTAssertEqual(r.costs, 38)
        XCTAssertEqual(w.cash, before + r.profit)
        let next = try Engine.advance(&w); XCTAssertEqual(next.stockPurchases, 0)
    }
    func testStartingEconomyCanGrowWithoutInjectedCash() throws {
        var w = World(now: epoch)
        for _ in 0..<30 {
            for ingredient in w.ingredients where ingredient.quantity < 15 && !w.orders.contains(where: { $0.ingredient == ingredient.id }) {
                if w.cash >= ingredient.unitCost * 40 { try Engine.order(&w, ingredient: ingredient.id, quantity: 40, supplier: 0) }
            }
            try Engine.advance(&w)
            if w.totalCustomers >= 15 && !w.claimed.contains("first-service") { try Engine.claim(&w, key: "first-service") }
            if w.cash >= Catalog.businesses[1].price && w.businesses.count == 1 { try Engine.buyBusiness(&w, id: 1) }
        }
        XCTAssertEqual(w.businesses.count, 2); XCTAssertGreaterThan(w.cash, 100); XCTAssertEqual(w.debt, 0)
    }
    func testEventEligibilityCooldownAndInvestmentDebt() throws {
        var w = rich(); w.reputation = 50; w.social.known.append(4)
        let d = Catalog.story.first { $0.category == .investment }!
        XCTAssertTrue(d.eligible(w))
        let id = w.identifier(); w.events.append(StoryEvent(id: id, key: "template-\(d.id)", day: w.day, title: d.title, text: d.text))
        let oldCash = w.cash; try Engine.choose(&w, event: id, option: 0)
        XCTAssertEqual(w.cash, oldCash - d.cost + 500); XCTAssertEqual(w.debt, 500)
        for _ in 0..<60 { try Engine.advance(&w) }
        XCTAssertEqual(w.events.filter { $0.key == "template-\(d.id)" }.count, 1)
        var poor = World(); poor.reputation = 0
        XCTAssertFalse(d.eligible(poor)); XCTAssertFalse(Catalog.story.first { $0.requiresProperty }!.eligible(poor))
    }
    func testSupplierQualityAffectsDeliveredStock() throws {
        var w = rich(); for i in w.products.indices { w.products[i].enabled = false }
        w.ingredients[0].quantity = 0
        try Engine.order(&w, ingredient: 0, quantity: 20, supplier: 2)
        try Engine.advance(&w); try Engine.advance(&w); try Engine.advance(&w)
        XCTAssertEqual(w.ingredients[0].quality, 1.2, accuracy: 0.001)
    }
    func testCorruptReorderedIDsAreRejected() throws {
        var w = rich(); w.ingredients.swapAt(0, 1); XCTAssertThrowsError(try SaveCodec.encode(w))
        w = rich(); w.relationships.swapAt(0, 1); XCTAssertThrowsError(try SaveCodec.encode(w))
    }

}
