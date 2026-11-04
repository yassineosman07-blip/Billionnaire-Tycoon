import XCTest
#if canImport(BusinessClickerCore)
@testable import BusinessClickerCore
#else
@testable import BusinessClicker
#endif

final class RevisionTests: XCTestCase {
    let now = Date(timeIntervalSince1970: 1800000000)
    func rich() -> World { var w = World(now: now); w.cash = 1000000000000000; return w }
    func testInitialContactsAreExactlyTheFourRelatives() throws {
        let w = World(now: now)
        XCTAssertEqual(w.social.known, [0,1,2,3]); XCTAssertEqual(Catalog.people[2].role, "Frère"); XCTAssertEqual(Catalog.people[3].role, "Ex-femme")
        XCTAssertTrue(w.messages.allSatisfy { w.social.known.contains($0.person) }); try Engine.validate(w)
    }
    func testDaysAloneNeverCreateContacts() throws {
        var w = rich(); for _ in 0..<100 { try Engine.advance(&w) }
        XCTAssertEqual(w.social.known, [0,1,2,3]); XCTAssertTrue(w.messages.allSatisfy { w.social.known.contains($0.person) })
    }
    func testThreeActionsSharedByBothActivitiesAndFourthHasNoEffect() throws {
        var w = World(now: now)
        try Engine.socialAction(&w, activity: .dating); try Engine.socialAction(&w, activity: .bar); try Engine.socialAction(&w, activity: .dating)
        XCTAssertEqual(Engine.actionsRemaining(w), 0); let before = w
        XCTAssertThrowsError(try Engine.socialAction(&w, activity: .bar)); XCTAssertEqual(w, before)
        XCTAssertEqual(w.social.records.count, 3)
    }
    func testQuietResultsAlsoConsumeAnAction() throws {
        var quiet: World?
        for seed in 1...100 {
            var w = World(now: now); w.seed = UInt64(seed)
            if try Engine.socialAction(&w, activity: .dating).outcome == .quiet { quiet = w; break }
        }
        let w = try XCTUnwrap(quiet); XCTAssertEqual(Engine.actionsRemaining(w), 2); XCTAssertEqual(w.social.used, 1)
    }
    func testBudgetResetsWithoutAccumulatingOrOfflineActions() throws {
        var w = World(now: now); try Engine.socialAction(&w, activity: .bar)
        try Engine.advance(&w); XCTAssertEqual(Engine.actionsRemaining(w), 3)
        XCTAssertEqual(try Engine.catchUp(&w, now: now.addingTimeInterval(1800 * 6), offline: true), 6)
        XCTAssertEqual(w.social.records.count, 1); XCTAssertEqual(Engine.actionsRemaining(w), 3)
    }
    func testReservationsAndDirectInteractionsUseSameBudget() throws {
        var w = rich()
        try Engine.schedule(&w, person: 0, inDays: 1, prepared: true)
        try Engine.schedule(&w, person: 1, inDays: 1, prepared: true)
        try Engine.schedule(&w, person: 2, inDays: 1, prepared: true)
        XCTAssertThrowsError(try Engine.schedule(&w, person: 3, inDays: 1, prepared: true))
        try Engine.advance(&w); XCTAssertEqual(Engine.actionsRemaining(w), 0)
        XCTAssertThrowsError(try Engine.interact(&w, person: 0, activity: "Repas"))
        try Engine.advance(&w); XCTAssertTrue(w.appointments.allSatisfy(\.resolved)); XCTAssertEqual(Engine.actionsRemaining(w), 3)
        try Engine.interact(&w, person: 0, activity: "Repas"); XCTAssertEqual(Engine.actionsRemaining(w), 2)
    }
    func testUnknownContactsCannotBeUsedAndFamilyCannotBeRomanced() throws {
        var w = rich()
        XCTAssertThrowsError(try Engine.interact(&w, person: 5, activity: "Repas"))
        XCTAssertThrowsError(try Engine.schedule(&w, person: 5, inDays: 1, prepared: false))
        for p in 0...3 { w.relationships[p].affinity = 100; w.relationships[p].trust = 100; XCTAssertThrowsError(try Engine.family(&w, person: p)) }
    }
    func testRandomActionsDeterministicAndSavedResultsNotReplayed() throws {
        var a = World(now: now); var b = a
        let r = try Engine.socialAction(&a, activity: .bar)
        XCTAssertEqual(r, try Engine.socialAction(&b, activity: .bar)); XCTAssertEqual(a, b)
        let loaded = try SaveCodec.decode(SaveCodec.encode(a)); XCTAssertEqual(loaded, a)
        XCTAssertEqual(Engine.actionsRemaining(loaded), 2); XCTAssertEqual(loaded.social.records, [r])
    }
    func testBarProbabilitiesAndInvestorIsNotFreeFunding() throws {
        var counts: [ActionOutcome: Int] = [:]
        for seed in 1...5000 {
            var w = World(now: now); w.seed = UInt64(seed)
            let r = try Engine.socialAction(&w, activity: .bar); counts[r.outcome, default: 0] += 1
            if r.outcome == .foundMoney { XCTAssertEqual(w.cash, 200); XCTAssertEqual(w.social.records[0].amount, 100) }
            if r.outcome == .investor { XCTAssertEqual(w.cash, 100); XCTAssertEqual(w.debt, 0); XCTAssertTrue(w.social.known.contains(4)) }
            if r.outcome == .acquaintance { XCTAssertEqual(w.social.known.count, 5) }
        }
        for (outcome, probability) in [(ActionOutcome.quiet,0.4),(.acquaintance,0.3),(.conversation,0.1),(.investor,0.1),(.foundMoney,0.05),(.opportunity,0.05)] {
            XCTAssertEqual(Double(counts[outcome, default: 0]) / 5000, probability, accuracy: 0.025)
        }
    }
    func testDatingNeverGeneratesMoneyOrInvestors() throws {
        for seed in 1...300 {
            var w = World(now: now); w.seed = UInt64(seed)
            let r = try Engine.socialAction(&w, activity: .dating)
            XCTAssertNotEqual(r.outcome, .foundMoney); XCTAssertNotEqual(r.outcome, .investor); XCTAssertEqual(w.cash, 100)
        }
    }
    func testTwoCafesIndependentSettingsAndTeams() throws {
        var w = rich()
        let a = try Engine.openBusiness(&w, type: 2, district: 0, name: "Brume Est")
        let b = try Engine.openBusiness(&w, type: 2, district: 0, name: "Brume Ouest")
        XCTAssertNotEqual(a, b); XCTAssertEqual(w.businesses.filter { $0.definitionID == 2 }.count, 2)
        try Engine.configureBusiness(&w, id: b, name: "Ouest", multiplier: 1.5, opening: 8, closing: 18)
        try Engine.hire(&w, id: a, manager: false); try Engine.upgrade(&w, id: a)
        let first = try XCTUnwrap(w.businesses.first { $0.id == a }); let second = try XCTUnwrap(w.businesses.first { $0.id == b })
        XCTAssertNotEqual(first.plot, second.plot); XCTAssertEqual(first.level, 2); XCTAssertEqual(second.level, 1)
        XCTAssertEqual(first.employees, 1); XCTAssertEqual(second.employees, 0); XCTAssertEqual(second.priceMultiplier, 1.5); XCTAssertNil(first.priceMultiplier)
        XCTAssertEqual(try SaveCodec.decode(SaveCodec.encode(w)), w)
    }
    func testOccupiedPlotCannotBePurchasedTwiceOrChargedOnFailure() throws {
        var w = rich(); let before = w
        XCTAssertThrowsError(try Engine.openBusiness(&w, type: 2, district: 0, name: "Collision", plot: 0)); XCTAssertEqual(w, before)
    }
    func testDifferentDistrictHasIndependentDemandAndNoDoubleSynergy() throws {
        var w = rich(); _ = try Engine.openBusiness(&w, type: 9, district: 0, name: nil)
        let synergy = w.synergy; _ = try Engine.openBusiness(&w, type: 9, district: 1, name: nil); XCTAssertEqual(w.synergy, synergy)
        let same = try Engine.openBusiness(&w, type: 2, district: 0, name: "A")
        _ = try Engine.openBusiness(&w, type: 2, district: 0, name: "B")
        let other = try Engine.openBusiness(&w, type: 2, district: 1, name: "C")
        try Engine.advance(&w)
        XCTAssertLessThan(w.businesses.first { $0.id == same }!.lastRevenue, w.businesses.first { $0.id == other }!.lastRevenue)
    }
    func testBranchStockOrderBelongsToOneInstanceAndIsPaidOnce() throws {
        var w = rich(); let a = try Engine.openBusiness(&w, type: 2, district: 0, name: "A")
        let b = try Engine.openBusiness(&w, type: 2, district: 1, name: "B")
        let cost = Engine.businessStockCost(w.businesses.first { $0.id == a }!, quantity: 60)
        let before = w.cash; try Engine.orderBusinessStock(&w, id: a, quantity: 60); XCTAssertEqual(w.cash, before - cost)
        XCTAssertThrowsError(try Engine.orderBusinessStock(&w, id: a, quantity: 60))
        try Engine.advance(&w); try Engine.advance(&w)
        XCTAssertNil(w.businesses.first { $0.id == a }!.supplyDay)
        XCTAssertNotEqual(w.businesses.first { $0.id == a }!.stockUnits, w.businesses.first { $0.id == b }!.stockUnits)
    }
    func testEveryCategoryHasTwoDistinctShops() {
        XCTAssertEqual(ShopCatalog.categories.count, 10); XCTAssertEqual(ShopCatalog.shops.count, 20)
        for category in ShopCatalog.categories { let shops = ShopCatalog.shops.filter { $0.category == category.id }; XCTAssertEqual(shops.count, 2); XCTAssertNotEqual(shops[0].theme, shops[1].theme); XCTAssertFalse(shops[0].offers.isEmpty); XCTAssertNotEqual(Set(shops[0].offers), Set(shops[1].offers)) }
    }
    func testPurchasePaidOnceAndUniqueItemsCannotRepeatAcrossShops() throws {
        var w = rich(); let before = w.cash
        let a = try Engine.purchase(&w, item: 4, shop: 4)
        XCTAssertEqual(w.cash, before - ShopCatalog.shops[4].price(4)); XCTAssertEqual(w.ownedItems[0].id, a)
        let after = w; XCTAssertThrowsError(try Engine.purchase(&w, item: 4, shop: 5)); XCTAssertEqual(w, after)
        XCTAssertThrowsError(try Engine.purchase(&w, item: 4, shop: 0))
    }
    func testRepeatedVehiclesHaveDistinctIDsButStatusNotDuplicated() throws {
        var w = rich(); let first = try Engine.purchase(&w, item: 3, shop: 0); let status = w.status
        let second = try Engine.purchase(&w, item: 3, shop: 1)
        XCTAssertNotEqual(first, second); XCTAssertEqual(w.status, status); XCTAssertEqual(w.collectionCount, 2)
        XCTAssertEqual(w.personalValue, Catalog.luxuries[3].price * 2)
        XCTAssertEqual(try SaveCodec.decode(SaveCodec.encode(w)), w)
    }
    func testLegacySaveMigratesWithoutLosingExactMoneyOrContacts() throws {
        var w = rich(); w.cash = Decimal(string:"123456789123456789.12")!
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: SaveCodec.encode(w)) as? [String: Any])
        object["version"] = 1; object.removeValue(forKey:"social"); object.removeValue(forKey:"ownedItems")
        var business = (object["businesses"] as! [[String:Any]])[0]; business.removeValue(forKey:"plot"); object["businesses"] = [business]
        // Preserve numeric lexeme independently from JSONSerialization's Double bridge.
        object["cash"] = 123
        var json = String(data: try JSONSerialization.data(withJSONObject:object,options:[.sortedKeys]),encoding:.utf8)!
        json = json.replacingOccurrences(of:"\"cash\":123",with:"\"cash\":123456789123456789.12")
        let loaded = try SaveCodec.decode(Data(json.utf8))
        XCTAssertEqual(loaded.version, 2); XCTAssertEqual(loaded.cash, w.cash); XCTAssertEqual(loaded.social.known, [0,1,2,3]); XCTAssertEqual(loaded.person(2).name, "Lina"); XCTAssertEqual(loaded.person(2).role, "Amie d’enfance"); XCTAssertEqual(loaded.businesses[0].plot, 0)
    }
    func testNewSaveRoundTripPreservesFinancialPrecision() throws {
        var w = rich(); w.cash = Decimal(string:"123456789123456789.12")!
        XCTAssertEqual(try SaveCodec.decode(SaveCodec.encode(w)).cash, w.cash)
    }
    func testMalformedModernSaveRejectedWithoutInvalidIndexAccess() throws {
        var w = rich(); w.businesses[0].type = 999
        let data = try JSONEncoder().encode(w); XCTAssertThrowsError(try SaveCodec.decode(data))
        w = rich(); w.social.used = 4; XCTAssertThrowsError(try SaveCodec.encode(w))
        w = rich(); w.social.known = [0,1,2]; XCTAssertThrowsError(try SaveCodec.encode(w))
    }
    func testAllCatalogueItemsHaveAValidShopOffer() {
        let all = Set(ShopCatalog.shops.flatMap(\.offers))
        XCTAssertEqual(all, Set(Catalog.luxuries.map(\.id)))
        XCTAssertTrue(ShopCatalog.shops.allSatisfy { shop in shop.offers.allSatisfy(Catalog.luxuries.indices.contains) })
    }

}
