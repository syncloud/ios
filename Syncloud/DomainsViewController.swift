import Foundation
import UIKit

class DomainsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnDiscover: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var domains = [String]()
    
    init(user: User) {
        super.init(nibName: "Domains", bundle: nil)
        self.update(user)
    }
    
    func update(user: User) {
        domains.removeAll()
        for domain in user.domains {
            domains.append(domain.user_domain)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "Domains"
        
        var btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("btnAddClick:"))
        self.navigationItem.rightBarButtonItem = btnAdd
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        
        var btnSettings = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnSettingsClick:"))
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)        
        self.toolbarItems = [flexibleSpace, btnSettings, flexibleSpace]
        self.navigationController!.setToolbarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func btnSettingsClick(sender: UIBarButtonItem) {
        var viewSettings = SettingsController()
        self.navigationController!.pushViewController(viewSettings, animated: true)
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
        cell.textLabel?.text = self.domains[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}