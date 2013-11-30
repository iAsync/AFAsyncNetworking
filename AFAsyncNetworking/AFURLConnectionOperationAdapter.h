#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@class AFURLConnectionOperation;

@interface AFURLConnectionOperationAdapter : NSObject< JFFAsyncOperationInterface >

-(instancetype)initWithAFURLConnectionOperation:( AFURLConnectionOperation* )afOperation;

@property ( nonatomic, readonly ) AFURLConnectionOperation* afOperation;

@end
