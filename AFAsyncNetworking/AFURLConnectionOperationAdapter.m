#import "AFURLConnectionOperationAdapter.h"

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
-(void)initializeWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                     cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                   progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   self->_cancelBlock = [ cancelHandler copy ];
   
//   - (void)setUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

//- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;
   
   
   
//   - (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

}

-(void)asyncOperationWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                         cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                       progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   [ self initializeWithResultHandler: handler
                        cancelHandler: cancelHandler
                      progressHandler: progress ];
   
   [ self->_afOperation start ];
}

-(void)cancel:(BOOL)canceled
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
               withExternalCallback:(JFFAsyncOperationInterfaceProgressHandler)progress
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


@end
