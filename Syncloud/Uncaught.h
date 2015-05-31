#ifndef Syncloud_Uncaught_h
#define Syncloud_Uncaught_h

volatile void exceptionHandler(NSException *exception);
extern NSUncaughtExceptionHandler *exceptionHandlerPtr;

#endif
