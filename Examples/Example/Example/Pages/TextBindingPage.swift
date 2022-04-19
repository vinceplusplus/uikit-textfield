import SwiftUI
import UIKitTextField

struct TextBindingPage: View {
  @State var name: String = ""
  
  var body: some View {
    VStack(alignment: .leading) {
      UIKitTextField(
        config: .init()
          .value(text: $name)
      )
      .border(Color.black)
      Text("\(name.isEmpty ? "Please enter your name above" : "Hello \(name)")")
    }
    .padding()
  }
}

struct TextBindingPage_Previews: PreviewProvider {
  static var previews: some View {
    TextBindingPage()
  }
}
