import SwiftUI
import AXKit
import Cocoa
import Dependencies

struct ContentView<AX: AXClient, RL: CFRunLoopClient> : View  where AX.RunLoopSource == RL.RunLoopSource {


  let client: AX
  let manager: AXObserverManager<AX, RL>

  init(ax: AX, rl: RL) {
    self.client = ax
    self.manager = AXObserverManager(client: client, runLoopClient: rl)
  }

  func run(pid: pid_t) {
    do {
      let appElement = client.application(pid: pid)

      try manager.createObserver(process: pid)
//      try? client.addNotification(observer: observer, element: appElement, notification: .titleChanged)
//      try? client.addNotification(observer: observer, element: appElement, notification: .windowMiniaturized)
//      try? client.addNotification(observer: observer, element: appElement, notification: .windowDeminiaturized)
//      try? client.addNotification(observer: observer, element: appElement, notification: .windowCreated)
      let stream = manager.notifications(for: pid)
      try manager.add(notification: .windowCreated, to: pid, element: appElement)
      Task {
        for try await n in stream {
          print(n)
        }
      }
    } catch {
      print("error!", error)
    }
  }

  var body: some View {
    VStack {

    }
    .padding()
    .onAppear {
      client.isProcessTrusted(usePrompt: true)
    }
    .task {
      let pid = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Safari").first!.processIdentifier

      run(pid: pid)
    }
  }
}

#Preview {
  ContentView(ax: AXClientLive(), rl: CFRunLoopClientLive())
}
