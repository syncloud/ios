import Foundation


class DeviceInternal {
    
    var webService: WebService

    init(webService: WebService) {
        self.webService = webService
    }
    
    func id() -> (result: Identification?, error: Error?) {
        let request = Request(RequestType.GET, "/id")

        let (response, error) = webService.execute(request)

        if error != nil {
            return (result: nil, error: error)
        }

        return (result: Identification(json: response!["data"] as! NSDictionary), error: nil)
    }

    func activate(mainDomain: String, userDomain: String, email: String, password: String, deviceUsername: String, devicePassword: String) -> (result: Identification?, error: Error?) {
        let parameters = [
            "main_domain": mainDomain,
            "redirect_email": email,
            "redirect_password": password,
            "user_domain": userDomain,
            "device_username": deviceUsername,
            "device_password": devicePassword
        ]
        let request = Request(RequestType.POST, "/activate", parameters)

        let (response, error) = webService.execute(request)

        if error != nil {
            return (result: nil, error: error)
        }

        return (result: Identification(json: response!["data"] as! NSDictionary), error: nil)
    }

}