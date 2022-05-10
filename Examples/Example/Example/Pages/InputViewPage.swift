import SwiftUI
import UIKitTextField
import MeasurementReader
import Expression

extension AnyView {
  init(content: () -> Self) {
    self.init(content())
  }
}

struct KeyStyle: ButtonStyle {
  let width: CGFloat
  var height: CGFloat = 80
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(configuration.isPressed ? Color.white : Color.gray)
      .frame(maxWidth: width)
      .frame(height: height)
      .background(Color.black.opacity(configuration.isPressed ? 0.5 : 1))
      .cornerRadius(16)
  }
}

struct KeyButton: View {
  let text: String
  let width: CGFloat
  var height: CGFloat = 80
  var action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      Text("\(text)")
    }
    .buttonStyle(KeyStyle(width: width, height: height))
  }
}

struct KeyPad: View {
  let spacing: CGFloat = 8
  let uiTextField: UITextField
  let onEvaluate: () -> Void
  @State var usesShortButtons = false
  
  var body: some View {
    // NOTE: for getting available width
    SimpleSizeReader { proxy in
      AnyView {
        let unitWidth = max(0, ((proxy.maxSize()?.width ?? 0) - 3 * spacing) / 4)
        let unitHeight: CGFloat = usesShortButtons ? 40 : 80
        func generic(_ text: String, width: CGFloat = unitWidth, height: CGFloat = unitHeight, action: @escaping () -> Void) -> some View {
          KeyButton(text: text, width: width, height: height) {
            action()
          }
        }
        func insert(_ text: String, width: CGFloat = unitWidth, height: CGFloat = unitHeight) -> some View {
          generic(text, width: width, height: height) {
            uiTextField.insertText(text)
          }
        }
        return .init(
          VStack(spacing: 0) {
            Color.clear
              .frame(height: 0)
              .measure(proxy)
            Toggle("Short Buttons", isOn: $usesShortButtons)
              .toggleStyle(.button)
            Spacer().frame(height: 8)
            VStack(spacing: 8) {
              HStack(spacing: 8) {
                generic("clear") { uiTextField.text = "" }
                insert("/")
                insert("*")
                generic("⌫") { uiTextField.deleteBackward() }
              }
              HStack(spacing: 8) {
                insert("7")
                insert("8")
                insert("9")
                insert("-")
              }
              HStack(spacing: 8) {
                insert("4")
                insert("5")
                insert("6")
                insert("+")
              }
              HStack(spacing: 8) {
                VStack {
                  HStack {
                    insert("1")
                    insert("2")
                    insert("3")
                  }
                  HStack {
                    insert("0", width: unitWidth * 2 + spacing)
                    insert(".")
                  }
                }
                generic("enter", height: unitHeight * 2 + spacing) {
                  onEvaluate()
                }
              }
            }
          }
            .padding(.top, 16)
            .padding(.horizontal, 8)
            .background(Color.gray)
        )
      }
    }
  }
}

struct InputViewPage: View {
  @State var expression = ""
  @State var result = ""
  @State var isFocused = false
  
  var body: some View {
    VStack(alignment: .leading) {
      UIKitTextField(
        config: .init {
          PaddedTextField()
        }
          .placeholder("Enter your expression")
          .value(text: $expression)
          .focused($isFocused)
          .inputView(content: .view { uiTextField in
            KeyPad(uiTextField: uiTextField, onEvaluate: onEvaluate)
          })
          .inputAccessoryView(content: .view { _ in
            HStack {
              Text("Preview: \(compute(expression: expression))")
                .frame(maxWidth: .infinity)
            }
            .background(Color.black)
            .foregroundColor(Color.white)
          })
          .shouldReturn { _ in
            onEvaluate()
            return false
          }
      )
      .padding(4)
      .border(Color.black)
      
      Text("Result: \(result)")
      
      Divider()

      Button {
        isFocused = false
      } label: {
        Text("Dismiss")
      }
    }
    .padding()
  }
  
  func compute(expression: String) -> String {
    if let result = try? Expression(expression).evaluate() {
      return "\(result)"
    } else {
      return "nil"
    }
  }
  
  func onEvaluate() {
    self.result = compute(expression: expression)
  }
}

struct InputViewPage_Previews: PreviewProvider {
  static var previews: some View {
    InputViewPage()
  }
}
