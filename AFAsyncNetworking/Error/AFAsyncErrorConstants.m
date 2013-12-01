#import "AFAsyncErrorConstants.h"



@implementation AFAsyncErrorConstants

+(NSString*)urlConnectionErrorDomain
{
   static NSString* const result = @"org.iAsync.AFAsyncNetworking.Connection";
   return result;
}

+(NSString*)urlSessionErrorDomain
{
   static NSString* const result = @"org.iAsync.AFAsyncNetworking.Session";
   return result;
}

@end
