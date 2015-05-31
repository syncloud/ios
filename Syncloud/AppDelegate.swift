import UIKit
import MessageUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MFMailComposeViewControllerDelegate {

    var window: UIWindow?
    var navController: UINavigationController?

    var logPath: String?
    
    func log2File() {
        if UIDevice.currentDevice().model != "iPhone Simulator" {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            self.logPath = documentsPath.stringByAppendingPathComponent("Syncloud.log")
            freopen(logPath!.cStringUsingEncoding(NSASCIIStringEncoding)!, "a+", stderr)
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        log2File()
        NSLog("Starting application")
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor.whiteColor()
            
            var authController = AuthController()
            self.navController = MainController(rootViewController: authController)
            window.rootViewController = self.navController
            window.makeKeyAndVisible()
        }
        return true
    }

    func sendLog() {
        if let theLogPath = logPath {
            var composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["support@syncloud.it"])
            composer.setSubject("Syncloud Report")
            composer.setMessageBody("Provide additional information here", isHTML: false)
            var logData = NSFileManager.defaultManager().contentsAtPath(theLogPath)
            composer.addAttachmentData(logData, mimeType: "Text/XML", fileName: "Syncloud.log")
            self.navController!.visibleViewController.presentViewController(composer, animated: true, completion: nil)
        }
    }

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.navController!.visibleViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

