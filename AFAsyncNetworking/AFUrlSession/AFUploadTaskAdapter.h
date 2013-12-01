#import "AFAbstractTaskAdapter.h"

@class AFHTTPSessionManager;

@interface AFUploadTaskAdapter : AFAbstractTaskAdapter

-(instancetype)initWithRequest:( NSURLRequest* )request
     urlOfFileWithDataToUpload:( NSURL* )url
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager;

-(instancetype)initWithRequest:( NSURLRequest* )request
                  dataToUpload:( NSData* )data
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager;

-(instancetype)initWithStreamedRequest:( NSURLRequest* )request
                  AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager;

@end
