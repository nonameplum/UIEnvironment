import Foundation
import UIKit

/// An interface for a view/view controller that uses ``UIEnvironment`` property.
public protocol UIEnvironmentable: UIResponder {}

extension UIView: UIEnvironmentable {}
extension UIViewController: UIEnvironmentable {}

extension UIEnvironmentable {
    /// Sets the environment value of the specified key path to the given value.
    ///
    /// Use this modifier to set one of the writable properties of the
    /// ``UIEnvironmentValues`` structure, including custom values that you
    /// create. For example, you can set the value associated with the
    /// ``UIEnvironmentValues/userInterfaceStyle`` key:
    ///
    /// ```swift
    /// MyView()
    ///     .environment(\.userInterfaceStyle, .dark)
    /// ```
    ///
    /// You then read the value inside `MyView` or one of its descendants
    /// using the ``UIEnvironment`` property wrapper:
    ///
    /// ```swift
    /// class MyView: UIView {
    ///     @Environment(\.userInterfaceStyle) var userInterfaceStyle: UIUserInterfaceStyle
    /// }
    /// ```
    ///
    /// The ``UIEnvironmentable/environment(_:_:)`` method affects the given view or view controller,
    /// as well as that view/view controller's descendant views and view controllers. It has no effect
    /// outside the view hierarchy on which you call it.
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates the property of the
    ///     ``UIEnvironmentValues`` structure to update.
    ///   - value: The new value to set for the item specified by `keyPath`.
    public func environment<V>(_ keyPath: WritableKeyPath<UIEnvironmentValues, V>, _ value: V) {
        var values = environmentValues
        values[keyPath: keyPath] = value
        objc_setAssociatedObject(
            self,
            UIResponder.key,
            UIResponder.EnvironmentValuesWrapper(values: values),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        notifyChilds()
    }
}

// MARK: - Internal helpers
extension UIEnvironmentable {
    /// Gets the ``UIEnvironmentValues`` value for given `keyPath` by finding the first object
    /// in the view hierarchy that has it set. If there is no value defined in the view
    /// hierarchy, [UIResponder.defaultValues](x-source-tag://UIResponder.defaultValues) instance will be used.
    ///
    /// - Parameter keyPath: A key path that indicates the property of the
    ///                      ``UIEnvironmentValues`` structure to get the value.
    /// - Returns: The value for the specified `keyPath`.
    internal func value<Value>(
        forKeyPath keyPath: KeyPath<UIEnvironmentValues, Value>
    ) -> Value {
        var value = UIResponder.defaultValues[keyPath: keyPath]

        traverseBottomUp(stop: { responder in
            if let receviedValue = responder.valueInSelf(forKeyPath: keyPath) {
                value = receviedValue
                return true
            } else {
                return false
            }
        })

        return value
    }
}

// MARK: - UIResponder Helpers
extension UIResponder {
    fileprivate func notifyChilds() {
        traverseTopDown { responder in
            guard let updatable = responder as? UIEnvironmentUpdating else {
                return
            }

            updatable.updateEnvironment()
        }
    }

    fileprivate var environmentValues: UIEnvironmentValues {
        get {
            let wrapper = objc_getAssociatedObject(self, Self.key) as? EnvironmentValuesWrapper
            return wrapper?.values ?? UIEnvironmentValues()
        }
        set {
            guard let wrapper = objc_getAssociatedObject(self, Self.key) as? EnvironmentValuesWrapper
            else {
                return
            }

            wrapper.values = newValue
        }
    }

    // MARK: Helpers

    /// Default ``UIEnvironmentValues``
    /// - Tag: UIResponder.defaultValues
    fileprivate static let defaultValues = UIEnvironmentValues()
}
