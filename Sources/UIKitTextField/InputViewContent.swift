#if canImport(UIKit)

import SwiftUI

public struct InputViewContent<UITextFieldType> where UITextFieldType: UITextFieldProtocol {
  let content: ((_ uiTextField: UITextFieldType) -> AnyView)?
  
  init(content: ((_ uiTextField: UITextFieldType) -> AnyView)?) {
    self.content = content
  }
  
  public static func view<Content>(
    @ViewBuilder content: @escaping (_ uiTextField: UITextFieldType) -> Content
  ) -> Self
  where
    Content: View
  {
    .init(content: { .init(content($0)) })
  }
  
  public static var none: Self { .init(content: nil) }
}

#endif
