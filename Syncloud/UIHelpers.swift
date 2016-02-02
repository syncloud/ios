import Foundation
import UIKit

extension UINavigationController {
    func replaceViewController(viewController: UIViewController, animated: Bool) {
        var controllers = self.viewControllers 
        controllers.removeLast()
        controllers.append(viewController)
        self.setViewControllers(controllers, animated: animated)
    }
    
    func replaceAll(viewController: UIViewController, animated: Bool) {
        self.setViewControllers([viewController], animated: true)
    }
}
