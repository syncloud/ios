import Foundation
import UIKit

class DomainsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnDiscover: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoDevices: UIView!

    var refreshEndpoints: UIRefreshControl?
    
    var mainDomain = Storage.getMainDomain()
    var domains = [Domain]()

    func mainController() -> MainController {
        return self.navigationController as! MainController
    }

    init() {
        super.init(nibName: "Domains", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "DeviceCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "deviceCell")

        self.tableView.hidden = false
        self.viewNoDevices.hidden = true
        
        self.title = "Devices"
        
        let btnAdd = UIBarButtonItem(title: "Discover", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnAddClick:"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, btnAdd, flexibleSpace]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reload:"), forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading devices...")
        self.tableView.addSubview(refreshControl)
        
        self.refreshEndpoints = refreshControl
        
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)

        self.loadDomains()
    }

    @IBAction func reload(sender: AnyObject) {
        loadDomains()
    }
    
    func loadDomains() {
        if self.refreshEndpoints!.refreshing == false {
           self.refreshEndpoints!.beginRefreshing()
        }
        mainDomain = Storage.getMainDomain()

        let credentials = Storage.getCredentials()
        let queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            let result = self.mainController().getUserService().getUser(credentials.email!, password: credentials.password!)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.refreshEndpoints!.endRefreshing()
                if result.error == nil {
                    self.showDomains(result.user!)
                }
            }
        }
    }

    func showDomains(user: User) {
        if user.domains.isEmpty {
            tableView.hidden = true
            viewNoDevices.hidden = false
        } else {
            tableView.hidden = false
            viewNoDevices.hidden = true
        }

        domains.removeAll()
        for domain in user.domains {
            domains.append(domain)
        }
        self.tableView.reloadData()
    }

    func btnAddClick(sender: UIBarButtonItem) {
        let viewDiscovery = DiscoveryController()
        self.navigationController!.pushViewController(viewDiscovery, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domains.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let domain = self.domains[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("deviceCell") as! DeviceCell
        cell.load(mainDomain, domain)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let domain = self.domains[indexPath.row]

        let queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        let progress = UIAlertController(title: "Opening device", message: "Finding address of the device...", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(progress, animated: true, completion: nil)

        dispatch_async(queue) { () -> Void in
            let url = findAccessibleUrl(Storage.getMainDomain(), domain)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                progress.dismissViewControllerAnimated(true, completion: { () -> Void in
                    if let url = url {
                        self.mainController().openUrl(url)
                    } else {
                        let alert = UIAlertController(title: "Can't open device", message: "If this device is in internal mode check that you are connected to the same network. It also possible that this device is offline.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
}