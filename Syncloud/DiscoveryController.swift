import Foundation
import UIKit

class DiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, EndpointListener {
    
    @IBOutlet weak var tableEndpoints: UITableView!
    @IBOutlet weak var viewNoDevices: UIView!
    
    var discovery: Discovery
    
    var endpoints = [IdentifiedEndpoint]()

    var refreshEndpoints: UIRefreshControl?
    
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
        
        let cellNib = UINib(nibName: "DeviceCell", bundle: nil)
        self.tableEndpoints.register(cellNib, forCellReuseIdentifier: "deviceCell")
        
        self.title = "Discovery"
        
        let btnRefresh = UIBarButtonItem(title: "Refresh", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DiscoveryController.btnDiscoveryClick(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, btnRefresh, flexibleSpace]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DiscoveryController.btnDiscoveryClick(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Discovering devices...")
        
        self.tableEndpoints.addSubview(refreshControl)

        self.refreshEndpoints = refreshControl
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        checkWiFi()
    }
    
    @IBAction func btnLearnMoreClicked(_ sender: AnyObject) {
        self.mainController().openUrl("http://syncloud.org")
    }
    
    func checkWiFi() {
        let ssid = getSSID()
        
        if ssid == nil {
            let alertMessage = "You are not connected to Wi-Fi network. Discovery is possible only in the same Wi-Fi network where you have Syncloud device connected."
            let alert = UIAlertController(title: "Wi-Fi Connection", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                self.checkWiFi()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.navigationController!.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            discoveryStart()
        }
    }
    
    @IBAction func btnDiscoveryClick(_ sender: AnyObject) {
        discoveryStart()
    }
    
    func discoveryStart() {
        self.tableEndpoints.isHidden = false
        self.viewNoDevices.isHidden = true
        if self.refreshEndpoints!.isRefreshing == false {
            self.refreshEndpoints!.beginRefreshing()
        }
        self.endpoints.removeAll(keepingCapacity: true)
        self.tableEndpoints.reloadData()
        
        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);
        queue.async { () -> Void in
            NSLog("Starting discovery")
            self.discovery.stop()
            self.discovery.start("syncloud", listener: self)
            sleep(10)
            NSLog("Stopping discovery")
            self.discovery.stop()
            
            DispatchQueue.main.async { () -> Void in
                self.refreshEndpoints!.endRefreshing()
                if self.endpoints.isEmpty {
                    self.tableEndpoints.isHidden = true
                    self.viewNoDevices.isHidden = false
                }
            }
        }
    }
    
    func found(_ endpoint: Endpoint) {
        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);

        queue.async { () -> Void in
            let device = DeviceInternal(host: endpoint.host)
            let (id, error) = device.id()

            if error != nil {
                return
            }

            let identifiedEndpoint = IdentifiedEndpoint(endpoint: endpoint, id: id!)

            DispatchQueue.main.async {
                () -> Void in

                if self.endpoints.filter({ e in e.endpoint.host == identifiedEndpoint.endpoint.host }).count == 0 {
                    self.endpoints.append(identifiedEndpoint)
                    self.tableEndpoints.reloadData()
                }
            }
        }
    }
    
    func error(_ error: Error) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let endpoint = self.endpoints[indexPath.row]
        
        let cell = self.tableEndpoints.dequeueReusableCell(withIdentifier: "deviceCell") as! DeviceCell
        cell.load(endpoint)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableEndpoints.deselectRow(at: indexPath, animated: true)
        let endpoint = self.endpoints[indexPath.row]
        self.mainController().openUrl(endpoint.endpoint.activationUrl())        
    }

}
