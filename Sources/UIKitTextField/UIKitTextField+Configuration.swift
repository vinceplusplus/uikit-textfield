#if canImport(UIKit)

import SwiftUI

public extension UIKitTextField {
  struct ValueState {
    let updateViewValue: (_ textField: UITextFieldType) -> Void
    let onViewValueChanged: (_ textField: UITextFieldType) -> Void
  }
}

public extension UIKitTextField {
  struct FocusState {
    let isSet: () -> Bool
    let isUnset: () -> Bool
    let set: () -> Void
    let unset: () -> Void
  }
}

public extension UIKitTextField {
  struct Configuration {
    var makeTextFieldHandler: () -> UITextFieldType
    
    var valueState: ValueState? = nil
    
    var placeholder: String?
    var font: UIFont?
    var textColor: Color?
    var textAlignment: NSTextAlignment?
    
    var clearsOnBeginEditing: Bool?
    var clearsOnInsertion: Bool?
    
    var clearButtonMode: UITextField.ViewMode?

    var focusState: FocusState? = nil
    
    var stretchesHorizontally = true
    var stretchesVertically = false
    
    var inputViewContent: InputViewContent<UITextFieldType> = .none
    var inputAccessoryViewContent: InputViewContent<UITextFieldType> = .none

    // UITextFieldDelegate
    var shouldBeginEditingHandler: (_ uiTextField: UITextFieldType) -> Bool = { _ in true }
    var onBeganEditingHandler: (_ uiTextField: UITextFieldType) -> Void = { _ in }
    var shouldEndEditingHandler: (_ uiTextField: UITextFieldType) -> Bool = { _ in true }
    var onEndedEditingHandler: (_ uiTextField: UITextFieldType, _ reason: UITextField.DidEndEditingReason) -> Void = { _, _ in }
    var shouldChangeCharactersHandler: (_ uiTextField: UITextFieldType, _ range: NSRange, _ replacementString: String) -> Bool = { _, _, _ in true }
    var onChangedSelectionHandler: (_ uiTextField: UITextFieldType) -> Void = { _ in }
    var shouldClearHandler: (_ uiTextField: UITextFieldType) -> Bool = { _ in true }
    var shouldReturnHandler: (_ uiTextField: UITextFieldType) -> Bool = { _ in true }
    
    // UITextInputTraits
    var keyboardType: UIKeyboardType?
    var keyboardAppearance: UIKeyboardAppearance?
    var returnKeyType: UIReturnKeyType?
    var textContentType: UITextContentType?
    var isSecureTextEntry: Bool?
    var enablesReturnKeyAutomatically: Bool?
    var autocapitalizationType: UITextAutocapitalizationType?
    var autocorrectionType: UITextAutocorrectionType?
    var spellCheckingType: UITextSpellCheckingType?
    var smartQuotesType: UITextSmartQuotesType?
    var smartDashesType: UITextSmartDashesType?
    var smartInsertDeleteType: UITextSmartInsertDeleteType?
    
    // extra configuration
    var configureHandler: (_ uiTextField: UITextFieldType) -> Void = { _ in }

    public init() where UITextFieldType == BaseUITextField {
      makeTextFieldHandler = { .init() }
    }
    
    public init(_ makeUITextField: @escaping () -> UITextFieldType) {
      makeTextFieldHandler = makeUITextField
    }
  }
}

public extension UIKitTextField.Configuration {
  func value(
    updateViewValue: @escaping (_ textField: UITextFieldType) -> Void,
    onViewValueChanged: @escaping (_ textField: UITextFieldType) -> Void
  ) -> Self {
    var config = self
    config.valueState = .init(
      updateViewValue: updateViewValue,
      onViewValueChanged: onViewValueChanged
    )
    return config
  }
  
  func value(text: Binding<String>) -> Self {
    value(
      updateViewValue: { textField in
        if textField.text != text.wrappedValue {
          textField.text = text.wrappedValue
        }
      },
      onViewValueChanged: { textField in
        text.wrappedValue = textField.text ?? ""
      }
    )
  }
  
  @available(iOS 15.0, *)
  func value<F>(value: Binding<F.FormatInput>, format: F) -> Self
  where
    F: ParseableFormatStyle,
    F.FormatOutput == String
  {
    self.value(
      value: Binding<F.FormatInput?>(
        get: {
          value.wrappedValue
        },
        set: {
          if let newValue = $0 {
            value.wrappedValue = newValue
          }
        }
      ),
      format: format
    )
  }
  
  @available(iOS 15.0, *)
  func value<F>(value: Binding<F.FormatInput?>, format: F) -> Self
  where
    F: ParseableFormatStyle,
    F.FormatOutput == String
  {
    self.value(
      updateViewValue: { textField in
        if !textField.isFirstResponder {
          if let wrappedValue = value.wrappedValue {
            let text = format.format(wrappedValue)
            if text != textField.text {
              textField.text = text
            }
          } else {
            textField.text = ""
          }
        }
      },
      onViewValueChanged: { textField in
        if textField.isFirstResponder {
          if let newValue = try? format.parseStrategy.parse(textField.text ?? "") {
            value.wrappedValue = newValue
          } else {
            value.wrappedValue = nil
          }
        }
      }
    )
  }
  
  func value<V>(value: Binding<V>, formatter: Formatter) -> Self {
    self.value(
      value: Binding<V?>(
        get: {
          value.wrappedValue
        },
        set: {
          if let newValue = $0 {
            value.wrappedValue = newValue
          }
        }
      ),
      formatter: formatter
    )
  }
  
  func value<V>(value: Binding<V?>, formatter: Formatter) -> Self {
    self.value(
      updateViewValue: { textField in
        if !textField.isFirstResponder {
          if let wrappedValue = value.wrappedValue {
            if
              let text = formatter.string(for: wrappedValue),
              text != textField.text
            {
              textField.text = text
            }
          } else {
            textField.text = ""
          }
        }
      },
      onViewValueChanged: { textField in
        if textField.isFirstResponder {
          var objectValue: AnyObject? = nil
          if
            formatter.getObjectValue(&objectValue, for: textField.text ?? "", errorDescription: nil),
            let newValue = objectValue as? V
          {
            value.wrappedValue = newValue
          } else {
            value.wrappedValue = nil
          }
        }
      }
    )
  }
  
  func placeholder(_ placeholder: String?) -> Self {
    var config = self
    config.placeholder = placeholder
    return config
  }

  func font(_ font: UIFont?) -> Self {
    var config = self
    config.font = font
    return config
  }
  
  func textColor(_ color: Color?) -> Self {
    var config = self
    config.textColor = color
    return config
  }
  
  func textAlignment(_ textAlignment: NSTextAlignment?) -> Self {
    var config = self
    config.textAlignment = textAlignment
    return config
  }
  
  func clearsOnBeginEditing(_ clearsOnBeginEditing: Bool?) -> Self {
    var config = self
    config.clearsOnBeginEditing = clearsOnBeginEditing
    return config
  }
  
  func clearsOnInsertion(_ clearsOnInsertion: Bool?) -> Self {
    var config = self
    config.clearsOnInsertion = clearsOnInsertion
    return config
  }
  
  func clearButtonMode(_ clearButtonMode: UITextField.ViewMode?) -> Self {
    var config = self
    config.clearButtonMode = clearButtonMode
    return config
  }
  
  func focused(_ binding: Binding<Bool>) -> Self {
    var config = self
    config.focusState = .init(
      isSet: {
        binding.wrappedValue
      },
      isUnset: {
        !binding.wrappedValue
      },
      set: {
        if !binding.wrappedValue {
          binding.wrappedValue = true
        }
      },
      unset: {
        if binding.wrappedValue {
          binding.wrappedValue = false
        }
      }
    )
    return config
  }
  
  func focused<Value>(_ binding: Binding<Value?>, equals value: Value?) -> Self where Value: Hashable {
    var config = self
    config.focusState = .init(
      isSet: {
        binding.wrappedValue == value
      },
      isUnset: {
        binding.wrappedValue == nil
      },
      set: {
        if binding.wrappedValue != value {
          binding.wrappedValue = value
        }
      },
      unset: {
        if binding.wrappedValue != nil {
          binding.wrappedValue = nil
        }
      }
    )
    return config
  }
  
  func stretches(horizontal: Bool, vertical: Bool) -> Self {
    var config = self
    config.stretchesHorizontally = horizontal
    config.stretchesVertically = vertical
    return config
  }

  func inputView(content: InputViewContent<UITextFieldType>) -> Self {
    var config = self
    config.inputViewContent = content
    return config
  }
  
  func inputAccessoryView(content: InputViewContent<UITextFieldType>) -> Self {
    var config = self
    config.inputAccessoryViewContent = content
    return config
  }
}

// extra configuration
public extension UIKitTextField.Configuration {
  func configure(handler: @escaping (_ uiTextField: UITextFieldType) -> Void) -> Self {
    var config = self
    config.configureHandler = handler
    return config
  }
}

#endif
