import Foundation
import UIKit

class DiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBOutlet weak var tableEndpoints: UITableView!
    
    var discovery: Discovery
    var ssh: SshRunner
    
    var endpoints = [IdentifiedEndpoint]()
       
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableEndpoints.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var endpoint = self.endpoints[indexPath.row]
        cell.textLabel?.text = endpoint.id.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}