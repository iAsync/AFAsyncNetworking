#import "AFAsyncOperationFactory.h"


#import "AFDataTaskAdapter.h"
#import "AFUploadTaskAdapter.h"
#import "AFDownloadTaskAdapter.h"


#import "AFURLConnectionOperationAdapter.h"

@implementation AFAsyncOperationFactory


#pragma mark -
#pragma mark NSUrlConnection based
+(JFFAsyncOperation)asyncOperationFromAFHTTPRequestOperation:( AFHTTPRequestOperation* )afOperation
{
   NSParameterAssert( nil != afOperation );
   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      AFURLConnectionOperationAdapter* result = [ [ AFURLConnectionOperationAdapter alloc ] initWithAFURLConnectionOperation: afOperation ];
      return result;
   };
   
   return buildAsyncOperationWithAdapterFactory( factory );
}


#pragma mark -
#pragma mark DataTask
+(JFFAsyncOperation)asyncDataTaskOperationFromRequest:( NSURLRequest*) request
                                           andSession:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != request );
   NSParameterAssert( nil != sessionManager );
   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      AFDataTaskAdapter* adapter =
      [ [ AFDataTaskAdapter alloc ] initWithRequest: request
                               AFHTTPSessionManager: sessionManager ];
      return adapter;
   };

   return buildAsyncOperationWithAdapterFactory( factory );
}



#pragma mark -
#pragma mark DownloadTask
+(JFFAsyncOperation)asyncDownloadTaskOperationFromRequest:( NSURLRequest*) request
                                      andSession:( AFHTTPSessionManager* )sessionManager
                   usingOptionalTmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder
{
   NSParameterAssert( nil != request );
   NSParameterAssert( nil != sessionManager );
   NSParameterAssert( nil != tmpFileNameBuilder );
   
   tmpFileNameBuilder = [ tmpFileNameBuilder copy ];
   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      AFDownloadTaskAdapter* adapter =
      [ [ AFDownloadTaskAdapter alloc ] initWithRequest: request
                                   AFHTTPSessionManager: sessionManager
                                       tmpFileNameBlock: tmpFileNameBuilder ];
      return adapter;
   };
   
   return buildAsyncOperationWithAdapterFactory( factory );
}

+(JFFAsyncOperation)asyncDownloadTaskOperationFromResumeData:( NSData*)resumeData
                                         andSession:( AFHTTPSessionManager* )sessionManager
                      usingOptionalTmpFileNameBlock:( AFTmpFileNameBuilderBlock )tmpFileNameBuilder
{
   NSParameterAssert( nil != resumeData );
   NSParameterAssert( nil != sessionManager );
   NSParameterAssert( nil != tmpFileNameBuilder );
   
   tmpFileNameBuilder = [ tmpFileNameBuilder copy ];
   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      AFDownloadTaskAdapter* adapter =
      [ [ AFDownloadTaskAdapter alloc ] initWithResumeData: resumeData
                                      AFHTTPSessionManager: sessionManager
                                          tmpFileNameBlock: tmpFileNameBuilder ];
      
      return adapter;
   };

   return buildAsyncOperationWithAdapterFactory( factory );
}


#pragma mark -
#pragma mark UploadTask
+(JFFAsyncOperation)asyncUploadTaskOperationWithFile:( NSURL* )urlOfFileWithUploadData
                                             request:( NSURLRequest* )request
                                             session:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != urlOfFileWithUploadData );
   NSParameterAssert( nil != request );
   NSParameterAssert( nil != sessionManager );
   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {

      AFUploadTaskAdapter* adapter =
      [ [ AFUploadTaskAdapter alloc ] initWithRequest: request
                            urlOfFileWithDataToUpload: urlOfFileWithUploadData
                                 AFHTTPSessionManager: sessionManager ];

      return adapter;
   };
   
   return buildAsyncOperationWithAdapterFactory( factory );
}

+(JFFAsyncOperation)asyncUploadTaskOperationWithData:( NSData* )uploadData
                                             request:( NSURLRequest* )request
                                             session:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != uploadData );
   NSParameterAssert( nil != request );
   NSParameterAssert( nil != sessionManager );

   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      
      AFUploadTaskAdapter* adapter =
      [ [ AFUploadTaskAdapter alloc ] initWithRequest: request
                                         dataToUpload: uploadData
                                 AFHTTPSessionManager: sessionManager ];
      
      return adapter;
   };
   
   return buildAsyncOperationWithAdapterFactory( factory );
}

+(JFFAsyncOperation)asyncUploadTaskOperationWithStreamedRequest:( NSURLRequest* )request
                                                        session:( AFHTTPSessionManager* )sessionManager
{
   NSParameterAssert( nil != request );
   NSParameterAssert( nil != sessionManager );

   
   JFFAsyncOperationInstanceBuilder factory = ^id<JFFAsyncOperationInterface>
   {
      
      AFUploadTaskAdapter* adapter =
      [ [ AFUploadTaskAdapter alloc ] initWithStreamedRequest: request
                                         AFHTTPSessionManager: sessionManager ];
      
      return adapter;
   };
   
   return buildAsyncOperationWithAdapterFactory( factory );
}

@end
