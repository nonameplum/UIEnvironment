@_exported import UIEnvironment
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var rootViewController: UIViewController {
        guard let vc = window?.rootViewController else {
            fatalError()
        }

        return vc
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: Helpers
    private func makeRootViewController() -> UIViewController {
        return makeTabBarController()
    }

    private func makeTabBarController() -> UITabBarController {
        let tabVC = UITabBarController()
        let vc1 = makeNavigationController()
        vc1.tabBarItem = .init(title: "First", image: UIImage(systemName: "1.circle.fill"), tag: 0)
        let vc2 = makeNavigationController()
        vc2.tabBarItem = .init(title: "Second", image: UIImage(systemName: "2.circle.fill"), tag: 1)
        tabVC.viewControllers = [vc1, vc2]
        tabVC.loadViewIfNeeded()
        tabVC.tabBar.isTranslucent = true
        tabVC.tabBar.barStyle = .black

        return tabVC
    }

    private func makeNavigationController() -> UINavigationController {
        let vc1 = makeViewController()
        let vc2 = makeViewController()
        let nav = UINavigationController()
        nav.viewControllers = [vc1, vc2]
        nav.viewControllers.enumerated().forEach { index, vc in
            vc.title = Self.stringNumber(from: index + 1)
        }
        return nav
    }

    private func makeViewController() -> ViewController {
        return ViewController(actions: [pushAction(), presentAction(), localeAction()])
    }

    private func pushAction() -> ViewController.Action {
        .init(title: "Push", onTap: { [unowned self] viewController in
            guard let navVC = viewController.navigationController else { return }
            let vc = self.makeViewController()
            vc.title = Self.stringNumber(from: navVC.viewControllers.count + 1)
            navVC.pushViewController(vc, animated: true)
        })
    }

    private func presentAction() -> ViewController.Action {
        .init(title: "Present", onTap: { [unowned self] viewController in
            let vc = self.makeTabBarController()
            viewController.present(vc, animated: true)
        })
    }

    private func dimissAction() -> ViewController.Action {
        .init(title: "Dimiss", onTap: { viewController in
            viewController.dismiss(animated: true)
        })
    }

    private func localeAction() -> ViewController.Action {
        var index = 0

        return .init(title: "Change locale", onTap: { [weak self] vc in
            let lang = ["pl", "uk", "en"][index % 3]
            index += 1
            self?.rootViewController.environment(\.locale, .init(identifier: lang))
        })
    }

    private static func stringNumber(from value: Int) -> String? {
        return Self.numberFormatter.string(from: NSNumber(value: value))?.localizedCapitalized
    }

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter
    }()
}
