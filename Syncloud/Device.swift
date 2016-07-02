import Foundation

func getRestUrl(host: String) -> String {
    //TODO: This is needed only for compatibility with releases prior 16.06. New rest URL should be used always.
    let newRestUrl = "http://\(host):81/rest";
    if checkUrl(newRestUrl+"/id") {
        return newRestUrl;
    }
    return "http://\(host):81/server/rest";
}

func getRestWebService(host: String) -> WebService {
    return WebService(apiUrl: getRestUrl(host))
}

class DeviceInternal {
    
    var host: String

    init(host: String) {
        self.host = host
    }

    func id() -> (result: Identification?, error: Error?) {
        var webService = getRestWebService(self.host)

        let request = Request(RequestType.GET, "/id")

        let (response, error) = webService.execute(request)

        if error != nil {
            return (result: nil, error: error)
        }

        return (result: Identification(json: response!["data"] as! NSDictionary), error: nil)
    }

    func activate(mainDomain: String, userDomain: String, email: String, password: String, deviceUsername: String, devicePassword: String) -> (result: Identification?, error: Error?) {
        var webService = getRestWebService(self.host)

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