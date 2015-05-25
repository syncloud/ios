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
        
        self.navigationController?.navigationBar.hidden = true
    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.hidden = true
//        super.viewWillAppear(animated)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.navigationBar.hidden = false
//        super.viewWillDisappear(animated)
//    }

//    override func viewWillAppear(animated: Bool) {
//        navigationController?.navigationBarHidden = true
//        super.viewWillAppear(animated)
//    }
//    
//    
//    override func viewWillDisappear(animated: Bool) {
//        navigationController?.navigationBarHidden = false
//        super.viewWillDisappear(animated)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLearnMoreClick(sender: AnyObject) {
        var url = NSURL(string: "http://syncloud.org")
        UIApplication.sharedApplication().openURL(url!)
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
            var service = RedirectService(apiUrl: "http://api.syncloud.it")
            var result = service.getUser(email, password: password)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.progressBar.stopAnimating()
                
                if result.error != nil {
                    var authCredentials = AuthCredentialsController()
                    self.navigationController!.pushViewController(authCredentials, animated: true)
                } else {
                    var viewDevices = DomainsViewController(user: result.user!)
                    self.navigationController!.replaceViewController(viewDevices, animated: true)
                }
            }
        }
    }
    
}
