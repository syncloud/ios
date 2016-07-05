import Foundation
import SystemConfiguration.CaptiveNetwork
import MessageUI

class UrlCheck : NSObject, NSURLConnectionDelegate {
    
    let request: NSURLRequest
    
    var response: NSURLResponse? = nil
    var error: NSError? = nil
    
    init(url: String) {
        let nsRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        nsRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        nsRequest.timeoutInterval = 10
        self.request = nsRequest
    }
    
    var connection: NSURLConnection?
    var finished = false
    
    func check() throws -> NSURLResponse? {
        self.connection = NSURLConnection(request: self.request, delegate: self, startImmediately: false)
        self.connection!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        self.connection!.start()
        while !self.finished {}
        self.connection?.cancel()
        if let theError = self.error {
            throw theError
        }
        return self.response
    }
    
    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            challenge.sender?.useCredential(NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!), forAuthenticationChallenge: challenge)
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.error = error
        self.finished = true
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.response = response
        self.finished = true
    }
    
    deinit {
        self.finished = true
    }
}

func checkUrl(url: String) -> Bool {
    
    do {
        NSLog("Request: \(url)")
        
        let request = UrlCheck(url: url)
        let response = try request.check()

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
    if SimulatorUtil.isRunningSimulator {
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
