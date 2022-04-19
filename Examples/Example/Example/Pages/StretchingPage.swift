import SwiftUI
import UIKitTextField

struct StretchingPage: View {
  var body: some View {
    VStack {
      UIKitTextField(
        config: .init {
          PaddedTextField()
        }
          .stretches(horizontal: true, vertical: false)
      )
      .border(Color.black)
      
      UIKitTextField(
        config: .init {
          PaddedTextField()
        }
          .stretches(horizontal: false, vertical: false)
      )
      .border(Color.black)
      
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

struct StretchingPage_Previews: PreviewProvider {
  static var previews: some View {
    StretchingPage()
  }
}
