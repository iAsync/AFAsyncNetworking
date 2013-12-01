#import "AFAbstractTaskAdapter.h"
#import "AFNetworkingBlocks.h"

@interface AFDownloadTaskAdapter : AFAbstractTaskAdapter

-(instancetype)initWithRequest:( NSURLRequest *)request
          AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
              tmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder;

-(instancetype)initWithResumeData:( NSData* )resumeData
             AFHTTPSessionManager:( AFHTTPSessionManager* )sessionManager
                 tmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder;

@end
