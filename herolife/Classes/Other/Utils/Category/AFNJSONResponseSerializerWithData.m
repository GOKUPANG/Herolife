//
//  AFNJSONResponseSerializerWithData.m
//  xiaorui
//
//  Created by sswukang on 16/7/25.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AFNJSONResponseSerializerWithData.h"
#import "AFURLResponseSerialization.h"

@implementation AFNJSONResponseSerializerWithData
- (id)responseObjectForResponse:(NSURLResponse *)response
						   data:(NSData *)data
						  error:(NSError *__autoreleasing *)error
{
	id JSONObject = [super responseObjectForResponse:response data:data error:error]; // may mutate `error`
	
	if (*error != nil) {
		NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
		[userInfo setValue:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:JSONResponseSerializerWithDataKey];
		[userInfo setValue:[response valueForKey:JSONResponseSerializerWithBodyKey] forKey:JSONResponseSerializerWithBodyKey];
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		(*error) = newError;
	}
	
	return JSONObject;
}
@end