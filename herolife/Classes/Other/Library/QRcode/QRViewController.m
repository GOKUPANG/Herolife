//
//  QRViewController.m
//  xiaorui
//
//  Created by sswukang on 16/5/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "AppDelegate.h"

@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setBackgroundColor:[UIColor grayColor]];
	btn.frame = CGRectMake(0, 0, 100, 44);
	btn.center = self.view.center;
	[btn setTitle:@"进入扫码" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(intoQRCodeVC) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
	self.navigationController.navigationBar.hidden = YES;
}
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
			
			[self presentViewController:alert animated:YES completion:nil];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"自游邦\"访问您的相机." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
		}
		
		return;
	}
	
	QRCodeController *qrcodeVC = [[QRCodeController alloc] init];
	qrcodeVC.view.alpha = 0;
	[qrcodeVC setDidReceiveBlock:^(NSString *result) {
		NSLog(@"%@", result);
	}];
	AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[del.window.rootViewController addChildViewController:qrcodeVC];
	[del.window.rootViewController.view addSubview:qrcodeVC.view];
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		qrcodeVC.view.alpha = 1;
	} completion:^(BOOL finished) {
	}];
}


@end
