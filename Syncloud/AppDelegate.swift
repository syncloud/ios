import UIKit
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MFMailComposeViewControllerDelegate {

    class AppUncaughtExceptionHandler: UncaughtExceptionHandler {
        override func handle(_ exception: NSException) {
            NSLog("Uncaught exception happened")
        }
    }

    var exceptionHandler: AppUncaughtExceptionHandler?
    
    func catchUnhandledExceptions() {
        self.exceptionHandler = AppUncaughtExceptionHandler()
        StaticHolder.setUncaughtExceptionHandler(exceptionHandler!)
        NSSetUncaughtExceptionHandler(exceptionHandlerPtr)
    }
    
    var logPath: String?
    
    func log2File() {
        if !SimulatorUtil.isRunningSimulator {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            self.logPath = documentsPath.appendingPathComponent("Syncloud.log")
            freopen(logPath!.cString(using: String.Encoding.ascii)!, "a+", stderr)
        }
    }

    var window: UIWindow?
    var navController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        catchUnhandledExceptions()
        log2File()

//        NSException(name: "MyException", reason: "Some message", userInfo:nil).raise()
        
        NSLog("Starting application")
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            
            let authController = AuthController()
            self.navController = MainController(rootViewController: authController)
            window.rootViewController = self.navController
            window.makeKeyAndVisible()
        }
        return true
    }

    func sendLog() {
        if let theLogPath = logPath {
            if MFMailComposeViewController.canSendMail() {
                let composer = MFMailComposeViewController()
                composer.mailComposeDelegate = self
                composer.setToRecipients(["support@syncloud.it"])
                composer.setSubject("Syncloud iOS Report")
                composer.setMessageBody("Provide additional information here", isHTML: false)
                let logData = FileManager.default.contents(atPath: theLogPath)
                composer.addAttachmentData(logData!, mimeType: "Text/XML", fileName: "Syncloud.log")
                self.navController!.visibleViewController!.present(composer, animated: true, completion: nil)
            }
        }
    }
    
    func clearLog() {
        let fileManager = FileManager.default
        if let theLogPath = logPath {
            if fileManager.fileExists(atPath: theLogPath) {
                try! fileManager.removeItem(atPath: theLogPath)
                log2File()
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.navController!.visibleViewController!.dismiss(animated: true, completion: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

