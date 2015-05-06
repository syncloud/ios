import Foundation

public class Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

public class ResultError: Error {
    var result: BaseResult

    init(_ message: String, result: BaseResult) {
        self.result = result
        super.init(message)
    }
}
