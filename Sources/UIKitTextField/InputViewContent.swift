#if canImport(UIKit)

import SwiftUI

public struct InputViewContent {
  let content: ((_ uiTextField: UITextField) -> AnyView)?
  
  init(content: ((_ uiTextField: UITextField) -> AnyView)?) {
    self.content = content
  }
  
  public static func view<Content>(
    @ViewBuilder content: @escaping (_ uiTextField: UITextField) -> Content
  ) -> Self
  where
    Content: View
  {
    .init(content: { .init(content($0)) })
  }
  
  public static var none: Self { .init(content: nil) }
}

#endif
