import XCTest

final class BusinessClickerUITests: XCTestCase {
    private func element(_ app: XCUIApplication, _ identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }
    override func tearDownWithError() throws {
        if (testRun?.failureCount ?? 0) > 0 {
            let app=XCUIApplication()
            let tree=app.debugDescription
            let hierarchy=XCTAttachment(string:tree);hierarchy.name="Hiérarchie au moment de l’échec";hierarchy.lifetime = .keepAlways;add(hierarchy)
            for identifier in ["city-day","event-defer","shop-category-0","Collection","Votre signature"] {
                let lines=tree.split(separator:"\n").filter { $0.contains(identifier) }.prefix(4).joined(separator:" | ")
                print("UI_DIAGNOSTIC \(identifier): \(lines.isEmpty ? "absent" : lines)")
            }
            let shot=XCTAttachment(screenshot:app.screenshot());shot.name="Écran au moment de l’échec";shot.lifetime = .keepAlways;add(shot)
        }
    }
    func testFirstServiceAndPersistence() throws {
        let app = XCUIApplication(); app.launchArguments = ["--ui-testing", "--ui-testing-reset"]; app.launch()
        if app.buttons["Continuer"].waitForExistence(timeout: 5) {
            for _ in 0..<3 { app.buttons["Continuer"].tap() }
            app.buttons["Ouvrir Tasty Crousty"].tap()
        }
        XCTAssertTrue(app.tabBars.buttons["Ville"].waitForExistence(timeout: 5))
        let cityShot=XCTAttachment(screenshot:app.screenshot());cityShot.name="Ville principale Kenney";cityShot.lifetime = .keepAlways;add(cityShot)
        app.buttons["advance-day"].tap()
        let day=element(app,"city-day");let deferred=element(app,"event-defer")
        // A presented event hides the city's accessibility tree until dismissed.
        let completed=XCTNSPredicateExpectation(predicate:NSPredicate { _,_ in
            deferred.exists || (day.exists && day.label == "JOUR 2")
        },object:nil)
        XCTAssertEqual(XCTWaiter.wait(for:[completed],timeout:20),.completed)
        if deferred.waitForExistence(timeout:2) { deferred.tap() }
        XCTAssertEqual(day.label,"JOUR 2")
        app.buttons["Bilan"].tap()
        XCTAssertTrue(app.navigationBars["Bilans quotidiens"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Chiffre d’affaires"].firstMatch.exists)
        app.buttons["Fermer"].tap()
        app.tabBars.buttons["Empire"].tap()
        XCTAssertTrue(app.staticTexts["Tasty Crousty"].firstMatch.waitForExistence(timeout: 3))
        app.terminate(); app.launchArguments = ["--ui-testing"]; app.launch()
        let restoredEvent=element(app,"event-defer")
        if restoredEvent.waitForExistence(timeout:2) { restoredEvent.tap() }
        XCTAssertTrue(app.tabBars.buttons["Ville"].waitForExistence(timeout: 5))
        XCTAssertEqual(element(app,"city-day").label,"JOUR 2")
        XCTAssertFalse(app.buttons["Ouvrir Tasty Crousty"].exists)
        let screenshot = XCTAttachment(screenshot: app.screenshot()); screenshot.lifetime = .keepAlways; add(screenshot)
    }
}

extension BusinessClickerUITests {
    private func freshGame() -> XCUIApplication {
        let app = XCUIApplication(); app.launchArguments = ["--ui-testing", "--ui-testing-reset"]; app.launch()
        XCTAssertTrue(app.buttons["Continuer"].waitForExistence(timeout: 5))
        for _ in 0..<3 { app.buttons["Continuer"].tap() }
        app.buttons["Ouvrir Tasty Crousty"].tap()
        XCTAssertTrue(app.tabBars.buttons["Ville"].waitForExistence(timeout: 5))
        return app
    }
    private func openActions(_ app: XCUIApplication) {
        app.buttons["Mon personnage"].firstMatch.tap()
        let shortcut = app.buttons["Actions · une rencontre peut tout changer"]
        for _ in 0..<6 { if shortcut.isHittable { break }; app.swipeUp() }
        shortcut.tap()
        XCTAssertTrue(app.navigationBars["Actions"].waitForExistence(timeout: 3))
    }
    func testThreeActionsPersistAcrossRelaunch() throws {
        let app = freshGame(); openActions(app)
        for _ in 0..<3 {
            let bar = app.buttons["Sortir au bar · 1 action"]
            for _ in 0..<5 { if bar.isHittable { break }; app.swipeUp() }
            bar.tap(); app.buttons["Utiliser une action · gratuit"].tap()
        }
        XCTAssertFalse(app.buttons["Sortir au bar · 1 action"].isEnabled)
        app.terminate(); app.launchArguments = ["--ui-testing"]; app.launch(); openActions(app)
        let bar = app.buttons["Sortir au bar · 1 action"]
        for _ in 0..<5 { if bar.isHittable { break }; app.swipeUp() }
        XCTAssertFalse(bar.isEnabled)
    }
    func testShopInteriorAndProductDetails() throws {
        let app = freshGame(); app.tabBars.buttons["Patrimoine"].tap()
        let collection=app.segmentedControls.buttons["Collection"]
        XCTAssertTrue(collection.waitForExistence(timeout:5));collection.tap()
        XCTAssertTrue(app.staticTexts["Votre signature"].waitForExistence(timeout:5))
        let category = element(app,"shop-category-0")
        for _ in 0..<4 { if category.isHittable { break }; app.swipeUp() }
        XCTAssertTrue(category.waitForExistence(timeout:5));category.tap();element(app,"shop-0").tap()
        XCTAssertTrue(app.navigationBars["Garage Avenue"].waitForExistence(timeout: 5))
        let item = element(app,"shop-item-3")
        for _ in 0..<5 { if item.isHittable { break }; app.swipeUp() }
        item.tap()
        XCTAssertTrue(app.navigationBars["Renault Clio IV"].waitForExistence(timeout: 3))
        let screenshot = XCTAttachment(screenshot: app.screenshot()); screenshot.lifetime = .keepAlways; add(screenshot)
    }
}
