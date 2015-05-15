import Foundation

enum RequestType {
    case GET
    case POST
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
}

func createRequest(request: Request, rootUrl: String) -> NSURLRequest {
    var paramsString = ""
    for (param, value) in request.params {
        if Array(request.params.keys)[0] != param {
            paramsString += "&"
        }
        paramsString += param
        paramsString += "="
        paramsString += value
    }
    
    switch request.type {
    case RequestType.GET:
        var url = rootUrl+request.url
        if !paramsString.isEmpty {
            url += "?"
            url += paramsString
        }
        return NSURLRequest(URL: NSURL(string: url)!)
    case RequestType.POST:
        var url = NSURL(string: (rootUrl+request.url))
        var nsRequest = NSMutableURLRequest(URL: url!)
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
        var response: NSURLResponse? = nil
        var error: NSErrorPointer = nil
        var responseData: NSData? =  NSURLConnection.sendSynchronousRequest(nsRequest, returningResponse: &response, error: error)

        if error != nil {
            return (result: nil, error: Error("Error happened"))
        }

        return parseJsonResult(responseData)
    }
    
    
}