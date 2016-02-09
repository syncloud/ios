import Foundation
import UIKit

class ActivateController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var textDomain: UITextField!
    @IBOutlet weak var textLogin: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelMainDomain: UILabel!
    @IBOutlet weak var tableActivate: UITableView!
    @IBOutlet weak var cellPassword: UITableViewCell!
    @IBOutlet weak var cellLogin: UITableViewCell!
    @IBOutlet weak var cellDomain: UITableViewCell!
    
    var cells = Dictionary<Int, [UITableViewCell]>()
    
    var device: DeviceInternal
    var idEndpoint: IdentifiedEndpoint

    let sectionActivate = 0
    
    init(idEndpoint: IdentifiedEndpoint) {
        self.idEndpoint = idEndpoint
        let serverUrl = "http://\(idEndpoint.endpoint.host):81/server/rest"
        self.device = DeviceInternal(webService: WebService(apiUrl: serverUrl))

        super.init(nibName: "Activate", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Activate"
        
        cells[sectionActivate] = [cellDomain, cellLogin, cellPassword]
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)

        let mainDomain = Storage.getMainDomain()
        self.labelMainDomain.text = ".\(mainDomain)"

        self.textDomain.becomeFirstResponder()
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnActivateClick(sender: UIButton) {
        self.activate()
    }
    
    func activate() {
        self.view.endEditing(true)
        self.activityIndicator.startAnimating()
        
        let domain = self.textDomain.text!.lowercaseString
        let deviceUsername = self.textLogin.text!
        let devicePassword = self.textPassword.text!
        
        let credentials = Storage.getCredentials()
        
        self.textDomain.enabled = false
        self.textLogin.enabled = false
        self.textPassword.enabled = false
        self.btnActivate.enabled = false
        
        let queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            let result = self.device.activate(
                Storage.getMainDomain(),
                userDomain: domain,
                email: credentials.email!,
                password: credentials.password!,
                deviceUsername: deviceUsername,
                devicePassword: devicePassword)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.textDomain.enabled = true
                self.textLogin.enabled = true
                self.textPassword.enabled = true
                self.btnActivate.enabled = true
                
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    let alert = UIAlertController(title: "Activation failed", message: "Something went wrong and device activation failed.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textPassword {
            activate()
        }
        if textField == textDomain {
            textDomain.resignFirstResponder()
            textLogin.becomeFirstResponder()
        }
        if textField == textLogin {
            textLogin.resignFirstResponder()
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