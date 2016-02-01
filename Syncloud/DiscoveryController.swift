import Foundation
import UIKit

class DiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, EndpointListener {
    
    @IBOutlet weak var tableEndpoints: UITableView!
    @IBOutlet weak var viewNoDevices: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var discovery: Discovery
    
    var endpoints = [IdentifiedEndpoint]()

    func mainController() -> MainController {
        return self.navigationController as! MainController
    }
    
    init() {
        discovery = Discovery()
        super.init(nibName: "Discovery", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: "DeviceCell", bundle: nil)
        self.tableEndpoints.registerNib(cellNib, forCellReuseIdentifier: "deviceCell")
        
        self.title = "Discovery"
        
        var btnRefresh = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnDiscoveryClick:"))
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, btnRefresh, flexibleSpace]
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        checkWiFi()
    }
    
    @IBAction func btnLearnMoreClicked(sender: AnyObject) {
        self.mainController().openUrl("http://syncloud.org")
    }
    
    func checkWiFi() {
        let ssid = getSSID()
        
        if ssid == nil {
            let alertMessage = "You are not connected to Wi-Fi network. Discovery is possible only in the same Wi-Fi network where you have Syncloud device connected."
            var alert = UIAlertController(title: "Wi-Fi Connection", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { action in
                self.checkWiFi()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                self.navigationController!.popViewControllerAnimated(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            discoveryStart()
        }
    }
    
    @IBAction func btnDiscoveryClick(sender: AnyObject) {
        discoveryStart()
    }
    
    func discoveryStart() {
        self.tableEndpoints.hidden = false
        self.viewNoDevices.hidden = true
        self.indicator.startAnimating()
        self.endpoints.removeAll(keepCapacity: true)
        self.tableEndpoints.reloadData()
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            NSLog("Starting discovery")
            self.discovery.stop()
            self.discovery.start("syncloud", listener: self)
            sleep(10)
            NSLog("Stopping discovery")
            self.discovery.stop()
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.indicator.stopAnimating()
                if self.endpoints.isEmpty {
                    self.tableEndpoints.hidden = true
                    self.viewNoDevices.hidden = false
                }
            }
        }
    }
    
    func found(endpoint: Endpoint) {
        let serverUrl = "http://\(endpoint.host):81/server/rest"
        var device = DeviceInternal(webService: WebService(apiUrl: serverUrl))
        var (id, error) = device.id()
        
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
        var endpoint = self.endpoints[indexPath.row]
        
        var cell = self.tableEndpoints.dequeueReusableCellWithIdentifier("deviceCell") as! DeviceCell
        cell.load(endpoint)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableEndpoints.deselectRowAtIndexPath(indexPath, animated: true)
        var endpoint = self.endpoints[indexPath.row]
        var viewActivate = ActivateController(idEndpoint: endpoint)
        self.navigationController!.pushViewController(viewActivate, animated: true)
        
    }

}