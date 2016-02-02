import Foundation

func nullToNil(value : AnyObject?) -> AnyObject? {
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
        self.user_domain = json.valueForKey("user_domain") as! String
        self.device_mac_address = json.valueForKey("device_mac_address") as! String
        self.device_name = json.valueForKey("device_name") as! String
        self.device_title = json.valueForKey("device_title") as! String
        self.map_local_address = nullToNil(json.valueForKey("map_local_address")) as! Bool?
        self.web_protocol = nullToNil(json.valueForKey("web_protocol")) as! String?
        self.ip = nullToNil(json.valueForKey("ip")) as! String?
        self.web_port = nullToNil(json.valueForKey("web_port")) as! Int?
        self.local_ip = nullToNil(json.valueForKey("local_ip")) as! String?
        self.web_local_port = nullToNil(json.valueForKey("web_local_port")) as! Int?
    }
    
    func getDnsUrl(main_domain: String) -> String? {
        if let do_map_local_address = self.map_local_address {
            let port = do_map_local_address ? self.web_local_port : self.web_port;
            if let the_protocol = self.web_protocol, the_port = port {
                return getUrl(the_protocol, "\(self.user_domain).\(main_domain)", the_port)
            }
        }
        return nil
    }

    func getExternalUrl() -> String? {
        if let the_protocol = self.web_protocol, let ip = self.ip, port = self.web_port {
            return getUrl(the_protocol, ip, port)
        }
        return nil
    }

    func getInternalUrl() -> String? {
        if let the_protocol = self.web_protocol, let ip = self.local_ip, port = self.web_local_port {
            return getUrl(the_protocol, ip, port)
        }
        return nil
    }
}

extension Domain: Serializable {
   @objc  var jsonProperties:Array<String> {
        get { return ["user_domain", "device_mac_address", "device_name", "device_title", "ip", "local_ip", "last_update", "services"] }
    }

    @objc func valueForKey(key: String!) -> AnyObject! {
        switch key {
        case "user_domain":
            return self.user_domain
        case "device_mac_address":
            return self.device_mac_address
        case "device_name":
            return self.device_name
        case "device_title":
            return self.device_title
        case "ip":
            return self.ip
        case "local_ip":
            return self.local_ip
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
        self.active = json.valueForKey("active") as! Bool
        self.email = json.valueForKey("email") as! String
        
        let itemsJson = json.objectForKey("domains") as! NSArray?
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

    @objc func valueForKey(key: String!) -> AnyObject! {
        switch key {
        case "active":
            return self.active
        case "email":
            return self.email
        case "domains":
            return self.domains
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
        self.name = json.valueForKey("name") as! String
        self.title = json.valueForKey("title") as! String
        self.mac_address = json.valueForKey("mac_address") as! String
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