import Foundation
import UIKit

class DiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, EndpointListener {
    
    @IBOutlet weak var tableEndpoints: UITableView!
    
    var discovery: Discovery
    var ssh: SshRunner
    
    var endpoints = [IdentifiedEndpoint]()
       
    init() {
        ssh = SshRunner()
        discovery = Discovery()
        super.init(nibName: "Discovery", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableEndpoints.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        discoveryStart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDiscoveryClick(sender: AnyObject) {
        discoveryStart()
    }
    
    func discoveryStart() {
        discovery.start(serviceName: "syncloud", listener: self)
    }
    
    func found(endpoint: Endpoint) {
        var connection = ConnectionPoint(endpoint: endpoint, credentials: standardCredentials())
        var tools = Tools(ssh: self.ssh)
        var (id, error) = tools.id(connection)
        
        if error != nil {
            return
        }
        
        var identifiedEndpoint = IdentifiedEndpoint(endpoint: endpoint, id: id!)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.endpoints.append(identifiedEndpoint)
            self.tableEndpoints.reloadData()
        }
    }
    
    func error(error: Error) {
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