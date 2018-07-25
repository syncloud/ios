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
        
        let blueColor = self.view.tintColor.cgColor
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.cornerRadius = 5
        btnSignUp.layer.borderColor = blueColor
        btnSignUp.layer.backgroundColor = blueColor
        btnSignUp.setTitleColor(UIColor.white, for: UIControlState())
        
        self.checkCredentials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLearnMoreClick(_ sender: AnyObject) {
        self.mainController().openUrl("http://syncloud.org")
    }
    
    @IBAction func btnSignUpClick(_ sender: AnyObject) {
        let authCredentials = CredentialsController(mode: AuthMode.signUp)
        self.navigationController!.pushViewController(authCredentials, animated: true)
    }
    
    @IBAction func btnSignInClick(_ sender: AnyObject) {
        let authCredentials = CredentialsController(mode: AuthMode.signIn)
        self.navigationController!.pushViewController(authCredentials, animated: true)
    }
    
    func checkCredentials() {
        let credentials = Storage.getCredentials()
        
        if let theEmail = credentials.email {
            self.signIn(theEmail, credentials.password!)
        }
    }
    
    func signIn(_ email: String, _ password: String) {
        viewButtons.isHidden = true
        progressBar.startAnimating()
        
        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);
        queue.async { () -> Void in
            let service = self.mainController().getUserService()
            let result = service.getUser(email, password: password)
            
            DispatchQueue.main.async { () -> Void in
                self.progressBar.stopAnimating()
                
                if result.error != nil {
                    let authCredentials = CredentialsController(mode: AuthMode.signIn)
                    self.navigationController!.pushViewController(authCredentials, animated: true)
                } else {
                    let viewDevices = DomainsController()
                    self.navigationController!.replaceAll(viewDevices, animated: true)
                }
            }
        }
    }
    
}
