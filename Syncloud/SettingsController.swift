import Foundation
import UIKit
import MessageUI

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate  {
    
    @IBOutlet weak var tableSettings: UITableView!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var labelEmailValue: UILabel!
    @IBOutlet weak var cellSignOut: UITableViewCell!
    @IBOutlet weak var cellSendLog: UITableViewCell!
    @IBOutlet weak var cellDomainNameService: UITableViewCell!
    @IBOutlet weak var labelDomainNameService: UILabel!
    
    let sectionAccount = 0
    let sectionFeedback = 1
    let sectionAdvanced = 2
    var cells = Dictionary<Int, [UITableViewCell]>()
    
    init() {
        super.init(nibName: "Settings", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"

        cells[sectionAccount] = [cellEmail, cellSignOut]
        cells[sectionFeedback] = [cellSendLog]
        cells[sectionAdvanced] = [cellDomainNameService]
        
        let credentials = Storage.getCredentials()
        
        if let theEmail = credentials.email {
            self.labelEmailValue.text = theEmail
        } else {
            self.labelEmailValue.text = "Not signed in yet"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        
        let mainDomain = Storage.getMainDomain()
        self.labelDomainNameService.text = "Domain Name Service: \(mainDomain)"
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendLog() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.sendLog()
    }
    
    func signOut() {
        (self.navigationController as! MainController).startOver()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section]!.count
    }

    func getCell(indexPath: NSIndexPath) -> UITableViewCell {
        var sectionCells = cells[indexPath.section]!
        return sectionCells[indexPath.row]
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sectionAccount {
            return "ACCOUNT"
        }
        if section == sectionFeedback {
            return "FEEDBACK"
        }
        if section == sectionAdvanced {
            return "ADVANCED"
        }
        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCell(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = getCell(indexPath)
        if cell == cellSignOut {
            signOut()
        }
        if cell == cellSendLog {
            sendLog()
        }
        if cell == cellDomainNameService {
            let viewDnsSelector = DnsSelectorController()
            self.navigationController!.pushViewController(viewDnsSelector, animated: true)
        }
        self.tableSettings.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}