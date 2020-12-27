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
        self.tableView.register(cellNib, forCellReuseIdentifier: "deviceCell")

        self.tableView.isHidden = false
        self.viewNoDevices.isHidden = true
        
        self.title = "Devices"
        
        let btnAdd = UIBarButtonItem(title: "Discover", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DomainsController.btnAddClick(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, btnAdd, flexibleSpace]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DomainsController.reload(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading devices...")
        self.tableView.addSubview(refreshControl)
        
        self.refreshEndpoints = refreshControl
        
        
        (self.navigationController as! MainController).addSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)

        self.loadDomains()
    }

    @IBAction func reload(_ sender: AnyObject) {
        loadDomains()
    }
    
    func loadDomains() {
        if self.refreshEndpoints!.isRefreshing == false {
           self.refreshEndpoints!.beginRefreshing()
        }
        mainDomain = Storage.getMainDomain()

        let credentials = Storage.getCredentials()
        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);
        queue.async { () -> Void in
            let result = self.mainController().getUserService().getUser(credentials.email!, password: credentials.password!)

            DispatchQueue.main.async { () -> Void in
                self.refreshEndpoints!.endRefreshing()
                if result.error == nil {
                    self.showDomains(result.user!)
                }
            }
        }
    }

    func showDomains(_ user: User) {
        if user.domains.isEmpty {
            tableView.isHidden = true
            viewNoDevices.isHidden = false
        } else {
            tableView.isHidden = false
            viewNoDevices.isHidden = true
        }

        domains.removeAll()
        for domain in user.domains {
            domains.append(domain)
        }
        self.tableView.reloadData()
    }

    @objc func btnAddClick(_ sender: UIBarButtonItem) {
        let viewDiscovery = DiscoveryController()
        self.navigationController!.pushViewController(viewDiscovery, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let domain = self.domains[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "deviceCell") as! DeviceCell
        cell.load(mainDomain, domain)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let domain = self.domains[indexPath.row]

        let queue = DispatchQueue(label: "org.syncloud.Syncloud", attributes: []);
        
        let progress = UIAlertController(title: "Opening device", message: "Finding address of the device...", preferredStyle: UIAlertController.Style.alert)
        self.present(progress, animated: true, completion: nil)

        queue.async { () -> Void in
            let url = findAccessibleUrl(Storage.getMainDomain(), domain)

            DispatchQueue.main.async { () -> Void in
                progress.dismiss(animated: true, completion: { () -> Void in
                    if let url = url {
                        self.mainController().openUrl(url)
                    } else {
                        let alert = UIAlertController(title: "Can't open device", message: "If this device is in internal mode check that you are connected to the same network. It also possible that this device is offline.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
}
