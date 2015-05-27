import Foundation
import UIKit

class MainController: UINavigationController {
    
    var startController: UIViewController?
    
    override init(rootViewController: UIViewController) {
        self.startController = rootViewController
        super.init(rootViewController: rootViewController)
        
        self.navigationBar.translucent = false
        self.setToolbarHidden(false, animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
