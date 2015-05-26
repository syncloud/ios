import Foundation
import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableSettings: UITableView!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var labelEmail: NSLayoutConstraint!
    @IBOutlet weak var labelEmailValue: UILabel!
    
    init() {
        super.init(nibName: "Settings", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"

        var credentials = Storage.getCredentials()
        
        if let theEmail = credentials.email {
            self.labelEmailValue.text = theEmail
        } else {
            self.labelEmailValue.text = "Not signed in yet"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var accountHeaderLabel = UILabel()
        accountHeaderLabel.text = "Account"
        return accountHeaderLabel
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellEmail
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}