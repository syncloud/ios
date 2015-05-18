import Foundation

func nullToNil(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}

class Service {
    var local_port: Int
    var name: String
    var port: Int
    var protocol_: String
    var type: String
    var url: String?
    
    init(json: NSDictionary) {
        self.local_port = json.valueForKey("local_port") as! Int
        self.name = json.valueForKey("name") as! String
        self.port = json.valueForKey("port") as! Int
        self.protocol_ = json.valueForKey("protocol") as! String
        self.type = json.valueForKey("type") as! String
        self.url = nullToNil(json.valueForKey("url")) as! String?
    }
}

extension Service: Serializable {
    @objc var jsonProperties:Array<String> {
        get { return ["local_port", "name", "port", "protocol", "type", "url"] }
    }

    @objc func valueForKey(key: String!) -> AnyObject! {
        switch key {
        case "local_port":
            return self.local_port
        case "name":
            return self.name
        case "port":
            return self.port
        case "protocol":
            return self.protocol_
        case "type":
            return self.type
        case "url":
            return self.url
        default:
            return NSNull()
        }
    }
}

class Domain {
    var user_domain: String
    var device_mac_address: String
    var device_name: String
    var device_title: String
    var ip: String
    var local_ip: String
    var last_update: String
    var services = [Service]()
    
    init(json: NSDictionary) {
        self.user_domain = json.valueForKey("user_domain") as! String
        self.device_mac_address = json.valueForKey("device_mac_address") as! String
        self.device_name = json.valueForKey("device_name") as! String
        self.device_title = json.valueForKey("device_title") as! String
        self.ip = json.valueForKey("ip") as! String
        self.local_ip = json.valueForKey("local_ip") as! String
        self.last_update = json.valueForKey("last_update") as! String
        
        var itemsJson = json.objectForKey("services") as! NSArray?
        if let theItemsJson = itemsJson {
            for item in theItemsJson {
                var itemJson = item as! NSDictionary
                self.services.append(Service(json: itemJson))
            }
        }

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
        case "last_update":
            return self.last_update
        case "services":
            return self.services
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
        
        var itemsJson = json.objectForKey("domains") as! NSArray?
        if let theItemsJson = itemsJson {
            for item in theItemsJson {
                var itemJson = item as! NSDictionary
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

class Credentials {
    var login: String
    var password: String?
    var key: String?
    
    init(login: String, password: String?, key: String?) {
        self.login = login
        self.password = password
        self.key = key
    }
}

class ConnectionPoint {
    var endpoint: Endpoint
    var credentials: Credentials
    
    init(endpoint: Endpoint, credentials: Credentials) {
        self.endpoint = endpoint
        self.credentials = credentials
    }
}

class Identification {
    var name: String
    var title: String
    var mac_address: String
    
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