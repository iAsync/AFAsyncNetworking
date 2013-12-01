#import "AFDownloadTaskAdapter.h"

#import "AFSessionCallbackBuilder.h"

@interface AFDownloadTaskAdapter()<AFAbstractTaskAdapterSubclassing>
@end

@implementation AFDownloadTaskAdapter
{
   AFTmpFileNameBuilderBlock _tmpFileNameBuilder;
   NSProgress* _downloadProgress;
}

-(instancetype)initWithRequest:( NSURLRequest *)request
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
              tmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder
{
   self = [ super initWithRequest: request
             AFHTTPSessionManager: sessionManager ];
   if ( nil == self )
   {
      return nil;
   }

   self->_tmpFileNameBuilder = [ tmpFileNameBuilder copy ];
   
   return self;
}

-(NSURLSessionTask*)createTaskWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                                  cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                                progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   AFDataTaskCompletionBlock afCompletion = [ AFSessionCallbackBuilder afCompletionBlockWithAsyncCallback: handler ];
   
   NSProgress* afProgress = nil;
   
   NSURLSessionTask* result =
   [ self.sessionManager downloadTaskWithRequest: self.request
                                        progress: &afProgress
                                     destination: self->_tmpFileNameBuilder
                               completionHandler: afCompletion ];
   self->_downloadProgress = afProgress;

   [ self observeProgress: afProgress
              notifyBlock: [ progress copy ] ];
   
   return result;
}

-(void)observeProgress:( NSProgress* )afProgress
           notifyBlock:(JFFAsyncOperationInterfaceProgressHandler)progressBlock
{
   NSAssert( NO, @"not implemented" );
}

@end
