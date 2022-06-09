#if canImport(UIKit)

import SwiftUI

public extension UIKitTextField {
  class Coordinator: NSObject, UITextFieldDelegate {
    var wrapper: UIKitTextField
    
    let textField: UITextFieldType
    
    let inputViewManager: InputViewManager<UITextFieldType>
    let inputAccessoryViewManager: InputViewManager<UITextFieldType>
    
    var lastForceUpdateCounter: Int = -1

    init(_ wrapper: UIKitTextField) {
      self.wrapper = wrapper
      
      textField = wrapper.config.makeTextFieldHandler()
      
      inputViewManager = .init(with: textField, content: EmptyView())
      inputAccessoryViewManager = .init(with: textField, content: EmptyView())

      super.init()

      textField.delegate = self
    }
    
    func updateInputView(
      with inputViewContent: InputViewContent<UITextFieldType>,
      inputViewManager: InputViewManager<UITextFieldType>,
      keyPath: ReferenceWritableKeyPath<UITextFieldProtocol, UIInputViewController?>
    ) {
      let inputViewController: UIInputViewController?
      if let content = inputViewContent.content {
        inputViewManager.update(with: content(textField))
        inputViewController = inputViewManager.inputViewController
      } else {
        inputViewManager.update(with: EmptyView())
        inputViewController = nil
      }
      if textField[keyPath: keyPath] != inputViewController {
        textField[keyPath: keyPath] = inputViewController
        textField.reloadInputViews()
      }
    }
    
    func updateUITextInputTraits(with config: Configuration) {
      textField.keyboardType = config.keyboardType ?? .default
      textField.keyboardAppearance = config.keyboardAppearance ?? .default
      textField.returnKeyType = config.returnKeyType ?? .default
      textField.textContentType = config.textContentType
      textField.isSecureTextEntry = config.isSecureTextEntry ?? false
      textField.enablesReturnKeyAutomatically = config.enablesReturnKeyAutomatically ?? false
      textField.autocapitalizationType = config.autocapitalizationType ?? .sentences
      textField.autocorrectionType = config.autocorrectionType ?? .default
      textField.spellCheckingType = config.spellCheckingType ?? .default
      textField.smartQuotesType = config.smartQuotesType ?? .default
      textField.smartDashesType = config.smartDashesType ?? .default
      textField.smartInsertDeleteType = config.smartInsertDeleteType ?? .default
    }
    
    func update(with wrapper: UIKitTextField) {
      lastForceUpdateCounter = wrapper.forceUpdateCounter
      
      self.wrapper = wrapper
      
      let config = wrapper.config
      
      config.valueState?.updateViewValue(textField)

      textField.placeholder = config.placeholder
      textField.font = config.font
      if let textColor = config.textColor {
        textField.textColor = .init(textColor)
      } else {
        textField.textColor = nil
      }
      textField.textAlignment = config.textAlignment ?? .left
      textField.clearsOnBeginEditing = config.clearsOnBeginEditing ?? false
      textField.clearsOnInsertion = config.clearsOnInsertion ?? false
      textField.clearButtonMode = config.clearButtonMode ?? .never
      
      // NOTE: since it would trigger additional events, and state change is not allowed inside update().
      //       it's cleaner to do outside update() to let all events be handled in a way to allow state
      //       change without the use of some `isInsideUpdate` variable
      if let focusControl = config.focusState {
        func shouldFocus() -> Bool {
          focusControl.isSet() && !textField.isFirstResponder
        }
        func shouldBlur() -> Bool {
          focusControl.isUnset() && textField.isFirstResponder
        }
        
        if shouldFocus() {
          DispatchQueue.main.async {
            if shouldFocus() {
              self.textField.becomeFirstResponder()
            }
          }
        } else if shouldBlur() {
          DispatchQueue.main.async {
            if shouldBlur() {
              self.textField.resignFirstResponder()
            }
          }
        }
      }

      // https://stackoverflow.com/a/59193838
      textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      textField.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
      textField.setContentHuggingPriority(config.stretchesHorizontally ? .defaultLow : .defaultHigh, for: .horizontal)
      textField.setContentHuggingPriority(config.stretchesVertically ? .defaultLow : .defaultHigh, for: .vertical)

      updateInputView(
        with: wrapper.config.inputViewContent,
        inputViewManager: inputViewManager,
        keyPath: \.inputViewController
      )

      updateInputView(
        with: wrapper.config.inputAccessoryViewContent,
        inputViewManager: inputAccessoryViewManager,
        keyPath: \.inputAccessoryViewController
      )

      updateUITextInputTraits(with: config)

      config.configureHandler(textField)
    }
    
    // UITextFieldDelegate
    // @objc members cannot live in extension, https://stackoverflow.com/a/48403602
    public func textFieldShouldBeginEditing(_: UITextField) -> Bool {
      wrapper.config.shouldBeginEditingHandler(textField)
    }

    public func textFieldDidBeginEditing(_: UITextField) {
      wrapper.config.focusState?.set()
      wrapper.config.onBeganEditingHandler(textField)
    }

    public func textFieldShouldEndEditing(_: UITextField) -> Bool {
      return wrapper.config.shouldEndEditingHandler(textField)
    }

    public func textFieldDidEndEditing(_: UITextField, reason: UITextField.DidEndEditingReason) {
      wrapper.forceUpdateCounter += 1
      if wrapper.config.focusState?.isSet() == true {
        wrapper.config.focusState?.unset()
      }
      wrapper.config.onEndedEditingHandler(textField, reason)
    }

    public func textField(_: UITextField, shouldChangeCharactersIn range: NSRange, replacementString: String) -> Bool {
      wrapper.config.shouldChangeCharactersHandler(textField, range, replacementString)
    }

    public func textFieldDidChangeSelection(_: UITextField) {
      wrapper.config.valueState?.onViewValueChanged(textField)
      wrapper.config.onChangedSelectionHandler(textField)
    }

    public func textFieldShouldClear(_: UITextField) -> Bool {
      wrapper.config.shouldClearHandler(textField)
    }

    public func textFieldShouldReturn(_: UITextField) -> Bool {
      wrapper.config.shouldReturnHandler(textField)
    }
  }
}

#endif
