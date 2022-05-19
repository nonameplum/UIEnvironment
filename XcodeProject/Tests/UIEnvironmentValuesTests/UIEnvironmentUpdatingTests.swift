import Foundation
import UIEnvironment
import UIKit
import XCTest

final class UIEnvironmentUpdatingTests: XCTestCase {
    func test_environmentValueChange_traverseViewHierarchy_shouldCallUpdates() {
        var counter: [String: Int] = [:]
        func incrementCount(for key: String) {
            counter[key, default: 0] += 1
        }

        func makeViewHierarchy(prefix: String) -> UITabBarController {
            let tabVC = UITabBarController()
            tabVC.viewControllers = [
                makeNavigationController(
                    EnvViewController(
                        onUpdateEnvironment: {
                            incrementCount(for: "\(prefix)vc1")
                        },
                        envView: nil
                    ),
                    makeViewController()
                ),
                makeNavigationController(
                    makeViewController(),
                    EnvViewController(
                        onUpdateEnvironment: {
                            incrementCount(for: "\(prefix)vc2")
                        },
                        envView: EnvView {
                            UIView()
                            EnvView {
                                EnvView().then {
                                    $0.onUpdateEnvironment = {
                                        incrementCount(for: "\(prefix)vc2-view-subview1-subview2")
                                    }
                                }
                            }.then {
                                $0.onUpdateEnvironment = {
                                    incrementCount(for: "\(prefix)vc2-view-subview1")
                                }
                            }
                        }.then {
                            $0.onUpdateEnvironment = {
                                incrementCount(for: "\(prefix)vc2-view")
                            }
                        }
                    )
                )
            ]
            return tabVC
        }
        let tabVC = makeViewHierarchy(prefix: "")
        let window = putInViewHierarchy(tabVC)
        let modalTabVC = makeViewHierarchy(prefix: "modal-")
        presentViewController(modalTabVC, on: tabVC)

        window.overrideUserInterfaceStyle = .dark

        XCTAssertEqual(counter["vc1"], 1)
        XCTAssertEqual(counter["vc2"], 1)
        XCTAssertEqual(counter["vc2-view"], 1)
        XCTAssertEqual(counter["vc2-view-subview1"], 1)
        XCTAssertEqual(counter["vc2-view-subview1-subview2"], 1)
        XCTAssertEqual(counter["modal-vc1"], 1)
        XCTAssertEqual(counter["modal-vc2"], 1)
        XCTAssertEqual(counter["modal-vc2-view"], 1)
        XCTAssertEqual(counter["modal-vc2-view-subview1"], 1)
        XCTAssertEqual(counter["modal-vc2-view-subview1-subview2"], 1)

        modalTabVC.environment(\.locale, "pl")

        XCTAssertEqual(counter["vc1"], 1)
        XCTAssertEqual(counter["vc2"], 1)
        XCTAssertEqual(counter["vc2-view"], 1)
        XCTAssertEqual(counter["vc2-view-subview1"], 1)
        XCTAssertEqual(counter["vc2-view-subview1-subview2"], 1)
        XCTAssertEqual(counter["modal-vc1"], 2)
        XCTAssertEqual(counter["modal-vc2"], 2)
        XCTAssertEqual(counter["modal-vc2-view"], 2)
        XCTAssertEqual(counter["modal-vc2-view-subview1"], 2)
        XCTAssertEqual(counter["modal-vc2-view-subview1-subview2"], 2)

        let modal_vc2_view = modalTabVC.children[1].children[1].view!
        modal_vc2_view.environment(\.calendar, .init(identifier: .iso8601))

        XCTAssertEqual(counter["vc1"], 1)
        XCTAssertEqual(counter["vc2"], 1)
        XCTAssertEqual(counter["vc2-view"], 1)
        XCTAssertEqual(counter["vc2-view-subview1"], 1)
        XCTAssertEqual(counter["vc2-view-subview1-subview2"], 1)
        XCTAssertEqual(counter["modal-vc1"], 2)
        XCTAssertEqual(counter["modal-vc2"], 2)
        XCTAssertEqual(counter["modal-vc2-view"], 3)
        XCTAssertEqual(counter["modal-vc2-view-subview1"], 3)
        XCTAssertEqual(counter["modal-vc2-view-subview1-subview2"], 3)
    }

    // MARK: Helpers
    private func makeNavigationController(_ viewControllers: UIViewController...) -> UINavigationController {
        let nav = UINavigationController()
        nav.viewControllers = viewControllers
        return nav
    }

    private func makeViewController() -> UIViewController {
        return UIViewController()
    }

    private final class EnvView: UIView, UIEnvironmentUpdating {
        @UIEnvironment(\.userInterfaceStyle) var userInterfaceStyle

        var onUpdateEnvironment: (() -> Void)?
        func updateEnvironment() {
            onUpdateEnvironment?()
        }
    }

    private final class EnvViewController: UIViewController, UIEnvironmentUpdating {
        @UIEnvironment(\.userInterfaceStyle) var userInterfaceStyle
        var envView: EnvView?

        init(onUpdateEnvironment: (() -> Void)? = nil, envView: EnvView? = nil) {
            self.envView = envView
            self.onUpdateEnvironment = onUpdateEnvironment

            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func loadView() {
            guard let envView = envView else {
                super.loadView()
                return
            }
            view = envView
        }

        var onUpdateEnvironment: (() -> Void)?
        func updateEnvironment() {
            onUpdateEnvironment?()
        }
    }
}

extension UIView {
    @resultBuilder
    fileprivate enum ViewBuilder {
        public static func buildBlock(_ views: UIView...) -> [UIView] {
            return views
        }

        public static func buildBlock(_ views: [UIView]...) -> [UIView] {
            return views.flatMap { $0 }
        }

        public static func buildArray(_ view: [[UIView]]) -> [UIView] {
            return view.flatMap { $0 }
        }
    }

    fileprivate convenience init(@ViewBuilder views: () -> [UIView]) {
        self.init(frame: .infinite)
        translatesAutoresizingMaskIntoConstraints = false
        views().forEach(addSubview)
    }
}

private protocol Configurable {}
extension UIResponder: Configurable {}
extension Configurable {
    @discardableResult
    fileprivate func then(_ setup: (Self) -> Void) -> Self {
        setup(self)
        return self
    }
}
