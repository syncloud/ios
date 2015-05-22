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
        
        self.title = "Discovery"
        var btnRefresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("btnDiscoveryClick:"))
        self.navigationItem.rightBarButtonItem = btnRefresh
        
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
        self.endpoints.removeAll(keepCapacity: true)
        self.tableEndpoints.reloadData()
        
        self.discovery.start(serviceName: "syncloud", listener: self)
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            var timeout = 20
            var count = 0
            while (count < timeout) {
                usleep(1000)
                count++
            }
            
            self.discovery.stop()
        }
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