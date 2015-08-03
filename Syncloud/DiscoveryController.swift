import Foundation
import UIKit

class DiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, EndpointListener {
    
    @IBOutlet weak var tableEndpoints: UITableView!
    
    var discovery: Discovery
    
    var endpoints = [IdentifiedEndpoint]()
       
    init() {
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
        
        var btnRefresh = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnDiscoveryClick:"))
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, btnRefresh, flexibleSpace]
        
        (self.navigationController as! MainController).addSettings()
        
        discoveryStart()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)
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
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            self.discovery.start(serviceName: "syncloud", listener: self)
        }
    }
    
    func found(endpoint: Endpoint) {
        let host = endpoint.host
        let serverUrl = "http://\(host):81/server/rest"
        var tools = Tools(webService: WebService(apiUrl: serverUrl))
        var (id, error) = tools.id()
        
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