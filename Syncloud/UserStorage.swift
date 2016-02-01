import Foundation

class UserStorage {
    let cacheFileUrl: NSURL
    
    init() {
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        self.cacheFileUrl = documentDirectoryURL.URLByAppendingPathComponent("user.json")
    }
    
    func load() -> User? {
        do {
            let json = try String(contentsOfURL: self.cacheFileUrl, encoding: NSUTF8StringEncoding)
            let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)
            if let jsonData = jsonData {
                let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                return User(json: jsonDict!)
            }
        } catch {
        }
        return nil
    }
    
    func save(user: User) {
        let json = Serialize.toJSON(user)
        do {
            try json!.writeToURL(self.cacheFileUrl, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {}
    }
    
    func erase() {
        let manager = NSFileManager.defaultManager()
        do {
            try manager.removeItemAtURL(self.cacheFileUrl)
        } catch {}
    }
}
