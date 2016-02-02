import Foundation
import UIKit

class ActivateController: UIViewController {
    
    @IBOutlet weak var textDomain: UITextField!
    @IBOutlet weak var textLogin: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelMainDomain: UILabel!
    
    var device: DeviceInternal
    var idEndpoint: IdentifiedEndpoint

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
        
        let mainDomain = Storage.getMainDomain()
        self.labelMainDomain.text = ".\(mainDomain)"
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnActivateClick(sender: UIButton) {
        self.view.endEditing(true)
        self.activityIndicator.startAnimating()
        
        let domain = self.textDomain.text!
        let deviceLogin = self.textLogin.text!
        let devicePassword = self.textPassword.text!

        let credentials = Storage.getCredentials()

        let queue = dispatch_queue_create("org.syncloud.Syncloud", nil);

        dispatch_async(queue) { () -> Void in
            let result = self.device.activate(
                Storage.getMainDomain(),
                domain: domain,
                email: credentials.email!,
                password: credentials.password!,
                deviceLogin: deviceLogin,
                devicePassword: devicePassword)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
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
}