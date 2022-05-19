import UIKit

extension UIViewController {
    func addChildViewController(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
