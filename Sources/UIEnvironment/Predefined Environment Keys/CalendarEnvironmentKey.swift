import Foundation
import UIKit

private enum CalendarEnvironmentKey: UIEnvironmentKey {
    static let defaultValue: Calendar = Calendar.current
}

extension UIEnvironmentValues {

    /// The current calendar that views should use when handling dates.
    public var calendar: Calendar {
        get { self[CalendarEnvironmentKey.self] }
        set { self[CalendarEnvironmentKey.self] = newValue }
    }
}
