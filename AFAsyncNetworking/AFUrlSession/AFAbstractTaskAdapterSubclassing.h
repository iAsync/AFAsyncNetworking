#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class NSURLSessionTask;

@protocol AFAbstractTaskAdapterSubclassing <NSObject>

-(NSURLSessionTask*)createTaskWithResultHandler:( JFFAsyncOperationInterfaceResultHandler   )handler
                                  cancelHandler:( JFFAsyncOperationInterfaceCancelHandler   )cancelHandler
                                progressHandler:( JFFAsyncOperationInterfaceProgressHandler )progress;

@end
