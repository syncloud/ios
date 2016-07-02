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

    convenience init(_ type: RequestType, _ url: String) {
        self.init(type, url, [:])
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
    
    func toString(baseUrl: String) -> String {
        return "\(self.type.toString()) URL: \(baseUrl)\(self.url) Parameters: \(self.paramsToString())"
    }
}

func createRequest(request: Request, _ rootUrl: String) -> NSURLRequest {
    let paramsString = request.paramsToString()
    var url = rootUrl+request.url

    switch request.type {
    case RequestType.GET:
        if !paramsString.isEmpty {
            url += "?"
            url += paramsString
        }
        return NSURLRequest(URL: NSURL(string: url)!)
    case RequestType.POST:
        let nsRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
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
        let nsRequest = createRequest(request, self.apiUrl)
        
        NSLog("Request: \(request.toString(self.apiUrl))")

        var responseData: NSData? = nil
        do {
            var response: NSURLResponse? = nil
            responseData = try NSURLConnection.sendSynchronousRequest(nsRequest, returningResponse: &response)
        } catch let error as NSError {
            let message = "Request failed with error: \(error.debugDescription)"
            NSLog(message)
            return (result: nil, error: Error(message))
        }

        if let responseData = responseData {
            let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)!
            NSLog("Response:\n\(responseString)")
        }
        
        return parseJsonResult(responseData)
    }
}