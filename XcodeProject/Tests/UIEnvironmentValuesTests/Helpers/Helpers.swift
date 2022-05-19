import Foundation
import UIKit

@discardableResult
func putInViewHierarchy(_ vc: UIViewController) -> UIWindow {
    let window = UIWindow()
    window.rootViewController = vc
    window.makeKeyAndVisible()
    return window
}
