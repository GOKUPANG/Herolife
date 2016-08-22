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

@interface HRTabBarViewController ()

@end

@implementation HRTabBarViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// 设置所有UITabBarItem的文字属性
	[self setupItemTitleTextAttrs];

	// 添加子控制器
	[self setupAllChildVcs];
	//默认选中第2个控制器
	self.selectedIndex = 1;
}

/**
 *  添加子控制器
 */
- (void)setupAllChildVcs
{
	[self setupOneChildVc:[[HRNavigationViewController alloc] initWithRootViewController:[[QRcodeController alloc] init]] title:@"扫描" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];

	[self setupOneChildVc:[[HRNavigationViewController alloc] initWithRootViewController:[[DeviceListController alloc] init]] title:@"首页" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];

	[self setupOneChildVc:[[HRNavigationViewController alloc] initWithRootViewController:[[SettingController alloc] init]] title:@"设置" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];

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

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttrs
{
	// 设置normal状态下的文字属性
	NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
	normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
	normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];

	// 设置normal状态下的文字属性
	NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
	selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

	// 利用Appearance对象统一设置文字属性
	UITabBarItem *item = [UITabBarItem appearance];
	[item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
	[item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}



@end
