@interface DownloadTaskTest : GHAsyncTestCase
@end

@implementation DownloadTaskTest
{
   NSURLRequest              * _request;
   NSData                    * _expectedReadme;
   
   NSURLSessionConfiguration * _config;
   NSOperationQueue          * _mainQueue;
   
   AFHTTPSessionManager      * _afSessionManager;
}

static AFTmpFileNameBuilderBlock NEW_FILE_NAME = ^NSURL*(NSURL *targetPath, NSURLResponse *response)
{
   NSFileManager* fileManager = [ NSFileManager defaultManager ];
   
   NSArray* URLs = [ fileManager URLsForDirectory: NSCachesDirectory
                                        inDomains: NSUserDomainMask ];
   NSURL* cachesDirectory = URLs[0];
   
   
   NSURL* originalURL = targetPath;
   
   NSString* tempFileName = [ originalURL lastPathComponent ];
   NSURL* destinationURL = [ cachesDirectory URLByAppendingPathComponent: tempFileName ];
   
   return destinationURL;
};


-(void)setUp
{
   [ super setUp ];
   
   NSURL* url = [ NSURL URLWithString: @"https://raw.github.com/iAsync/AFAsyncNetworking/master/README.md" ];
   NSURLRequest* request = [ NSURLRequest requestWithURL: url ];
   self->_request = request;
   
   NSString* readmePath = [ [ NSBundle mainBundle ] pathForResource: @"README"
                                                             ofType: @"md" ];
   self->_expectedReadme = [ NSData dataWithContentsOfFile: readmePath ];
   
   
   self->_config = [ NSURLSessionConfiguration defaultSessionConfiguration ];
   self->_mainQueue = [ NSOperationQueue mainQueue ];
   
   self->_afSessionManager = [ AFHTTPSessionManager manager ];
}

-(void)tearDown
{
   self->_request          = nil;
   self->_expectedReadme   = nil;
   self->_config           = nil;
   self->_mainQueue        = nil;
   self->_afSessionManager = nil;
   
   
   [ super tearDown ];
}

-(void)testDownloadedReadmeIsCopiedByAFNetworking
{
   self->_afSessionManager.responseSerializer = [ AFHTTPResponseSerializer serializer ];
   __block AFDataTaskCompletionInfo* received = nil;
   
   __block NSData* receivedReadme = nil;
   __block NSError* error = nil;
   
   SEL testMethod = _cmd;
   [ self prepare: testMethod ];
   
   JFFDidFinishAsyncOperationHandler completionBlock = ^void( AFDataTaskCompletionInfo* blockResult, NSError* blockError )
   {
      error = blockError;
      received = blockResult;
      
      [ self notify: kGHUnitWaitStatusSuccess
        forSelector: testMethod ];
   };
   
   JFFAsyncOperation loader =
   [ AFAsyncOperationFactory asyncDownloadTaskOperationFromRequest: self->_request
                                                        andSession: self->_afSessionManager
                                     usingOptionalTmpFileNameBlock: NEW_FILE_NAME ];
   loader( nil, nil, completionBlock );
   
   
   [ self waitForStatus: kGHUnitWaitStatusSuccess
                timeout: 1000 ];
   GHAssertTrue( [ received isMemberOfClass: [ AFDataTaskCompletionInfo class ] ], @"data task result class mismatch" );
   
   GHAssertTrue( [ received.responseObject isKindOfClass: [ NSURL class ] ], @"response object class mismatch" );
   
   receivedReadme = [ NSData dataWithContentsOfURL: received.responseObject ];
   GHAssertNotNil( receivedReadme, @"downloaded readme is unavailable" );
   
   GHAssertTrue( [ self->_expectedReadme isEqualToData: receivedReadme ], @"downloaded content mismatch" );
}

-(void)testNewFilenameBlockIsRequired
{
   GHAssertThrows
   (
   [ AFAsyncOperationFactory asyncDownloadTaskOperationFromRequest: self->_request
                                                        andSession: self->_afSessionManager
                                     usingOptionalTmpFileNameBlock: nil ],
    @"assert expected"
    );
}


-(void)testDownloadErrorIsWrapped
{
   __block AFDataTaskCompletionInfo* received = nil;
   __block NSError* error = nil;
   
   NSURL* nonExistingUrl = [ NSURL URLWithString: @"http://aaa" ];
   NSURLRequest* request = [ NSURLRequest requestWithURL: nonExistingUrl ];
   
   
   SEL testMethod = _cmd;
   [ self prepare: testMethod ];
   
   JFFDidFinishAsyncOperationHandler completionBlock = ^void( AFDataTaskCompletionInfo* blockResult, NSError* blockError )
   {
      error = blockError;
      received = blockResult;
      
      [ self notify: kGHUnitWaitStatusSuccess
        forSelector: testMethod ];
   };
   
   JFFAsyncOperation loader =
   [ AFAsyncOperationFactory asyncDownloadTaskOperationFromRequest: request
                                                        andSession: self->_afSessionManager
                                     usingOptionalTmpFileNameBlock: NEW_FILE_NAME ];
   
   loader( nil, nil, completionBlock );
   
   
   [ self waitForStatus: kGHUnitWaitStatusSuccess
                timeout: 1000 ];
   GHAssertNil( received, @"unexpecred response" );
   GHAssertNotNil( error, @"error expected" );
   
   
   GHAssertTrue( [ error isMemberOfClass: [ AFDataTaskError class ] ], @"error class mismatch" );
   
   
   AFDataTaskError* castedError = (AFDataTaskError*)error;
   GHAssertNotNil( castedError.errorFromAFNetworking, @"underlying error mismatch" );
}

@end