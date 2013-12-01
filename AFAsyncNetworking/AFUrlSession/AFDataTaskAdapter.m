#import "AFDataTaskAdapter.h"

#import "AFDataTaskError.h"
#import "AFDataTaskCompletionInfo.h"

@interface AFDataTaskAdapter()<AFAbstractTaskAdapterSubclassing>
@end


@implementation AFDataTaskAdapter

-(NSURLSessionTask*)createTaskWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                                  cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                                progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   handler = [ handler copy ];
   
   
   AFDataTaskCompletionBlock afCompletion = ^void( NSURLResponse *response, id responseObject, NSError *error )
   {
      if ( nil != handler )
      {
         if ( nil != responseObject )
         {
            AFDataTaskCompletionInfo* blockResult = [ AFDataTaskCompletionInfo new ];
            {
               blockResult.responseObject = responseObject;
               blockResult.response = response;
            }
            handler( blockResult, nil );
         }
         else
         {
            NSString* domain = [ AFAsyncErrorConstants urlSessionErrorDomain ];
            
            AFDataTaskError* blockError =
            [ [ AFDataTaskError alloc ] initWithDomain: domain
                                                  code: 1
                                              userInfo: nil ];
            blockError.errorFromAFNetworking = error;
            blockError.response = response;
            
            handler( nil, blockError );
         }
      }
   };

   return [ self.sessionManager dataTaskWithRequest: self.request
                                  completionHandler: [ afCompletion copy ] ];
}

@end
