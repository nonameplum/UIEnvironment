import UIKit

extension UIView {
    internal func traverse(_ stopVisitor: (_ view: UIView) -> Bool) {
        guard !stopVisitor(self) else { return }

        self.subviews.forEach { view in
            view.traverse(stopVisitor)
        }
    }
}
