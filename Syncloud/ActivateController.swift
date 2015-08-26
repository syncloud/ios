import Foundation
import UIKit

class ActivateController: UIViewController {
    
    @IBOutlet weak var textDomain: UITextField!
    @IBOutlet weak var textLogin: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnActivateClick(sender: UIButton) {
        self.activityIndicator.startAnimating()
        
        var domain = self.textDomain.text
        var deviceLogin = self.textLogin.text
        var devicePassword = self.textPassword.text

        var credentials = Storage.getCredentials()

        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);

        dispatch_async(queue) { () -> Void in
            var result = self.device.activate(
                domain,
                email: credentials.email!,
                password: credentials.password!,
                deviceLogin: deviceLogin,
                devicePassword: devicePassword)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityIndicator.stopAnimating()

                if result.error != nil {
                    var alert = UIAlertController(title: "Activation failed", message: "Something went wrong and device activation failed.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
            }

        }
    }
}