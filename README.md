# AXKit

A type-safe wrapper around `AXUIElement.h`.

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
