@interface DataTaskTest : GHAsyncTestCase
@end

@implementation DataTaskTest
{
   NSURLRequest              * _request;
   NSData                    * _expectedReadme;
   
   NSURLSessionConfiguration * _config;
   NSOperationQueue          * _mainQueue;
   
   AFHTTPSessionManager      * _afSessionManager;
}


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

-(void)testReadmeIsDownloadedCorrectly
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
   [ AFAsyncOperationFactory asyncDataTaskOperationFromRequest: self->_request
                                                    andSession: self->_afSessionManager ];
   loader( nil, nil, completionBlock );

   
   [ self waitForStatus: kGHUnitWaitStatusSuccess
                timeout: 1000 ];
   GHAssertTrue( [ received isMemberOfClass: [ AFDataTaskCompletionInfo class ] ], @"data task result class mismatch" );
   
   receivedReadme = received.responseObject;
   GHAssertTrue( [receivedReadme isKindOfClass: [ NSData class ] ], @"response object class mismatch" );
   
   GHAssertTrue( [ self->_expectedReadme isEqualToData: receivedReadme ], @"downloaded content mismatch" );
}

-(void)testDownloadErrorIsWrapped
{
   __block AFDataTaskCompletionInfo* received = nil;
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
   [ AFAsyncOperationFactory asyncDataTaskOperationFromRequest: self->_request
                                                    andSession: self->_afSessionManager ];
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