import XCTest

// HACK: https://stackoverflow.com/questions/32897757/is-there-a-way-to-find-if-the-xcuielement-has-focus-or-not/35915719#35915719
extension XCUIElement {
  var hasKeyboardFocus: Bool {
    (value(forKey: "hasKeyboardFocus") as? Bool) ?? false
  }
}

extension XCTestCase {
  func wait(for time: TimeInterval) {
    RunLoop.current.run(until: .now + time)
  }
}

class ExampleUITests: XCTestCase {
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {}
  
  func testTextBinding() throws {
    let app = XCUIApplication()
    app.launch()
    
    app.otherElements.buttons["Text Binding"].tap()
    
    XCTAssert(app.staticTexts["Please enter your name above"].exists)
    
    let textField = app.textFields.element(boundBy: 0)
    
    textField.tap()
    textField.typeText("John")
    
    XCTAssertFalse(app.staticTexts["Please enter your name above"].exists)
    XCTAssert(app.staticTexts["Hello John"].exists)
  }
  
  func testValueBinding() throws {
    let app = XCUIApplication()
    app.launch()
    
    app.otherElements.buttons["Value Binding"].tap()
    
    let textField0 = app.textFields.element(boundBy: 0)
    let textField1 = app.textFields.element(boundBy: 1)
    let result0 = app.staticTexts["result0"]
    let result1 = app.staticTexts["result1"]
    
    XCTAssert(textField0.exists)
    XCTAssert(textField1.exists)
    XCTAssert(result0.exists)
    XCTAssert(result1.exists)
    
    textField0.tap()
    textField0.typeText("\(XCUIKeyboardKey.delete.rawValue)1234abcd1234")
    XCTAssertEqual(textField0.value as? String, "1234abcd1234")
    XCTAssertEqual(result0.label, "Your input: 1234")
    
    textField1.tap()
    XCTAssertEqual(textField0.value as? String, "1,234")
    
    textField0.tap()
    textField0.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5))
    XCTAssertEqual(textField0.value as? String, "")
    XCTAssertEqual(result0.label, "Your input: 1")
    
    textField1.tap()
    textField1.typeText("\(XCUIKeyboardKey.delete.rawValue)1234abcd1234")
    XCTAssertEqual(textField1.value as? String, "1234abcd1234")
    XCTAssertEqual(result1.label, "Your input: 1234")
    
    textField0.tap()
    XCTAssertEqual(textField1.value as? String, "1,234")
    
    textField1.tap()
    textField1.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5))
    XCTAssertEqual(textField1.value as? String, "")
    XCTAssertEqual(result1.label, "Your input: nil")
  }
  
  func testFocusBinding() throws {
    let app = XCUIApplication()
    app.launch()
    
    app.otherElements.buttons["Focus Binding"].tap()
    
    let textField0 = app.textFields.element(boundBy: 0)
    let textField1a = app.textFields.element(boundBy: 1)
    let textField1b = app.textFields.element(boundBy: 2)
    let focusButton0 = app.buttons["Toggle Focus"]
    let focusButton1a = app.buttons["focusButton1a"]
    let focusButton1b = app.buttons["focusButton1b"]
    let result0 = app.staticTexts["result0"]
    let result1 = app.staticTexts["result1"]

    // tapping on text fields
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: nil")
    
    textField0.tap()
    XCTAssertEqual(result0.label, "isFocused: true")
    XCTAssertEqual(result1.label, "Focus: nil")
    
    textField1a.tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: field1a")
    
    textField1b.tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: field1b")
    
    textField0.tap()
    XCTAssertEqual(result0.label, "isFocused: true")
    XCTAssertEqual(result1.label, "Focus: nil")
    
    wait(for: 0.5)
    app.buttons["Dismiss"].tap()
    wait(for: 0.5)
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: nil")
    
    // using buttons to set focus
    focusButton0.tap()
    XCTAssertEqual(result0.label, "isFocused: true")
    XCTAssertEqual(result1.label, "Focus: nil")
    XCTAssertEqual(textField0.hasKeyboardFocus, true)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, false)
    focusButton0.tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: nil")
    XCTAssertEqual(textField0.hasKeyboardFocus, false)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, false)
    
    focusButton0.tap()
    XCTAssertEqual(result0.label, "isFocused: true")
    XCTAssertEqual(result1.label, "Focus: nil")
    XCTAssertEqual(textField0.hasKeyboardFocus, true)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, false)
    focusButton1a.tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: field1a")
    XCTAssertEqual(textField0.hasKeyboardFocus, false)
    XCTAssertEqual(textField1a.hasKeyboardFocus, true)
    XCTAssertEqual(textField1b.hasKeyboardFocus, false)
    focusButton1b.tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: field1b")
    XCTAssertEqual(textField0.hasKeyboardFocus, false)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, true)
    app.buttons["Unfocus"].tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: nil")
    XCTAssertEqual(textField0.hasKeyboardFocus, false)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, false)
    focusButton1b.tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: field1b")
    XCTAssertEqual(textField0.hasKeyboardFocus, false)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, true)
    app.buttons["Dismiss"].tap()
    XCTAssertEqual(result0.label, "isFocused: false")
    XCTAssertEqual(result1.label, "Focus: nil")
    XCTAssertEqual(textField0.hasKeyboardFocus, false)
    XCTAssertEqual(textField1a.hasKeyboardFocus, false)
    XCTAssertEqual(textField1b.hasKeyboardFocus, false)
  }
  
  func testInputView() throws {
    let app = XCUIApplication()
    app.launch()
    
    app.otherElements.buttons["Input View"].tap()
    
    let textField = app.textFields.element(boundBy: 0)
    
    textField.tap()
    
    app.buttons["1"].tap()
    XCTAssert(app.staticTexts["Preview: 1.0"].exists)
    app.buttons["+"].tap()
    XCTAssert(app.staticTexts["Preview: nil"].exists)
    app.buttons["2"].tap()
    XCTAssert(app.staticTexts["Preview: 3.0"].exists)
    app.buttons["*"].tap()
    XCTAssert(app.staticTexts["Preview: nil"].exists)
    app.buttons["3"].tap()
    XCTAssert(app.staticTexts["Preview: 7.0"].exists)
    app.buttons["-"].tap()
    XCTAssert(app.staticTexts["Preview: nil"].exists)
    app.buttons["4"].tap()
    XCTAssert(app.staticTexts["Preview: 3.0"].exists)
    XCTAssert(app.staticTexts["Result: "].exists)
    app.buttons["enter"].tap()
    
    XCTAssertEqual(textField.value as? String, "1+2*3-4")
    XCTAssert(app.staticTexts["Preview: 3.0"].exists)
    XCTAssert(app.staticTexts["Result: 3.0"].exists)
  }
}
