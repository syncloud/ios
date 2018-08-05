import UIKit
import Security

import Foundation
import Security

struct KeychainConstants {
    static var klass: String { return toString(kSecClass) }
    static var classGenericPassword: String { return toString(kSecClassGenericPassword) }
    static var attrAccount: String { return toString(kSecAttrAccount) }
    static var valueData: String { return toString(kSecValueData) }
    static var returnData: String { return toString(kSecReturnData) }
    static var matchLimit: String { return toString(kSecMatchLimit) }
    
    fileprivate static func toString(_ value: CFString) -> String {
        return (value as String) ?? ""
    }
}

open class Keychain {
    
    open class func set(_ key: String, value: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return set(key, value: data)
        }
        
        return false
    }
    
    open class func set(_ key: String, value: Data) -> Bool {
        let query = [
            KeychainConstants.klass       : KeychainConstants.classGenericPassword,
            KeychainConstants.attrAccount : key,
            KeychainConstants.valueData   : value ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        return status == noErr
    }
    
    open class func get(_ key: String) -> String? {
        if let data = getData(key),
            let currentString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                
                return currentString
        }
        
        return nil
    }
    
    open class func getData(_ key: String) -> Data? {
        let query = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : key,
            KeychainConstants.returnData  : kCFBooleanTrue,
            KeychainConstants.matchLimit  : kSecMatchLimitOne ] as [String : Any]
        
        var result: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if status == noErr { return result as? Data }
        
        return nil
    }
    
    open class func delete(_ key: String) -> Bool {
        let query = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : key ] as [String : Any]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
    open class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
}
