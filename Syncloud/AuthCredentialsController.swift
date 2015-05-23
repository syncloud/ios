import Foundation
import UIKit

class AuthCredentialsController: UIViewController {
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: "AuthCredentials", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign in"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signIn(sender: UIButton) {
        self.activityIndicator.startAnimating()
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            var service = RedirectService(apiUrl: "http://api.syncloud.it")
            var email = self.emailTextEdit.text
            var password = self.passwordTextEdit.text
            var result = service.getUser(email, password: password)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    
                } else {
                    Keychain.set("email", value: email)
                    Keychain.set("password", value: password)
                    var viewDevices = DomainsViewController(user: result.user!)
                    self.navigationController!.replaceViewController(viewDevices, animated: true)
                    
                    var e = Keychain.get("email")
                    var p = Keychain.get("password")
                    println(e)
                    println(p)
                }
            }
        }
    }
}