import Foundation

private enum TimeZoneEnvironmentKey: UIEnvironmentKey {
    static let defaultValue: TimeZone = TimeZone.current
}

extension UIEnvironmentValues {

    /// The current time zone that views should use when handling dates.
    public var timeZone: TimeZone {
        get { self[TimeZoneEnvironmentKey.self] }
        set { self[TimeZoneEnvironmentKey.self] = newValue }
    }
}
