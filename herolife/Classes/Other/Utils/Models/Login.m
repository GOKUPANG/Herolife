//
//  Login.m
//  xiaorui
//
//  Created by sswukang on 16/3/11.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "Login.h"
#import "HRUser.h"

#define kLoginStatus       @"login_status"
#define kLoginPreUserEmail @"pre_user_email"
#define kLoginUserDict     @"user_dict"
//#define k

static HRUser *curLoginUser;

@implementation Login

+(BOOL)isLogined {
	NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
	if (loginStatus.boolValue && [Login curLoginUser]) {
		HRUser *loginUser = [Login curLoginUser];
		if (loginUser.status && loginUser.status == 0) {
			return NO;
		}
		return YES;
	}else{
		return NO;
	}
}

+(void)doLogin: (NSDictionary *)loginData{
	
	
	curLoginUser = [HRUser userFromJSONResponse:loginData];
	//save to userdefaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];
	[defaults synchronize];
	
	NSString *fileName = HRNSSearchPathForDirectoriesInDomains(kLoginUserDict);
	DDLogInfo(@"fileName-%@", fileName);
	[NSKeyedArchiver archiveRootObject:loginData toFile:fileName];
}

+(void)doLogout {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
	[defaults setObject:@"" forKey:kDefaultsToken];
	[defaults synchronize];
	//删掉 gzhuarui.cn 的 cookie
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	[cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.domain hasSuffix:@".gzhuarui.cn"]) {
			
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
		}
	}];
}

+(HRUser *)curLoginUser {
	if (!curLoginUser) {
//		NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
		NSDictionary *loginData = [NSKeyedUnarchiver unarchiveObjectWithFile:HRNSSearchPathForDirectoriesInDomains(kLoginUserDict)];
		curLoginUser = loginData? [HRUser userFromJSONResponse: loginData]: nil;
	}
	return curLoginUser;
}

@end
