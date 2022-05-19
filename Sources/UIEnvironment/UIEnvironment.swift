import Foundation
import UIKit

/// A property wrapper that reads a value from a UIKit view's environment.
///
/// Use the `UIEnvironment` property wrapper to read a value
/// stored in a view's environment. Indicate the value to read using an
/// ``UIEnvironmentValues`` key path in the property declaration. For example, you
/// can create a property that reads the color scheme of the current
/// view using the key path of the ``UIEnvironmentValues/userInterfaceStyle``
/// property:
///
/// ```swift
/// @UIEnvironment(\.userInterfaceStyle) var userInterfaceStyle: UIUserInterfaceStyle
/// ```
///
/// You can condition a view's content on the associated value, which
/// you read from the declared property by directly referring from it:
///
/// ```swift
/// if userInterfaceStyle == .dark {
///     DarkContent()
/// } else {
///     LightContent()
/// }
/// ```
///
/// If the value changes, UIEnvironment framework updates any view
/// that implements ``UIEnvironmentUpdating``.
/// For example, that might happen in the above example if the user
/// changes the Appearance settings.
///
/// You can use this property wrapper to read --- but not set --- an environment
/// value. UIEnvironment framework updates some environment values automatically based on system
/// settings and provides reasonable defaults for others. You can override some
/// of these, as well as set custom environment values that you define,
/// using the ``UIEnvironmentable/environment(_:_:)`` convenience method.
///
/// For the complete list of environment values provided by UIEnvironment framework, see the
/// properties of the ``UIEnvironmentValues`` structure. For information about
/// creating custom environment values, see the ``UIEnvironmentKey`` protocol.
@propertyWrapper public struct UIEnvironment<Value> {
    public static subscript<EnclosingSelf: UIEnvironmentable>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            return instance.value(forKeyPath: keyPath)
        }
        set {}
    }

    @available(*, unavailable, message: "@UIEnvironment can only be applied to classes")
    /// The wrapped property can not be directly used.
    ///
    /// You don't access`wrappedValue` directly.
    /// Instead, you read the property variable created with
    /// the ``UIEnvironment`` property wrapper:
    ///
    /// ```swift
    /// @Environment(\.userInterfaceStyle) private var userInterfaceStyle
    ///
    /// if userInterfaceStyle == .dark {
    ///     DarkContent()
    /// } else {
    ///     LightContent()
    /// }
    /// ```
    /// 
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private let keyPath: KeyPath<UIEnvironmentValues, Value>

    /// Creates an environment property to read the specified key path.
    /// - Parameter keyPath: A key path to a specific resulting value.
    public init(_ keyPath: KeyPath<UIEnvironmentValues, Value>) {
        UIScreen.setupTraitCollectionListener
        UIWindow.setupOverrideUserInterfaceListener
        UIEnvironmentValues.setupCurrentLocaleListener
        UIEnvironmentValues.setupSizeCategoryListener
        self.keyPath = keyPath
    }
}
