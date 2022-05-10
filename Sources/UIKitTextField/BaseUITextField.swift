#if canImport(UIKit)

import UIKit

open class BaseUITextField: UITextField {
  private var _inputViewController: UIInputViewController?
  private var _inputAccessoryViewController: UIInputViewController?
  
  open override var inputViewController: UIInputViewController? {
    get { _inputViewController }
    set { _inputViewController = newValue }
  }
  
  open override var inputAccessoryViewController: UIInputViewController? {
    get { _inputAccessoryViewController }
    set { _inputAccessoryViewController = newValue }
  }
}

extension BaseUITextField: UITextFieldProtocol {}

#endif
