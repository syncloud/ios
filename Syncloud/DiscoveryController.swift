import Foundation
import UIKit

class DiscoveryController: UIViewController {
    
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
    
    
    var discovery: Discovery
    var ssh: SshRunner
       
    init() {
        ssh = SshRunner()
        discovery = Discovery(serviceName: "syncloud", listener: Listener(ssh: ssh))
        super.init(nibName: "Discovery", bundle: nil)
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

}