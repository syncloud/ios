import Foundation

enum RequestType {
    case GET
    case POST
    
    func toString() -> String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

class Request {
    var url: String
    var type: RequestType
    var params: Dictionary<String, String>
    
    init(_ type: RequestType, _ url: String, _ params: Dictionary<String, String>) {
        self.url = url
        self.type = type
        self.params = params
    }
    
    func paramsToString() -> String {
        var paramsString = ""
        for (param, value) in self.params {
            if Array(self.params.keys)[0] != param {
                paramsString += "&"
            }
            paramsString += param
            paramsString += "="
            paramsString += value
        }
        return paramsString
    }
    
    func toString() -> String {
        return "\(self.type.toString()) URL: \(self.url) Parameters: \(self.paramsToString())"
    }
}

func createRequest(request: Request, rootUrl: String) -> NSURLRequest {
    var paramsString = request.paramsToString()
    var url = rootUrl+request.url

    switch request.type {
    case RequestType.GET:
        if !paramsString.isEmpty {
            url += "?"
            url += paramsString
        }
        return NSURLRequest(URL: NSURL(string: url)!)
    case RequestType.POST:
        var nsRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        nsRequest.HTTPMethod = "POST"
        nsRequest.HTTPBody = paramsString.dataUsingEncoding(NSUTF8StringEncoding)
        return nsRequest
    }
}

class WebService {
    var apiUrl: String
    
    init(apiUrl: String) {
        self.apiUrl = apiUrl
    }
    
    func execute(request: Request) -> (result: NSDictionary?, error: Error?) {
        var nsRequest = createRequest(request, self.apiUrl)
        
        NSLog("Request: \(request.toString()) to \(self.apiUrl)")
        
        var response: NSURLResponse? = nil
        var error: NSErrorPointer = nil
        var responseData: NSData? =  NSURLConnection.sendSynchronousRequest(nsRequest, returningResponse: &response, error: error)
        
        if error != nil {
            let message = "Request failed with error \(error.debugDescription)"
            NSLog(message)
            return (result: nil, error: Error(message))
        }
        
        if let theResponseData = responseData {
            var responseString = NSString(data: theResponseData, encoding: NSUTF8StringEncoding)!
            NSLog("Response:\n\(responseString)")
        }
        
        return parseJsonResult(responseData)
    }
    
    
}