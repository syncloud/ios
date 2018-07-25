import Foundation

class StorageKeys {
    static var Email = "email"
    static var Password = "password"
    static var MainDomain = "mainDomain"
}

open class Storage {
    
    open class func getCredentials() -> (email: String?, password: String?) {
        let email = Keychain.get(StorageKeys.Email)
        let password = Keychain.get(StorageKeys.Password)
        return (email: email, password: password)
    }

    open class func hasCredentials() -> Bool {
        let (email, _) = getCredentials()
        return email != nil
    }

    open class func saveCredentials(email: String, password: String) {
        Keychain.set(StorageKeys.Email, value: email)
        Keychain.set(StorageKeys.Password, value: password)
    }
    
    open class func deleteCredentials() {
        Keychain.delete(StorageKeys.Email)
        Keychain.delete(StorageKeys.Password)
    }

    open class func getMainDomain() -> String {
        let defaults = UserDefaults.standard
        if let mainDomain = defaults.string(forKey: StorageKeys.MainDomain) {
            return mainDomain
        }
        return "syncloud.it"
    }

    open class func setMainDomain(_ mainDomain: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(mainDomain, forKey: StorageKeys.MainDomain)
    }
}
