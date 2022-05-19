import Foundation

/// A collection of environment values propagated through a view/view controller hierarchy.
///
/// UIEnvironmentValues exposes a collection of values to your app's views in an
/// `UIEnvironmentValues` structure. To read a value from the structure,
/// declare a property using the ``UIEnvironment`` property wrapper and
/// specify the value's key path. For example, you can read the current locale:
///
///     @UIEnvironment(\.locale) var locale: Locale
///
/// Use the property you declare to dynamically control a view's layout.
/// UIEnvironmentValues automatically sets or updates many environment values, like
/// ``UIEnvironmentValues/locale``, based on device characteristics, system state,
/// or user settings.
///
/// You can set or override some values using the ``UIEnvironmentable/environment(_:_:)``
/// view modifier:
///
///     MyView()
///         .environment(\.locale, .init(identifier: "pl"))
///
/// The value that you set affects the environment for the view that you modify
/// --- including its descendants in the view hierarchy --- but only up to the
/// point where you apply a different environment modifier.
///
/// Create custom environment values by defining a type that
/// conforms to the ``UIEnvironmentKey`` protocol, and then extending the
/// environment values structure with a new property. Use your key to get and
/// set the value, and provide a dedicated modifier for clients to use when
/// setting the value:
///
///     private struct MyEnvironmentKey: UIEnvironmentKey {
///         static let defaultValue: String = "Default value"
///     }
///
///     extension UIEnvironmentValues {
///         var myCustomValue: String {
///             get { self[MyEnvironmentKey.self] }
///             set { self[MyEnvironmentKey.self] = newValue }
///         }
///     }
///
/// Clients of your value then access the value in the usual way, reading it
/// with the ``UIEnvironment`` property wrapper, and setting it
/// using the ``UIEnvironmentable/environment(_:_:)`` convenience method.
public struct UIEnvironmentValues {
    private var values: [ObjectIdentifier: Any] = [:]

    /// Creates an environment values instance.
    ///
    /// You don't typically create an instance of ``UIEnvironmentValues``
    /// directly. Doing so would provide access only to default values that
    /// don't update based on system settings or device characteristics.
    /// Instead, you rely on an environment values' instance
    /// that UIEnvironment framework manages for you when you use the ``UIEnvironment``
    /// property wrapper and the ``UIEnvironmentable/environment(_:_:)`` convenience method.
    public init() {}

    /// Accesses the environment value associated with a custom key.
    ///
    /// Create custom environment values by defining a key
    /// that conforms to the ``UIEnvironmentKey`` protocol, and then using that
    /// key with the subscript operator of the ``UIEnvironmentValues`` structure
    /// to get and set a value for that key:
    ///
    ///     private struct MyEnvironmentKey: UIEnvironmentKey {
    ///         static let defaultValue: String = "Default value"
    ///     }
    ///
    ///     extension UIEnvironmentValues {
    ///         var myCustomValue: String {
    ///             get { self[MyEnvironmentKey.self] }
    ///             set { self[MyEnvironmentKey.self] = newValue }
    ///         }
    ///     }
    ///
    /// You use custom environment values the same way you use system-provided
    /// values, setting a value with the ``UIEnvironmentable/environment(_:_:)`` convenience
    /// method, and reading values with the ``UIEnvironment`` property wrapper.
    public subscript<K>(key: K.Type) -> K.Value where K: UIEnvironmentKey {
        get {
            if let value = self.values[ObjectIdentifier(key)] as? K.Value {
                return value
            } else {
                self.noValueFound?()
                return key.defaultValue
            }
        }
        set {
            self.values[ObjectIdentifier(key)] = newValue
        }
    }

    // MARK: Helpers
    private var noValueFound: (() -> Void)?

    internal mutating func hasValue<V>(for keyPath: KeyPath<UIEnvironmentValues, V>) -> Bool {
        var hasValue = true
        self.noValueFound = { hasValue = false }
        let _ = self[keyPath: keyPath]
        self.noValueFound = nil
        return hasValue
    }
}
