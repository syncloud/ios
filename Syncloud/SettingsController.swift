import Foundation
import UIKit
import MessageUI

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate  {
    
    @IBOutlet weak var tableSettings: UITableView!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var labelEmailValue: UILabel!
    @IBOutlet weak var cellSignOut: UITableViewCell!
    @IBOutlet weak var cellSendLog: UITableViewCell!
    
    let sectionAccount = 0
    let sectionLog = 1
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
        cells[sectionLog] = [cellSendLog]
        
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
        Storage.deleteCredentials()
        let authController = AuthController()
        self.navigationController!.replaceAll(authController, animated: true)
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
    }
    
}