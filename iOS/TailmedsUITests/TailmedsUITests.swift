import XCTest

final class TailmedsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensForm() {
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 2))
        app.buttons["cancelButton"].tap()
    }

    func testAddEntryFlow() {
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 2))
        app.buttons["saveButton"].tap()
    }

    func testFreeLimitTriggersPaywall() {
        for _ in 0..<9 {
            if app.buttons["addButton"].exists {
                app.buttons["addButton"].tap()
                if app.buttons["saveButton"].waitForExistence(timeout: 1) {
                    app.buttons["saveButton"].tap()
                }
            }
        }
        XCTAssertTrue(app.buttons["purchaseButton"].waitForExistence(timeout: 2) || app.buttons["paywallDismissButton"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addButton"].tap()
        let textField = app.textFields.firstMatch
        if textField.waitForExistence(timeout: 2) {
            textField.tap()
            app.staticTexts["Details"].tap()
            XCTAssertFalse(app.keyboards.element.exists)
        }
        if app.buttons["cancelButton"].exists {
            app.buttons["cancelButton"].tap()
        }
    }

    func testSettingsOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
