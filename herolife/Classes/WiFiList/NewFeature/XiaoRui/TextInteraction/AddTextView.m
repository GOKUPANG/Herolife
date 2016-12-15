//
//  AddTextView.m
//  xiaorui
//
//  Created by sswukang on 16/5/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AddTextView.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "HRTotalData.h"
#import "TextInteractionController.h"
@interface AddTextView ()
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

@end
@implementation AddTextView


- (void)setData:(HRTotalData *)data
{
	_data = data;
}

- (void)awakeFromNib
{
	self.determineBtn.layer.cornerRadius = self.determineBtn.hr_height *0.5;
	self.cancle.layer.cornerRadius = self.cancle.hr_height *0.5;
	self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5];
	[self.deviceName becomeFirstResponder];
	
}
- (void)addTapGesture
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	[self addGestureRecognizer:tap];
}
- (void)tapClick
{
	[self.deviceName resignFirstResponder];
}
#pragma mark - UI点击
//确定
- (IBAction)determineBtnClick:(UIButton *)sender {
	[self.deviceName resignFirstResponder];
	if (self.deviceName.text.length > 0) {
		
		[kUserDefault setObject:self.deviceName.text forKey:kUserDefaultTextVCUserName];
		[self hiddenSelf];
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"昵称不能为空!"];
	}
	
	
}
//取消
- (IBAction)cancleBtnClick:(UIButton *)sender {
	[self.deviceName resignFirstResponder];
	NSString *userName = [kUserDefault objectForKey:kUserDefaultTextVCUserName];
	if (userName.length > 0) {
		[self hiddenSelf];
	}else
	{
		UINavigationController *v = (UINavigationController *)[self activityViewController];
		TextInteractionController *VC = v.childViewControllers.lastObject;
		[SVProgressTool hr_showErrorWithStatus:@"用户昵称不能为空!"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			
			[VC.navigationController popViewControllerAnimated:YES];
		});
		
	}
	
}
#pragma mark -拿到根控制器

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

- (void)hiddenSelf
{
	[SVProgressHUD dismiss];
	self.superview.hidden = YES;
}
@end
