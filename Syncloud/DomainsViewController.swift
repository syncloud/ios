import Foundation
import UIKit

class DomainsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnDiscover: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var btnAdd: UIBarButtonItem?
    
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
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "Domains"
        self.btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("btnAddClick:"))
        self.navigationItem.rightBarButtonItem = self.btnAdd
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func btnAddClick(sender: UIBarButtonItem) {
        var viewDiscovery = DiscoveryController()
        self.navigationController?.pushViewController(viewDiscovery, animated: true)
    }
    
    @IBAction func clickDiscover(sender: AnyObject) {
        var viewDiscovery = DiscoveryController()
        self.presentViewController(viewDiscovery, animated: true, completion: nil)
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