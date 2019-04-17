import Foundation

@objc
protocol Serializable {
    var jsonProperties:Array<String> { get }
    func valueForKey(_ key: String!) -> AnyObject!
}

struct Serialize {
    static func toDictionary(_ obj:Serializable) -> NSDictionary {
        // make dictionary
        var dict = Dictionary<String, AnyObject>()

        // add values
        for prop in obj.jsonProperties {
            let val: AnyObject! = obj.valueForKey(prop)

            if (val is String)
            {
                dict[prop] = val as! String as AnyObject
            }
            else if (val is Int)
            {
                dict[prop] = val as! Int as AnyObject
            }
            else if (val is Double)
            {
                dict[prop] = val as! Double as AnyObject
            }
            else if (val is Array<String>)
            {
                dict[prop] = val as! Array<String> as AnyObject
            }
            else if (val is Serializable)
            {
                dict[prop] = toJSON(val as! Serializable) as AnyObject
            }
            else if (val is Array<Serializable>)
            {
                var arr = Array<NSDictionary>()

                for item in (val as! Array<Serializable>) {
                    arr.append(toDictionary(item))
                }

                dict[prop] = arr as AnyObject
            }

        }

        // return dict
        return dict as NSDictionary
    }

    static func toJSON(_ obj: Serializable) -> String? {
        // get dict
        let dict = toDictionary(obj)

        // make JSON
        let data = try! JSONSerialization.data(withJSONObject: dict, options:JSONSerialization.WritingOptions())

        // return result
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
    }
    
    static func toJSON(_ dictionary: NSDictionary) -> String? {
        // make JSON
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options:JSONSerialization.WritingOptions())
        
        // return result
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
    }
    
}

