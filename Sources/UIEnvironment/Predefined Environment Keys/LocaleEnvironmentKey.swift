import UIKit

private enum LocaleEnvironmentKey: UIEnvironmentKey {
    static let defaultValue: Locale = Locale.current
}

extension UIEnvironmentValues {

    /// The current locale that views should use.
    public var locale: Locale {
        get { self[LocaleEnvironmentKey.self] }
        set { self[LocaleEnvironmentKey.self] = newValue }
    }

    public static let setupCurrentLocaleListener: Void = {
        NotificationCenter.default.addObserver(
            forName: NSLocale.currentLocaleDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            UIApplication.shared.forEachWindow {
                $0.environment(\.locale, Locale.current)
            }
        }
    }()
}
