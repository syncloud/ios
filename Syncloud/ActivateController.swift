import Foundation
import UIKit

class ActivateController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var endpoint: IdentifiedEndpoint

    init(endpoint: IdentifiedEndpoint) {
        self.endpoint = endpoint
        
        super.init(nibName: "Activate", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Activate"
        (self.navigationController as! MainController).addSettings()

        let host = self.endpoint.endpoint.host;
        let url = NSURL(string: "http://\(host):81/server/html/activate.html?release=0.9")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
}