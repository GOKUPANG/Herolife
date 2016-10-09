//
//  QRTools.m
//  xiaorui
//
//  Created by sswukang on 16/7/20.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "QRTools.h"

#import "QRCodeController.h"
//#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "AddNewDeviceViewController.h"

@implementation QRTools

#pragma mark - 二维码
/**
 *  是否可以打开设置页面
 *
 *  @return
 */
- (BOOL)canOpenSystemSettingView {
	if (IS_VAILABLE_IOS8) {
		NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
			return YES;
		} else {
			return NO;
		}
	} else {
		return NO;
	}
}

/**
 *  跳到系统设置页面
 */
- (void)systemSettingView {
	if (IS_VAILABLE_IOS8) {
		NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
			[[UIApplication sharedApplication] openURL:url];
		}
	}
}
/*!
 *  扫一扫
 */

- (void)intoQRCodeVC {
	NSString *mediaType = AVMediaTypeVideo;
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
	if(authStatus == AVAuthorizationStatusDenied){
		if (IS_VAILABLE_IOS8) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"自游邦\"访问您的相机." preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			}]];
			[alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				if ([self canOpenSystemSettingView]) {
					[self systemSettingView];
				}
			}]];
			
			UINavigationController *v = (UINavigationController *)[self activityViewController];
			UIViewController *addNewVC = v.childViewControllers.lastObject;
			[addNewVC presentViewController:alert animated:YES completion:nil];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"自游邦\"访问您的相机." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
		}
		
		return;
	}
	
	QRCodeController *qrcodeVC = [[QRCodeController alloc] init];
	qrcodeVC.view.alpha = 0;
	__weak typeof (self) weakSelf = self;
	[qrcodeVC setDidReceiveBlock:^(NSString *result) {
		
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[@"result"] = result;
		[kNotification postNotificationName:kNotificationQRCodeCreateXiaoRui object:nil userInfo:dict];
		
		DDLogInfo(@"%@", result);
	}];
	
	AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[del.window.rootViewController addChildViewController:qrcodeVC];
	[del.window.rootViewController.view addSubview:qrcodeVC.view];
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		qrcodeVC.view.alpha = 1;
	} completion:^(BOOL finished) {
	}];
}


//拿到根控制器
- (UIViewController *)activityViewController
{
	UIViewController* activityViewController = nil;
	
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	if(window.windowLevel != UIWindowLevelNormal)
	{
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for(UIWindow *tmpWin in windows)
		{
			if(tmpWin.windowLevel == UIWindowLevelNormal)
			{
				window = tmpWin;
				break;
			}
		}
	}
	
	NSArray *viewsArray = [window subviews];
	if([viewsArray count] > 0)
	{
		UIView *frontView = [viewsArray objectAtIndex:0];
		
		id nextResponder = [frontView nextResponder];
		
		if([nextResponder isKindOfClass:[UIViewController class]])
		{
			activityViewController = nextResponder;
		}
		else
		{
			activityViewController = window.rootViewController;
		}
	}
	DDLogInfo(@"%@", activityViewController);
	return activityViewController;
}
@end
