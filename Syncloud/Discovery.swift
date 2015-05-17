import Foundation

protocol EndpointListener {
    func found(endpoint: Endpoint)
    func error(error: Error)
}


class BrowserDelegate : NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    var resolving = [NSNetService]()
    
    var listener: EndpointListener
    
    init(listener: EndpointListener) {
        self.listener = listener
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didFindDomain domainName: String, moreComing moreDomainsComing: Bool) {
        println("netServiceDidFindDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didRemoveDomain domainName: String, moreComing moreDomainsComing: Bool) {
        println("netServiceDidRemoveDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didFindService netService: NSNetService, moreComing moreServicesComing: Bool) {
        println("netServiceDidFindService")
        netService.delegate = self
        resolving.append(netService)
        netService.resolveWithTimeout(0.0)
        
//        var addresses = netService.addresses!
//        var i = 0
//        for i in 0..<addresses.count {
//            var address = addresses[i] as! NSData
//            println(address)
//        }
        var serviceName = netService.name
        println(serviceName)
    }

    func netServiceDidResolveAddress(sender: NSNetService) {
        var addresses = sender.addresses!
        var i = 0
        for i in 0..<addresses.count {
            var addressData = addresses[i] as! NSData
            var address = sockaddr()
            addressData.getBytes(&address, length: sizeof(sockaddr))
            if address.sa_family == sa_family_t(AF_INET) {
                println("IPv4 address")
            }
            if address.sa_family == sa_family_t(AF_INET6) {
                println("IPv6 address")
            }
            println(addressData)
        }
    }
    
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didRemoveService netService: NSNetService, moreComing moreServicesComing: Bool) {
        println("netServiceDidRemoveService")
    }
    
    func netServiceBrowserWillSearch(aNetServiceBrowser: NSNetServiceBrowser){
        println("netServiceBrowserWillSearch")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didNotSearch errorInfo: [NSObject : AnyObject]) {
        println("netServiceDidNotSearch")
    }
    
    func netServiceBrowserDidStopSearch(netServiceBrowser: NSNetServiceBrowser) {
        println("netServiceDidStopSearch")
    }
    
}


class Discovery {
    let BM_DOMAIN = "local."
    let BM_TYPE = "_ssh._tcp."

    let serviceName: String
    var nsb: NSNetServiceBrowser
    var nsbdel: BrowserDelegate
    
    init(serviceName: String, listener: EndpointListener) {
        self.serviceName = serviceName
        self.nsb = NSNetServiceBrowser()
        self.nsbdel = BrowserDelegate(listener: listener)
        nsb.delegate = nsbdel
    }
    
    func start() {
        nsb.searchForServicesOfType(BM_TYPE, inDomain: BM_DOMAIN)
    }
    
    func stop() {
        nsb.stop()
    }
    
}
