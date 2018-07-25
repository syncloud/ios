import Foundation

private var _uncaughtExceptionHandler: UncaughtExceptionHandler?

open class StaticHolder: NSObject {
    
    open class var uncaughtExceptionHandler : UncaughtExceptionHandler? {
        return _uncaughtExceptionHandler
    }

    open class func getUncaughtExceptionHandler() -> UncaughtExceptionHandler {
        return _uncaughtExceptionHandler!
    }
    
    
    open class func setUncaughtExceptionHandler(_ handler: UncaughtExceptionHandler) {
        return _uncaughtExceptionHandler = handler
    }
    
}
