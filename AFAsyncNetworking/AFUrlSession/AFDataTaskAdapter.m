#import "AFDataTaskAdapter.h"

#import "AFSessionCallbackBuilder.h"

@interface AFDataTaskAdapter()<AFAbstractTaskAdapterSubclassing>
@end


@implementation AFDataTaskAdapter



-(NSURLSessionTask*)createTaskWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                                  cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                                progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   AFDataTaskCompletionBlock afCompletion = [ AFSessionCallbackBuilder afCompletionBlockWithAsyncCallback: handler ];
   
   
   return [ self.sessionManager dataTaskWithRequest: self.request
                                  completionHandler: [ afCompletion copy ] ];
}

@end
