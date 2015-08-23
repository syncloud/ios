import Foundation
import UIKit

class DomainsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnDiscover: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "Domains"
        
        var btnAdd = UIBarButtonItem(title: "Discover", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnAddClick:"))
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, btnAdd, flexibleSpace]
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)

        self.loadDomains()
    }

    func loadDomains() {
        var credentials = Storage.getCredentials()
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            var result = self.mainController().userService.getUser(credentials.email!, password: credentials.password!)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if result.error == nil {
                    self.updateDomains(result.user!)
                }
            }
        }
    }

    func updateDomains(user: User) {
        domains.removeAll()
        for domain in user.domains {
            domains.append(domain)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func btnAddClick(sender: UIBarButtonItem) {
        var viewDiscovery = DiscoveryController()
        self.navigationController!.pushViewController(viewDiscovery, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domains.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.domains[indexPath.row].user_domain
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let domain = self.domains[indexPath.row]

        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        dispatch_async(queue) { () -> Void in
            let url = findAccessibleUrl(domain)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if let url = url {
                    self.mainController().openUrl(url)
                }
            }
        }

    }
}