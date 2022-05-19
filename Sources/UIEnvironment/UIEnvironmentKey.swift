import Foundation

/// A key for accessing values in the environment.
///
/// You can create custom environment values by extending the
/// ``UIEnvironmentValues`` structure with new properties.
/// First declare a new environment key type and specify a value for the
/// required ``defaultValue`` property:
///
/// ```swift
/// private struct MyEnvironmentKey: UIEnvironmentKey {
///     static let defaultValue: String = "Default value"
/// }
/// ```
///
/// The Swift compiler automatically infers the associated ``Value`` type as the
/// type you specify for the default value. Then use the key to define a new
/// environment value property:
///
/// ```swift
/// extension UIEnvironmentValues {
///     var myCustomValue: String {
///         get { self[MyEnvironmentKey.self] }
///         set { self[MyEnvironmentKey.self] = newValue }
///     }
/// }
/// ```
///
/// Clients of your environment value never use the key directly.
/// Instead, they use the key path of your custom environment value property.
/// To set the environment value for a view/view controllers and all its children, add the
/// ``UIEnvironmentable/environment(_:_:)`` convenience method:
///
/// ```swift
/// MyView()
///     .environment(\.myCustomValue, "Another string")
/// ```
///
/// To read the value from inside `MyView` or one of its descendants, use the
/// ``UIEnvironment`` property wrapper:
///
/// ```swift
/// class MyView: UILabel {
///     @UIEnvironment(\.myCustomValue) var customValue: String
///
///     override init(frame: CGRect) {
///         super.init(frame: frame)
///         self.text = customValue
///     }
///
///     required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
/// }
/// ```
///
public protocol UIEnvironmentKey {
    
    /// The associated type representing the type of the environment key's value.
    associatedtype Value

    /// The default value for the environment key.
    static var defaultValue: Self.Value { get }
}
