#if canImport(UIKit)

import UIKit

public extension UIKitTextField.Configuration {
  func keyboardType(_ keyboardType: UIKeyboardType?) -> Self {
    var config = self
    config.keyboardType = keyboardType
    return config
  }
  
  func keyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance?) -> Self {
    var config = self
    config.keyboardAppearance = keyboardAppearance
    return config
  }
  
  func returnKeyType(_ returnKeyType: UIReturnKeyType?) -> Self {
    var config = self
    config.returnKeyType = returnKeyType
    return config
  }
  
  func textContentType(_ textContentType: UITextContentType?) -> Self {
    var config = self
    config.textContentType = textContentType
    return config
  }
  
  func isSecureTextEntry(_ isSecureTextEntry: Bool?) -> Self {
    var config = self
    config.isSecureTextEntry = isSecureTextEntry
    return config
  }
  
  func enablesReturnKeyAutomatically(_ enablesReturnKeyAutomatically: Bool?) -> Self {
    var config = self
    config.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
    return config
  }
  
  func autocapitalizationType(_ autocapitalizationType: UITextAutocapitalizationType?) -> Self {
    var config = self
    config.autocapitalizationType = autocapitalizationType
    return config
  }
  
  func autocorrectionType(_ autocorrectionType: UITextAutocorrectionType?) -> Self {
    var config = self
    config.autocorrectionType = autocorrectionType
    return config
  }
  
  func spellCheckingType(_ spellCheckingType: UITextSpellCheckingType?) -> Self {
    var config = self
    config.spellCheckingType = spellCheckingType
    return config
  }
  
  func smartQuotesType(_ smartQuotesType: UITextSmartQuotesType?) -> Self {
    var config = self
    config.smartQuotesType = smartQuotesType
    return config
  }
  
  func smartDashesType(_ smartDashesType: UITextSmartDashesType?) -> Self {
    var config = self
    config.smartDashesType = smartDashesType
    return config
  }
  
  func smartInsertDeleteType(_ smartInsertDeleteType: UITextSmartInsertDeleteType?) -> Self {
    var config = self
    config.smartInsertDeleteType = smartInsertDeleteType
    return config
  }
}

#endif
