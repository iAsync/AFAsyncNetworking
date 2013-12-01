#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@class AFHTTPSessionManager;

@interface AFAsyncOperationFactory : NSObject

+(JFFAsyncOperation)asyncOperationFromAFHTTPRequestOperation:( AFHTTPRequestOperation* )afOperation;

+(JFFAsyncOperation)asyncDataTaskOperationFromRequest:( NSURLRequest*) request
                                           andSession:( AFHTTPSessionManager* )sessionManager;

@end
