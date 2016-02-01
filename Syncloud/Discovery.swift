import Foundation

protocol EndpointListener {
    func found(endpoint: Endpoint)
    func error(error: Error)
}

func ipv4Enpoint(data: NSData) -> Endpoint? {
    var address = sockaddr()
    data.getBytes(&address, length: sizeof(sockaddr))
    if address.sa_family == sa_family_t(AF_INET) {
        var addressIPv4 = sockaddr_in()
        data.getBytes(&addressIPv4, length: sizeof(sockaddr))
        let host = String.fromCString(inet_ntoa(addressIPv4.sin_addr))
        let port = Int(CFSwapInt16(addressIPv4.sin_port))
        return Endpoint(host: host!, port: port)
    }
    return nil
}

class BrowserDelegate : NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    var resolving = [NSNetService]()
    
    var listener: EndpointListener
    
    init(listener: EndpointListener) {
        self.listener = listener
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didFindDomain domainName: String, moreComing moreDomainsComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didFindDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didRemoveDomain domainName: String, moreComing moreDomainsComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didRemoveDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didFindService netService: NSNetService, moreComing moreServicesComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didFindService")
        netService.delegate = self
        resolving.append(netService)
        netService.resolveWithTimeout(0.0)
    }

    func netServiceDidResolveAddress(sender: NSNetService) {
        for addressData in sender.addresses! {
            let endpoint = ipv4Enpoint(addressData)
            if let theEndpoint = endpoint {
                self.listener.found(theEndpoint)
            }
        }
    }
    
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didRemoveService netService: NSNetService, moreComing moreServicesComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didRemoveService")
    }
    
    func netServiceBrowserWillSearch(aNetServiceBrowser: NSNetServiceBrowser){
        NSLog("BrowserDelegate.netServiceBrowserWillSearch")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didNotSearch errorInfo: [String : NSNumber]) {
        NSLog("BrowserDelegate.netServiceBrowser.didNotSearch")
    }
    
    func netServiceBrowserDidStopSearch(netServiceBrowser: NSNetServiceBrowser) {
        NSLog("BrowserDelegate.netServiceBrowserDidStopSearch")
    }
    
}


class Discovery {
    let BM_DOMAIN = "local."
    let BM_TYPE = "_ssh._tcp."

    var nsb: NSNetServiceBrowser
    var nsbdel: BrowserDelegate?
    
    init() {
        self.nsb = NSNetServiceBrowser()
    }
    
    func start(serviceName: String, listener: EndpointListener) {
        self.nsbdel = BrowserDelegate(listener: listener)
        nsb.delegate = nsbdel
        nsb.searchForServicesOfType(BM_TYPE, inDomain: BM_DOMAIN)
    }
    
    func stop() {
        nsb.stop()
    }
    
}
