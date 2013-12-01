#import <AFAsyncNetworking/AFNetworkingBlocks.h>

#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@class AFHTTPSessionManager;

@interface AFAsyncOperationFactory : NSObject


#pragma mark - 
#pragma mark NSUrlConnection based
+(JFFAsyncOperation)asyncOperationFromAFHTTPRequestOperation:( AFHTTPRequestOperation* )afOperation;


#pragma mark -
#pragma mark DataTask
+(JFFAsyncOperation)asyncDataTaskOperationFromRequest:( NSURLRequest* )request
                                           andSession:( AFHTTPSessionManager* )sessionManager;

#pragma mark -
#pragma mark DownloadTask
+(JFFAsyncOperation)asyncDownloadTaskOperationFromRequest:( NSURLRequest* )request
                                               andSession:( AFHTTPSessionManager* )sessionManager
                            usingOptionalTmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder;

+(JFFAsyncOperation)asyncDownloadTaskOperationFromResumeData:( NSData*)resumeData
                                                  andSession:( AFHTTPSessionManager* )sessionManager
                               usingOptionalTmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder;


#pragma mark -
#pragma mark UploadTask
+(JFFAsyncOperation)asyncUploadTaskOperationWithFile:( NSURL* )urlOfFileWithUploadData
                                             request:( NSURLRequest* )request
                                             session:( AFHTTPSessionManager* )sessionManager;

+(JFFAsyncOperation)asyncUploadTaskOperationWithData:( NSData* )uploadData
                                             request:( NSURLRequest* )request
                                             session:( AFHTTPSessionManager* )sessionManager;

+(JFFAsyncOperation)asyncUploadTaskOperationWithStreamedRequest:( NSURLRequest* )request
                                                        session:( AFHTTPSessionManager* )sessionManager;


@end
