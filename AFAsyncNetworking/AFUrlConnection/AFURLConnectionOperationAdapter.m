#import "AFURLConnectionOperationAdapter.h"


#import "AFAsyncError.h"
#import "AFCompletionInfo.h"
#import "AFAsyncNetworkingBlocks.h"
#import "AFUrlConnectionProgressInfo.h"


@implementation AFURLConnectionOperationAdapter
{
   JFFAsyncOperationInterfaceCancelHandler _cancelBlock;
}


-(instancetype)init
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(instancetype)initWithAFURLConnectionOperation:( AFHTTPRequestOperation* )afOperation
{
   self = [ super init ];
   if ( nil == self )
   {
      return nil;
   }
   
   self->_afOperation = afOperation;
   
   return self;
}

#pragma mark -
#pragma mark JFFAsyncOperationInterface
-(void)initializeWithResultHandler:( JFFAsyncOperationInterfaceResultHandler )handler
                     cancelHandler:( JFFAsyncOperationInterfaceCancelHandler )cancelHandler
                   progressHandler:( JFFAsyncOperationInterfaceProgressHandler )progress
{
   self->_cancelBlock = [ cancelHandler copy ];
   
   AFProgressBlock downloadProgress =
      [ self hookProgressBlock: self->_afOperation.downloadProgress
          withExternalCallback: progress ];
   [ self->_afOperation setDownloadProgressBlock: downloadProgress ];

   AFProgressBlock uploadProgress =
      [ self hookProgressBlock: self->_afOperation.uploadProgress
          withExternalCallback: progress ];
   [ self->_afOperation setUploadProgressBlock: uploadProgress ];
   
   
   AFSuccessfulCompletionBlock onSuccess =
      [ self hookSuccessfulCompletion: self->_afOperation.onSuccess
                 withExternalCallback: handler ];
   AFUnsuccessfulCompletionBlock onError =
      [ self hookUnsuccessfulCompletion: self->_afOperation.onError
                   withExternalCallback: handler ];
   
   [ self->_afOperation setCompletionBlockWithSuccess: onSuccess
                                              failure: onError ];
}

-(void)asyncOperationWithResultHandler:( JFFAsyncOperationInterfaceResultHandler )handler
                         cancelHandler:( JFFAsyncOperationInterfaceCancelHandler )cancelHandler
                       progressHandler:( JFFAsyncOperationInterfaceProgressHandler )progress
{
   [ self initializeWithResultHandler: handler
                        cancelHandler: cancelHandler
                      progressHandler: progress ];
   
   [ self->_afOperation start ];
}

-(void)cancel:( BOOL )canceled
{
   if ( canceled )
   {
      [ self->_afOperation cancel ];
   }
   
   if ( nil != self->_cancelBlock )
   {
      self->_cancelBlock( canceled );
   }
}

#pragma mark -
#pragma mark AFBlockHooks
-(AFProgressBlock)hookProgressBlock:( AFProgressBlock )originalProgress
               withExternalCallback:( JFFAsyncOperationInterfaceProgressHandler )progress
{
   originalProgress = [ originalProgress copy ];
   progress = [ progress copy ];
   
   AFProgressBlock result = ^void(
      NSUInteger bytesWritten,
      long long totalBytesWritten,
      long long totalBytesExpectedToWrite )
   {
      if ( nil != originalProgress )
      {
         originalProgress( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
      }
      
      if ( nil != progress )
      {
         AFUrlConnectionProgressInfo* blockResult = [ AFUrlConnectionProgressInfo new ];
         {
            blockResult.bytesWritten              = bytesWritten             ;
            blockResult.totalBytesWritten         = totalBytesWritten        ;
            blockResult.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
         }
         progress( blockResult );
      }
   };
   
   return [ result copy ];
}

-(AFSuccessfulCompletionBlock)hookSuccessfulCompletion:( AFSuccessfulCompletionBlock )originalSuccess
                                  withExternalCallback:( AFAsyncCompletionCallbackBlock )completion
{
   originalSuccess = [ originalSuccess copy ];
   completion = [ completion copy ];
   
   AFSuccessfulCompletionBlock result = ^void(AFHTTPRequestOperation *operation, id responseObject)
   {
      if ( nil != originalSuccess )
      {
         originalSuccess( operation, responseObject );
      }
      
      if ( nil != completion )
      {
         AFCompletionInfo* blockResult = [ AFCompletionInfo new ];
         {
            blockResult.operation      = operation     ;
            blockResult.responseObject = responseObject;
         }
         completion( blockResult, nil );
      }
   };
   
   return [ result copy ];
}

-(AFUnsuccessfulCompletionBlock)hookUnsuccessfulCompletion:( AFUnsuccessfulCompletionBlock )originalFailure
                                  withExternalCallback:( AFAsyncCompletionCallbackBlock )completion
{
   originalFailure = [ originalFailure copy ];
   completion = [ completion copy ];
   
   
   AFUnsuccessfulCompletionBlock result = ^void(AFHTTPRequestOperation *operation, NSError* error)
   {
      if ( nil != originalFailure )
      {
         originalFailure( operation, error );
      }
      
      if ( nil != completion )
      {
         NSString* domain = [ AFAsyncErrorConstants urlConnectionErrorDomain ];
         AFAsyncError* blockError = [ [ AFAsyncError alloc ] initWithDomain: domain
                                                                       code: 1
                                                                   userInfo: nil ];
         blockError.errorFromAFNetworking = error;
         blockError.operation = operation;
         
         completion( nil, blockError );
      }
   };
   
   return [ result copy ];
}

@end
