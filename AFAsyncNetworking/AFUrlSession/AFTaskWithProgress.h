#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class NSProgress;

@protocol AFTaskWithProgress <NSObject>

-(void)observeProgress:( NSProgress* )afProgress
           notifyBlock:( JFFAsyncOperationInterfaceProgressHandler )progressBlock;

@end
