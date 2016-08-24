//
//  DeviceListController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "DeviceListController.h"
#define HRNavigationBarFrame self.navigationController.navigationBar.bounds
@interface DeviceListController ()
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
@end

@implementation DeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.hidden = YES;
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"设备列表";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;
	self.view.backgroundColor = [UIColor grayColor];
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	self.navView.frame = CGRectMake(0, 20, HRUIScreenW, HRNavH);
}
@end
