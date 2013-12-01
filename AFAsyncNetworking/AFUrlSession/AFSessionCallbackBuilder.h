#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import "AFNetworkingBlocks.h"

#import <Foundation/Foundation.h>

@interface AFSessionCallbackBuilder : NSObject

+(AFDataTaskCompletionBlock)afCompletionBlockWithAsyncCallback:(JFFAsyncOperationInterfaceResultHandler)handler;

@end
