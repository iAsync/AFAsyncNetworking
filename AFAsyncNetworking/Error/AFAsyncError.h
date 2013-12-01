#import <Foundation/Foundation.h>

@interface AFAsyncError : NSError

@property ( nonatomic ) AFHTTPRequestOperation* operation;
@property ( nonatomic ) NSError* errorFromAFNetworking;

@end
