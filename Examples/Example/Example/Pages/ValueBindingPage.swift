import SwiftUI
import UIKitTextField

struct ValueBindingPage: View {
  @State var value: Int = 0
  @State var optionalValue: Int? = 0
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Enter a number:")
      UIKitTextField(
        config: .init()
          .value(value: $value, format: .number)
      )
      .border(Color.black)
      // NOTE: avoiding the formatting behavior which comes from Text()
      Text("Your input: \("\(value)")")
        .accessibilityIdentifier("result0")
      
      Divider()
      
      Text("Enter an optional number:")
      UIKitTextField(
        config: .init()
          .value(value: $optionalValue, format: .number)
      )
      .border(Color.black)
      Text("Your input: \(optionalValue.flatMap { "\($0)" } ?? "nil")")
        .accessibilityIdentifier("result1")

      Divider()
      
      Button {
        UIApplication.shared.sendAction(
          #selector(UIApplication.resignFirstResponder),
          to: nil,
          from: nil,
          for: nil
        )
      } label: {
        Text("Dismiss keyboard")
      }
    }
    .padding()
  }
}

struct ValueBindingPage_Previews: PreviewProvider {
  static var previews: some View {
    ValueBindingPage()
  }
}
