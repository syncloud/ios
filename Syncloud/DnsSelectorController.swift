import Foundation
import UIKit

class DnsSelectorController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerDns: UIPickerView!
    
    init() {
        super.init(nibName: "DnsSelector", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var pickerDomainComponent = 0
    
    var domainsValues: [String] = [String]()
    var domainsTitles: [String] = [String]()
    
    var mainDomain: String = Storage.getMainDomain()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Server"

        let viewController = self.navigationController!.visibleViewController!
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DnsSelectorController.btnSaveClick(_:)))
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DnsSelectorController.btnCancelClick(_:)))
        viewController.navigationItem.rightBarButtonItem = btnSave
        viewController.navigationItem.leftBarButtonItem = btnCancel
        
        self.domainsValues = ["syncloud.it", "syncloud.info"]
        self.domainsTitles = ["Production: syncloud.it", "Testing: syncloud.info"]

        self.mainDomain = Storage.getMainDomain()

        self.pickerDns.selectRow(domainsValues.index(of: self.mainDomain)!, inComponent: self.pickerDomainComponent, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    func btnSaveClick(_ sender: UIBarButtonItem) {
        let newMainDomain = self.domainsValues[self.pickerDns.selectedRow(inComponent: self.pickerDomainComponent)]
        Storage.setMainDomain(newMainDomain)
        self.navigationController!.popViewController(animated: true)
    }

    func btnCancelClick(_ sender: UIBarButtonItem) {
        self.navigationController!.popViewController(animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.domainsValues.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.domainsTitles[row]
    }
}
