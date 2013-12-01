#import "AFAsyncOperationFactory.h"


#import "AFAbstractTaskAdapter.h"
#import "AFURLConnectionOperationAdapter.h"

@implementation AFAsyncOperationFactory

+(JFFAsyncOperation)asyncOperationFromAFHTTPRequestOperation:( AFHTTPRequestOperation* )afOperation
{
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      AFURLConnectionOperationAdapter* result = [ [ AFURLConnectionOperationAdapter alloc ] initWithAFURLConnectionOperation: afOperation ];
      return result;
   };
   
   return buildAsyncOperationWithAdapterFactory( factory );
}

+(JFFAsyncOperation)asyncDataTaskOperationFromRequest:( NSURLRequest*) request
                                           andSession:( AFHTTPSessionManager* )sessionManager
{
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      AFAbstractTaskAdapter* adapter =
         [ [ AFAbstractTaskAdapter alloc ] initWithRequest: request
                                      AFHTTPSessionManager: sessionManager ];
      return adapter;
   };

   return buildAsyncOperationWithAdapterFactory( factory );
}

@end
