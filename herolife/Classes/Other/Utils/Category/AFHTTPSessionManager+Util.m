//
//  AFHTTPSessionManager+Util.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/26.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"
#import "AFNJSONResponseSerializerWithData.h"
#import "HRServicesManager.h"

@implementation AFHTTPSessionManager (Util)

+ (instancetype)hrManager
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	
	manager.responseSerializer = [AFNJSONResponseSerializerWithData serializer];
	
	[manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
	NSString *token = [HRServicesManager sharedManager].token;
	if (token) [manager.requestSerializer setValue:token forHTTPHeaderField:TOKEN_HEADER_NAME];
	
	manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
	
	return manager;
}

+ (instancetype)hrPostManager
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	
	manager.responseSerializer = [AFNJSONResponseSerializerWithData serializer];
	[manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
	NSString *token = [HRServicesManager sharedManager].token;
	if (token) [manager.requestSerializer setValue:token forHTTPHeaderField:TOKEN_HEADER_NAME];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
	
	[manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	return manager;
}

+ (NSString *)generateUserAgent
{
	NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
	NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	
	DDLogDebug(@"hero.huarui/%@/%@/%@/%@/%@", appVersion,
				[UIDevice currentDevice].systemName,
				[UIDevice currentDevice].systemVersion,
				[UIDevice currentDevice].model,
				IDFV);
	return [NSString stringWithFormat:@"hero.huarui/%@/%@/%@/%@/%@", appVersion,
			[UIDevice currentDevice].systemName,
			[UIDevice currentDevice].systemVersion,
			[UIDevice currentDevice].model,
			IDFV];
}
@end
