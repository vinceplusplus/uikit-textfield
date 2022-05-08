#if canImport(UIKit)

import XCTest
import SwiftUI
@testable import UIKitTextField
import ViewInspector

extension UIKitTextFieldTests {
  func testIsEnabled() throws {
    // NOTE: it's not so obvious that the built-in `.disabled()` alone will suffice updating
    //       the `.isEnabled` property
    let view = UIKitTextField(config: .init())
      .disabled(true)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().find(UIKitTextField.self).actualView().uiView()
    XCTAssertEqual(textField.isEnabled, false)
  }
}

#endif
