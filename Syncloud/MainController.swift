import Foundation
import UIKit

class MainController: UINavigationController {
    
    var startController: UIViewController?

    override init(rootViewController: UIViewController) {
        self.startController = rootViewController
        super.init(rootViewController: rootViewController)
        
        self.navigationBar.isTranslucent = false
        self.setToolbarHidden(false, animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getUserService() -> IUserService {
        return CachedUserService(service: RedirectService(webService: WebService(apiUrl: getRedirectApiUrl(Storage.getMainDomain()))))
    }

    func addSettings() {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "settings"), for: UIControlState())
        button.addTarget(self, action: #selector(MainController.btnSettingsClick(_:)), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let btnSettings = UIBarButtonItem(customView: button)

        let viewController = self.visibleViewController!
        viewController.navigationItem.rightBarButtonItem = btnSettings
        
    }

    func btnSettingsClick(_ sender: UIBarButtonItem) {
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
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        viewController.navigationItem.rightBarButtonItem = btnSave
        viewController.navigationItem.leftBarButtonItem = btnCancel
    }
    
    func openUrl(_ url: String) {
        let nsUrl = URL(string: url)!
        if OpenInChromeController.sharedInstance.isChromeInstalled() {
            OpenInChromeController.sharedInstance.openInChrome(nsUrl, callbackURL: nil, createNewTab: true)
        } else {
            UIApplication.shared.openURL(nsUrl)
        }
    }
}
