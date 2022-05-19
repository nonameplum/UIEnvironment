import UIKit

extension UIResponder {
    internal class EnvironmentValuesWrapper: NSObject {
        var values: UIEnvironmentValues

        init(values: UIEnvironmentValues) {
            self.values = values
        }
    }

    internal static let key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
}
