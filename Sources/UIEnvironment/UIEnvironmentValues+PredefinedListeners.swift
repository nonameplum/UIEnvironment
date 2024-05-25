import Foundation
import UIKit

extension UIEnvironmentValues {
    /// A closure that is called once for each instance of UIEnvironment passing it's `keyPath`.
    /// As such, any setup or initialization that has to happens only once, has to be handled internally within this closure.
    ///
    /// Use this property to disable or override default environment listeners.
    ///
    public static var setupPredefinedEnvironmentListeners: (_ keyPath: AnyKeyPath) -> (() -> Void)? = { _ in
        {
            UIScreen.setupTraitCollectionListener
            UIWindow.setupOverrideUserInterfaceListener
            UIEnvironmentValues.setupCurrentLocaleListener
            UIEnvironmentValues.setupSizeCategoryListener
        }
    }
}
