import Foundation

func nullToNil(_ value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}

class Domain {
    var user_domain: String
    var device_mac_address: String
    var device_name: String
    var device_title: String
    var map_local_address: Bool?
    var web_protocol: String?
    var ip: String?
    var web_port: Int?
    var local_ip: String?
    var web_local_port: Int?
    
    init(json: NSDictionary) {
        self.user_domain = json.value(forKey: "user_domain") as! String
        self.device_mac_address = json.value(forKey: "device_mac_address") as! String
        self.device_name = json.value(forKey: "device_name") as! String
        self.device_title = json.value(forKey: "device_title") as! String
        self.map_local_address = nullToNil(json.value(forKey: "map_local_address") as AnyObject) as! Bool?
        self.web_protocol = nullToNil(json.value(forKey: "web_protocol") as AnyObject) as! String?
        self.ip = nullToNil(json.value(forKey: "ip") as AnyObject) as! String?
        self.web_port = nullToNil(json.value(forKey: "web_port") as AnyObject) as! Int?
        self.local_ip = nullToNil(json.value(forKey: "local_ip") as AnyObject) as! String?
        self.web_local_port = nullToNil(json.value(forKey: "web_local_port") as AnyObject) as! Int?
    }
    
    func getDnsUrl(_ main_domain: String) -> String? {
        if let do_map_local_address = self.map_local_address {
            let port = do_map_local_address ? self.web_local_port : self.web_port;
            if let the_protocol = self.web_protocol, let the_port = port {
                return getUrl(the_protocol, "\(self.user_domain).\(main_domain)", the_port)
            }
        }
        return nil
    }

    func getExternalUrl() -> String? {
        if let the_protocol = self.web_protocol, let ip = self.ip, let port = self.web_port {
            return getUrl(the_protocol, ip, port)
        }
        return nil
    }

    func getInternalUrl() -> String? {
        if let the_protocol = self.web_protocol, let ip = self.local_ip, let port = self.web_local_port {
            return getUrl(the_protocol, ip, port)
        }
        return nil
    }
}

extension Domain: Serializable {
   @objc  var jsonProperties:Array<String> {
        get { return ["user_domain", "device_mac_address", "device_name", "device_title", "ip", "local_ip", "last_update", "services"] }
    }

    @objc func valueForKey(_ key: String!) -> AnyObject! {
        switch key {
        case "user_domain":
            return self.user_domain as AnyObject
        case "device_mac_address":
            return self.device_mac_address as AnyObject
        case "device_name":
            return self.device_name as AnyObject
        case "device_title":
            return self.device_title as AnyObject
        case "ip":
            return self.ip as AnyObject
        case "local_ip":
            return self.local_ip as AnyObject
        default:
            return NSNull()
        }
    }
}

class User {
    var active: Bool
    var email: String
    var domains = [Domain]()
    
    init(json: NSDictionary) {
        self.active = json.value(forKey: "active") as! Bool
        self.email = json.value(forKey: "email") as! String
        
        let itemsJson = json.object(forKey: "domains") as! NSArray?
        if let theItemsJson = itemsJson {
            for item in theItemsJson {
                let itemJson = item as! NSDictionary
                self.domains.append(Domain(json: itemJson))
            }
        }
    }
}

extension User: Serializable {
    @objc var jsonProperties:Array<String> {
        get { return ["active", "email", "domains"] }
    }

    @objc func valueForKey(_ key: String!) -> AnyObject! {
        switch key {
        case "active":
            return self.active as AnyObject
        case "email":
            return self.email as AnyObject
        case "domains":
            return self.domains as AnyObject
        default:
            return NSNull()
        }
    }
}

class Endpoint {
    var host: String
    var port: Int
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    
    func toString() -> String {
        return self.host+":"+String(self.port)
    }
    
}

class Identification {
    var name: String
    var title: String
    var mac_address: String
    
    init(name: String, title: String, mac_address: String) {
        self.name = name
        self.title = title
        self.mac_address = mac_address
    }
    
    init(json: NSDictionary) {
        self.name = json.value(forKey: "name") as! String
        self.title = json.value(forKey: "title") as! String
        self.mac_address = json.value(forKey: "mac_address") as! String
    }
}

class IdentifiedEndpoint {
    var endpoint: Endpoint
    var id: Identification
    
    init(endpoint: Endpoint, id: Identification) {
        self.endpoint = endpoint
        self.id = id
    }
}
