import Foundation
import UIEnvironment
import UIKit
import XCTest

final class UIUserInterfaceStyleEnvironmentKeyTests: XCTestCase {
    func test_interfaceStyleEnvironmentKey_overrideUserInterfaceStyle_changesEnvironmentValue() {
        let vc = makeVC()
        let window = putInViewHierarchy(vc)

        window.overrideUserInterfaceStyle = .light

        XCTAssertEqual(vc.userInterfaceStyle, .light)

        window.overrideUserInterfaceStyle = .dark

        XCTAssertEqual(vc.userInterfaceStyle, .dark)
    }

    func test_preferredUserInterfaceStyle_changesStyleForTheEnclosingPresentation() {
        let vc = makeVC()
        let modalVC = makeVC()
        let window = putInViewHierarchy(vc)
        presentViewController(modalVC, on: vc)

        let view = EnvView()
        modalVC.view.addSubview(view)
        let subView = EnvView()
        view.addSubview(subView)

        window.overrideUserInterfaceStyle = .light

        XCTAssertEqual(vc.userInterfaceStyle, .light, "precondition")
        XCTAssertEqual(modalVC.userInterfaceStyle, .light, "precondition")

        subView.preferredUserInterfaceStyle(.dark)

        XCTAssertEqual(vc.userInterfaceStyle, .light, "Expected the value change only to the nearest enclosing presentation")
        XCTAssertEqual(vc.envView.userInterfaceStyle, .light, "Expected the value change only to the nearest enclosing presentation")

        XCTAssertEqual(view.userInterfaceStyle, .dark)
        XCTAssertEqual(subView.userInterfaceStyle, .dark, "Expected that the value should flow down")
        XCTAssertEqual(modalVC.userInterfaceStyle, .dark, "Expected that the value propagates up through the view hierarchy")
        XCTAssertEqual(modalVC.envView.userInterfaceStyle, .dark, "Expected that the value propagates up through the view hierarchy")
    }

    func test_preferredUserInterfaceStyle_changesStyleUntilFirstMetOverriddenStyle() {
        let vc = makeVC()
        let view = EnvView()
        vc.view.addSubview(view)
        let subView = EnvView()
        view.addSubview(subView)

        vc.envView.preferredUserInterfaceStyle(.dark)

        XCTAssertEqual(vc.userInterfaceStyle, .dark, "precondition")
        XCTAssertEqual(vc.envView.userInterfaceStyle, .dark, "precondition")
        XCTAssertEqual(view.userInterfaceStyle, .dark, "precondition")
        XCTAssertEqual(subView.userInterfaceStyle, .dark, "precondition")

        view.preferredUserInterfaceStyle(.light)

        XCTAssertEqual(vc.userInterfaceStyle, .dark, "Expected to change the value until another overriden style")
        XCTAssertEqual(vc.envView.userInterfaceStyle, .dark, "Expected to change the value until another overriden style")
        XCTAssertEqual(view.userInterfaceStyle, .light, "precondition")
        XCTAssertEqual(subView.userInterfaceStyle, .light, "precondition")
    }

    // MARK: Helpers
    private func makeVC() -> EnvViewController {
        return EnvViewController()
    }

    private final class EnvView: UIView {
        @UIEnvironment(\.userInterfaceStyle) var userInterfaceStyle
    }

    private final class EnvViewController: UIViewController {
        @UIEnvironment(\.userInterfaceStyle) var userInterfaceStyle
        var envView: EnvView { view as! EnvView }

        override func loadView() {
            view = EnvView()
        }
    }
}
