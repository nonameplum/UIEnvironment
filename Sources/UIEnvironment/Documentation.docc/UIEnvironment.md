# ``UIEnvironment``

A framework that mimics the SwiftUI view's environment to replicate the value distribution thought your UIKit view hierarchy.

## Additional Resources

* [GitHub Repo](https://github.com/nonameplum/UIEnvironment)
* [SwiftUI @Environment](https://developer.apple.com/documentation/swiftui/environment)
* [Example App](https://github.com/nonameplum/UIEnvironment/tree/main/XcodeProject)

## Overview

Use the `UIEnvironment` property wrapper to read a value stored in a view’s environment. Indicate the value to read using an `UIEnvironmentValues` key path in the property declaration. For example, you can create a property that reads the user interface style of the current view using the key path of the `userInterfaceStyle` property:

```swift
final class ViewController: UIViewController {
    @UIEnvironment(\.userInterfaceStyle) private var userInterfaceStyle
    ...
}
```

You can condition a view's content on the associated value, which you read from the declared property by directly referring from it:

```swift    
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = userInterfaceStyle ? .black : .white
}
```

If the value changes, UIEnvironment framework updates any view that implements ``UIEnvironmentUpdating``.
For example, that might happen in the above example if the user changes the Appearance settings.

```swift
final class ViewController: UIViewController {
    @UIEnvironment(\.userInterfaceStyle) private var userInterfaceStyle
    ...
}

extension ViewController: UIEnvironmentUpdating {
    func updateEnvironment() {
        view.backgroundColor = userInterfaceStyle ? .black : .white
    }
}
```