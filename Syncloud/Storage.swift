import Foundation

class StorageKeys {
    static var Email = "email"
    static var Password = "password"
    static var MainDomain = "mainDomain"
}

public class Storage {
    
    public class func getCredentials() -> (email: String?, password: String?) {
        let email = Keychain.get(StorageKeys.Email)
        let password = Keychain.get(StorageKeys.Password)
        return (email: email, password: password)
    }

    public class func hasCredentials() -> Bool {
        let (email, password) = getCredentials()
        return email != nil
    }

    public class func saveCredentials(email  email: String, password: String) {
        Keychain.set(StorageKeys.Email, value: email)
        Keychain.set(StorageKeys.Password, value: password)
    }
    
    public class func deleteCredentials() {
        Keychain.delete(StorageKeys.Email)
        Keychain.delete(StorageKeys.Password)
    }

    public class func getMainDomain() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let mainDomain = defaults.stringForKey(StorageKeys.MainDomain) {
            return mainDomain
        }
        return "syncloud.it"
    }

    public class func setMainDomain(mainDomain: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(mainDomain, forKey: StorageKeys.MainDomain)
    }
}
