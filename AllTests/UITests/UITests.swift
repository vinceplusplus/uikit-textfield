import XCTest

extension XCUIApplication {
  func tapKey(_ key: String) {
    // NOTE: need to skip keyboard onboarding, https://developer.apple.com/forums/thread/650826
    let keyButton = self.keys[key]
    if !keyButton.isHittable {
      // NOTE: sometimes it might need time to come into existence
      _ = keyButton.waitForExistence(timeout: 1)
      // NOTE: if still not hittable, there should be an onboarding screen
      if !keyButton.isHittable {
        self.buttons["Continue"].tap()
      }
    }
    keyButton.tap()
  }
}

class UITests: XCTestCase {
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {}
  
  func testInputValidation() throws {
    let app = XCUIApplication()
    app.launch()
    
    app.otherElements.buttons["Input Validation"].tap()
    
    let textField = app.textFields.element(boundBy: 0)
    
    XCTAssert(textField.exists)
    
#if targetEnvironment(simulator)
    app.buttons["Disable Hardware Keyboard"].tap()
#endif
    
    textField.tap()
    
    XCTAssertEqual(textField.value as? String, "")
    
    app.tapKey("A")
    app.tapKey("A")
    app.tapKey("A")
    
    XCTAssert(textField.value as? String == "")
    
    app.tapKey("more")

    app.tapKey("1")
    app.tapKey("2")
    app.tapKey("3")
    app.tapKey(".")
    app.tapKey(".")
    app.tapKey(".")
    app.tapKey("1")
    app.tapKey("1")
    app.tapKey("1")
    
    XCTAssert(textField.value as? String == "123.111")
    
    app.tapKey("more")

    app.tapKey("b")
    app.tapKey("c")
    
    XCTAssert(textField.value as? String == "123.111")
    
    app.tapKey("delete")
    app.tapKey("delete")
    app.tapKey("delete")
    app.tapKey("delete")
    app.tapKey("delete")
    app.tapKey("delete")
    app.tapKey("delete")
    
    XCTAssert(textField.value as? String == "")
    
    app.buttons["Restore Hardware Keyboard"].tap()
    
    textField.typeText("1234...4a3b2c1d")
    
    XCTAssert(textField.value as? String == "1234.4321")
  }
  
  func testInputViews() throws {
    let app = XCUIApplication()
    app.launch()
    
    app.otherElements.buttons["Input Views"].tap()
    
    let textField = app.textFields["Use custom input views to input"]
    
    XCTAssert(textField.exists)
    
    textField.tap()
    app.buttons["1"].tap()
    app.buttons["2"].tap()
    app.buttons["3"].tap()
    app.buttons["4"].tap()
    app.buttons["5"].tap()
    app.buttons["6"].tap()
    app.buttons["7"].tap()
    app.buttons["8"].tap()
    app.buttons["9"].tap()
    app.buttons["🐵"].tap()
    app.buttons["🐶"].tap()
    app.buttons["🦊"].tap()
    
    XCTAssertEqual(textField.value as? String, "123456789🐵🐶🦊")
    
    app.buttons["⌫"].tap()
    app.buttons["⌫"].tap()
    app.buttons["⌫"].tap()
    app.buttons["⌫"].tap()
    XCTAssertEqual(textField.value as? String, "12345678")
  }
}
