import SwiftUI
import UIKitTextField

// HACK: disable hardware keyboard for ui testing
//       https://stackoverflow.com/a/57618331
//       https://github.com/nst/iOS-Runtime-Headers/blob/master/PrivateFrameworks/UIKitCore.framework/UIKeyboardInputMode.h
#if targetEnvironment(simulator)
class HardwareKeyboardDisablingHack {
  static let shared = HardwareKeyboardDisablingHack()

  private let setter = NSSelectorFromString("setHardwareLayout:")
  private let getter = NSSelectorFromString("hardwareLayout")
  private(set) var hardwareKeyboardIsDisabled = false
  private var originalState = [UITextInputMode: AnyObject]()

  func disableHardwareKeyboard() {
    if !hardwareKeyboardIsDisabled {
      UITextInputMode.activeInputModes.forEach {
        if
          $0.responds(to: getter) && $0.responds(to: setter),
          let value = $0.perform(getter)
        {
          originalState[$0] = value.takeUnretainedValue()
          $0.perform(setter, with: nil)
        }
      }
      
      hardwareKeyboardIsDisabled = true
    }
  }
  
  func enableHardwareKeyboard() {
    if hardwareKeyboardIsDisabled {
      originalState.forEach {
        $0.key.perform(setter, with: $0.value)
      }
      
      hardwareKeyboardIsDisabled = false
    }
  }
}
#endif

struct InputValidationPage: View {
  @State var originalTextInputModeState: [UITextInputMode: AnyObject] = [:]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Enter a number")
      UIKitTextField(
        config: .init()
          .shouldChangeCharacters { uiTextField, range, replacementString in
            if
              let oldText = uiTextField.text,
              let range = Range(range, in: oldText)
            {
              let newText = oldText.replacingCharacters(in: range, with: replacementString)
              if newText == "" || Double(newText) != nil {
                return true
              }
            }
            return false
          }
      )
      .border(Color.black)
      
#if targetEnvironment(simulator)
      Button {
        HardwareKeyboardDisablingHack.shared.disableHardwareKeyboard()
      } label: {
        Text("Disable Hardware Keyboard")
      }
      Button {
        HardwareKeyboardDisablingHack.shared.enableHardwareKeyboard()
      } label: {
        Text("Restore Hardware Keyboard")
      }
#endif
    }
  }
}

struct KeyButton: View {
  let uiTextField: UITextField
  let text: String
  
  var body: some View {
    Button {
      uiTextField.insertText(text)
    } label: {
      Text(text)
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color.white)
    }
  }
}

struct InputViewPage: View {
  @State var state = 0
  var body: some View {
    VStack {
      UIKitTextField(
        config: .init()
          .placeholder("Use custom input views to input")
          .inputView(content: .view(content: { uiTextField in
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
          }))
          .inputAccessoryView(content: .view { uiTextField in
            HStack(spacing: 1) {
              KeyButton(uiTextField: uiTextField, text: "🐵")
              KeyButton(uiTextField: uiTextField, text: "🐶")
              KeyButton(uiTextField: uiTextField, text: "🦊")
              Button {
                uiTextField.deleteBackward()
              } label: {
                Text("⌫")
                  .frame(maxWidth: .infinity)
                  .frame(height: 120)
                  .background(Color.white)
              }
            }
            .background(Color.gray)
            .border(Color.gray)
            .clipped()
          })
      )
      .border(Color.black)
    }
  }
}

struct ContentView: View {
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: InputValidationPage()) {
          Text("Input Validation")
        }
        NavigationLink(destination: InputViewPage()) {
          Text("Input Views")
        }
      }
    }
  }
}
