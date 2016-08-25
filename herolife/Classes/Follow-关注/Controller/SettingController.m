//
//  SettingController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blueColor];
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"icon_bg.jpg"];
	[self.view addSubview:backgroundImage];
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	
	
	navView.titleLabel.text = @"设置";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	self.navView.frame = CGRectMake(0, 20, HRUIScreenW, HRNavH);
}
@end
