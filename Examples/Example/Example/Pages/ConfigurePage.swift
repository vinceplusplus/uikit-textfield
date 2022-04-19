import SwiftUI
import UIKitTextField

struct ConfigurePage: View {
  @State var text = "some text..."
  @State var pads = true
  
  var body: some View {
    VStack {
      Toggle("Padding", isOn: $pads)
      UIKitTextField(
        config: .init {
          PaddedTextField()
        }
          .value(text: $text)
          .configure { uiTextField in
            uiTextField.padding = pads ? .init(top: 4, left: 8, bottom: 4, right: 8) : .zero
          }
      )
      .border(Color.black)
    }
    .padding()
  }
}

struct ConfigurePage_Previews: PreviewProvider {
  static var previews: some View {
    ConfigurePage()
  }
}
