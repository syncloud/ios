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
    
    private static func toString(value: CFStringRef) -> String {
        return (value as String) ?? ""
    }
}

public class Keychain {
    
    public class func set(key: String, value: String) -> Bool {
        if let data = value.dataUsingEncoding(NSUTF8StringEncoding) {
            return set(key, value: data)
        }
        
        return false
    }
    
    public class func set(key: String, value: NSData) -> Bool {
        let query = [
            KeychainConstants.klass       : KeychainConstants.classGenericPassword,
            KeychainConstants.attrAccount : key,
            KeychainConstants.valueData   : value ]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        return status == noErr
    }
    
    public class func get(key: String) -> String? {
        if let data = getData(key),
            let currentString = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                
                return currentString
        }
        
        return nil
    }
    
    public class func getData(key: String) -> NSData? {
        let query = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : key,
            KeychainConstants.returnData  : kCFBooleanTrue,
            KeychainConstants.matchLimit  : kSecMatchLimitOne ]
        
        var result: AnyObject?
        
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }
        
        if status == noErr { return result as? NSData }
        
        return nil
    }
    
    public class func delete(key: String) -> Bool {
        let query = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : key ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
    public class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
}