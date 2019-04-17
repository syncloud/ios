import Foundation
import SystemConfiguration.CaptiveNetwork
import MessageUI

class UrlCheck : NSObject, NSURLConnectionDataDelegate {
    
    let request: URLRequest
    
    var response: URLResponse? = nil
    var error: Error? = nil
    
    init(url: String) {
        let nsRequest: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!)
        nsRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        nsRequest.timeoutInterval = 10
        self.request = nsRequest as URLRequest
    }
    
    var connection: NSURLConnection?
    var finished = false
    
    func check() throws -> URLResponse? {
        self.connection = NSURLConnection(request: self.request, delegate: self, startImmediately: false)
        self.connection!.schedule(in: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        self.connection!.start()
        while !self.finished {}
        self.connection?.cancel()
        if let theError = self.error {
            throw theError
        }
        return self.response
    }
    
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        NSLog("Auth challenge")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            NSLog("Auth challenge: \(challenge.protectionSpace.authenticationMethod)")
            challenge.sender?.use(URLCredential(trust: challenge.protectionSpace.serverTrust!), for: challenge)
        }
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        NSLog("Connection error: \(error)")
        self.error = error
        self.finished = true
    }
    
    func connection(_ didReceiveResponse: NSURLConnection, didReceive response: URLResponse) {
        NSLog("Connection response: \(response)")
        self.response = response
        self.finished = true
    }
    
    deinit {
        self.finished = true
    }
}

func checkUrl(_ url: String) -> Bool {
    
    do {
        NSLog("Request: \(url)")
        
        let request = UrlCheck(url: url)
        let response = try request.check()

        if let httpResponse = response as? HTTPURLResponse {
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

func findAccessibleUrl(_ mainDomain: String, _ domain: Domain) -> String? {
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
    if let interfaces:CFArray = CNCopySupportedInterfaces() {
        for i in 0..<CFArrayGetCount(interfaces){
            let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
            let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
            let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
            if unsafeInterfaceData != nil {
                let interfaceData = unsafeInterfaceData! as NSDictionary
                currentSSID = interfaceData["SSID"] as! String?
            }
        }
    }
    return currentSSID
}
