import Foundation
import UIKit
import UIEnvironment

final class View: UILabel {
    @UIEnvironment(\.myCustomValue) var customValue: String
    @UIEnvironment(\.userInterfaceStyle) var userInterfaceStyle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text = "MyCustomValue: \(customValue)"
        updateEnvironment()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension View: UIEnvironmentUpdating {
    func updateEnvironment() {
        switch userInterfaceStyle {
        case .light, .unspecified:
            backgroundColor = .lightGray
            textColor = .black
        case .dark:
            backgroundColor = .black
            textColor = .white
        @unknown default:
            fatalError()
        }
    }
}
