import Foundation
import UIKit

class AuthCredentialsController: UIViewController {
    @IBOutlet weak var emailTextEdit: UITextField!
    @IBOutlet weak var passwordTextEdit: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: "AuthCredentials", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var titleItem = UINavigationItem(title: "Login")
//
//        self.navigationController!.navigationBar.pushNavigationItem(titleItem, animated: true)
        
        self.title = "Sign in"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setupNavigation() {
//        UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
//        @"MyButton" style:UIBarButtonItemStyleBordered target:
//        self action:@selector(myButtonClicked:)];
//        
//        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//        [self.navigationItem setRightBarButtonItem:myNavBtn];
//        
//        // create a navigation push button that is initially hidden
//        navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [navButton setFrame:CGRectMake(60, 50, 200, 40)];
//        [navButton setTitle:@"Push Navigation" forState:UIControlStateNormal];
//        [navButton addTarget:self action:@selector(pushNewView:)
//        forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:navButton];
//        [navButton setHidden:YES];
//    }
    
    @IBAction func signIn(sender: UIButton) {
        self.activityIndicator.startAnimating()
        
        var queue = dispatch_queue_create("org.syncloud.Syncloud", nil);
        
        dispatch_async(queue) { () -> Void in
            var service = RedirectService(apiUrl: "http://api.syncloud.it")
            var result = service.getUser(self.emailTextEdit.text, password: self.passwordTextEdit.text)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityIndicator.stopAnimating()
                
                if result.error != nil {
                    
                } else {
                    var viewDevices = DomainsViewController(user: result.user!)
                    self.navigationController?.pushViewController(viewDevices, animated: true)
//                    self.presentViewController(viewDevices, animated: true, completion: nil)
                    
                }
            }
        }
    }
}