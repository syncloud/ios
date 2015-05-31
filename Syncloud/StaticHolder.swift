import Foundation

private var _uncaughtExceptionHandler: UncaughtExceptionHandler?

public class StaticHolder: NSObject {
    
    public class var uncaughtExceptionHandler : UncaughtExceptionHandler? {
        return _uncaughtExceptionHandler
    }

    public class func getUncaughtExceptionHandler() -> UncaughtExceptionHandler {
        return _uncaughtExceptionHandler!
    }
    
    
    public class func setUncaughtExceptionHandler(handler: UncaughtExceptionHandler) {
        return _uncaughtExceptionHandler = handler
    }
    
}
