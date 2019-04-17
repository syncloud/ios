import Foundation

open class AppError {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

open class ResultError: AppError {
    var result: BaseResult

    init(_ message: String, result: BaseResult) {
        self.result = result
        super.init(message)
    }
}
