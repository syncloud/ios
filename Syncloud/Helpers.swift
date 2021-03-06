import Foundation

func getUrl(_ theProtocol: String, _ address: String, _ port: Int) -> String {
    var url = "\(theProtocol)://\(address)"
    if needAddPort(theProtocol, port) {
        url = url+":\(port)"
    }
    return url
}

func needAddPort(_ theProtocol: String, _ port: Int) -> Bool {
    if (theProtocol == "http" && port == 80) {
        return false
    }
    if theProtocol == "https" && port == 443 {
        return false
    }
    return true
}

func getRedirectApiUrl(_ mainDomain: String) -> String{
    return "http://api.\(mainDomain)"
}
