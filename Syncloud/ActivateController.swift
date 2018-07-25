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
        self.device = DeviceInternal(host: idEndpoint.endpoint.host)

        super.init(nibName: "Activate", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Activate"
        
        cells[sectionActivate] = [cellDomain, cellLogin, cellPassword]
        
        self.tableActivate.rowHeight = 44.0
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)

        let mainDomain = Storage.getMainDomain()
        self.labelMainDomain.text = ".\(mainDomain)"

        self.textDomain.becomeFirstResponder()
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnActivateClick(_ sender: UIButton) {
        self.activate()
    }
    
    func activate() {
        self.view.endEditing(true)
        self.activityIndicator.startAnimating()
        
        let domain = self.textDomain.text!.lowercased()
        let deviceUsername = self.textLogin.text!
        let devicePassword = self.textPassword.text!
        
        let credentials = Storage.getCredentials()
        
        self.textDomain.isEnabled = false
        self.textLogin.isEnabled = false
        self.textPassword.isEnabled = false
        self.btnActivate.isEnabled = false
        
        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);
        
        queue.async { () -> Void in
            let result = self.device.activate(
                Storage.getMainDomain(),
                userDomain: domain,
                email: credentials.email!,
                password: credentials.password!,
                deviceUsername: deviceUsername,
                devicePassword: devicePassword)
            
            DispatchQueue.main.async { () -> Void in
                self.textDomain.isEnabled = true
                self.textLogin.isEnabled = true
                self.textPassword.isEnabled = true
                self.btnActivate.isEnabled = true
                
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    let alert = UIAlertController(title: "Activation failed", message: "Something went wrong and device activation failed.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.navigationController!.popToRootViewController(animated: true)
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
