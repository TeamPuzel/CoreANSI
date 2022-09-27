# CoreANSI

This is CoreANSI, a library for interacting with the terminal, and the foundation of SwiftTerminalUI.
It supports formatting and colors too!

Example:

```swift
import CoreANSI

@main
struct ColorTestMain {
    static func main() {
        let window = getWindowSize()
        print(window.x)
        print(window.y)
        print("Hello"
            .foregroundColor(.red)
            .formatting(.underline, .blinking))
    }
}
```
