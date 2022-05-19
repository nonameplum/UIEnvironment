import UIKit

extension UIApplication {
    internal func forEachWindow(_ body: (UIWindow) -> Void) {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach(body)
    }
}
