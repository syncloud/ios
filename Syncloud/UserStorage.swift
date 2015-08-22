import Foundation

class UserStorage {
    let cacheFileUrl: NSURL
    
    init() {
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        self.cacheFileUrl = documentDirectoryURL.URLByAppendingPathComponent("user.json")
    }
    
    func load() -> User? {
        var error: NSErrorPointer = nil
        let json = String(contentsOfURL: self.cacheFileUrl, encoding: NSUTF8StringEncoding, error: error)
        if let json = json {
            let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)
            if let jsonData = jsonData {
                var jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: error) as? NSDictionary
                if let jsonDict = jsonDict {
                    return User(json: jsonDict)
                }
            }
        }
        return nil
    }
    
    func save(user: User) {
        let json = Serialize.toJSON(user)
        json!.writeToURL(self.cacheFileUrl, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    func erase() {
        var manager = NSFileManager.defaultManager()
        manager.removeItemAtURL(self.cacheFileUrl, error: nil)
    }
}
