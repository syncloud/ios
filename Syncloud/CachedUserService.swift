import Foundation

class CachedUserService: IUserService {
    var service: IUserService;
    
    var storage: UserStorage
    
    init(service: IUserService) {
        self.service = service
        self.storage = UserStorage()
    }
    
    func getUser(_ email: String, password: String) -> UserResult {
        let (user, error) = self.service.getUser(email, password: password)
        if user != nil {
            self.storage.save(user!)
        }
        if error != nil {
            if !(error is ResultError) {
                let user = self.storage.load()
                if user != nil && user?.email == email {
                    return (user: user, error: nil)
                }
            } else {
                self.storage.erase()
            }
        }
        return (user: user, error: error)
    }
    
    func createUser(_ email: String, password: String) -> UserResult {
        let (user, error) = self.service.createUser(email, password: password)
        if user != nil {
            self.storage.save(user!)
        }
        return (user: user, error: error)
    }
}
