//
//  AppDelegate.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "HRTabBarViewController.h"
#import "HRNavigationViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#define ShareSDKAppId @"164558e46c000"
#define QQSDKAppId @"1105629306"
#define QQSDKAppKey @"Ig2gYUcepC3rE9NH"

#import "RegisterViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//显示界面
	[self setupWindow];
	
	//集成ShareSDK
	[self addShareSDK];
	
	/******* 日志 ********/
#ifdef DEBUG
	[self setLogger];
#endif
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
}
#pragma mark - 一些自定义的方法
- (void)addShareSDK
{
	/**
	 *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
	 *  在将生成的AppKey传入到此方法中。
	 *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
	 *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
	 *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
	 */
 [ShareSDK registerApp:ShareSDKAppId
  
	   activePlatforms:@[
						 @(SSDKPlatformTypeQQ)]
			  onImport:^(SSDKPlatformType platformType)
  {
	  switch (platformType)
	  {
		  case SSDKPlatformTypeQQ:
			  [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
			default:
			  break;
	  }
  }
	   onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
  {
	  
	  switch (platformType)
	  {
		  case SSDKPlatformTypeQQ:
			  [appInfo SSDKSetupQQByAppId:QQSDKAppId
								   appKey:QQSDKAppKey
								 authType:SSDKAuthTypeBoth];
			  break;
		
		  default:
			  break;
	  }
  }];
}
- (void)setupWindow
{
	BOOL isLogin = YES;
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	LoginController *loginVC = [[LoginController alloc] init];
	HRNavigationViewController *nav = [[HRNavigationViewController alloc] initWithRootViewController:loginVC];
	HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
	
	if (isLogin) {
		self.window.rootViewController = tabBarVC;
	}else
	{
		self.window.rootViewController = nav;
	}
	
	[self.window makeKeyAndVisible];
}
-(void) setLogger {
	
	DDTTYLogger *logger = [DDTTYLogger sharedInstance];
	logger.colorsEnabled = YES;
	
	[logger setForegroundColor:[UIColor colorWithRed:219 green:44 blue:56 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagError];
	[logger setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:DDLogFlagWarning];
	
	[logger setForegroundColor:[UIColor colorWithRed:91 green:149 blue:207 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagInfo];
	
	[logger setForegroundColor:[UIColor colorWithRed:133 green:208 blue:107 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagDebug];
	
	[DDLog addLogger:logger];
}

@end
