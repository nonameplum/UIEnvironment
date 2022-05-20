# UIEnvironment

A framework that mimics the [SwiftUI view's environment](https://developer.apple.com/documentation/swiftui/environment) to replicate the value distribution thought your UIKit view hierarchy.

---

* [Overview](#Overview)
* [Documentation](#Documentation)
* [Installation](#Installation)
* [License](#License)

## Overview

Use the `UIEnvironment` property wrapper to read a value stored in a view’s environment. Indicate the value to read using an `UIEnvironmentValues` key path in the property declaration. 
For example, you can create a property that reads the user interface style of the current view using the key path of the `userInterfaceStyle` property:

```swift
final class ViewController: UIViewController {
    @UIEnvironment(\.userInterfaceStyle) private var userInterfaceStyle
    ...
}
```

You can condition a view's content on the associated value, which
you read from the declared property by directly referring from it:

```swift    
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = userInterfaceStyle == .dark ? .black : .white
}
```

If the value changes, UIEnvironment framework updates any view
that implements ``UIEnvironmentUpdating``.
For example, that might happen in the above example if the user
changes the Appearance settings.

```swift
final class ViewController: UIViewController {
    @UIEnvironment(\.userInterfaceStyle) private var userInterfaceStyle
    ...
}

extension ViewController: UIEnvironmentUpdating {
    func updateEnvironment() {
        view.backgroundColor = userInterfaceStyle == .dark ? .black : .white
    }
}
```

Please refer to the [example application](https://github.com/nonameplum/UIEnvironment/tree/main/XcodeProject) for more details.

You can use this property wrapper to read _but not set_ an environment
value. UIEnvironment framework updates some environment values automatically based on system
settings and provides reasonable defaults for others. You can override some
of these, as well as set custom environment values that you define,
using the `UIEnvironmentable.environment(_:_:)` convenience method.
For the complete list of environment values provided by UIEnvironment framework, see the
properties of the `UIEnvironmentValues` structure. For information about
creating custom environment values, see the `UIEnvironmentKey` protocol.

## Documentation

The documentation for the latest release is available here:

* [main](https://nonameplum.github.io/UIEnvironment/main/documentation/uienvironment/)
* [1.0.0](https://nonameplum.github.io/UIEnvironment/1.0.0/documentation/uienvironment/)

## Installation

You can add UIEnvironment to an Xcode project by adding it as a package dependency.

  1. From the **File** menu, select **Add Packages...**
  2. Enter "https://github.com/nonameplum/uienvironment" into the package repository URL text field
  3. Depending on how your project is structured:
      - If you have a single application target that needs access to the library, then add **UIEnvironment** directly to your application.
      - If you want to use this library from multiple Xcode targets, or mixing Xcode targets and SPM targets, you must create a shared framework that depends on **UIEnvironment** and then depend on that framework in all of your targets.


You can add `UIEnvironment` to an Xcode project by adding it as a package dependency.

### Adding UIEnvironment as a Dependency

To use the UIEnvironment framework in a SwiftPM project, add the following line to the dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/nonameplum/uienvironment"),
```

Include `"UIEnvironment"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "UIEnvironment", package: "uienvironment"),
]),
```

Finally, add `import UIEnvironment` to your source code.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
