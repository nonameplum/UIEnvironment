import Foundation

private struct MyEnvironmentKey: UIEnvironmentKey {
    static let defaultValue: String = "Default value"
}

extension UIEnvironmentValues {
    var myCustomValue: String {
        get { self[MyEnvironmentKey.self] }
        set { self[MyEnvironmentKey.self] = newValue }
    }
}
