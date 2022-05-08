#if canImport(UIKit)

import XCTest
import SwiftUI
@testable import UIKitTextField
import ViewInspector

extension UIKitTextFieldTests {
  func testUITextFieldDelegate() throws {
    // NOTE: test whether we interface correctly with UITextFieldDelegate
    struct CallCaptures {
      // NOTE: arguments terminated by Void
      var shouldBeginEditing = (UITextField, Void)(.init(), ())
      var onBeganEditing = (UITextField, Void)(.init(), ())
      var shouldEndEditing = (UITextField, Void)(.init(), ())
      var onEndedEditing = ((UITextField, UITextField.DidEndEditingReason), Void)((.init(), .committed), ())
      var shouldChangeCharacters = ((UITextField, NSRange, String), Void)((.init(), .init(), ""), ())
      var onChangedSelection = (UITextField, Void)(.init(), ())
      var shouldClear = (UITextField, Void)(.init(), ())
      var shouldReturn = (UITextField, Void)(.init(), ())
    }
    var captures = CallCaptures()
    
    var shouldBeginEditing = false
    var shouldEndEditing = false
    var shouldChangeCharacters = false
    var shouldClear = false
    var shouldReturn = false

    let view = UIKitTextField(
      config: .init()
        .shouldBeginEditing { uiTextField in
          captures.shouldBeginEditing = (uiTextField, ())
          return shouldBeginEditing
        }
        .onBeganEditing { uiTextField in
          captures.onBeganEditing = (uiTextField, ())
        }
        .shouldEndEditing { uiTextField in
          captures.shouldEndEditing = (uiTextField, ())
          return shouldEndEditing
        }
        .onEndedEditing { uiTextField, reason in
          captures.onEndedEditing = ((uiTextField, reason), ())
        }
        .shouldChangeCharacters { uiTextField, range, replacementString in
          captures.shouldChangeCharacters = ((uiTextField, range, replacementString), ())
          return shouldChangeCharacters
        }
        .onChangedSelection { uiTextField in
          captures.onChangedSelection = (uiTextField, ())
        }
        .shouldClear { uiTextField in
          captures.shouldClear = (uiTextField, ())
          return shouldClear
        }
        .shouldReturn { uiTextField in
          captures.shouldReturn = (uiTextField, ())
          return shouldReturn
        }
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }
    
    wait(for: 0.1)
    
    let textField = try view.inspect().actualView().uiView()
    
    captures = .init()
    
    shouldBeginEditing = false
    XCTAssertEqual(textField.delegate?.textFieldShouldBeginEditing?(textField), false)
    XCTAssertEqual(captures.shouldBeginEditing.0, textField)
    shouldBeginEditing = true
    XCTAssertEqual(textField.delegate?.textFieldShouldBeginEditing?(textField), true)
    XCTAssertEqual(captures.shouldBeginEditing.0, textField)
    
    textField.delegate?.textFieldDidBeginEditing?(textField)
    XCTAssertEqual(captures.onBeganEditing.0, textField)
    
    shouldEndEditing = false
    XCTAssertEqual(textField.delegate?.textFieldShouldEndEditing?(textField), false)
    XCTAssertEqual(captures.shouldEndEditing.0, textField)
    shouldEndEditing = true
    XCTAssertEqual(textField.delegate?.textFieldShouldEndEditing?(textField), true)
    XCTAssertEqual(captures.shouldEndEditing.0, textField)
    
    textField.delegate?.textFieldDidEndEditing?(textField, reason: .committed)
    XCTAssertEqual(captures.onEndedEditing.0.0, textField)
    XCTAssertEqual(captures.onEndedEditing.0.1, .committed)
    
    shouldChangeCharacters = false
    XCTAssertEqual(
      textField.delegate?.textField?(
        textField,
        shouldChangeCharactersIn: .init(location: 12, length: 34),
        replacementString: "abc"
      ),
      false
    )
    XCTAssertEqual(captures.shouldChangeCharacters.0.0, textField)
    XCTAssertEqual(captures.shouldChangeCharacters.0.1, .init(location: 12, length: 34))
    XCTAssertEqual(captures.shouldChangeCharacters.0.2, "abc")
    
    shouldChangeCharacters = true
    XCTAssertEqual(
      textField.delegate?.textField?(
        textField,
        shouldChangeCharactersIn: .init(location: 34, length: 56),
        replacementString: "def"
      ),
      true
    )
    XCTAssertEqual(captures.shouldChangeCharacters.0.0, textField)
    XCTAssertEqual(captures.shouldChangeCharacters.0.1, .init(location: 34, length: 56))
    XCTAssertEqual(captures.shouldChangeCharacters.0.2, "def")
    
    textField.delegate?.textFieldDidChangeSelection?(textField)
    XCTAssertEqual(captures.onChangedSelection.0, textField)
    
    shouldClear = false
    XCTAssertEqual(textField.delegate?.textFieldShouldClear?(textField), false)
    XCTAssertEqual(captures.shouldClear.0, textField)
    shouldClear = true
    XCTAssertEqual(textField.delegate?.textFieldShouldClear?(textField), true)
    XCTAssertEqual(captures.shouldClear.0, textField)
    
    shouldReturn = false
    XCTAssertEqual(textField.delegate?.textFieldShouldReturn?(textField), false)
    XCTAssertEqual(captures.shouldReturn.0, textField)
    shouldReturn = true
    XCTAssertEqual(textField.delegate?.textFieldShouldReturn?(textField), true)
    XCTAssertEqual(captures.shouldReturn.0, textField)
  }
}

#endif
