#import "AFAsyncOperationFactory.h"

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

@end
