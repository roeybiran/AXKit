# AXKit

A type-safe wrapper around `AXUIElement.h`.

## Testability

Because `AXUIElement.h` uses opauqe CF types, testing is nearly impossible without resorting to. Here’s how it could be done with `AXKit` (which was designed to be generic mainly for this purpose):
Typically, you’ll wrap your business logic that involves `AXKit` in a generic class, from which you’ll expose Swift-native objects relevant to your domain. For example:

```swift
import AXKit

struct MenuItem {
  let title: String
}

class Wrapper<T: AXClient> {
  let client: T

  func getMenuItems() -> [MenuItem] {
  	try client.attributeValue(...)
  }
}
```

Then, you’ll declare a client for your class to be used in production contexts. The fact that it’s generic is now an implementation detail. For example:

```swift
class Wrapper {
	let client = AXClientLive()

	func getMenuItems() -> [MenuItem] {
  		try client.attributeValue(...)
  	}
}
```

And finally, to test your business logic, you’ll use your class and “inject” the mock implementation of `AXKit`, `AXClientMock`. The mock exposes its API using closures that can be easily overridden, along with types that can be easily created, mocked and extended for testing purposes.

```swift
@Test
func basicTest() {
  let mock = AXClientMock()
  mock._application = { pid in UIElementMock() }
  let sut = Wrapper(client: mock)
}
```

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
