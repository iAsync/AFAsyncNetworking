@interface AFOperationTest : GHAsyncTestCase
@end


@implementation AFOperationTest
{
   NSURLRequest              * _request;
   NSData                    * _expectedReadme;
   
   NSURLSessionConfiguration * _config;
   NSOperationQueue          * _mainQueue;
   
   AFHTTPRequestOperation* _afOperation;
   AFHTTPRequestOperation* _badUrlOperation;
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
   
   self->_afOperation = [ [ AFHTTPRequestOperation alloc ] initWithRequest: self->_request ];
   
   
   NSURL* nonExistingUrl = [ NSURL URLWithString: @"http://aaa" ];
   NSURLRequest* badRequest = [ NSURLRequest requestWithURL: nonExistingUrl ];
   self->_badUrlOperation = [ [ AFHTTPRequestOperation alloc ] initWithRequest: badRequest ];
}

-(void)tearDown
{
   self->_request          = nil;
   self->_expectedReadme   = nil;
   self->_config           = nil;
   self->_mainQueue        = nil;
   
   [ self->_afOperation cancel ];
   self->_afOperation = nil;
   
   
   [ super tearDown ];
}

-(void)testReadmeIsDownloadedCorrectly
{
   self->_afOperation.responseSerializer = [ AFHTTPResponseSerializer serializer ];
   __block AFCompletionInfo* received = nil;
   
   __block NSData* receivedReadme = nil;
   __block NSError* error = nil;
   
   SEL testMethod = _cmd;
   [ self prepare: testMethod ];
   
   JFFDidFinishAsyncOperationHandler completionBlock = ^void( AFCompletionInfo* blockResult, NSError* blockError )
   {
      error = blockError;
      received = blockResult;
      
      [ self notify: kGHUnitWaitStatusSuccess
        forSelector: testMethod ];
   };
   
   JFFAsyncOperation loader =
   [ AFAsyncOperationFactory asyncOperationFromAFHTTPRequestOperation: self->_afOperation  ];
   loader( nil, nil, completionBlock );
   
   
   [ self waitForStatus: kGHUnitWaitStatusSuccess
                timeout: 1000 ];
   GHAssertTrue( [ received isMemberOfClass: [ AFCompletionInfo class ] ], @"data task result class mismatch" );

   receivedReadme = received.responseObject;
   GHAssertTrue( [receivedReadme isKindOfClass: [ NSData class ] ], @"response object class mismatch" );
   
   GHAssertTrue( received.operation == self->_afOperation, @"operation object mismatch" );

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
   [ AFAsyncOperationFactory asyncOperationFromAFHTTPRequestOperation: self->_badUrlOperation  ];
   
   loader( nil, nil, completionBlock );
   
   
   [ self waitForStatus: kGHUnitWaitStatusSuccess
                timeout: 1000 ];
   GHAssertNil( received, @"unexpecred response" );
   GHAssertNotNil( error, @"error expected" );
   
   
   GHAssertTrue( [ error isMemberOfClass: [ AFAsyncError class ] ], @"error class mismatch" );
   
   
   AFDataTaskError* castedError = (AFDataTaskError*)error;
   GHAssertNotNil( castedError.errorFromAFNetworking, @"underlying error mismatch" );
}

@end
