#import "AFUploadTaskAdapter.h"

#import "AFSessionCallbackBuilder.h"

@interface AFUploadTaskAdapter()<AFAbstractTaskAdapterSubclassing>
@end


@implementation AFUploadTaskAdapter
{
   NSProgress* _uploadProgress;
   
   NSURL * _urlOfFileWithDataToUpload;
   NSData* _dataToUpload             ;
}

#pragma mark -
#pragma mark Forbidden constructors
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

#pragma mark -
#pragma mark Allowed constructors
-(instancetype)initWithRequest:( NSURLRequest* )request
     urlOfFileWithDataToUpload:( NSURL* )url
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != request        );
   NSParameterAssert( nil != sessionManager );
   NSParameterAssert( nil != url            );

   
   self = [ super initWithRequest: request
             AFHTTPSessionManager: sessionManager ];
   if ( nil == self )
   {
      return nil;
   }
   
   self->_urlOfFileWithDataToUpload = url;
   
   return self;
}

-(instancetype)initWithRequest:( NSURLRequest* )request
                  dataToUpload:( NSData* )data
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != request        );
   NSParameterAssert( nil != sessionManager );
   NSParameterAssert( nil != data           );
   
   self = [ super initWithRequest: request
             AFHTTPSessionManager: sessionManager ];
   if ( nil == self )
   {
      return nil;
   }
   
   self->_dataToUpload = data;
   
   return self;
}

-(instancetype)initWithStreamedRequest:( NSURLRequest* )request
                  AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager;
{
   NSParameterAssert( nil != request        );
   NSParameterAssert( nil != sessionManager );
   
   self = [ super initWithRequest: request
             AFHTTPSessionManager: sessionManager ];

   return self;
}

#pragma mark -
#pragma mark AFAbstractTaskAdapterSubclassing
-(NSURLSessionTask*)createTaskWithResultHandler:( JFFAsyncOperationInterfaceResultHandler )handler
                                  cancelHandler:( JFFAsyncOperationInterfaceCancelHandler )cancelHandler
                                progressHandler:( JFFAsyncOperationInterfaceProgressHandler )progress
{
   NSProgress* uploadProgress = nil;
   
   AFDataTaskCompletionBlock afCompletion = [ AFSessionCallbackBuilder afCompletionBlockWithAsyncCallback: handler ];
   
   NSURLSessionTask* result = nil;
   
   if ( nil != self->_urlOfFileWithDataToUpload )
   {
      result = [ self.sessionManager uploadTaskWithRequest: self.request
                                                  fromFile: self->_urlOfFileWithDataToUpload
                                                  progress: &uploadProgress
                                         completionHandler: afCompletion ];
   }
   else if ( nil != self->_dataToUpload )
   {
      result = [ self.sessionManager uploadTaskWithRequest: self.request
                                                  fromData: self->_dataToUpload
                                                  progress: &uploadProgress
                                         completionHandler: afCompletion ];
   }
   else
   {
      result = [ self.sessionManager uploadTaskWithStreamedRequest: self.request
                                                          progress: &uploadProgress
                                                 completionHandler: afCompletion ];
   }
   
   self->_uploadProgress = uploadProgress;
   
//   [ self observeProgress: uploadProgress
//              notifyBlock: [ progress copy ] ];
   
   return result;
}

-(void)observeProgress:( NSProgress* )afProgress
           notifyBlock:( JFFAsyncOperationInterfaceProgressHandler )progressBlock
{
   NSAssert( NO, @"not implemented" );
}

@end


