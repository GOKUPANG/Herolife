//
//  CreateXRHttpTools.m
//  xiaorui
//
//  Created by sswukang on 16/7/20.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CreateXRHttpTools.h"

@implementation CreateXRHttpTools

+ (void)postHttpCreateIrdevWithMid:(NSString *)mid title:(NSString *)title responseDict:(void(^)(NSDictionary *dict))responseDict result:(void(^)(NSError *error))result
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"type"] = @"irdev";
	parameters[@"title"] = title;
	parameters[@"language"] = @"und";
	parameters[@"field_mid[und][0][value]"] = mid;
	NSString *uuid = [kUserDefault objectForKey:kUserDefaultUserInputUUID];
	parameters[@"field_uuid[und][0][value]"] = uuid;
	parameters[@"field_version[und][0][value]"] = @"0.0.1";
	parameters[@"field_brand[und][0][value]"] = @"xiaorui brand";
	parameters[@"field_state[und][0][value]"] = @"1";
	
	for (int i = 1; i < 17; i++) {
		for (int j = 0; j < 10; j++) {
			NSString *str = [NSString stringWithFormat:@"field_param%02d[und][%d][value]", i,j];
			parameters[str] = @"0";
		}
	}
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	
	[manager POST:HRAPI_XiaoRuiNode_URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		//		kNotificationPost(@"")
		NSDictionary *dict = (NSDictionary *)responseObject;
		DDLogInfo(@"创建红外地址表%@",dict);
		responseDict(dict);
		result(nil);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		responseDict(nil);
		result(error);
		
	}];

}

+ (void)postHttpCreateSingleswitchWithMid:(NSString *)mid title:(NSString *)title responseDict:(void(^)(NSDictionary *dict))responseDict result:(void(^)(NSError *error))result
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"type"] = @"singleswitch";
	parameters[@"title"] = title;
	parameters[@"language"] = @"und";
	parameters[@"field_mid[und][0][value]"] = mid;
	NSString *uuid = [kUserDefault objectForKey:kUserDefaultUserInputUUID];
	parameters[@"field_uuid[und][0][value]"] = uuid;
	parameters[@"field_version[und][0][value]"] = @"0.0.1";
	parameters[@"field_brand[und][0][value]"] = @"xiaorui brand";
	parameters[@"field_state[und][0][value]"] = @"1";
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	for (int i = 1; i < 4; i++) {
		for (int j = 0; j < 10; j++) {
			NSString *str = [NSString stringWithFormat:@"field_param%02d[und][%d][value]", i,j];
			parameters[str] = @"0";
		}
	}
	
	[manager POST:HRAPI_XiaoRuiNode_URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		//		kNotificationPost(@"")
		NSDictionary *dict = (NSDictionary *)responseObject;
		DDLogInfo(@"创建单火地址表%@",dict);
		responseDict(dict);
		result(nil);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		DDLogDebug(@"%@", error);
		responseDict(nil);
		result(error);
	}];
}
@end
