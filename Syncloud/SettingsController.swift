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
    @IBOutlet weak var labelSignOut: UILabel!
    @IBOutlet weak var cellClearLog: UITableViewCell!
    
    let sectionAccount = 0
    let sectionReport = 1
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

        cells[sectionAccount] = [cellEmail]
        cells[sectionReport] = [cellSendLog, cellClearLog]
        cells[sectionAdvanced] = [cellDomainNameService]
        
        let credentials = Storage.getCredentials()
        
        if let theEmail = credentials.email {
            self.labelEmailValue.text = theEmail
            cells[sectionAccount]!.append(cellSignOut)
        } else {
            self.labelEmailValue.text = "Not signed in yet"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        
        let mainDomain = Storage.getMainDomain()
        self.labelDomainNameService.text = mainDomain
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendLog() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.sendLog()
    }
    
    func clearLog() {
        let alertMessage = "Do you want to erase all logged records?"
        let alert = UIAlertController(title: "Clear log file", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.clearLog()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOut() {
        (self.navigationController as! MainController).startOver()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section]!.count
    }

    func getCell(_ indexPath: IndexPath) -> UITableViewCell {
        var sectionCells = cells[indexPath.section]!
        return sectionCells[indexPath.row]
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sectionAccount {
            return "ACCOUNT"
        }
        if section == sectionReport {
            return "REPORT"
        }
        if section == sectionAdvanced {
            return "ADVANCED"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = getCell(indexPath)
        if cellSignOut != nil && cell == cellSignOut {
            signOut()
        }
        if cell == cellSendLog {
            sendLog()
        }
        if cell == cellClearLog {
            clearLog()
        }
        if cell == cellDomainNameService {
            let viewDnsSelector = DnsSelectorController()
            self.navigationController!.pushViewController(viewDnsSelector, animated: true)
        }
        self.tableSettings.deselectRow(at: indexPath, animated: true)
    }
    
}
