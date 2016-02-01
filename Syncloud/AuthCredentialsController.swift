import Foundation
import UIKit

enum AuthMode {
    case SignIn
    case SignUp
}

class AuthCredentialsController: UIViewController {
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func mainController() -> MainController {
        return self.navigationController as! MainController
    }

    var mode: AuthMode
    
    init(mode: AuthMode) {
        self.mode = mode
        super.init(nibName: "AuthCredentials", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.mode {
        case .SignIn:
            self.title = "Sign In"
            self.btnSignIn.setTitle("Sign In", forState: UIControlState.Normal)
        case .SignUp:
            self.title = "Sign Up"
            self.btnSignIn.setTitle("Sign Up", forState: UIControlState.Normal)
        }
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSignInClick(sender: UIButton) {
        self.activityIndicator.startAnimating()
        
        let email = self.emailTextEdit.text!
        let password = self.passwordTextEdit.text!
        
        let queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            let redirectService = self.mainController().userService

            var result: UserResult!
            switch self.mode {
            case .SignIn:
                result = redirectService.getUser(email, password: password)
            case .SignUp:
                result = redirectService.createUser(email, password: password)
            }
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    let alert = UIAlertController(title: "Login failed", message: "Incorrect email or password", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    Storage.saveCredentials(email: email, password: password)
                    let viewDevices = DomainsController()
                    self.navigationController!.replaceAll(viewDevices, animated: true)
                }
            }
        }
    }
}