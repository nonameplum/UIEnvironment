import UIKit

private enum UIUserInterfaceStyleEnvironmentKey: UIEnvironmentKey {
    static let defaultValue: UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
}

extension UIEnvironmentValues {

    /// The user interface style of this environment.
    ///
    /// Read this environment value from within a view to find out if UIKit
    /// is currently displaying the view using the `light` or
    /// `dark` appearance. The value that you receive depends on
    /// whether the user has enabled Dark Mode, possibly superseded by
    /// the configuration of the current presentation's view hierarchy.
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
    /// You can set the `userInterfaceStyle` environment value directly,
    /// using ``UIEnvironmentable/environment(_:_:)`` convenience method,
    /// but that usually isn't what you want. Doing so changes the user
    /// interface style of the given view and its child views but *not* the views
    /// above it in the view hierarchy. Instead, set a color scheme using the
    /// ``UIEnvironmentable/preferredUserInterfaceStyle(_:)`` modifier, which
    /// also propagates the value up through the view hierarchy
    /// to the enclosing presentation, like a sheet or a window.
    public var userInterfaceStyle: UIUserInterfaceStyle {
        get { self[UIUserInterfaceStyleEnvironmentKey.self] }
        set { self[UIUserInterfaceStyleEnvironmentKey.self] = newValue }
    }
}

extension UIEnvironmentable {

    /// Sets the preferred user interface style for this presentation.
    ///
    /// Use one of the values in `UIUserInterfaceStyle` with this modifier to set a
    /// preferred user interface style for the nearest enclosing presentation, like a
    /// view controller or a window. The value that you set overrides the
    /// user's Dark Mode selection for that presentation.
    ///
    /// If you apply the modifier to any of the views in the view controller
    /// the value that you set propagates up through the view hierarchy to the enclosing
    /// presentation, or until another color scheme modifier higher in the
    /// hierarchy overrides it. The value you set also flows down to all child
    /// views of the enclosing presentation.
    ///
    /// If you need to detect the user interface style that currently applies to a view,
    /// read the ``UIEnvironmentValues/userInterfaceStyle`` environment value:
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
    /// - Parameter userInterfaceStyle: The preferred user interface style for this view.
    public func preferredUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) {
        var prevResponder: UIResponder?

        traverseBottomUp { responder in
            defer { prevResponder = responder }

            if responder.valueInSelf(forKeyPath: \.userInterfaceStyle) != nil {
                (prevResponder as? UIEnvironmentable)?.environment(\.userInterfaceStyle, userInterfaceStyle)
                return true
            }

            if responder is UIViewController || responder is UIWindow,
               let object = responder as? UIEnvironmentable {
                object.environment(\.userInterfaceStyle, userInterfaceStyle)
                return true
            }
            return false
        }

        environment(\.userInterfaceStyle, userInterfaceStyle)
    }
}

import SwiftHook

extension UIScreen {
    public static let setupTraitCollectionListener: Void = {
        _ = try? hookBefore(
            targetClass: UIScreen.self,
            selector: #selector(UIScreen.traitCollectionDidChange(_:)),
            closure: {
                UIApplication.shared.forEachWindow {
                    $0.environment(\.userInterfaceStyle, UITraitCollection.current.userInterfaceStyle)
                }
            }
        )
    }()

    @objc private func swizzled_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        swizzled_traitCollectionDidChange(previousTraitCollection)
        UIApplication.shared.forEachWindow {
            $0.environment(\.userInterfaceStyle, UITraitCollection.current.userInterfaceStyle)
        }
    }
}

extension UIWindow {
    public static let setupOverrideUserInterfaceListener: Void = {
        _ = try? hookBefore(
            targetClass: UIWindow.self,
            selector: #selector(setter: UIWindow.overrideUserInterfaceStyle),
            closure: { object, sel, style in
                object.environment(\.userInterfaceStyle, style)
            } as @convention(block) (UIWindow, Selector, UIUserInterfaceStyle) -> Void
        )
    }()
}
