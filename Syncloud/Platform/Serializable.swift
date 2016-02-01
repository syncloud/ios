import Foundation

@objc
protocol Serializable {
    var jsonProperties:Array<String> { get }
    func valueForKey(key: String!) -> AnyObject!
}

struct Serialize {
    static func toDictionary(obj:Serializable) -> NSDictionary {
        // make dictionary
        var dict = Dictionary<String, AnyObject>()

        // add values
        for prop in obj.jsonProperties {
            let val: AnyObject! = obj.valueForKey(prop)

            if (val is String)
            {
                dict[prop] = val as! String
            }
            else if (val is Int)
            {
                dict[prop] = val as! Int
            }
            else if (val is Double)
            {
                dict[prop] = val as! Double
            }
            else if (val is Array<String>)
            {
                dict[prop] = val as! Array<String>
            }
            else if (val is Serializable)
            {
                dict[prop] = toJSON(val as! Serializable)
            }
            else if (val is Array<Serializable>)
            {
                var arr = Array<NSDictionary>()

                for item in (val as! Array<Serializable>) {
                    arr.append(toDictionary(item))
                }

                dict[prop] = arr
            }

        }

        // return dict
        return dict
    }

    static func toJSON(obj: Serializable) -> String? {
        // get dict
        let dict = toDictionary(obj)

        // make JSON
        let data = try! NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions())

        // return result
        return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
    
    static func toJSON(dictionary: NSDictionary) -> String? {
        // make JSON
        let data = try! NSJSONSerialization.dataWithJSONObject(dictionary, options:NSJSONWritingOptions())
        
        // return result
        return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
    
}