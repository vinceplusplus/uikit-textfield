#if canImport(UIKit)

import XCTest
import SwiftUI
@testable import UIKitTextField
import ViewInspector
import SnapshotTesting

extension UIKitTextField: Inspectable {}

final class UIKitTextFieldTests: XCTestCase {
  func testTextBinding() throws {
    class ViewModel: ObservableObject {
      @Published var text: String = "1234"
    }
    struct ContentView: View, Inspectable {
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        UIKitTextField(
          config: .init()
            .value(text: $viewModel.text)
        )
      }
    }
    
    let viewModel = ViewModel()
    let view = ContentView(viewModel: viewModel)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }
    
    let textField = try view.inspect().find(UIKitTextField<BaseUITextField>.self).actualView().uiView()
    XCTAssertEqual(textField.text, "1234")
    
    viewModel.text = "12345"
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "12345")
    
    textField.becomeFirstResponder()
    textField.insertText("6")
    wait(for: 0.1)
    XCTAssertEqual(viewModel.text, "123456")
    
    textField.deleteBackward()
    wait(for: 0.1)
    XCTAssertEqual(viewModel.text, "12345")
  }
  
  @available(iOS 15.0, *)
  func testFormatBinding() throws {
    class ViewModel: ObservableObject {
      @Published var value: Double = 123
    }
    struct ContentView: View, Inspectable {
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        UIKitTextField(
          config: .init()
            .value(value: $viewModel.value, format: .number)
        )
      }
    }

    let viewModel = ViewModel()
    let view = ContentView(viewModel: viewModel)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().find(UIKitTextField<BaseUITextField>.self).actualView().uiView()
    
    XCTAssertEqual(textField.text, "123")
    
    viewModel.value = 1234
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,234")
    
    textField.becomeFirstResponder()
    textField.insertText("5")
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,2345")
    XCTAssertEqual(viewModel.value, 12345)
    
    textField.resignFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "12,345")
    XCTAssertEqual(viewModel.value, 12345)
  }
  
  func testFormatterBinding() throws {
    class ViewModel: ObservableObject {
      @Published var value: Double = 123
    }
    struct ContentView: View, Inspectable {
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        UIKitTextField(
          config: .init()
            .value(value: $viewModel.value, formatter: formatter)
        )
      }
      var formatter: Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
      }
    }

    let viewModel = ViewModel()
    let view = ContentView(viewModel: viewModel)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().find(UIKitTextField<BaseUITextField>.self).actualView().uiView()
    
    XCTAssertEqual(textField.text, "123")
    
    viewModel.value = 1234
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,234")
    
    textField.becomeFirstResponder()
    textField.insertText("5")
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,2345")
    // NOTE: `Formatter` has a slightly different behavior than `ParseableFormatStyle`
    XCTAssertEqual(viewModel.value, 1234)
    
    textField.resignFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,234")
    XCTAssertEqual(viewModel.value, 1234)
  }
  
  @available(iOS 15.0, *)
  func testOptionalFormatBinding() throws {
    class ViewModel: ObservableObject {
      @Published var value: Double? = 123
    }
    struct ContentView: View, Inspectable {
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        UIKitTextField(
          config: .init()
            .value(value: $viewModel.value, format: .number)
        )
      }
    }

    let viewModel = ViewModel()
    let view = ContentView(viewModel: viewModel)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().find(UIKitTextField<BaseUITextField>.self).actualView().uiView()
    
    XCTAssertEqual(textField.text, "123")
    
    viewModel.value = 1234
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,234")
    
    textField.becomeFirstResponder()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.insertText("abc")
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "abc")
    XCTAssertEqual(viewModel.value, nil)
    
    textField.resignFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "")
    XCTAssertEqual(viewModel.value, nil)
  }
  
  func testOptionalFormatterBinding() throws {
    class ViewModel: ObservableObject {
      @Published var value: Double? = 123
    }
    struct ContentView: View, Inspectable {
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        UIKitTextField(
          config: .init()
            .value(value: $viewModel.value, formatter: formatter)
        )
      }
      var formatter: Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
      }
    }

    let viewModel = ViewModel()
    let view = ContentView(viewModel: viewModel)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().find(UIKitTextField<BaseUITextField>.self).actualView().uiView()
    
    XCTAssertEqual(textField.text, "123")
    
    viewModel.value = 1234
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "1,234")
    
    textField.becomeFirstResponder()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.deleteBackward()
    textField.insertText("abc")
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "abc")
    XCTAssertEqual(viewModel.value, nil)
    
    textField.resignFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(textField.text, "")
    XCTAssertEqual(viewModel.value, nil)
  }
  
  func testPlaceholder() throws {
    let placeholder = "Enter something ..."
    let view = UIKitTextField(
      config: .init()
        .placeholder(placeholder)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.placeholder, placeholder)
  }
  
  func testFont() throws {
    let font = UIFont.systemFont(ofSize: 16)
    let view = UIKitTextField(
      config: .init()
        .font(font)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.font, font)
  }
  
  func testTextColor() throws {
    let textColor = Color.red
    let view = UIKitTextField(
      config: .init()
        .textColor(textColor)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.textColor?.isEqual(UIColor(textColor)), true)
  }
  
  func testTextAlignment() throws {
    let view = UIKitTextField(
      config: .init()
        .textAlignment(.center)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.textAlignment, .center)
  }
  
  func testClearsOnBeginEditing() throws {
    let view = UIKitTextField(
      config: .init()
        .clearsOnBeginEditing(true)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.clearsOnBeginEditing, true)
  }
  
  func testClearsOnInsertion() throws {
    let view = UIKitTextField(
      config: .init()
        .clearsOnInsertion(true)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.clearsOnInsertion, true)
  }
  
  func testClearButtonMode() throws {
    let view = UIKitTextField(
      config: .init()
        .clearButtonMode(.always)
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField.clearButtonMode, .always)
  }
  
  func testStretching() throws {
    assertSnapshot(
      matching: ZStack {
        UIKitTextField(
          config: .init()
            .value(text: .constant("Abcdef"))
            .stretches(horizontal: false, vertical: false)
        )
        .border(Color.green)
      }
        .frame(width: 200, height: 200)
      ,
      as: .image
    )
    
    assertSnapshot(
      matching: ZStack {
        UIKitTextField(
          config: .init()
            .value(text: .constant("Abcdef"))
            .stretches(horizontal: true, vertical: false)
        )
        .border(Color.green)
      }
        .frame(width: 200, height: 200)
      ,
      as: .image
    )
    
    assertSnapshot(
      matching: ZStack {
        UIKitTextField(
          config: .init()
            .value(text: .constant("Abcdef"))
            .stretches(horizontal: false, vertical: true)
        )
        .border(Color.green)
      }
        .frame(width: 200, height: 200)
      ,
      as: .image
    )
    
    assertSnapshot(
      matching: ZStack {
        UIKitTextField(
          config: .init()
            .value(text: .constant("Abcdef"))
            .stretches(horizontal: true, vertical: true)
        )
        .border(Color.green)
      }
        .frame(width: 200, height: 200)
      ,
      as: .image
    )
  }
  
  func testBoolFocusState() throws {
    class ViewModel: ObservableObject {
      @Published var isFocused: Bool = false
    }
    struct ContentView: View, Inspectable {
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        UIKitTextField(
          config: .init()
            .focused($viewModel.isFocused)
        )
      }
    }
    
    let viewModel = ViewModel()
    let view = ContentView(viewModel: viewModel)
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }
    
    wait(for: 0.1)
    
    let textField = try view.inspect().find(UIKitTextField<BaseUITextField>.self).actualView().uiView()
    
    XCTAssertEqual(textField.isFirstResponder, false)
    
    viewModel.isFocused = true
    wait(for: 0.1)
    XCTAssertEqual(textField.isFirstResponder, true)
    
    viewModel.isFocused = false
    wait(for: 0.1)
    XCTAssertEqual(textField.isFirstResponder, false)
    
    textField.becomeFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(viewModel.isFocused, true)
    
    textField.resignFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(viewModel.isFocused, false)
  }
  
  func testValueFocusState() throws {
    // NOTE: ViewInspector seems to have trouble locating the second text field, instead,
    //       it returns the first one as the second one
    let textField0 = BaseUITextField()
    let textField1 = BaseUITextField()
    
    enum Field {
      case field0
      case field1
    }
    class ViewModel: ObservableObject {
      @Published var focusedField: Field?
    }
    struct ContentView: View, Inspectable {
      let textField0: BaseUITextField
      let textField1: BaseUITextField
      @ObservedObject var viewModel: ViewModel
      var body: some View {
        return VStack {
          UIKitTextField(
            config: .init {
              textField0
            }
              .value(text: .constant("abcdef"))
              .focused($viewModel.focusedField, equals: .field0)
          )
          UIKitTextField(
            config: .init {
              textField1
            }
              .value(text: .constant("123456"))
              .focused($viewModel.focusedField, equals: .field1)
          )
        }
        .frame(width: 200, height: 200)
      }
    }
    
    let viewModel = ViewModel()
    let view = ContentView(
      textField0: textField0,
      textField1: textField1,
      viewModel: viewModel
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }
    
    wait(for: 0.1)
    
    XCTAssertEqual(textField0.isFirstResponder, false)
    XCTAssertEqual(textField1.isFirstResponder, false)

    viewModel.focusedField = .field0
    wait(for: 0.1)
    XCTAssertEqual(textField0.isFirstResponder, true)
    XCTAssertEqual(textField1.isFirstResponder, false)

    viewModel.focusedField = .field1
    wait(for: 0.1)
    XCTAssertEqual(textField0.isFirstResponder, false)
    XCTAssertEqual(textField1.isFirstResponder, true)

    viewModel.focusedField = nil
    wait(for: 0.1)
    XCTAssertEqual(textField0.isFirstResponder, false)
    XCTAssertEqual(textField1.isFirstResponder, false)

    textField0.becomeFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(viewModel.focusedField, .field0)

    textField1.becomeFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(viewModel.focusedField, .field1)

    textField1.resignFirstResponder()
    wait(for: 0.1)
    XCTAssertEqual(viewModel.focusedField, nil)
  }
  
  func testInputViews() throws {
    struct KeyButton: View {
      let uiTextField: UITextField
      let text: String
      
      var body: some View {
        Button {} label: {
          Text(text)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.white)
        }
      }
    }
    let textField = BaseUITextField()
    let view = UIKitTextField(
      config: .init {
        textField
      }
        .value(text: .constant("abc"))
        .inputView(content: .view { uiTextField in
          VStack(spacing: 1) {
            HStack(spacing: 1) {
              KeyButton(uiTextField: uiTextField, text: "1")
              KeyButton(uiTextField: uiTextField, text: "2")
              KeyButton(uiTextField: uiTextField, text: "3")
            }
            HStack(spacing: 1) {
              KeyButton(uiTextField: uiTextField, text: "4")
              KeyButton(uiTextField: uiTextField, text: "5")
              KeyButton(uiTextField: uiTextField, text: "6")
            }
            HStack(spacing: 1) {
              KeyButton(uiTextField: uiTextField, text: "7")
              KeyButton(uiTextField: uiTextField, text: "8")
              KeyButton(uiTextField: uiTextField, text: "9")
            }
          }
          .background(Color.gray)
          .border(Color.gray)
        })
        .inputAccessoryView(content: .view { uiTextField in
          HStack(spacing: 1) {
            KeyButton(uiTextField: uiTextField, text: "🐵")
            KeyButton(uiTextField: uiTextField, text: "🐶")
            KeyButton(uiTextField: uiTextField, text: "🦊")
          }
          .background(Color.gray)
          .border(Color.gray)
          .clipped()
        })
    )
      .frame(width: 200, height: 100)
    
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }
    
    wait(for: 0.1)
    
    textField.becomeFirstResponder()
    
    wait(for: 1)
    
    assertSnapshot(matching: textField.inputViewController!.view.layer, as: .image)
    assertSnapshot(matching: textField.inputAccessoryViewController!.view.layer, as: .image)
  }
  
  func testCustomTextField() throws {
    class CustomTextField: BaseUITextField {}
    
    let customTextField = CustomTextField()
    
    let view = UIKitTextField(
      config: .init {
        customTextField
      }
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }

    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(textField, customTextField)
    XCTAssert(type(of: textField) === CustomTextField.self)
  }

  func testConfigure() throws {
    var capture = (UITextField, Void)(.init(), ())
    
    let view = UIKitTextField(
      config: .init()
        .configure { uiTextField in
          capture = (uiTextField, ())
        }
    )
    ViewHosting.host(view: view)
    defer {
      ViewHosting.expel()
    }
    
    wait(for: 0.1)
    
    let textField = try view.inspect().actualView().uiView()
    XCTAssertEqual(capture.0, textField)
  }
}

#endif
