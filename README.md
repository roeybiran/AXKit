# AXKit

A type-safe wrapper around `AXUIElement.h`.

## Testability

Because `AXUIElement.h` uses opaque CF types, testing is nearly impossible without resorting to mocks. `AXKit` was designed to be generic mainly for this purpose, and `AXKitTestSupport` provides a complete mock implementation.

### Using AXKitTestSupport

In your app, you'll typically create a generic class that wraps over `AXClient`. That class should return native Swift types relevant to your domain. For example:

```swift
import AXKit

struct MenuItem {
  let title: String
}

class MenuService<Client: AXClient> {
  let client: Client

  init(client: Client) {
    self.client = client
  }

  func getMenuItems(for application: pid_t) throws -> [MenuItem] {
    let appElement = client.application(pid: application)
    let menuBar = try client.attributeValue(element: appElement, for: client.menuBar)
    // ... convert to MenuItem array
    return []
  }
}
```

In production, you'll use `AXClientLive`:

```swift
let service = MenuService(client: AXClientLive())
```

### Testing with Mocks

When testing your class, inject the mock client from `AXKitTestSupport` and override the `var _closures` (not the methods). The mock exposes configurable closures for every protocol method:

```swift
import AXKit
import AXKitTestSupport
import Testing

@Test
func getMenuItems_shouldReturnMenuItems() throws {
  let mock = AXClientMock()
  let mockElement = UIElementMock(id: "menu-bar")
  
  // Override the closure, not the method
  mock._application = { pid in UIElementMock(id: "app-\(pid)") }
  mock._attributeValue = { element, attribute, value in
    value.pointee = mockElement
    return .success
  }
  
  let sut = MenuService(client: mock)
  let items = try sut.getMenuItems(for: 12345)
  // Assert on items...
}
```

**Important**: Always override the `var _closures` (like `_application`, `_attributeValue`, etc.), not the protocol methods themselves. The mock methods delegate to these closures, allowing you to control behavior in tests.

## TODO

- Improve type safety:
  - Restrict notifications per element type (e.g. disallow adding "AXApplicationHidden" on an "AXWindow").
  - Restrict actions per element type (e.g., disallow performing "AXPress" on an "AXWindow").
  - Restrict attributes per element type (e.g., attribute "AXEnhancedUserInterface" won't be available on "AXWindow").
- Add chaining (e.g. `client.application().value(.children)[0].value("FOO")...`)

## References

- [/System/Library/Accessibility/AccessibilityDefinitions.plist](/System/Library/Accessibility/AccessibilityDefinitions.plist)

## Acknowledgements

- [AXSwift](https://github.com/tmandry/AXSwift)
