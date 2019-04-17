import Foundation

enum RequestType {
    case get
    case post
    
    func toString() -> String {
        switch self {
        case .get:
            return "GET"
        case .post:
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
    
    func toString(_ baseUrl: String) -> String {
        return "\(self.type.toString()) URL: \(baseUrl)\(self.url)"
    }
}

func createRequest(_ request: Request, _ rootUrl: String) -> URLRequest {
    let paramsString = request.paramsToString()
    var url = rootUrl+request.url

    switch request.type {
    case RequestType.get:
        if !paramsString.isEmpty {
            url += "?"
            url += paramsString
        }
        return URLRequest(url: URL(string: url)!)
    case RequestType.post:
        let nsRequest = NSMutableURLRequest(url: URL(string: url)!)
        nsRequest.httpMethod = "POST"
        nsRequest.httpBody = paramsString.data(using: String.Encoding.utf8)
        return nsRequest as URLRequest
    }
}

class WebService {
    var apiUrl: String

    init(apiUrl: String) {
        self.apiUrl = apiUrl
    }

    func execute(_ request: Request) -> (result: NSDictionary?, error: AppError?) {
        let nsRequest = createRequest(request, self.apiUrl)
        
        NSLog("Request: \(request.toString(self.apiUrl))")

        var responseData: Data? = nil
        do {
            var response: URLResponse? = nil
            responseData = try NSURLConnection.sendSynchronousRequest(nsRequest, returning: &response)
        } catch let error as NSError {
            let message = "Request failed with error: \(error.debugDescription)"
            NSLog(message)
            return (result: nil, error: AppError(message))
        }

        if let responseData = responseData {
            let responseString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)!
            NSLog("Response:\n\(responseString)")
        }
        
        return parseJsonResult(responseData)
    }
}
