import Foundation
import UIKit

class AuthController: UIViewController {
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: "Auth", bundle: nil)
    }

    func mainController() -> MainController {
        return self.navigationController as! MainController
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var blueColor = self.view.tintColor.CGColor
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.cornerRadius = 5
        btnSignUp.layer.borderColor = blueColor
        btnSignUp.layer.backgroundColor = blueColor
        btnSignUp.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.checkCredentials()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLearnMoreClick(sender: AnyObject) {
        var url = NSURL(string: "http://syncloud.org")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func btnSignUpClick(sender: AnyObject) {
        var authCredentials = AuthCredentialsController(mode: AuthMode.SignUp)
        self.navigationController!.pushViewController(authCredentials, animated: true)
    }
    
    @IBAction func btnSignInClick(sender: AnyObject) {
        var authCredentials = AuthCredentialsController(mode: AuthMode.SignIn)
        self.navigationController!.pushViewController(authCredentials, animated: true)
    }
    
    func checkCredentials() {
        var credentials = Storage.getCredentials()
        
        if let theEmail = credentials.email {
            self.signIn(theEmail, credentials.password!)
        }
    }
    
    func signIn(email: String, _ password: String) {
        viewButtons.hidden = true
        progressBar.startAnimating()
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            var service = self.mainController().userService
            var result = service.getUser(email, password: password)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.progressBar.stopAnimating()
                
                if result.error != nil {
                    var authCredentials = AuthCredentialsController(mode: AuthMode.SignIn)
                    self.navigationController!.pushViewController(authCredentials, animated: true)
                } else {
                    var viewDevices = DomainsController()
                    self.navigationController!.replaceAll(viewDevices, animated: true)
                }
            }
        }
    }
    
}
