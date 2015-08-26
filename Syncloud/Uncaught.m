#import <Foundation/Foundation.h>

#import "Uncaught.h"
#import "Syncloud-Swift.h"

volatile void exceptionHandler(NSException *exception) {
    [[StaticHolder uncaughtExceptionHandler] handle:exception];
}

NSUncaughtExceptionHandler* exceptionHandlerPtr = (NSUncaughtExceptionHandler*)&exceptionHandler;