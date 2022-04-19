import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: TextBindingPage()) {
          Text("Text Binding")
        }
        NavigationLink(destination: ValueBindingPage()) {
          Text("Value Binding")
        }
        NavigationLink(destination: FocusBindingPage()) {
          Text("Focus Binding")
        }
        NavigationLink(destination: CustomTextFieldPage()) {
          Text("Custom Text Field")
        }
        NavigationLink(destination: StretchingPage()) {
          Text("Stretching")
        }
        NavigationLink(destination: InputViewPage()) {
          Text("Input View")
        }
        NavigationLink(destination: ConfigurePage()) {
          Text("Custom Configuration")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
