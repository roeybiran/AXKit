//

import SwiftUI
import AXKit

@main
struct AXKitDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(ax: AXClientLive())
        }
    }
}
