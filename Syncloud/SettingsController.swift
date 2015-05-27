import Foundation
import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableSettings: UITableView!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var labelEmailValue: UILabel!
    @IBOutlet weak var cellSignOut: UITableViewCell!
    
    let sectionAccount = 0
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
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[sectionAccount]!.count
    }

    func getCell(indexPath: NSIndexPath) -> UITableViewCell {
        var sectionCells = cells[indexPath.section]!
        return sectionCells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCell(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = getCell(indexPath)
        if cell == cellSignOut {
            Storage.deleteCredentials()
            var authController = AuthController()
            self.navigationController!.replaceAll(authController, animated: true)
        }
    }
    
}