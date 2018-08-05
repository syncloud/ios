import Foundation

open class Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

open class ResultError: Error {
    var result: BaseResult

    init(_ message: String, result: BaseResult) {
        self.result = result
        super.init(message)
    }
}
