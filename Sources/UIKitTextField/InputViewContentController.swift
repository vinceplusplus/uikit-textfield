#if canImport(UIKit)

import SwiftUI

internal protocol InputViewContentControllerDelegate: AnyObject {
  func viewWillLayoutSubviews(_ viewController: InputViewContentController)
  func viewDidLayoutSubviews(_ viewController: InputViewContentController)
}

internal class InputViewContentController: UIHostingController<AnyView> {
  weak var delegate: InputViewContentControllerDelegate?
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    delegate?.viewWillLayoutSubviews(self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    delegate?.viewDidLayoutSubviews(self)
  }
}

#endif
