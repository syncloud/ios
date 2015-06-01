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
    
    func addSettings() {
        var viewController = self.visibleViewController!
        var btnSettings = UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnSettingsClick:"))
        btnSettings.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Arial", size: 26)!, NSForegroundColorAttributeName : viewController.view.tintColor],
            forState: UIControlState.Normal)
        viewController.navigationItem.rightBarButtonItem = btnSettings
    }

    func btnSettingsClick(sender: UIBarButtonItem) {
        var viewSettings = SettingsController()
        self.pushViewController(viewSettings, animated: true)
    }
    
}
