import AXKit
import Cocoa
import Dependencies
import SwiftUI

struct ContentView<AX: AXClient, RL: CFRunLoopClient>: View where AX.RunLoopSource == RL.RunLoopSource {

  // MARK: Lifecycle

  init(ax: AX, rl: RL) {
    client = ax
    manager = AXObserverManager(client: client, runLoopClient: rl)
  }

  // MARK: Internal

  let client: AX
  let manager: AXObserverManager<AX, RL>

  var body: some View {
    VStack { }
      .padding()
      .onAppear {
        client.isProcessTrusted(usePrompt: true)
      }
      .task {
        let pid = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Safari").first!.processIdentifier

        run(pid: pid)
      }
  }

  func run(pid: pid_t) {
    do {
      let appElement = client.application(pid: pid)

      let s = try client.attributeValue(
        element: appElement,
        for: client.children, client.windows, client.menuBar,
        stopOnError: false)
      let win = s.1!.first!
      _ = try client.attributeValue(
        element: win,
        for: client.children, .title,
        stopOnError: false)
//      let stream = manager.notifications(for: pid)
//      try manager.add(notification: .windowCreated, to: pid, element: appElement)
//      Task {
//        for try await n in stream {
//          print(n)
//        }
//      }
    } catch {}
  }

}

#Preview {
  ContentView(ax: AXClientLive(), rl: CFRunLoopClientLive())
}
