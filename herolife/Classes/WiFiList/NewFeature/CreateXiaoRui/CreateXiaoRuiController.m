//
//  CreateXiaoRuiController.m
//  herolife
//
//  Created by sswukang on 2016/12/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CreateXiaoRuiController.h"
#import "CreatXiaoRuiView.h"

@interface CreateXiaoRuiController ()

@end

@implementation CreateXiaoRuiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    CreatXiaoRuiView *creatView = [CreatXiaoRuiView shareCreateXiaoRui];
    creatView.uuid = self.qrUUID;
    self.view = creatView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    for (UINavigationController *nav in  self.tabBarController.childViewControllers) {
        for (UIViewController *VC in nav.childViewControllers) {
            
            DDLogWarn(@"tabBarController--%@", NSStringFromClass([VC class]));
        }
    }
    [self IsTabBarHidden:YES];
    
    [kNotification removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self IsTabBarHidden:NO];
}
#pragma mark - 隐藏底部条
- (void)IsTabBarHidden:(BOOL)hidden
{
    for (UIView *view  in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            view.hidden = hidden;
        }
    }
}
@end
