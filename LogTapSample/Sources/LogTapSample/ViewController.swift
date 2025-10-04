import UIKit
import LogTapFramework

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let logger = LogTap()
        logger.log("Hello from LogTapSample!")
    }
}

