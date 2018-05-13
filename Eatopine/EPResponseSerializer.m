//
//  JSONResponseSerializerWithData.m
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

#import "EPResponseSerializer.h"
@implementation EPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (*error != nil) {
            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
            NSError *jsonError;
            // parse to json
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            // store the value in userInfo if JSON has no error
            if (jsonError == nil){
                userInfo[JSONResponseSerializerWithDataKey] = json;
            }else{
                NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
                (*error) = newError;
            }
        }
        return (nil);
    }
    return ([super responseObjectForResponse:response data:data error:error]);
}

@end
