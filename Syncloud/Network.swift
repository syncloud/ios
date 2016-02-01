import Foundation
import SystemConfiguration.CaptiveNetwork
import MessageUI

func checkUrl(url: String) -> Int? {
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
            return httpResponse.statusCode
        }
        return nil
    } catch (let error) {
        let message = "Request failed with error: \(error)"
        NSLog(message)
        return nil
    }
}

func getUrl(address: String, _ port: Int) -> String {
    var url = "http://\(address)"
    if port != 80 {
        url = url+":\(port)"
    }
    return url
}

func findAccessibleUrl(domain: Domain) -> String? {
    let server: Service? = nil
    
    if let theServer = server {
        if let externalPort = theServer.port {
            let urlDomain = getUrl("\(domain.user_domain).syncloud.it", externalPort)
            if checkUrl(urlDomain) == 200 {
                return urlDomain;
            }
            
            if let external_ip = domain.ip {
                let urlPublicIp = getUrl(external_ip, externalPort)
                if checkUrl(urlPublicIp) == 200 {
                    return urlPublicIp;
                }
            }
        }
        
        if let local_ip = domain.local_ip {
            let urlLocal = getUrl(local_ip, theServer.local_port)
            if checkUrl(urlLocal) == 200 {
                return urlLocal;
            }
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
