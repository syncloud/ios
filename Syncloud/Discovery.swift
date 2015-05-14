import Foundation


class BMBrowserDelegate : NSObject, NSNetServiceBrowserDelegate {
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didFindDomain domainName: String, moreComing moreDomainsComing: Bool) {
        println("netServiceDidFindDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didRemoveDomain domainName: String, moreComing moreDomainsComing: Bool) {
        println("netServiceDidRemoveDomain")
    }
    
    func netServiceBrowser(netServiceBrowser: NSNetServiceBrowser, didFindService netService: NSNetService, moreComing moreServicesComing: Bool) {
        println("netServiceDidFindService")
        var serviceName = netService.name
        println(serviceName)
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
    var nsbdel: BMBrowserDelegate
    
    init(serviceName: String) {
        self.serviceName = serviceName
        self.nsb = NSNetServiceBrowser()
        self.nsbdel = BMBrowserDelegate()
        nsb.delegate = nsbdel
    }
    
    func start() {
        nsb.searchForServicesOfType(BM_TYPE, inDomain: BM_DOMAIN)
    }
    
    func stop() {
        nsb.stop()
    }
    
}
