import Foundation
import UIKit

class AuthCredentialsController: UIViewController {
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var discovery: Discovery
    var ssh: SshRunner
    
    class Listener: EndpointListener {
        var ssh: SshRunner
        
        init(ssh: SshRunner) {
            self.ssh = ssh
        }
        
        func found(endpoint: Endpoint) {
            var connection = ConnectionPoint(endpoint: endpoint, credentials: standardCredentials())
            var tools = Tools(ssh: self.ssh)
            var (id, error) = tools.id(connection)
            
            if error != nil {
                return
            }
            
            var identifiedEndpoint = IdentifiedEndpoint(endpoint: endpoint, id: id!)
            
            println(endpoint.host+":"+String(endpoint.port))
        }
        
        func error(error: Error) {
        }
    }
    
    init() {
        ssh = SshRunner()
        discovery = Discovery(serviceName: "syncloud", listener: Listener(ssh: ssh))
        super.init(nibName: "AuthCredentials", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: UIButton) {
        self.activityIndicator.startAnimating()

        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            
//            var endpoint = Endpoint(host: "192.168.1.27", port: 22)
//            var credentials = Credentials(login: "root", password: "syncloud", key: nil)
//            var connection = ConnectionPoint(endpoint: endpoint, credentials: credentials)
//            
//            var response = SshRunner().run(connection, command: ["syncloud-id", "id"])
            
            self.discovery.start()
            
            var service = RedirectService(apiUrl: "http://api.syncloud.it")
            var result = service.getUser(self.emailTextEdit.text, password: self.passwordTextEdit.text)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    
                } else {
                    var viewDevices = DomainsViewController(user: result.user!)
                    self.presentViewController(viewDevices, animated: true, completion: nil)
                }
            }
        }
    }
}