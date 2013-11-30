#import "AFURLConnectionOperationAdapter.h"

@implementation AFURLConnectionOperationAdapter

-(instancetype)initWithAFURLConnectionOperation:( AFURLConnectionOperation* )afOperation
{
   self = [ super init ];
   if ( nil == self )
   {
      return nil;
   }
   
   self->_afOperation = afOperation;
   
   return self;
}



@end
