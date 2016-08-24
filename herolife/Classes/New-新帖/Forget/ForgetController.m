//
//  ForgetController.m
//  herolife
//
//  Created by sswukang on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ForgetController.h"

@interface ForgetController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** <#name#> */
@property(nonatomic, weak) UILabel *userNameLabel;
/** 用户名文本 */
@property(nonatomic, weak)  UITextField *userNameField;
/** <#name#> */
@property(nonatomic, weak) UIButton *passwdButton;
@end

@implementation ForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化
	[self setupViews];
	//全屏放回
	[self goBack];
	
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
}
#pragma mark - 内部方法
- (void)setupViews
{
	self.view.backgroundColor = [UIColor blueColor];
	self.navigationController.navigationBar.hidden = YES;
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"忘记密码";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
	[self.view addSubview:navView];
	self.navView = navView;
	
	//label
	UILabel *userNameLabel = [[UILabel alloc] init];
	userNameLabel.text = @"用户名或电子邮箱地址:";
	userNameLabel.font = [UIFont systemFontOfSize:17];
	userNameLabel.textColor = [UIColor whiteColor];
	userNameLabel.textAlignment = NSTextAlignmentLeft;
	[self.view addSubview:userNameLabel];
	self.userNameLabel = userNameLabel;
	
	//用户名
	UITextField *userNameField = [[UITextField alloc]init];
	userNameField.borderStyle = UITextBorderStyleNone;
	[userNameField setReturnKeyType:UIReturnKeyGo];
	userNameField.backgroundColor = [UIColor clearColor];
	userNameField.textColor = [UIColor whiteColor];
	[userNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
//	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//	dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//	dict[NSAttachmentAttributeName] = [UIFont systemFontOfSize:17];
//	userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:dict];
	//设置光标位置
	UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(HRCommonScreenW * 20,0,HRCommonScreenW * 20,26)];
	leftView.backgroundColor = [UIColor clearColor];
	userNameField.leftView = leftView;
	userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	userNameField.leftViewMode = UITextFieldViewModeAlways;
	
	userNameField.layer.cornerRadius = 5;
	userNameField.layer.masksToBounds = YES;
	userNameField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:75 /255.0];
	userNameField.font = [UIFont systemFontOfSize:17];
	userNameField.placeholder = @"请输入";
	[self.view addSubview:userNameField];
	self.userNameField = userNameField;
	self.userNameField.delegate = self;
	
	UIButton *passwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[passwdButton setTitle:@"邮寄新的密码" forState:UIControlStateNormal];
	[passwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	passwdButton.layer.cornerRadius = 5;
	passwdButton.layer.masksToBounds = YES;
	passwdButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:75 /255.0];
	[passwdButton addTarget:self action:@selector(passwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	passwdButton.titleLabel.font = [UIFont systemFontOfSize:17];
	[self.view addSubview:passwdButton];
	self.passwdButton = passwdButton;
	
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	[self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(HRCommonScreenW *50);
		make.top.equalTo(self.navView).offset(HRCommonScreenH *200);
	}];
	[self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(HRCommonScreenW *30);
		make.right.equalTo(self.view).offset(- HRCommonScreenW *30);
		make.top.equalTo(self.userNameLabel.mas_bottom).offset(HRCommonScreenH *12);
		make.height.mas_equalTo(HRCommonScreenH *80);
	}];
	[self.passwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.userNameField);
		make.top.equalTo(self.userNameField.mas_bottom).offset(HRCommonScreenH *40);
		make.height.mas_equalTo(HRCommonScreenH *80);
		make.width.mas_equalTo(HRCommonScreenW *236);
	}];
}
#pragma mark - UI事件
- (void)passwdButtonClick:(UIButton *)btn
{
	if (self.userNameField.text.length > 0) {
		
		[SVProgressTool hr_showSuccessWithStatus:@"发送成功!"];
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"用户名或电子邮箱地址不能为空!"];
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

#pragma mark - 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self passwdButtonClick: self.passwdButton];
	return [self.userNameField resignFirstResponder];
	
}
@end
