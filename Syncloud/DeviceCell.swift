import Foundation
import UIKit

class DeviceCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    
    func load(_ mainDomain: String, _ domain: Domain) {
        labelTitle.text = "\(domain.user_domain).\(mainDomain)"
        labelSubtitle.text = domain.device_title
    }
    
    func load(_ device: IdentifiedEndpoint) {
        labelTitle.text = device.id.title
        labelSubtitle.text = device.endpoint.host
    }
}
