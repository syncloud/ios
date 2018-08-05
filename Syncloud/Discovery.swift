import Foundation

protocol EndpointListener {
    func found(_ endpoint: Endpoint)
    func error(_ error: Error)
}

func ipv4Enpoint(_ data: Data) -> Endpoint? {
    var address = sockaddr()
    (data as NSData).getBytes(&address, length: MemoryLayout<sockaddr>.size)
    if address.sa_family == sa_family_t(AF_INET) {
        var addressIPv4 = sockaddr_in()
        (data as NSData).getBytes(&addressIPv4, length: MemoryLayout<sockaddr>.size)
        let host = String(cString: inet_ntoa(addressIPv4.sin_addr))
        let port = Int(CFSwapInt16(addressIPv4.sin_port))
        return Endpoint(host: host, port: port)
    }
    return nil
}

class BrowserDelegate : NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    var resolving = [NetService]()
    
    var listener: EndpointListener
    
    init(listener: EndpointListener) {
        self.listener = listener
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser, didFindDomain domainName: String, moreComing moreDomainsComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didFindDomain")
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser, didRemoveDomain domainName: String, moreComing moreDomainsComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didRemoveDomain")
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser, didFind netService: NetService, moreComing moreServicesComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didFindService")
        netService.delegate = self
        resolving.append(netService)
        netService.resolve(withTimeout: 0.0)
    }

    func netServiceDidResolveAddress(_ sender: NetService) {
        for addressData in sender.addresses! {
            let endpoint = ipv4Enpoint(addressData)
            if let theEndpoint = endpoint {
                self.listener.found(theEndpoint)
            }
        }
    }
    
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser, didRemove netService: NetService, moreComing moreServicesComing: Bool) {
        NSLog("BrowserDelegate.netServiceBrowser.didRemoveService")
    }
    
    func netServiceBrowserWillSearch(_ aNetServiceBrowser: NetServiceBrowser){
        NSLog("BrowserDelegate.netServiceBrowserWillSearch")
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser, didNotSearch errorInfo: [String : NSNumber]) {
        NSLog("BrowserDelegate.netServiceBrowser.didNotSearch")
    }
    
    func netServiceBrowserDidStopSearch(_ netServiceBrowser: NetServiceBrowser) {
        NSLog("BrowserDelegate.netServiceBrowserDidStopSearch")
    }
    
}


class Discovery {
    let BM_DOMAIN = "local."
    let BM_TYPE = "_ssh._tcp."

    var nsb: NetServiceBrowser
    var nsbdel: BrowserDelegate?
    
    init() {
        self.nsb = NetServiceBrowser()
    }
    
    func start(_ serviceName: String, listener: EndpointListener) {
        self.nsbdel = BrowserDelegate(listener: listener)
        nsb.delegate = nsbdel
        nsb.searchForServices(ofType: BM_TYPE, inDomain: BM_DOMAIN)
    }
    
    func stop() {
        nsb.stop()
    }
    
}
