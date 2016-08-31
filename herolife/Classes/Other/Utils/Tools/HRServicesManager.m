//
//  HRServices.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/25.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "HRServicesManager.h"
#import <MJExtension.h>
#import "HRNewUser.h"
#import "AppDelegate.h"
#import "Login.h"


@interface HRServicesManager ()


@end

@implementation HRServicesManager

#pragma mark - 单例方法

+ (instancetype) sharedManager {
	static HRServicesManager *services;
	static dispatch_once_t pred = 0;
	dispatch_once(&pred, ^{
		services = [[HRServicesManager alloc] init]; // or some other init method
	});
	return services;
}

#pragma mark - functions
-(NSString *) token {
	if (!_token) {
		_token = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsToken];
	}
	return _token;
}

-(NSString *) sessid {
	if (!_sessid) {
		_sessid = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsSessid];
	}
	return _sessid;
}

-(NSString *) session_name {
	if (!_session_name) {
		_session_name = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsSessionName];
	}
	return _session_name;
}


#pragma mark - static functions

+ (void)loginWithUsername: (NSString *)userName password:(NSString *)password result:(void(^)(NSError *error))result {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	
	[manager POST: HRAPI_LOGIN_URL
	   parameters: @{
					 @"username":userName,
					 @"password":password
					 }
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
			  
//			  HRAFNWriteToPlist(@"login");
			  DDLogInfo(@"xiaoruiInfo---%@", responseObject);
              [HRServicesManager sharedManager].sessid       = responseObject[@"sessid"];
              [HRServicesManager sharedManager].session_name = responseObject[@"session_name"];
			  HRUser *user = [HRUser userWithDict:responseObject[@"user"]];
			  
			  HRNewUser *newUser = [HRNewUser mj_objectWithKeyValues:responseObject[@"user"]];
			  
			  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			  [defaults setObject:[HRServicesManager sharedManager].sessid forKey:kDefaultsSessid];
			  [defaults setObject:[HRServicesManager sharedManager].session_name forKey:kDefaultsSessionName];
			  
			  [defaults setObject: user.name forKey:kDefaultsUserName];
			  [defaults setObject: newUser.name forKey:kDefaultsUserName];
			  [defaults setObject: newUser.mail forKey:kDefaultsUserMail];
			  [defaults setObject: [NSString stringWithFormat:@"%ld",(long)user.userID] forKey:kDefaultsUid];
			  [defaults setObject: newUser.uid forKey:kDefaultsUid];
			  [defaults setObject: password forKey:kDefaultsPassWord];
			  
			  
			  if (newUser.picture) {
				  DDLogInfo(@"%@",newUser.picture);
				   DDLogInfo(@"%@",newUser.picture[@"url"]);
				  [defaults setObject: newUser.picture[@"url"] forKey:kDefaultsIconURL];
			  }else
			  {
				  [defaults setObject: nil forKey:kDefaultsIconURL];
			  }
			  [defaults synchronize];
			  //获取token
			  [self postToGetToken:result];
			  //保存User
			  [Login doLogin:responseObject];
			  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_DID_LOGINED object:nil];
			  
			  //保存用户名到数据库
			  if (userName.length > 0) {
				  
				  [HRSqlite hrSqliteSaveUserName:user.name];
			  }

			  
		  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			  
			 
			  DDLogError(@"%@",error);
			  result(error);
			  return;
		  }];
}

+ (void) logout: (void(^)(NSError*))result {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	[manager POST:HRAPI_LOGOUT_URL
	   parameters:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			  /*注销成功*/
			  if (result) {
				  result(nil);
			  }
			  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_DID_LOGOUTED object:nil];
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			if (result) result(nil);
		}];
	
	/* 不管注销成功与否，都要将用户的登陆状态设为未登陆*/
	[Login doLogout];
	
	/// 断开socket连接
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate disconnectionToHost];
	
}

/**
 *  登陆之后保存用户数据
 *
 *  @param responseObject 回复的字典
 *  @param password       新密码
 *  @param logined        是否登陆成功
 */
+(void) saveUser: (NSDictionary *)responseObject newPasswd: (NSString *)password isLogined: (BOOL)logined{
//	HRConfig *config = [HRConfig sharedConfig];
//	if (responseObject) {
//		config.sessid      = responseObject[@"sessid"];
//		config.sessionName = responseObject[@"session_name"];
//		if (!config.user) {
//			config.user = [HRUser alloc];
//		}
//		config.user = [config.user initWithJSONResponse:];
//		[config.user saveToDatabase];
//	}
//	if (password) {
//		config.user.password = password;
//	}
//	[config setIsUserLogined:logined];
}

/**
 *  获取token
 *
 *  @param result 结果回调
 */
+(void) postToGetToken: (void(^)(NSError *error))result {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	[manager POST:HRAPI_CSRF_URL
				parameters:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [HRServicesManager sharedManager].token        = responseObject[@"token"];
			  
			  //save token to userdefaults
			  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			  [defaults setObject:[HRServicesManager sharedManager].token forKey:kDefaultsToken];
			  [defaults synchronize];
			  result(nil);
		  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			  DDLogInfo(@"Erroe when POST to query token: \n%@", error);
			  result(error);
		  }];
}

@end

