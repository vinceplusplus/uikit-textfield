import SwiftUI
import UIKitTextField

class CustomTextField: UITextField {
  let padding = UIEdgeInsets(top: 4, left: 8 + 32 + 8, bottom: 4, right: 8)
  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    super.textRect(forBounds: bounds).inset(by: padding)
  }
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    super.editingRect(forBounds: bounds).inset(by: padding)
  }
}

struct CustomTextFieldPage: View {
  @State var isFocused = false
  var body: some View {
    VStack {
      UIKitTextField(
        config: .init {
          CustomTextField()
        }
          .focused($isFocused)
          .textContentType(.emailAddress)
          .keyboardType(.emailAddress)
          .autocapitalizationType(UITextAutocapitalizationType.none)
          .autocorrectionType(.no)
      )
      .background(alignment: .leading) {
        HStack(spacing: 0) {
          Color.clear.frame(width: 8)
          ZStack {
            Image(systemName: "mail")
          }
          .frame(width: 32)
        }
      }
      .border(Color.black)
      
      Button {
        isFocused = false
      } label: {
        Text("Dismiss")
      }
    }
    .padding()
  }
}

struct CustomTextFieldPage_Previews: PreviewProvider {
  static var previews: some View {
    CustomTextFieldPage()
  }
}
