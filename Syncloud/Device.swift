import Foundation


class DeviceInternal {
    
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

    func activate(domain: String, email: String, password: String, deviceLogin: String, devicePassword: String) -> (result: Identification?, error: Error?) {
        var parameters = [
            "redirect-email": email,
            "redirect-password": password,
            "redirect-domain": domain,
            "name": deviceLogin,
            "password": devicePassword
        ]
        var request = Request(RequestType.POST, "/activate", parameters)

        let (response, error) = webService.execute(request)

        if error != nil {
            return (result: nil, error: error)
        }

        return (result: Identification(json: response!["data"] as! NSDictionary), error: nil)
    }

}