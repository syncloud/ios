import Foundation
import UIKit

enum AuthMode {
    case SignIn
    case SignUp
}

class CredentialsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var mode: AuthMode
    
    @IBOutlet weak var tableCredentials: UITableView!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var cellPassword: UITableViewCell!
    @IBOutlet weak var cellSignIn: UITableViewCell!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    
    var cells = Dictionary<Int, [UITableViewCell]>()
    
    let sectionCredentials = 0
    
    init(mode: AuthMode) {
        self.mode = mode
        super.init(nibName: "Credentials", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mainController() -> MainController {
        return self.navigationController as! MainController
    }
    
    func getTitleText() -> String {
        switch self.mode {
        case .SignIn:
            return "Sign In"
        case .SignUp:
            return "Sign Up"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleText = self.getTitleText()
        self.title = titleText
        self.buttonSignIn.setTitle(titleText, forState: UIControlState.Normal)
        
        cells[sectionCredentials] = [cellEmail, cellPassword]
        
        self.tableCredentials.rowHeight = 44.0
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        
        self.textEmail.becomeFirstResponder()
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSignInClick(sender: UIButton) {
        self.signIn()
    }
    
    func signIn() {
        self.indicatorActivity.startAnimating()
        
        let email = self.textEmail.text!
        let password = self.textPassword.text!
        
        self.textEmail.enabled = false
        self.textPassword.enabled = false
        self.buttonSignIn.enabled = false
        
        let queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            let service = self.mainController().getUserService()
            
            var result: UserResult!
            switch self.mode {
            case .SignIn:
                result = service.getUser(email, password: password)
            case .SignUp:
                result = service.createUser(email, password: password)
            }
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.indicatorActivity.stopAnimating()

                self.textEmail.enabled = true
                self.textPassword.enabled = true
                self.buttonSignIn.enabled = true
                
                if result.error != nil {
                    let titleText = self.getTitleText()
                    let alert = UIAlertController(title: "\(titleText) Failed", message: "Incorrect email or password", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textPassword {
            signIn()
        }
        if textField == textEmail {
            textEmail.resignFirstResponder()
            textPassword.becomeFirstResponder()
        }
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section]!.count
    }
    
    func getCell(indexPath: NSIndexPath) -> UITableViewCell {
        var sectionCells = cells[indexPath.section]!
        let cell = sectionCells[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = getCell(indexPath)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
