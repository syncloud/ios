import Foundation

typealias JsonResult = (result: NSDictionary?, error: Error?)

func parseJsonResult(data: NSData?) -> JsonResult {
    if data == nil {
        return (result: nil, error: Error("There's no JSON"))
    }
    
    var error: NSErrorPointer = nil
    var jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: error) as? NSDictionary
    
    if error != nil {
        return (result: nil, error: Error("Parsing JSON caused a error"))
    }
    
    if let theJsonResult = jsonResult {
        var baseResult = BaseResult(json: theJsonResult)
        if baseResult.success {
            return (result: jsonResult, error: nil)
        } else {
            return (result: nil, error: ResultError("Returned JSON indicates error", result: baseResult))
        }
    }
    
    return (result: nil, error: Error("Unable to parse JSON"))
}


class ParameterMessages {
    var parameter: String
    var messages = [String]()
    
    init(json: NSDictionary) {
        self.parameter = json.valueForKey("parameter") as! String
        
        var itemsJson = json.objectForKey("messages") as! NSArray?
        if let theItemsJson = itemsJson {
            for item in theItemsJson {
                var itemString = item as! String
                self.messages.append(itemString)
            }
        }
    }
}

class BaseResult {
    var success: Bool
    var message: String
    var parameters_messages: [ParameterMessages]?
    
    init(json: NSDictionary) {
        self.success = json.valueForKey("success") as! Bool
        self.message = json.valueForKey("message") as! String
        
        var itemsJson = json.objectForKey("parameters_messages") as! NSArray?
        if let theItemsJson = itemsJson {
            self.parameters_messages = [ParameterMessages]()
            for item in theItemsJson {
                var itemJson = item as! NSDictionary
                self.parameters_messages!.append(ParameterMessages(json: itemJson))
            }
        }
        
    }
}