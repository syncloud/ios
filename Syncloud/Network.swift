import Foundation
import SystemConfiguration.CaptiveNetwork
import MessageUI

func checkUrl(url: String) -> Bool {
    NSLog("Request: \(url)")
    
    let nsRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
    nsRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
    nsRequest.timeoutInterval = 5
    
    var response: NSURLResponse? = nil
    do {
        try NSURLConnection.sendSynchronousRequest(nsRequest, returningResponse: &response)
        if let httpResponse = response as? NSHTTPURLResponse {
            let message = "Response has status code: \(httpResponse.statusCode)"
            NSLog(message)
            return httpResponse.statusCode == 200
        }
        return false
    } catch (let error) {
        let message = "Request failed with error: \(error)"
        NSLog(message)
        return false
    }
}

func findAccessibleUrl(mainDomain: String, _ domain: Domain) -> String? {
    if let theDnsUrl = domain.getDnsUrl(mainDomain) {
        if checkUrl(theDnsUrl) {
            return theDnsUrl
        }
    }

    if let theExternalUrl = domain.getExternalUrl() {
        if checkUrl(theExternalUrl) {
            return theExternalUrl
        }
    }

    if let theInternalUrl = domain.getInternalUrl() {
        if checkUrl(theInternalUrl) {
            return theInternalUrl
        }
    }

    return nil
}

func getSSID() -> String? {
    if UIDevice.currentDevice().model == "iPhone Simulator" {
        return "Simulator"
    }
    
    var currentSSID: String? = nil
    if let interfaces:CFArray! = CNCopySupportedInterfaces() {
        for i in 0..<CFArrayGetCount(interfaces){
            let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
            let rec = unsafeBitCast(interfaceName, AnyObject.self)
            let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
            if unsafeInterfaceData != nil {
                let interfaceData = unsafeInterfaceData! as Dictionary!
                currentSSID = interfaceData["SSID"] as! String?
            }
        }
    }
    return currentSSID
}
