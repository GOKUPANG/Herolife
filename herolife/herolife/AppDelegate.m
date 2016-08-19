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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//显示界面
	[self setupWindow];
	
	
	
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
- (void)setupWindow
{
	BOOL isLogin = NO;
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	LoginController *loginVC = [[LoginController alloc] init];
	HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
	
	if (isLogin) {
		self.window.rootViewController = tabBarVC;
	}else
	{
		self.window.rootViewController = loginVC;
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
