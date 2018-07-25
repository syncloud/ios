import Foundation

class UserStorage {
    let cacheFileUrl: URL
    
    init() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        self.cacheFileUrl = documentDirectoryURL.appendingPathComponent("user.json")
    }
    
    func load() -> User? {
        do {
            let json = try String(contentsOf: self.cacheFileUrl, encoding: String.Encoding.utf8)
            let jsonData = json.data(using: String.Encoding.utf8)
            if let jsonData = jsonData {
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary
                return User(json: jsonDict!)
            }
        } catch {
        }
        return nil
    }
    
    func save(_ user: User) {
        let json = Serialize.toJSON(user)
        do {
            try json!.write(to: self.cacheFileUrl, atomically: true, encoding: String.Encoding.utf8)
        } catch {}
    }
    
    func erase() {
        let manager = FileManager.default
        do {
            try manager.removeItem(at: self.cacheFileUrl)
        } catch {}
    }
}
