import Foundation

func getUrl(theProtocol: String, _ address: String, _ port: Int) -> String {
    var url = "\(theProtocol)://\(address)"
    if port != 80 {
        url = url+":\(port)"
    }
    return url
}

func getRedirectApiUrl(mainDomain: String) -> String{
    return "http://api.\(mainDomain)"
}