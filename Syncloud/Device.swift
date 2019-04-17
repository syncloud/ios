import Foundation

func getRestWebService(_ host: String) -> WebService {
    return WebService(apiUrl: "http://\(host):81/rest")
}

class DeviceInternal {
    
    var host: String

    init(host: String) {
        self.host = host
    }

    func id() -> (result: Identification?, error: AppError?) {
        let webService = getRestWebService(self.host)

        let request = Request(RequestType.get, "/id")

        let (response, error) = webService.execute(request)

        if error != nil {
            return (result: nil, error: error)
        }

        return (result: Identification(json: response!["data"] as! NSDictionary), error: nil)
    }

}
