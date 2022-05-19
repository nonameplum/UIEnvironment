import UIKit

final class ViewController: UIViewController {
    struct Action {
        let title: String
        let onTap: (UIViewController) -> Void
    }

    @UIEnvironment(\.locale) private var locale
    @UIEnvironment(\.userInterfaceStyle) private var userInterfaceStyle
    @UIEnvironment(\.timeZone) private var timeZone
    @UIEnvironment(\.sizeCategory) private var sizeCategory
    private var actions: [Action]

    init(actions: [Action]) {
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        stackView.addArrangedSubview(UIView())
    }

    // MARK: Helpers
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(subview)

        var subviewStyle: UIUserInterfaceStyle = .light
        actions.append(
            Action(
                title: "Toggle user interface style",
                onTap: { [weak subview] _ in
                    subviewStyle = subviewStyle == .dark ? .light : .dark
                    subview?.environment(\.userInterfaceStyle, subviewStyle)
                }
            )
        )
        makeButtons(actions: actions).forEach { button in
            stackView.addArrangedSubview(button)
        }

        return stackView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.setContentHuggingPriority(.init(rawValue: 999.0), for: .vertical)
        return label
    }()

    private lazy var subview: View = View()

    private func makeButtons(actions: [Action]) -> [UIButton] {
        return actions.map { action in
            let button = UIButton(configuration: .borderedTinted())
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(action.title, for: .normal)
            button.addAction(.init(handler: { [unowned self] _ in
                action.onTap(self)
            }), for: .touchUpInside)
            return button
        }
    }

    private func labelText() -> String {
        """
        🚀
        UIEnvironment
        Example
        Locale: \(locale.identifier)
        Language: \(locale.languageCode ?? "N/A")
        TimeZone: \(timeZone.identifier)
        InterfaceStyle: \(userInterfaceStyle)
        SizeCategory: \(sizeCategory.rawValue)
        """
    }
}

extension ViewController: UIEnvironmentUpdating {
    func updateEnvironment() {
        label.text = labelText()
    }
}

extension UIUserInterfaceStyle: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        case .unspecified:
            return "unspecified"
        @unknown default:
            return "unkown"
        }
    }
}
