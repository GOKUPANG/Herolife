//
//  HRTabBarViewController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRTabBarViewController.h"
#import "SettingController.h"
#import "QRcodeController.h"
#import "DeviceListController.h"
#import "HRNavigationViewController.h"
#import "HRTabBar.h"
#import "AddNewDeviceViewController.h"

@interface HRTabBarViewController ()<HRTabBarDelegate>

@end

@implementation HRTabBarViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// 添加子控制器
	[self setupAllChildVcs];
	self.tabBar.barTintColor = [[UIColor whiteColor]  colorWithAlphaComponent:0.2];
	self.tabBar.alpha = 0.2;
	
	// 处理TabBar
	[self setupTabBar];
	//默认选中第2个控制器
	self.selectedIndex = 1;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)setupTabBar
{
	[self.tabBar removeFromSuperview];
	HRTabBar *tabBar = [[HRTabBar alloc] initWithFrame:CGRectMake(0, HRUIScreenH - 49, HRUIScreenW, 49)];
	tabBar.delegate = self;
	[self.view addSubview:tabBar];
}
/**
 *  添加子控制器
 */
- (void)setupAllChildVcs
{
	[self setupOneChildVc:[[HRNavigationViewController alloc] initWithRootViewController:[[AddNewDeviceViewController alloc] init]] title:@"扫描添加" image:@"扫描白" selectedImage:@"扫描蓝"];

	[self setupOneChildVc:[[HRNavigationViewController alloc] initWithRootViewController:[[DeviceListController alloc] init]] title:@"首页" image:@"首页白" selectedImage:@"首页蓝"];

	[self setupOneChildVc:[[HRNavigationViewController alloc] initWithRootViewController:[[SettingController alloc] init]] title:@"设置" image:@"设置白" selectedImage:@"设置蓝"];

}

/**
 *  初始化一个子控制器
 *
 *  @param childVcClass  子控制器的具体类型
 *  @param title         子控制器的标题
 *  @param image         子控制器的图标
 *  @param selectedImage 子控制器的选中图标
 */
- (void)setupOneChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
	childVc.tabBarItem.title = title;
	if (image.length) childVc.tabBarItem.image = [UIImage imageNamed:image];
	if (selectedImage.length) childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
	[self addChildViewController:childVc];
}

#pragma mark - HRTabBarDelegate
- (void)hrTabBar:(HRTabBar *)tabBar didClickBtn:(NSInteger)index
{
	self.selectedIndex = index -1;
    HRNavigationViewController *nav = self.selectedViewController;
    for (UIViewController *VC in nav.childViewControllers) {
        DDLogWarn(@"UIViewController--selectedViewController--%@", NSStringFromClass([VC class]));
    }
    DDLogWarn(@"selectedViewController--%@", NSStringFromClass([self.selectedViewController class]));
}


@end
