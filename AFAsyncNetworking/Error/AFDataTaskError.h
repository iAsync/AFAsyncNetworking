#import <Foundation/Foundation.h>

@interface AFDataTaskError : NSError

@property ( nonatomic ) NSURLResponse *response;
@property ( nonatomic ) NSError* errorFromAFNetworking;

@end
