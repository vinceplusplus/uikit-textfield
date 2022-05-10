#if canImport(UIKit)

import UIKit

public protocol UITextFieldProtocol: UITextField {
  var inputViewController: UIInputViewController? { get set }
  var inputAccessoryViewController: UIInputViewController? { get set }
}

#endif
