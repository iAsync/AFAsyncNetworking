#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface AFCompletionInfo : NSObject

@property ( nonatomic ) AFHTTPRequestOperation* operation;
@property ( nonatomic ) id responseObject;

@end
