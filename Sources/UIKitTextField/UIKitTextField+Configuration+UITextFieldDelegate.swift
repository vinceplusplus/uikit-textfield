#if canImport(UIKit)

import UIKit

public extension UIKitTextField.Configuration {
  func shouldBeginEditing(handler: @escaping (_ uiTextField: UITextFieldType) -> Bool) -> Self {
    var config = self
    config.shouldBeginEditingHandler = handler
    return config
  }
  
  func onBeganEditing(handler: @escaping (_ uiTextField: UITextFieldType) -> Void) -> Self {
    var config = self
    config.onBeganEditingHandler = handler
    return config
  }
  
  func shouldEndEditing(handler: @escaping (_ uiTextField: UITextFieldType) -> Bool) -> Self {
    var config = self
    config.shouldEndEditingHandler = handler
    return config
  }
  
  func onEndedEditing(handler: @escaping (_ uiTextField: UITextFieldType, _ reason: UITextField.DidEndEditingReason) -> Void) -> Self {
    var config = self
    config.onEndedEditingHandler = handler
    return config
  }
  
  func shouldChangeCharacters(handler: @escaping (_ uiTextField: UITextFieldType, _ range: NSRange, _ replacementString: String) -> Bool) -> Self {
    var config = self
    config.shouldChangeCharactersHandler = handler
    return config
  }
  
  func onChangedSelection(handler: @escaping (_ uiTextField: UITextFieldType) -> Void) -> Self {
    var config = self
    config.onChangedSelectionHandler = handler
    return config
  }
  
  func shouldClear(handler: @escaping (_ uiTextField: UITextFieldType) -> Bool) -> Self {
    var config = self
    config.shouldClearHandler = handler
    return config
  }
  
  func shouldReturn(handler: @escaping (_ uiTextField: UITextFieldType) -> Bool) -> Self {
    var config = self
    config.shouldReturnHandler = handler
    return config
  }
}

#endif
