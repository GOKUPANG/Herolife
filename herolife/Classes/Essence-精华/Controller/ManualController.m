//
//  ManualController.m
//  herolife
//
//  Created by sswukang on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ManualController.h"

@interface ManualController ()
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 二维码按钮 */
@property(nonatomic, weak) UIButton *qrButton;
/** 二维码Label */
@property(nonatomic, weak) UILabel *qrLabel;
/** 手动添加按钮 */
@property(nonatomic, weak) UIButton *manualButton;
/** 手动添加label */
@property(nonatomic, weak) UILabel *manualLabel;

@end

@implementation ManualController

- (void)viewDidLoad {
	[super viewDidLoad];
	//初始化
	[self setupViews];
	[self goBack];
}

#pragma mark - 内部方法
//初始化
- (void)setupViews
{
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"icon_bg.jpg"];
	[self.view addSubview:backgroundImage];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"智能门锁";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;

	//求字体长度
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
	//二维码按钮
//	CGFloat tabbarMinY = HRUIScreenH - 49;
	UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[qrButton setBackgroundImage:[UIImage imageNamed:@"发光圆"] forState:UIControlStateNormal];
	[qrButton setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
//	qrButton.frame = CGRectMake(0, tabbarMinY - HRCommonScreenH *(104 +72), HRCommonScreenW * 72, HRCommonScreenW * 72);
//	qrButton.hr_centerX = 100;
	[qrButton addTarget:self action:@selector(qrcodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:qrButton];
	self.qrButton = qrButton;
	
	//求字体长度
	CGSize leftSize = [@"扫描二维码" sizeWithAttributes:dict];
	
	//二维码Label
//	UILabel *qrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(qrButton.frame) + HRCommonScreenH*10, leftSize.width, leftSize.height)];
//	qrLabel.hr_centerX = qrButton.hr_centerX;
	UILabel *qrLabel = [[UILabel alloc] init];
	qrLabel.backgroundColor = [UIColor clearColor];
	qrLabel.textColor = [UIColor whiteColor];
	qrLabel.textAlignment = NSTextAlignmentCenter;
	qrLabel.font = [UIFont systemFontOfSize:14];
	qrLabel.text = @"扫描二维码";
	[self.view addSubview:qrLabel];
	self.qrLabel = qrLabel;
	
	//手动添加按钮
	UIButton *manualButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[manualButton setBackgroundImage:[UIImage imageNamed:@"发光圆"] forState:UIControlStateNormal];
	[manualButton setImage:[UIImage imageNamed:@"手指"] forState:UIControlStateNormal];
//	manualButton.frame = CGRectMake(0, tabbarMinY - HRCommonScreenH *(104 +72), HRCommonScreenW * 72, HRCommonScreenW * 72);
//	manualButton.hr_centerX = self.view.hr_centerX + HRCommonScreenW *134;
	[manualButton addTarget:self action:@selector(manualButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:manualButton];
	self.manualButton = manualButton;
	
	CGSize rightSize = [@"手动添加" sizeWithAttributes:dict];
	//手动添加label
//	UILabel *manualLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(qrButton.frame) + HRCommonScreenH*10, rightSize.width, rightSize.height)];
//	manualLabel.hr_centerX = manualButton.hr_centerX;
	UILabel *manualLabel = [[UILabel alloc] init];
	manualLabel.backgroundColor = [UIColor clearColor];
	manualLabel.textColor = [UIColor whiteColor];
	manualLabel.textAlignment = NSTextAlignmentCenter;
	manualLabel.font = [UIFont systemFontOfSize:14];
	manualLabel.text = @"手动添加";
	[self.view addSubview:manualLabel];
	
	self.manualLabel = manualLabel;
	
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	[self.qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view).offset(- HRCommonScreenW * 134);
		make.bottom.equalTo(self.view).offset(- HRCommonScreenH * 64 - 49);
		
	}];
	[self.qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.qrLabel);
		make.bottom.equalTo(self.qrLabel.mas_top).offset(- HRCommonScreenH * 10);
		
	}];
	[self.manualLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.qrLabel);
		make.centerX.equalTo(self.view).offset(HRCommonScreenW * 134);
	}];
	[self.manualButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.manualLabel);
		make.bottom.equalTo(self.manualLabel.mas_top).offset(- HRCommonScreenH * 10);
		
	}];
}

#pragma mark - UI事件
- (void)qrcodeButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)manualButtonClick:(UIButton *)btn
{
	
}
#pragma mark - 全屏放回
- (void)backButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
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
