import UIKit

extension UIResponder {
    internal func traverseTopDown(_ visitor: (_ responder: UIResponder) -> Void) {
        if let view = self as? UIView {
            // If we start from the UIView, traverse until the first subview
            // that is the `UIViewController.view`.
            // The rest will be traversed from the UIViewController point of view.
            var stop = false
            // Do not look for a view controller if the view is the traverse starting point.
            var isFirst = true
            view.traverse { view in
                if let nextVC = view.next as? UIViewController, !isFirst {
                    nextVC.traverseTopDown(visitor)
                    stop = true
                } else {
                    visitor(view)
                }
                isFirst = false
                return stop
            }
        } else if let viewController = self as? UIViewController {
            viewController.traverse { viewController in
                visitor(viewController)
                viewController.view.traverse { view in
                    visitor(view)
                    if view.next is UIViewController, view.next != viewController {
                        // Stop view's traverse if the view controller is reached by the subview,
                        // as all view controllers will be visited by the `viewController.traverse`.
                        return true
                    } else {
                        return false
                    }
                }
                return false
            }
        }
    }

    internal func traverseBottomUp(stop: (_ responder: UIResponder) -> Bool) {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if stop(responder) {
                break
            }

            if responder.next == nil,
               let parent = (responder as? UIViewController)?.parent {
                nextResponder = parent
            } else {
                nextResponder = responder.next
            }
        }
    }
}

extension UIViewController {
    fileprivate var isModal: Bool {
        return presentingViewController?.presentedViewController == self
    }
}
