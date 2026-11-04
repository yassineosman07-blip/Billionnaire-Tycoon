import XCTest

final class BusinessClickerUITests: XCTestCase {
    func testFirstServiceAndPersistence() throws {
        let app = XCUIApplication(); app.launchArguments = ["--ui-testing", "--ui-testing-reset"]; app.launch()
        if app.buttons["Continuer"].waitForExistence(timeout: 5) {
            for _ in 0..<3 { app.buttons["Continuer"].tap() }
            app.buttons["Ouvrir Tasty Crousty"].tap()
        }
        XCTAssertTrue(app.tabBars.buttons["Accueil"].waitForExistence(timeout: 5))
        app.buttons["Passer au lendemain"].tap()
        XCTAssertTrue(app.navigationBars["Bilans quotidiens"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Chiffre d’affaires"].firstMatch.exists)
        app.buttons["Fermer"].tap()
        app.tabBars.buttons["Empire"].tap()
        XCTAssertTrue(app.staticTexts["Tasty Crousty"].firstMatch.waitForExistence(timeout: 3))
        app.terminate(); app.launchArguments = ["--ui-testing"]; app.launch()
        XCTAssertTrue(app.tabBars.buttons["Accueil"].waitForExistence(timeout: 5))
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
        XCTAssertTrue(app.tabBars.buttons["Accueil"].waitForExistence(timeout: 5))
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
        let category = app.staticTexts["Concessionnaires"]
        for _ in 0..<4 { if category.isHittable { break }; app.swipeUp() }
        category.tap(); app.staticTexts["Garage Avenue"].tap()
        XCTAssertTrue(app.navigationBars["Garage Avenue"].waitForExistence(timeout: 5))
        let item = app.staticTexts["Renault Clio IV"]
        for _ in 0..<5 { if item.isHittable { break }; app.swipeUp() }
        item.tap()
        XCTAssertTrue(app.navigationBars["Renault Clio IV"].waitForExistence(timeout: 3))
        let screenshot = XCTAttachment(screenshot: app.screenshot()); screenshot.lifetime = .keepAlways; add(screenshot)
    }
}
