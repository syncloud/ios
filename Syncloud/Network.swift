import Foundation
import SystemConfiguration.CaptiveNetwork
import MessageUI

func checkUrl(url: String) -> Int? {
    NSLog("Request: \(url)")
    
    var nsRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
    nsRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
    nsRequest.timeoutInterval = 5
    
    var response: NSURLResponse? = nil
    var error: NSErrorPointer = nil
    var responseData: NSData? =  NSURLConnection.sendSynchronousRequest(nsRequest, returningResponse: &response, error: error)
    
    if error != nil {
        let message = "Request failed with error: \(error.debugDescription)"
        NSLog(message)
        return nil
    }
    
    if let httpResponse = response as? NSHTTPURLResponse {
        let message = "Response has status code: \(httpResponse.statusCode)"
        NSLog(message)
        return httpResponse.statusCode
    }
    
    return nil
}

func getUrl(address: String, port: Int) -> String {
    var url = "http://\(address)"
    if port != 80 {
        url = url+":\(port)"
    }
    return url
}

func findAccessibleUrl(domain: Domain) -> String? {
    let server = domain.service("server")
    
    if let theServer = server {
        if let externalPort = theServer.port {
            let urlDomain = getUrl("\(domain.user_domain).syncloud.it", externalPort)
            if checkUrl(urlDomain) == 200 {
                return urlDomain;
            }
            
            let urlPublicIp = getUrl(domain.ip, externalPort)
            if checkUrl(urlPublicIp) == 200 {
                return urlPublicIp;
            }
        }
        
        let urlLocal = getUrl(domain.local_ip, theServer.local_port)
        if checkUrl(urlLocal) == 200 {
            return urlLocal;
        }
        
    }
    return nil
}

func getSSID() -> String? {
    if UIDevice.currentDevice().model == "iPhone Simulator" {
        return "Simulator"
    }
    
    if let interfaces = CNCopySupportedInterfaces() {
        let interfacesArray = interfaces.takeRetainedValue() as! [String]
        if let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfacesArray[0]) {
            let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary
            return interfaceData["SSID"] as? String
        }
    }
    return nil
}
