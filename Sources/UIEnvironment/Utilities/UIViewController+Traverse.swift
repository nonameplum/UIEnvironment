import UIKit

extension UIViewController {
    internal func traverse(_ stopVisitor: (_ viewController: UIViewController) -> Bool) {
        guard !stopVisitor(self) else { return }

        self.children.forEach { viewController in
            viewController.traverse(stopVisitor)
        }

        self.childModalViewController?.traverse(stopVisitor)
    }
}

extension UIViewController {
    fileprivate var childModalViewController: UIViewController? {
        if self.presentedViewController?.presentingViewController == self {
            return self.presentedViewController
        } else {
            return nil
        }
    }
}
