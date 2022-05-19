import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "#\(line): Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}

extension XCTestCase {
    func presentViewController(
        _ viewController: UIViewController,
        on presentingViewController: UIViewController
    ) {
        let exp = expectation(description: #function)

        presentingViewController.present(viewController, animated: false) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func dismissViewController(_ viewController: UIViewController) {
        let exp = expectation(description: #function)

        viewController.dismiss(animated: false) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}
