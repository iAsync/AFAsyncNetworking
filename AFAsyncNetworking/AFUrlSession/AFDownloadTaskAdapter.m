#import "AFDownloadTaskAdapter.h"

#import "AFSessionCallbackBuilder.h"

@interface AFDownloadTaskAdapter()<AFAbstractTaskAdapterSubclassing>
@end

@implementation AFDownloadTaskAdapter
{
   AFTmpFileNameBuilderBlock _tmpFileNameBuilder;
   NSProgress* _downloadProgress;
   NSData* _resumeData;
}

-(instancetype)init
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(instancetype)initWithRequest:( NSURLRequest *)request
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(instancetype)initWithRequest:( NSURLRequest *)request
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
              tmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder
{
   NSParameterAssert( nil != request        );
   NSParameterAssert( nil != sessionManager );
   
   self = [ super initWithRequest: request
             AFHTTPSessionManager: sessionManager ];
   if ( nil == self )
   {
      return nil;
   }

   self->_tmpFileNameBuilder = [ tmpFileNameBuilder copy ];
   
   return self;
}

-(instancetype)initWithResumeData:( NSData* )resumeData
             AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
                 tmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder
{
   self = [ super initWithRequest: nil
             AFHTTPSessionManager: sessionManager ];
   if ( nil == self )
   {
      return nil;
   }
   
   self->_tmpFileNameBuilder = [ tmpFileNameBuilder copy ];
   self->_resumeData = resumeData;
   
   return self;
}

-(NSURLSessionTask*)createTaskWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                                  cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                                progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   AFDataTaskCompletionBlock afCompletion = [ AFSessionCallbackBuilder afCompletionBlockWithAsyncCallback: handler ];
   
   NSProgress* afProgress = nil;
   
   NSURLSessionTask* result = nil;
   if ( nil != self->_resumeData )
   {
      result = [ self.sessionManager downloadTaskWithResumeData: self->_resumeData
                                                       progress: &afProgress
                                                    destination: self->_tmpFileNameBuilder
                                              completionHandler: afCompletion ];
   }
   else
   {
      result = [ self.sessionManager downloadTaskWithRequest: self.request
                                                    progress: &afProgress
                                                 destination: self->_tmpFileNameBuilder
                                           completionHandler: afCompletion ];
   }
   
   
   self->_downloadProgress = afProgress;
//   [ self observeProgress: afProgress
//              notifyBlock: [ progress copy ] ];
   
   return result;
}

-(void)observeProgress:( NSProgress* )afProgress
           notifyBlock:( JFFAsyncOperationInterfaceProgressHandler )progressBlock
{
   NSAssert( NO, @"not implemented" );
}

@end
