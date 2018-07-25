import Foundation
import UIKit

enum AuthMode {
    case signIn
    case signUp
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
        case .signIn:
            return "Sign In"
        case .signUp:
            return "Sign Up"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleText = self.getTitleText()
        self.title = titleText
        self.buttonSignIn.setTitle(titleText, for: UIControlState())
        
        cells[sectionCredentials] = [cellEmail, cellPassword]
        
        self.tableCredentials.rowHeight = 44.0
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        
        self.textEmail.becomeFirstResponder()
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSignInClick(_ sender: UIButton) {
        self.signIn()
    }
    
    func signIn() {
        self.indicatorActivity.startAnimating()
        
        let email = self.textEmail.text!
        let password = self.textPassword.text!
        
        self.textEmail.isEnabled = false
        self.textPassword.isEnabled = false
        self.buttonSignIn.isEnabled = false
        
        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);
        
        queue.async { () -> Void in
            let service = self.mainController().getUserService()
            
            var result: UserResult!
            switch self.mode {
            case .signIn:
                result = service.getUser(email, password: password)
            case .signUp:
                result = service.createUser(email, password: password)
            }
            
            DispatchQueue.main.async { () -> Void in
                self.indicatorActivity.stopAnimating()

                self.textEmail.isEnabled = true
                self.textPassword.isEnabled = true
                self.buttonSignIn.isEnabled = true
                
                if result.error != nil {
                    let titleText = self.getTitleText()
                    let alert = UIAlertController(title: "\(titleText) Failed", message: "Incorrect email or password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    Storage.saveCredentials(email: email, password: password)
                    let viewDevices = DomainsController()
                    self.navigationController!.replaceAll(viewDevices, animated: true)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textPassword {
            signIn()
        }
        if textField == textEmail {
            textEmail.resignFirstResponder()
            textPassword.becomeFirstResponder()
        }
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section]!.count
    }
    
    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var sectionCells = cells[indexPath.section]!
        let cell = sectionCells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
