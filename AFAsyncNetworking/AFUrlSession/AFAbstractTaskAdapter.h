#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@interface AFAbstractTaskAdapter : NSObject< JFFAsyncOperationInterface >

-(instancetype)initWithRequest:( NSURLRequest *)request
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager;

@property ( nonatomic, readonly ) NSURLRequest        * request       ;
@property ( nonatomic, readonly ) AFHTTPSessionManager* sessionManager;
@property ( nonatomic, readonly ) NSURLSessionTask    * task          ;

@end
