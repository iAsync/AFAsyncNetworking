#import <Foundation/Foundation.h>

@interface AFUrlConnectionProgressInfo : NSObject

@property ( nonatomic ) NSUInteger bytesWritten             ;
@property ( nonatomic ) long long  totalBytesWritten        ;
@property ( nonatomic ) long long  totalBytesExpectedToWrite;

@end
