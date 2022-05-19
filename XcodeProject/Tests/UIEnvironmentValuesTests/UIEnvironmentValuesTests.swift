import Foundation
import UIEnvironment
import UIKit
import XCTest

final class UIEnvironmentValuesTests: XCTestCase {
    func test_view_defaultValue() {
        let view = makeView()

        XCTAssertEqual(view.locale, Locale.current)
    }

    func test_viewController_defaultValue() {
        let vc = makeVC()

        XCTAssertEqual(vc.locale, Locale.current)
    }

    func test_view_environment() {
        let view = makeView()

        view.environment(\.locale, "pl")

        XCTAssertEqual(view.locale, "pl")
    }

    func test_viewController_environment() {
        let vc = makeVC()

        vc.environment(\.locale, "se")

        XCTAssertEqual(vc.locale, "se")
    }

    func test_flat_hierarchy() {
        let root = makeView()
        let child1 = makeView()
        let child2 = makeView()

        root.addSubview(child1)
        root.addSubview(child2)

        root.environment(\.locale, "pl")

        XCTAssertEqual(root.locale, "pl")
        XCTAssertEqual(child1.locale, "pl")
        XCTAssertEqual(child2.locale, "pl")
    }

    func test_deep_view_hierarchy() {
        let root = makeView()
        let child1 = makeView()
        let child2 = makeView()

        root.addSubview(child1)
        child1.addSubview(child2)

        root.environment(\.locale, "pl")

        XCTAssertEqual(root.locale, "pl")
        XCTAssertEqual(child1.locale, "pl")
        XCTAssertEqual(child2.locale, "pl")
    }

    func test_viewControllers_andView_environment() {
        let vc = makeVC()
        let view = makeView()

        vc.view.addSubview(view)

        vc.environment(\.locale, "se")

        XCTAssertEqual(vc.locale, "se")
        XCTAssertEqual(view.locale, "se")
    }

    func test_childViewControllers() {
        let vc = makeVC()
        let child1VC = makeVC()
        let child2VC = makeVC()

        vc.addChildViewController(child1VC)
        child1VC.addChildViewController(child2VC)

        vc.environment(\.locale, "se")

        XCTAssertEqual(vc.locale, "se")
        XCTAssertEqual(child1VC.locale, "se")
        XCTAssertEqual(child2VC.locale, "se")
    }

    func test_present_viewController() {
        let vc1 = makeVC()
        let vc2 = makeVC()
        putInViewHierarchy(vc1)

        vc1.environment(\.locale, "pl")

        presentViewController(vc2, on: vc1)
        dismissViewController(vc1)
    }

    func test_navigationController() {
        let vc1 = makeVC()
        let vc2 = makeVC()

        let nav = UINavigationController()
        nav.viewControllers = [vc1, vc2]
        putInViewHierarchy(nav)

        nav.environment(\.locale, "pl")

        XCTAssertEqual(vc1.locale, "pl")
        XCTAssertEqual(vc2.locale, "pl")

        nav.viewControllers = [vc1]

        XCTAssertEqual(vc1.locale, "pl")

        nav.viewControllers = []
    }

    func test_do_not_override_child_environment() {
        let view = makeView()
        let childView = makeView()
        view.addSubview(childView)

        childView.environment(\.locale, "pl")

        XCTAssertEqual(view.locale, Locale.current)
        XCTAssertEqual(childView.locale, "pl")

        view.environment(\.locale, "uk")

        XCTAssertEqual(view.locale, "uk")
        XCTAssertEqual(childView.locale, "pl")
    }

    func test_environmentUpdating() {
        let view = makeView()
        let childView = makeView()
        view.addSubview(childView)

        var changeCount = 0
        childView.onEnvironmentChange = { changeCount += 1 }

        view.environment(\.locale, "pl")

        XCTAssertEqual(childView.locale, "pl")
        XCTAssertEqual(changeCount, 1)

        view.environment(\.locale, "uk")

        XCTAssertEqual(childView.locale, "uk")
        XCTAssertEqual(changeCount, 2)

        childView.environment(\.locale, "fr")

        XCTAssertEqual(childView.locale, "fr")
        XCTAssertEqual(changeCount, 3)
    }

    func test_multiple_environemntValues_changes() {
        let view = makeView()
        let childView = makeView()
        view.addSubview(childView)

        XCTAssertEqual(view.locale.languageCode, Locale.current.languageCode)
        XCTAssertEqual(childView.locale.languageCode, Locale.current.languageCode)

        view.environment(\.locale, "pl")

        XCTAssertEqual(view.locale, "pl", "precondition")
        XCTAssertEqual(childView.locale, "pl", "precondition")
        XCTAssertEqual(view.calendar, .current, "precondition")
        XCTAssertEqual(childView.calendar, .current, "precondition")

        childView.environment(\.locale, "fr")
        view.environment(\.calendar, .init(identifier: .indian))

        XCTAssertEqual(view.locale, "pl")
        XCTAssertEqual(childView.locale, "fr")
        XCTAssertEqual(view.calendar, .init(identifier: .indian))
        XCTAssertEqual(childView.calendar, .init(identifier: .indian))
    }

    // MARK: Helpers
    private func makeView(file: StaticString = #file, line: UInt = #line) -> EnvView {
        let view = EnvView()
        trackForMemoryLeaks(view, file: file, line: line)
        return view
    }

    private func makeVC(file: StaticString = #file, line: UInt = #line) -> EnvViewController {
        let vc = EnvViewController()
        trackForMemoryLeaks(vc, file: file, line: line)
        return vc
    }

    private final class EnvView: UIView, UIEnvironmentUpdating {
        @UIEnvironment(\.locale) var locale: Locale
        @UIEnvironment(\.calendar) var calendar: Calendar
        var onEnvironmentChange: (() -> Void)?

        init() {
            super.init(frame: .zero)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func updateEnvironment() {
            onEnvironmentChange?()
        }
    }

    private final class EnvViewController: UIViewController {
        @UIEnvironment(\.locale) var locale: Locale
    }
}
