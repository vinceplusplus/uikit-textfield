#if canImport(UIKit)

import SwiftUI

internal class InputViewManager {
  let textField: UITextField
  let hostingController: InputViewContentController
  let inputView: UIInputView
  let inputViewContent: UIView
  var lastIntrinsicContentSize: CGSize?
  
  init<Content>(with textField: UITextField, content: Content) where Content: View {
    self.textField = textField
    hostingController = .init(rootView: .init(content))
    
    inputViewContent = hostingController.view
    inputViewContent.translatesAutoresizingMaskIntoConstraints = false

    inputView = .init()
    inputView.translatesAutoresizingMaskIntoConstraints = false
    inputView.allowsSelfSizing = true
    
    // NOTE: it seems it only works with `safeAreaLayoutGuide`, without it, the animation of the input
    //       accessory view won't sync well with bottom edge of the safe area
    inputView.addSubview(inputViewContent)
    inputViewContent.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: inputView.safeAreaLayoutGuide.leadingAnchor).isActive = true
    inputViewContent.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: inputView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    inputViewContent.safeAreaLayoutGuide.topAnchor.constraint(equalTo: inputView.safeAreaLayoutGuide.topAnchor).isActive = true
    inputViewContent.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: inputView.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    hostingController.delegate = self
  }
  
  func update<Content>(with content: Content) where Content: View {
    hostingController.rootView = .init(content)
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
