import Foundation

class StorageKeys {
    static var Email = "email"
    static var Password = "password"
}

public class Storage {
    
    public class func getCredentials() -> (email: String?, password: String?) {
        var email = Keychain.get(StorageKeys.Email)
        var password = Keychain.get(StorageKeys.Password)
        return (email: email, password: password)
    }
    
    public class func saveCredentials(# email: String, password: String) {
        Keychain.set(StorageKeys.Email, value: email)
        Keychain.set(StorageKeys.Password, value: password)
    }
}
