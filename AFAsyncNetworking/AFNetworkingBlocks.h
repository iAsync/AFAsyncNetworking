#ifndef AFAsyncNetworking_AFNetworkingBlocks_h
#define AFAsyncNetworking_AFNetworkingBlocks_h

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

typedef void (^AFProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^AFSuccessfulCompletionBlock)(AFHTTPRequestOperation *operation, id responseObject);

typedef void (^AFUnsuccessfulCompletionBlock)(AFHTTPRequestOperation *operation, NSError *error);


typedef void (^AFDataTaskCompletionBlock)(NSURLResponse *response, id responseObject, NSError *error);

#endif
