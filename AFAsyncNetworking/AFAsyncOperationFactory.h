#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface AFAsyncOperationFactory : NSObject

+(JFFAsyncOperation)asyncOperationFromAFHTTPRequestOperation:( AFHTTPRequestOperation* )afOperation;

@end
