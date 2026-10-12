import XCTest

final class MyAtlasUITests: XCTestCase {
    func testAtlasHomeLoads() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["myatlas"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Offline atlas"].exists)
    }
}