#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface AFURLConnectionOperationAdapter : NSObject< JFFAsyncOperationInterface >

-(instancetype)initWithAFURLConnectionOperation:( AFHTTPRequestOperation* )afOperation;

@property ( nonatomic, readonly ) AFHTTPRequestOperation* afOperation;

@end
