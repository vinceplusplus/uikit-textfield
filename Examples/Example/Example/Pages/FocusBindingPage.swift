import SwiftUI
import UIKitTextField

struct FocusBindingPage: View {
  @State var isFocused: Bool = false
  @State var focusedField: String?
  
  var body: some View {
    VStack(alignment: .leading) {
      Group {
        Text("isFocused: \(isFocused ? "true" : "false")")
          .accessibilityIdentifier("result0")
        UIKitTextField(
          config: .init()
            .focused($isFocused)
        )
        .border(Color.black)
        Button {
          isFocused.toggle()
        } label: {
          Text("Toggle Focus")
        }
      }
      
      Divider()
      
      Group {
        Text("Focus: \(focusedField.flatMap { "\($0)" } ?? "nil")")
          .accessibilityIdentifier("result1")
        HStack {
          UIKitTextField(
            config: .init()
              .focused($focusedField, equals: "field1a")
          )
          .border(Color.black)
          UIKitTextField(
            config: .init()
              .focused($focusedField, equals: "field1b")
          )
          .border(Color.black)
        }
        HStack {
          Button {
            focusedField = "field1a"
          } label: {
            Text("Focus")
              .frame(maxWidth: .infinity)
          }
          .accessibilityIdentifier("focusButton1a")
          Button {
            focusedField = "field1b"
          } label: {
            Text("Focus")
              .frame(maxWidth: .infinity)
          }
          .accessibilityIdentifier("focusButton1b")
        }
        Button {
          focusedField = nil
        } label: {
          Text("Unfocus")
            .frame(maxWidth: .infinity)
        }
      }
      
      Divider()
      
      Button {
        UIApplication.shared.sendAction(
          #selector(UIApplication.resignFirstResponder),
          to: nil,
          from: nil,
          for: nil
        )
      } label: {
        Text("Dismiss")
      }
    }
    .padding()
  }
}

struct FocusBindingPage_Previews: PreviewProvider {
  static var previews: some View {
    FocusBindingPage()
  }
}
