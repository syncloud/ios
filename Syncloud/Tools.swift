import Foundation


class Tools {
    
    var webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func id() -> (result: Identification?, error: Error?) {
        var request = Request(RequestType.GET, "/id")

        let (response, error) = webService.execute(request)

        if error != nil {
            return (result: nil, error: error)
        }

        return (result: Identification(json: response!["data"] as! NSDictionary), error: nil)
    }
    
}