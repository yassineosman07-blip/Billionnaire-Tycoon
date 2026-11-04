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
