import XCTest
#if canImport(BusinessClickerCore)
@testable import BusinessClickerCore
#else
@testable import BusinessClicker
#endif

final class CityExperienceTests: XCTestCase {
    func testNoEventDaysAreRecordedAndCannotReroll() throws {
        var w=World();let cash=w.cash
        XCTAssertNil(Engine.rollDailyEvent(&w,probability:0))
        XCTAssertNil(Engine.rollDailyEvent(&w,probability:1))
        XCTAssertTrue(w.events.isEmpty);XCTAssertEqual(w.dailyEventRolls.count,1);XCTAssertEqual(w.cash,cash)
        let loaded=try SaveCodec.decode(SaveCodec.encode(w));XCTAssertEqual(loaded.dailyEventRolls,w.dailyEventRolls)
    }
    func testDailyEventOccursWithoutWaitingForThirdDayAndChoiceIsUnique() throws {
        var w=World();let id=try XCTUnwrap(Engine.rollDailyEvent(&w,probability:1))
        XCTAssertEqual(w.day,1);XCTAssertEqual(w.events.count,1)
        XCTAssertEqual(Engine.rollDailyEvent(&w,probability:1),id);XCTAssertEqual(w.events.count,1)
        let before=w.cash;try Engine.choose(&w,event:id,option:1)
        XCTAssertEqual(w.cash,before);XCTAssertThrowsError(try Engine.choose(&w,event:id,option:1))
    }
    func testProbabilityIsDeterministicAndWithinExpectedRange() {
        var count=0
        for seed in 1...2000 {
            var a=World();a.seed=UInt64(seed);var b=a
            let x=Engine.rollDailyEvent(&a);let y=Engine.rollDailyEvent(&b)
            XCTAssertEqual(x,y);XCTAssertEqual(a.events,b.events)
            if x != nil { count += 1 }
        }
        XCTAssertEqual(Double(count)/2000,0.4,accuracy:0.035)
    }
    func testOfflineRollsDoNotResolveChoicesOrConsumeSocialBudget() throws {
        let now=Date(timeIntervalSince1970:1800000000);var w=World(now:now)
        _ = try Engine.catchUp(&w,now:now.addingTimeInterval(1800*20),offline:true)
        XCTAssertEqual(w.dailyEventRolls.count,20);XCTAssertTrue(w.events.allSatisfy { !$0.resolved })
        XCTAssertEqual(Engine.actionsRemaining(w),3)
        let saved=try SaveCodec.decode(SaveCodec.encode(w));XCTAssertEqual(saved,w)
        XCTAssertEqual(try Engine.catchUp(&w,now:now.addingTimeInterval(1800*20),offline:true),0)
    }
    func testStockBubbleReflectsRealStockAndDoesNotChangeMoney() throws {
        var w=World();w.ingredients[0].quantity=0;let cash=w.cash
        let notices=CityStatus.notices(w)
        XCTAssertEqual(notices.first?.target,.business(0));XCTAssertEqual(notices.first?.title,"Stocks épuisés");XCTAssertEqual(w.cash,cash)
        w.ingredients[0].quantity=40;XCTAssertFalse(CityStatus.notices(w).contains { $0.id=="business-0" })
    }
    func testWorkAndEventNoticesPointToCorrectPersistentObjects() throws {
        var w=World();w.cash=100000;try Engine.buyProperty(&w,id:0);try Engine.renovate(&w,id:0)
        let event=try XCTUnwrap(Engine.rollDailyEvent(&w,probability:1))
        var notices=CityStatus.notices(w)
        XCTAssertTrue(notices.contains { $0.target == .property(0) && $0.symbol=="hammer.fill" })
        XCTAssertTrue(notices.contains { $0.target == .event(event) })
        try Engine.choose(&w,event:event,option:2);notices=CityStatus.notices(w)
        XCTAssertFalse(notices.contains { $0.target == .event(event) })
    }
}
