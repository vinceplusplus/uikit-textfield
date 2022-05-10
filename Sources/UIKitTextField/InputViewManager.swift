#if canImport(UIKit)

import SwiftUI

internal class InputViewManager<UITextFieldType> where UITextFieldType: UITextFieldProtocol {
  let textField: UITextFieldType
  let inputViewContentController: InputViewContentController
  let inputViewContent: UIView
  let inputViewController: UIInputViewController
  let inputView: UIInputView
  var lastIntrinsicContentSize: CGSize?
  
  init<Content>(with textField: UITextFieldType, content: Content) where Content: View {
    self.textField = textField
    
    inputViewContentController = .init(rootView: .init(content))
    
    inputViewContent = inputViewContentController.view
    inputViewContent.translatesAutoresizingMaskIntoConstraints = false
    
    inputViewController = .init()
    inputView = inputViewController.inputView!
    inputView.translatesAutoresizingMaskIntoConstraints = false
    inputView.allowsSelfSizing = true
    
    inputViewController.addChild(inputViewContentController)
    inputView.addSubview(inputViewContent)
    inputViewContent.leadingAnchor.constraint(equalTo: inputView.leadingAnchor).isActive = true
    inputViewContent.trailingAnchor.constraint(equalTo: inputView.trailingAnchor).isActive = true
    inputViewContent.topAnchor.constraint(equalTo: inputView.topAnchor).isActive = true
    inputViewContent.bottomAnchor.constraint(equalTo: inputView.bottomAnchor).isActive = true
    inputViewContentController.didMove(toParent: inputViewController)
    
    inputViewContentController.delegate = self
  }
  
  func update<Content>(with content: Content) where Content: View {
    inputViewContentController.rootView = .init(content)
  }
}

extension InputViewManager: InputViewContentControllerDelegate {
  func viewWillLayoutSubviews(_: InputViewContentController) {}
  
  func viewDidLayoutSubviews(_: InputViewContentController) {
    inputViewContent.invalidateIntrinsicContentSize()
    if inputViewContent.intrinsicContentSize != lastIntrinsicContentSize {
      lastIntrinsicContentSize = inputViewContent.intrinsicContentSize
      // NOTE: reloadInputViews() seems to sometimes cause flickering of the paste button on suggestion bar on iPad.
      //       even a button press will trigger viewDidLayoutSubviews(), so only call it when necessary
      textField.reloadInputViews()
    }
  }
}

#endif
