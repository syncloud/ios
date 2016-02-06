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

    func getUserService() -> IUserService {
        return CachedUserService(service: RedirectService(webService: WebService(apiUrl: getRedirectApiUrl(Storage.getMainDomain()))))
    }

    func addSettings() {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.setImage(UIImage(named: "settings"), forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("btnSettingsClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 24, 24)
        
        let btnSettings = UIBarButtonItem(customView: button)

        let viewController = self.visibleViewController!
        viewController.navigationItem.rightBarButtonItem = btnSettings
        
    }

    func btnSettingsClick(sender: UIBarButtonItem) {
        let viewSettings = SettingsController()
        self.pushViewController(viewSettings, animated: true)
    }

    func startOver() {
        Storage.deleteCredentials()
        UserStorage().erase()
        let authController = AuthController()
        self.replaceAll(authController, animated: true)
    }
    
    func addSaveCancel() {
        let viewController = self.visibleViewController!
        let btnSave = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: nil)
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: nil)
        viewController.navigationItem.rightBarButtonItem = btnSave
        viewController.navigationItem.leftBarButtonItem = btnCancel
    }
    
    func openUrl(url: String) {
        let nsUrl = NSURL(string: url)!
        if OpenInChromeController.sharedInstance.isChromeInstalled() {
            OpenInChromeController.sharedInstance.openInChrome(nsUrl, callbackURL: nil, createNewTab: true)
        } else {
            UIApplication.sharedApplication().openURL(nsUrl)
        }
    }
}
