import Foundation

typealias JsonResult = (result: NSDictionary?, error: AppError?)

func parseJsonResult(_ data: Data?) -> JsonResult {
    if data == nil {
        return (result: nil, error: AppError("There's no JSON"))
    }
    
    var jsonResult: NSDictionary? = nil
    
    do {
        jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
    } catch {
        let message = "Parsing JSON caused a error"
        NSLog(message)
        return (result: nil, error: AppError(message))
    }
    
    if let theJsonResult = jsonResult {
        let baseResult = BaseResult(json: theJsonResult)
        if baseResult.success {
            return (result: jsonResult, error: nil)
        } else {
            let message = "Returned JSON indicates error"
            NSLog(message)
            return (result: nil, error: ResultError(message, result: baseResult))
        }
    }
    
    return (result: nil, error: AppError("Unable to parse JSON"))
}


class ParameterMessages {
    var parameter: String
    var messages = [String]()
    
    init(json: NSDictionary) {
        self.parameter = json.value(forKey: "parameter") as! String
        
        let itemsJson = json.object(forKey: "messages") as! NSArray?
        if let theItemsJson = itemsJson {
            for item in theItemsJson {
                let itemString = item as! String
                self.messages.append(itemString)
            }
        }
    }
}

class BaseResult {
    var success: Bool
    var message: String?
    var parameters_messages: [ParameterMessages]?
    
    init(json: NSDictionary) {
        self.success = json.value(forKey: "success") as! Bool
        self.message = json.value(forKey: "message") as? String
        
        let itemsJson = json.object(forKey: "parameters_messages") as! NSArray?
        if let theItemsJson = itemsJson {
            self.parameters_messages = [ParameterMessages]()
            for item in theItemsJson {
                let itemJson = item as! NSDictionary
                self.parameters_messages!.append(ParameterMessages(json: itemJson))
            }
        }
        
    }
}
