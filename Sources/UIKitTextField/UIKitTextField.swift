#if canImport(UIKit)

import SwiftUI

public struct UIKitTextField<UITextFieldType>: UIViewRepresentable where UITextFieldType: UITextFieldProtocol {
  public typealias UIViewType = UITextFieldType

  var config: Configuration
  @State var forceUpdateCounter: Int = 0

  public init(config: Configuration) {
    self.config = config
  }

  public func makeCoordinator() -> Coordinator {
    .init(self)
  }
  
  public func makeUIView(context: Context) -> UITextFieldType {
    context.coordinator.textField
  }
  
  public func updateUIView(_ textField: UITextFieldType, context: Context) {
    context.coordinator.update(with: self)
  }
}

#endif
