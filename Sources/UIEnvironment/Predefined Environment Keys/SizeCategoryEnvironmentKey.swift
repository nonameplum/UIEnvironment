import Foundation
import UIKit

private enum SizeCategoryEnvironmentKey: UIEnvironmentKey {
    static let defaultValue: UIContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
}

extension UIEnvironmentValues {

    /// The current Size Category.
    ///
    /// This value changes as the user's chosen Dynamic Type size changes. The
    /// default value is device-dependent.
    public var sizeCategory: UIContentSizeCategory {
        get { self[SizeCategoryEnvironmentKey.self] }
        set { self[SizeCategoryEnvironmentKey.self] = newValue }
    }

    internal static let setupSizeCategoryListener: Void = {
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            UIApplication.shared.forEachWindow {
                $0.environment(\.sizeCategory, UIApplication.shared.preferredContentSizeCategory)
            }
        }
    }()
}
