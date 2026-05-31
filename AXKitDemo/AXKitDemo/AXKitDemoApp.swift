//

import AXKit
import RBKit
import SwiftUI

@main
struct AXKitDemoApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(ax: AXClientLive(), rl: CFRunLoopClientLive())
    }
  }
}
