import SwiftUI
import AXKit
import Cocoa
import Dependencies

struct ContentView<AX: AXClient>: View {

  let client: AX

  init(ax: AX) {
    self.client = ax
  }

  func run(pid: pid_t) {
    do {
      let appElement = client.application(pid: pid)
      let observer = try client.createObserver(application: pid)
//      try? client.addNotification(observer: observer, element: appElement, notification: .titleChanged)
//      try? client.addNotification(observer: observer, element: appElement, notification: .windowMiniaturized)
//      try? client.addNotification(observer: observer, element: appElement, notification: .windowDeminiaturized)
      try? client.addNotification(observer: observer, element: appElement, notification: .windowCreated)
      Task {
        for await n in client.start(observer: observer) {
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
    .task {
      let pid = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Safari").first!.processIdentifier

      run(pid: pid)
    }
  }
}

#Preview {
  ContentView(ax: AXClientLive())
}
