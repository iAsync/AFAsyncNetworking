#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@interface AFAbstractTaskAdapter : NSObject< JFFAsyncOperationInterface >

-(instancetype)initWithAFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager;

@property ( nonatomic, readonly ) AFHTTPSessionManager* sessionManager;
@property ( nonatomic, readonly ) NSURLSessionTask    * task          ;

@end
