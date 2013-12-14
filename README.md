AFAsyncNetworking
=================

A collection of wrapper adapter classes that integrate [AFNetworking 2.0](https://github.com/iAsync/AFNetworking) with [iAsync](https://github.com/EmbeddedSources/iAsync/) library.

**Note:** We use a fork of AFNetworking since @mattt does not accept pull requests with a static library target.

```
License : BSD
```



## Wrapping Around AFNetworking to Avoid Callback Hell.
AFNetworking is one of the most famous and widely used networking libraries for iOS. As of version 1.0 it was based on *NSOperation* API that was capable of managing dependencies between the operations. It was possible to manage execution order and get a single completion point of several parallel operations.

After switching to AFNetworking 2.0 you can only subscribe to NSURLSessionTaskDelegate events using block based callbacks. This means that you end up writing code like this :


```objective-c

NSString* geolocationUrl = [ NSString stringWithFormat: @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&address=%@", @"Kiev"];

AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
[manager GET:geolocationUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonLocation) {
    dispatch_async( myBackgroundQueue, ^{
            NSError* parseError;
    
            id<AWCoordinatesParser> parser = [ AWParserFactory jsonCoordinatesParser ];
            AWCoordinates* coordinates = [ parser parseData: jsonLocation
                                                      error: &parseError ];
            if ( !coordinates )                                          
            {
                 [ self handleError: parseError ];
            }                                          
                                                     
            NSString* weatherUrl = [ NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%1.2f&lon=%1.2f", coordinates.latitude, coordinates.longitude ];
            
            
            [manager GET:weatherUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonWeather) {
                  dispatch_async( myBackgroundQueue, ^{
                        NSError* parseError;
                        id<AWWeatherParser> parser = [ AWParserFactory jsonWeatherParser ];
                        AWWeatherInfo* weather = [ parser parseData: weatherJson
                                                              error: &parseError ];
                        if ( !weather )                                          
                        {
                            [ self handleError: parseError ];
                        }                                          
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                           [ self updateGuiWithWeatherInfo: weather ];
                        });
                  });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [ self handleError: error ];
            }];
    });
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [ self handleError: error ];
}];
```

This code solves a typical task of retrieving and parsing weather information from two web services. As you can see, this code has 4 levels of nested callbacks and is hard to maitain. This is known as a "**callback hell**" problem.


With the help of functional programming ideas imlemented in iAsync library, the same code can be written in a declarative manner and effectively split into subtasks : 

```objective-c
+(JFFAsyncOperation)asyncWeatherForAddress:( NSString* )userInput
{
   return bindSequenceOfAsyncOperationsArray
   (
      [ self asyncLocationForAddress: userInput ],
     @[
         [ self parseRawAddressBinder ],
         [ self getWeatherBinder      ],
         [ self parseWeatherBinder    ]
      ]
   );
}
```

## Why Functional Progarmming?
This approach has some benefits over calback hell :

1. **Declarative programming** - you perform task decomposition as opposed to having all logic in a bunch of nested blocks.
2. **Operations flow** - you can manage operations flow and ensure they are executed in the right order.
3. **Performance** - it is possible to cancel asynchronous operations that are no longer needed with the respect to their dependencies. This may be useful when the user leaves some view controller that launched a number of operations.

## Creating AFNetworking Operations

It is really easy to create asynchronous operations that use AFNetworking under the hood. Let's take a look at the implementation of **asyncLocationForAddress:** function from the previous example :


```objective-c
+(JFFAsyncOperation)asyncLocationForAddress:( NSString* )userInput
{
   NSString* requestUrlBase = @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&address=";
   NSString* requestUrlString =  [ requestUrlBase stringByAppendingString: userInput ];
   
   NSURL* requestUrl = [ NSURL URLWithString: requestUrlString ];
   NSURLRequest* request = [ NSURLRequest requestWithURL: requestUrl ];
   NSParameterAssert( nil != request );   

   AFHTTPSessionManager* session = [ AFHTTPSessionManager manager ];
   session.responseSerializer = [ AFHTTPResponseSerializer serializer ];
   
   JFFAsyncOperation result =
   [ AFAsyncOperationFactory asyncDataTaskOperationFromRequest: request
                                                    andSession: session ];
   
   return [ result copy ];
}
```


## Executing AFNetworking Operations
Invoking an asynchronous operation is as easy as using dispathc_async() API. 
See the example below :

```objective-c
-(IBAction)getWeatherButtonTapped:(id)sender
{
   [ self.txtAddress resignFirstResponder ];
   
   NSString* address = self.txtAddress.text;
   if ( ![ self validateAddress: address ] )
   {
	  // Handle validation error and show alert
      return;
   }
   
   
   JFFAsyncOperation loader = [ AWOperationsFactory asyncWeatherForAddress: address ];
   
   
   __weak ESViewController* weakSelf = self;
   JFFCancelAsyncOperationHandler onCancel = ^void(BOOL isOperationKeepGoing)
   {
      [ weakSelf onWeatherInfoRequestCancelled ];
   };
   JFFDidFinishAsyncOperationHandler onLoaded = ^void(id result, NSError *error)
   {
      [ weakSelf onWeatherInfoLoaded: result
                           withError: error ];
   };
   JFFCancelAsyncOperation cancelLoad = loader( nil, onCancel, onLoaded );
   self->_cancelLoad = cancelLoad;
   
   self.activityIndicator.hidden = NO;
   [ self.activityIndicator startAnimating ];
}
```


# Useful Links
1. AFNetworking home page           - <https://github.com/AFNetworking/AFNetworking>
2. iAsync home page                 - <https://github.com/EmbeddedSources/iAsync>
3. Code examples repository         - <https://github.com/iAsync/weather-afasync>
4. Callback hell problem definition - <http://tirania.org/blog/archive/2013/Aug-15.html>
5. Slides about iAsync library and functional programming in Objective-C - <https://github.com/iAsync/iAsyncSlides/blob/master/iAsync-slides.pdf?raw=true>
