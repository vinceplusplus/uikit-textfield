import XCTest
import SwiftUI
@testable import UIKitTextField
import ViewInspector

extension UIKitTextFieldTests {
  func testKeyboardType() throws {
    let view = UIKitTextField(
      config: .init()
        .keyboardType(.emailAddress)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.keyboardType, .emailAddress)
  }
  
  func testKeyboardAppearance() throws {
    let view = UIKitTextField(
      config: .init()
        .keyboardAppearance(.dark)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.keyboardAppearance, .dark)
  }
  
  func testReturnKeyType() throws {
    let view = UIKitTextField(
      config: .init()
        .returnKeyType(.go)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.returnKeyType, .go)
  }
  
  func testTextContentType() throws {
    let view = UIKitTextField(
      config: .init()
        .textContentType(.emailAddress)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.textContentType, .emailAddress)
  }
  
  func testIsSecureTextEntry() throws {
    let view = UIKitTextField(
      config: .init()
        .isSecureTextEntry(true)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.isSecureTextEntry, true)
  }
  
  func testEnablesReturnKeyAutomatically() throws {
    let view = UIKitTextField(
      config: .init()
        .enablesReturnKeyAutomatically(true)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.enablesReturnKeyAutomatically, true)
  }
  
  func testAutocapitalizationType() throws {
    let view = UIKitTextField(
      config: .init()
        .autocapitalizationType(.words)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.autocapitalizationType, .words)
  }
  
  func testAutocorrectionType() throws {
    let view = UIKitTextField(
      config: .init()
        .autocorrectionType(.no)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.autocorrectionType, .no)
  }
  
  func testSpellCheckingType() throws {
    let view = UIKitTextField(
      config: .init()
        .spellCheckingType(.no)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.spellCheckingType, .no)
  }
  
  func testSmartQuotesType() throws {
    let view = UIKitTextField(
      config: .init()
        .smartQuotesType(.no)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.smartQuotesType, .no)
  }
  
  func testSmartDashesType() throws {
    let view = UIKitTextField(
      config: .init()
        .smartDashesType(.yes)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.smartDashesType, .yes)
  }
  
  func testSmartInsertDeleteType() throws {
    let view = UIKitTextField(
      config: .init()
        .smartInsertDeleteType(.no)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.smartInsertDeleteType, .no)
  }
}
