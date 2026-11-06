import XCTest

final class BusinessClickerUITests: XCTestCase {
    func testFirstServiceAndPersistence() throws {
        let app = XCUIApplication(); app.launchArguments = ["--ui-testing", "--ui-testing-reset"]; app.launch()
        if app.buttons["Continuer"].waitForExistence(timeout: 5) {
            for _ in 0..<3 { app.buttons["Continuer"].tap() }
            app.buttons["Ouvrir Tasty Crousty"].tap()
        }
        XCTAssertTrue(app.tabBars.buttons["Ville"].waitForExistence(timeout: 5))
        let cityShot=XCTAttachment(screenshot:app.screenshot());cityShot.name="Ville principale Kenney";cityShot.lifetime = .keepAlways;add(cityShot)
        app.buttons["advance-day"].tap()
        let dayChanged=XCTNSPredicateExpectation(predicate:NSPredicate(format:"label == %@","JOUR 2"),object:app.staticTexts["city-day"])
        XCTAssertEqual(XCTWaiter.wait(for:[dayChanged],timeout:10),.completed)
        if app.buttons["event-defer"].waitForExistence(timeout:2) { app.buttons["event-defer"].tap() }
        app.buttons["Bilan"].tap()
        XCTAssertTrue(app.navigationBars["Bilans quotidiens"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Chiffre d’affaires"].firstMatch.exists)
        app.buttons["Fermer"].tap()
        app.tabBars.buttons["Empire"].tap()
        XCTAssertTrue(app.staticTexts["Tasty Crousty"].firstMatch.waitForExistence(timeout: 3))
        app.terminate(); app.launchArguments = ["--ui-testing"]; app.launch()
        XCTAssertTrue(app.tabBars.buttons["Ville"].waitForExistence(timeout: 5))
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
        let app = freshGame(); app.tabBars.buttons["Patrimoine"].tap(); app.buttons["Collection"].tap()
        let category = app.buttons["shop-category-0"]
        for _ in 0..<4 { if category.isHittable { break }; app.swipeUp() }
        XCTAssertTrue(category.waitForExistence(timeout:5));category.tap();app.buttons["shop-0"].tap()
        XCTAssertTrue(app.navigationBars["Garage Avenue"].waitForExistence(timeout: 5))
        let item = app.buttons["shop-item-3"]
        for _ in 0..<5 { if item.isHittable { break }; app.swipeUp() }
        item.tap()
        XCTAssertTrue(app.navigationBars["Renault Clio IV"].waitForExistence(timeout: 3))
        let screenshot = XCTAttachment(screenshot: app.screenshot()); screenshot.lifetime = .keepAlways; add(screenshot)
    }
}
