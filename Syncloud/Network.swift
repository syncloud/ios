import Foundation

func checkUrl(url: String) -> Int? {
    NSLog("Request: \(url)")
    
    var nsRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
    
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

func findAccessibleUrl(domain: Domain) -> String? {
    let server = domain.service("server")
    
    if let theServer = server {
        let urlLocal = "http://\(domain.local_ip):\(theServer.local_port)"
        if checkUrl(urlLocal) == 200 {
            return urlLocal;
        }
        
        let urlPublic = "http://\(domain.ip):\(theServer.port)"
        if checkUrl(urlPublic) == 200 {
            return urlPublic;
        }
        
    }
    return nil
}
