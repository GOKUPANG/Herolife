//
//  NextController.m
//  herolife
//
//  Created by sswukang on 16/8/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "NextController.h"

#import "GoToSetUpController.h"

@interface NextController ()
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 头像 */
@property(nonatomic, weak) UIImageView *iconImage;
/** 头像底纹viwe 上*/
@property(nonatomic, weak) UIView *upView;
/** 头像底纹viwe 下 */
@property(nonatomic, weak) UIView *downView;
/** 通过电源, 长按6秒, 直到指示灯闪烁 label */
@property(nonatomic, weak) UILabel *promptLabel;
/** 添加按钮 */
@property(nonatomic, weak) HRButton *nextButton;

@end

@implementation NextController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupViews];
	[self goBack];
	//隐藏底部条
	[self IsTabBarHidden:YES];
}
#pragma mark - 内部方法
//初始化
- (void)setupViews
{
	
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
	[self.view addSubview:backgroundImage];
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"设备列表";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:navView];
	self.navView = navView;
	
	//头像底纹viwe 上
	UIView *upView = [[UIView alloc] init];
	upView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:upView];
	self.upView = upView;
	
	//头像底纹viwe 小
	UIView *downView = [[UIView alloc] init];
	downView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
	[self.view addSubview:downView];
	self.downView = downView;
	
	//头像
	UIImageView *iconImage = [[UIImageView alloc] init];
	iconImage.image = [UIImage imageNamed:@"Default-568h@3x-1"];
	self.iconImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
	self.iconImage.layer.masksToBounds = YES;
	
	[self.view addSubview:iconImage];
	self.iconImage = iconImage;
	
	//通过电源, 长按6秒, 直到指示灯闪烁 label
	UILabel *promptLabel = [[UILabel alloc] init];
	promptLabel.text = @"通过电源, 长按6秒, 直到指示灯闪烁";
	promptLabel.textColor = [UIColor whiteColor];
	promptLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:promptLabel];
	self.promptLabel = promptLabel;
	
	//添加按钮
	HRButton *nextButton = [HRButton buttonWithType:UIButtonTypeCustom];
	[nextButton setTitle:@"下一步" forState:UIControlStateNormal];
	[nextButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
	[nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:nextButton];
	self.nextButton = nextButton;
}


- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	//导航条
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	[self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH *112);
		make.centerX.equalTo(self.view);
		make.height.width.mas_equalTo(HRCommonScreenW * 432);
		
	}];
	
	self.upView.layer.cornerRadius = self.upView.hr_width * 0.5;
	self.upView.layer.masksToBounds = YES;
	
	[self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.upView).offset(HRCommonScreenH *22);
		make.centerX.equalTo(self.view);
		make.height.width.mas_equalTo(HRCommonScreenW * 388);
		
	}];
	self.downView.layer.cornerRadius = self.downView.hr_width * 0.5;
	self.downView.layer.masksToBounds = YES;
	
	//头像
	[self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.downView).offset(HRCommonScreenH * 18);
		make.centerX.equalTo(self.view);
		make.height.width.mas_equalTo(HRCommonScreenW * 348);
	}];
	
	self.iconImage.layer.cornerRadius = self.iconImage.hr_height * 0.5;
	self.iconImage.layer.masksToBounds = YES;
	
	//label
	[self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.upView.mas_bottom).offset(HRCommonScreenH * 20);
		make.centerX.equalTo(self.view);
	}];
	
	//下一步按钮
	[self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.promptLabel.mas_bottom).offset(HRCommonScreenH * 104);
		make.left.equalTo(self.view).offset(HRCommonScreenW *192);
		make.right.equalTo(self.view).offset(- HRCommonScreenW *192);
		make.height.mas_equalTo(HRCommonScreenH * 80);
	}];
	
	self.nextButton.layer.cornerRadius = self.nextButton.hr_height * 0.5;
	self.nextButton.layer.masksToBounds = YES;
}
#pragma mark - UI事件
- (void)leftButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)nextButtonClick:(UIButton *)btn
{
	[self IsTabBarHidden:YES];
	GoToSetUpController *enterVC = [[GoToSetUpController alloc] init];
	[self.navigationController pushViewController:enterVC animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[self IsTabBarHidden:YES];
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
#pragma mark - 全屏放回
- (void)goBack
{
	// 获取系统自带滑动手势的target对象
	id target = self.navigationController.interactivePopGestureRecognizer.delegate;
	// 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
	// 设置手势代理，拦截手势触发
	pan.delegate = self;
	// 给导航控制器的view添加全屏滑动手势
	[self.view addGestureRecognizer:pan];
	// 禁止使用系统自带的滑动手势
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	// 注意：只有非根控制器才有滑动返回功能，根控制器没有。
	// 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
	if (self.childViewControllers.count == 1) {
		// 表示用户在根控制器界面，就不需要触发滑动手势，
		return NO;
	}
	return YES;
}

@end
