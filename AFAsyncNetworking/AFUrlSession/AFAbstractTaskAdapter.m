#import "AFAbstractTaskAdapter.h"


@interface AFAbstractTaskAdapter()<AFAbstractTaskAdapterSubclassing, AFTaskWithProgress>
@end


@implementation AFAbstractTaskAdapter
{
   JFFAsyncOperationInterfaceCancelHandler _cancelCallback;
}


-(instancetype)initWithRequest:( NSURLRequest *)request
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != request        );
   NSParameterAssert( nil != sessionManager );
   
   self = [ super init ];
   if ( nil == self )
   {
      return nil;
   }
   
   self->_sessionManager = sessionManager;
   self->_request        = request       ;
   
   return self;
}


#pragma mark -
#pragma mark JFFAsyncOperationInterface
-(void)asyncOperationWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                          cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                        progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   self->_cancelCallback = cancelHandler;
   self->_task = [ self createTaskWithResultHandler: handler
                                      cancelHandler: cancelHandler
                                    progressHandler: progress ];
   [ self->_task resume ];
}


-(void)cancel:(BOOL)canceled
{
   if ( nil != self->_cancelCallback )
   {
      self->_cancelCallback( canceled );
   }

   if ( canceled )
   {
      [ self->_task cancel ];
   }
}

#pragma mark -
#pragma mark AFAbstractTaskAdapterSubclassing
-(NSURLSessionTask*)createTaskWithResultHandler:(JFFAsyncOperationInterfaceResultHandler)handler
                                  cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                                progressHandler:(JFFAsyncOperationInterfaceProgressHandler)progress
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)observeProgress:( NSProgress* )afProgress
           notifyBlock:( JFFAsyncOperationInterfaceProgressHandler )progressBlock
{
   [ self doesNotRecognizeSelector: _cmd ];
}

@end
