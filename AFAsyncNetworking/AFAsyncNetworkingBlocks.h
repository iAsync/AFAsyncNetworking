#ifndef AFAsyncNetworking_AFAsyncNetworkingBlocks_h
#define AFAsyncNetworking_AFAsyncNetworkingBlocks_h

@class AFUrlConnectionProgressInfo;
@class AFCompletionInfo;

typedef void (^AFAsyncProgressCallbackBlock)( AFUrlConnectionProgressInfo* progressInfo );
typedef void (^AFAsyncCompletionCallbackBlock)( AFCompletionInfo* result, NSError* error );

#endif
