import UIKit
import UIKitTextField

class PaddedTextField: BaseUITextField {
  var padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8) {
    didSet {
      setNeedsLayout()
    }
  }
  
  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    super.textRect(forBounds: bounds).inset(by: padding)
  }
  
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    super.editingRect(forBounds: bounds).inset(by: padding)
  }
}
