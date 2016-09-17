//
//  LoginController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "LoginController.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "UIView+XD.h"
#import "InputText.h"
#import "UIImageView+WebCache.h"
#import "HRTabBarViewController.h"
#import "ForgetController.h"
#import "HRServicesManager.h"
#import "HRTabBarViewController.h"
#import "RegisterViewController.h"

@interface LoginController ()<UITextFieldDelegate>
/** 背景图片 */
@property(nonatomic, weak)  UIImageView *backgroundImageView;
/** 用户名文本 */
@property(nonatomic, weak)  UITextField *userNameField;
/**  */
@property(nonatomic, weak) UILabel *userNameLabel;
/** 密码文本 */
@property(nonatomic, weak)  UITextField *passwdField;
/**  */
@property(nonatomic, weak) UILabel *passwdLabel;
/** 登陆按钮 */
@property(nonatomic, weak) UIButton *loginButton;
/** 账号下划线 */
@property(nonatomic, weak) UIView *userLine;
/** 密码下划线 */
@property(nonatomic, weak) UIView *passwdLine;
/** 忘记密码 */
@property(nonatomic, weak) UIButton *forgetButton;
/** 注册新帐号 */
@property(nonatomic, weak) UIButton *registerButton;
/** 忘记密码下划线 */
@property(nonatomic, weak) UIView *forgetLine;
/** 注册新帐号下划线 */
@property(nonatomic, weak) UIView *registerLine;
/** 底部透明view */
@property(nonatomic, weak) UIView *tabBarView;
/** UILabel */
@property(nonatomic, weak)  UILabel *loginLabel;
/** QQ第三方登陆 */
@property(nonatomic, weak)  UIButton *qqButton;
@property (nonatomic, assign) BOOL chang;


@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化view
	[self setupViews];
	//设置所有监听器
	[self setObserves];
}
- (void)setObserves
{
	[kNotification addObserver:self selector:@selector(recevedRegister:) name:kNotificationRegister object:nil];
}
- (void)dealloc
{
	[kNotification removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//	[self.userNameField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

}
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	//w375.000000h667.000000
	// 比例
//	CGFloat const HRCommonScreenH = HRUIScreenH / 667 /2;
//	CGFloat const HRCommonScreenW = HRUIScreenW / 375 /2;
	//底部条
	[self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self.view);
		make.height.mas_equalTo(HRCommonScreenH * 160);
	}];
	//第三方QQ按钮
	[self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(- HRCommonScreenH * 40);
		make.centerX.equalTo(self.view);
		make.height.mas_equalTo(HRCommonScreenH * 40);
		make.width.mas_equalTo(HRCommonScreenH * 40);
	}];
	//登陆labe
	[self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.qqButton.mas_top).offset(- HRCommonScreenH * 40);
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.tabBarView).offset(HRCommonScreenH * 16);
	}];
	DDLogInfo(@"w%fh%f",HRUIScreenW,HRUIScreenH);
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSAttachmentAttributeName] = [UIFont systemFontOfSize:28];
	//忘记密码按钮
	[self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.tabBarView.mas_top).offset(-HRCommonScreenH * 278);
		make.centerX.equalTo(self.view).offset(- HRCommonScreenW *80);
	}];
	//忘记密码下划线
	[self.forgetLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.forgetButton.mas_bottom);
		make.left.equalTo(self.forgetButton);
		make.centerX.equalTo(self.forgetButton);
		make.height.mas_equalTo(1);

	}];
	
	//注册按钮
	[self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.forgetButton);
		make.centerX.equalTo(self.view).offset(HRCommonScreenW *80);
		
	}];
	//注册下划线
	[self.registerLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.registerButton.mas_bottom);
		make.left.equalTo(self.registerButton);
		make.centerX.equalTo(self.registerButton);
		make.height.mas_equalTo(1);
		
	}];
	//登陆
	[self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.forgetButton.mas_top).offset(- HRCommonScreenH * 38);
		make.left.equalTo(self.view).offset(HRCommonScreenW * 30);
		make.right.equalTo(self.view).offset(- HRCommonScreenW * 30);
		make.height.mas_equalTo(HRCommonScreenH * 82);
		
	}];
	//密码下划线
	[self.passwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.loginButton.mas_top).offset(- HRCommonScreenH * 100);
		make.left.right.equalTo(self.loginButton);
		make.height.mas_equalTo(1);
		
	}];
	//密码
	[self.passwdField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.passwdLine).offset(3);
		make.left.equalTo(self.passwdLine).offset(HRCommonScreenW * 40);
		make.right.equalTo(self.passwdLine).offset(- HRCommonScreenW * 40);
		make.height.mas_equalTo(HRCommonScreenH * 60);
		
	}];
	[self.passwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.passwdLine).offset(3);
		make.left.equalTo(self.passwdLine).offset(HRCommonScreenW * 40);
		make.right.equalTo(self.passwdLine).offset(- HRCommonScreenW * 40);
		make.height.mas_equalTo(HRCommonScreenH * 60);
		
	}];
	//用户下划线
	[self.userLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.passwdLine.mas_top).offset(- HRCommonScreenH * 90);
		make.left.right.equalTo(self.loginButton);
		make.height.mas_equalTo(1);
		
	}];
	//用户
	[self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.userLine).offset(3);
		make.left.equalTo(self.passwdLine).offset(HRCommonScreenW * 40);
		make.right.equalTo(self.passwdLine).offset(- HRCommonScreenW * 40);
		make.height.mas_equalTo(self.passwdField.mas_height);
		
	}];
	//
	[self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.userLine).offset(3);
		make.left.equalTo(self.passwdLine).offset(HRCommonScreenW * 40);
		make.right.equalTo(self.passwdLine).offset(- HRCommonScreenW * 40);
		make.height.mas_equalTo(self.passwdField.mas_height);
		
	}];
	
}
#pragma mark - 通知
- (void)recevedRegister:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	NSString *user = dict[@"user"];
	NSString *pass = dict[@"pass"];
	self.userNameField.text = user;
	self.passwdField.text = pass;
	self.userNameLabel.text = @"";
	self.passwdLabel.text = @"";
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[self loginButtonClick:self.loginButton];
	});
}
#pragma mark - 内部方法
/**
 *  初始化view
 */
- (void)setupViews
{
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"icon_bg.jpg"];
	[self.view addSubview:backgroundImage];
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//用户名
	CGFloat centerX = self.view.width * 0.5;
	InputText *inputText = [[InputText alloc] init];
	CGFloat userY = 74;
	UITextField *userNameField = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
	userNameField.delegate = self;
	self.userNameField = userNameField;
	[userNameField setReturnKeyType:UIReturnKeyNext];
	userNameField.borderStyle = UITextBorderStyleNone;
	[userNameField setReturnKeyType:UIReturnKeyNext];
	userNameField.backgroundColor = [UIColor clearColor];
	userNameField.textColor = [UIColor whiteColor];
	[userNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
	userNameField.font = [UIFont systemFontOfSize:17];

	[self.view addSubview:userNameField];
	
	UILabel *userNameLabel = [self setupTextName:@"用户名" frame:userNameField.frame];
	userNameLabel.textColor = [UIColor whiteColor];
	self.userNameLabel = userNameLabel;
	[self.view addSubview:userNameLabel];
	
	//密码
	CGFloat passwordY = CGRectGetMaxY(userNameField.frame) + 5;
	UITextField *passwdField = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
	[passwdField setReturnKeyType:UIReturnKeyGo];
	passwdField.borderStyle = UITextBorderStyleNone;
	passwdField.backgroundColor = [UIColor clearColor];
	passwdField.textColor = [UIColor whiteColor];
	[passwdField setClearButtonMode:UITextFieldViewModeWhileEditing];

	passwdField.font = [UIFont systemFontOfSize:17];
	[passwdField setSecureTextEntry:YES];
	passwdField.delegate = self;
	self.passwdField = passwdField;
	
	[self.view addSubview:passwdField];
	
	UILabel *passwdLabel = [self setupTextName:[NSString stringWithFormat:@"密  \t码"] frame:passwdField.frame];
	passwdLabel.textColor = [UIColor whiteColor];
	self.passwdLabel = passwdLabel;
	[self.view addSubview:passwdLabel];

	
	
	//账号下划线
	UIView *userLine = [[UIView alloc] init];
	userLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:userLine];
	self.userLine = userLine;
	//密码下划线
	UIView *passwdLine = [[UIView alloc] init];
	passwdLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:passwdLine];
	self.passwdLine = passwdLine;
	
	//确认登陆
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[loginButton setTitle:@"确认登陆" forState:UIControlStateNormal];
	loginButton.tintColor = [UIColor whiteColor];
	loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
	loginButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
	loginButton.layer.borderWidth = 1;
	loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
	[loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];
	self.loginButton = loginButton;
	
	//忘记密码
	UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
	[forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[forgetButton setBackgroundColor:[UIColor clearColor]];
	[forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:forgetButton];
	self.forgetButton = forgetButton;
	//注册新帐号
	UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[registerButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
	[registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[registerButton setBackgroundColor:[UIColor clearColor]];
	[registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:registerButton];
	self.registerButton = registerButton;
	//忘记密码下划线
	UIView *forgetLine = [[UIView alloc] init];
	forgetLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:forgetLine];
	self.forgetLine = forgetLine;
	//注册新帐号下划线
	UIView *registerLine = [[UIView alloc] init];
	registerLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:registerLine];
	self.registerLine = registerLine;
	
	//底部透明view
	UIView *tabBarView = [[UIView alloc] init];
	tabBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:tabBarView];
	self.tabBarView = tabBarView;
	
	//其他登陆方式
	UILabel *loginLabel = [[UILabel alloc] init];
	loginLabel.text = @"其他登陆方式";
	loginLabel.font = [UIFont systemFontOfSize:14];
	loginLabel.textColor = [UIColor whiteColor];
	loginLabel.backgroundColor = [UIColor clearColor];
	[tabBarView addSubview:loginLabel];
	self.loginLabel = loginLabel;
	//第三方登陆
	UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[qqButton setImage:[UIImage imageNamed:@"形状-8"] forState:UIControlStateNormal];
	[qqButton addTarget:self action:@selector(qqButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[tabBarView addSubview:qqButton];
	self.qqButton = qqButton;
}
#pragma mark - UI事件

//忘记密码
- (void)forgetButtonClick:(UIButton *)button
{
	ForgetController *forgetVC = [[ForgetController alloc] init];
	[self.navigationController pushViewController:forgetVC animated:YES];
}
//注册
- (void)registerButtonClick:(UIButton *)button
{
	RegisterViewController *registerVC = [[RegisterViewController alloc] init];
	[self.navigationController pushViewController:registerVC animated:YES];
}
//第三方登陆事件
- (void)qqButtonClick:(UIButton *)button
{
	[ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
	DDLogWarn(@"---------------qqButtonClick------------------");
	//例如QQ的登录
	[ShareSDK getUserInfo:SSDKPlatformTypeQQ
		   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
	 {
		 DDLogWarn(@"---------------SSDKPlatformTypeQQ------------------");
		 if (state == SSDKResponseStateSuccess)
		 {
			 //1.首先获取到微信的openID，然后通过openID去后台数据库查询该微信的openID有没有绑定好的手机号.
			 //  2.如果没有绑定,首相第一步就是将微信用户的头像、昵称等等基本信息添加到数据库；然后通过手机获取验证码;最后绑定手机号。然后就登录App.
			 //  3.如果有，那么后台就返回一个手机号，然后通过手机登录App.
			 NSDictionary *ssdk = user.credential.rawData;
			 //保存openid,nickname
			 
			 DDLogWarn(@"openid=%@",[ssdk valueForKeyPath:@"openid"]);
			 NSString *openid = [ssdk valueForKeyPath:@"openid"];
			 [kNSUserDefaults setObject:openid forKey:kNSUserDefaultsOpenid];
			 NSString *nickname = user.nickname;
			 [kNSUserDefaults setObject:nickname forKey:kNSUserDefaultsNickname];
			 
			 //头像
			 NSDictionary *rawDict = user.rawData;
			 NSString *urlStr = [rawDict valueForKeyPath:@"figureurl_2"];
			 [kNSUserDefaults setObject:urlStr forKey:kNSUserDefaultsNickname];
			 
			 [self loginSSDKWithOpenID: openid];
			 
		 } else
		 {
			 DDLogWarn(@"error-000-----%@",error);
		 }
		 
	 }];
}

#pragma mark - 登陆授权 用OPENID 注册账号
- (void)loginSSDKWithOpenID:(NSString *)openid
{
	
	//加密
	NSString *muString = [NSString hr_stringWithBase64String:openid];
	
	[HRServicesManager loginWithUsername:openid
								password:muString
								  result:^(NSError *error) {
									  
									  
									  if (error) {
										  NSDictionary *dict = error.userInfo;
										  NSNumber * code = [dict valueForKeyPath:@"statusCode"];
										  NSString *codeString = [code stringValue];
										  //如果没有注册就去注册
										  if ([codeString isEqualToString:@"401"]) {
											  
											  [self registerWithOpenID:openid muString:muString];
											  
										  }
										  
									  } else {
										  
										  [SVProgressTool hr_dismiss];
										  HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
										  [self.navigationController pushViewController:tabBarVC animated:YES];
										  
									  }
								  }];
}

#pragma mark - 注册
- (void)registerWithOpenID:(NSString *)openId muString:(NSString *)muString
{
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	parameters[@"name"] = openId;
	parameters[@"mail"] = [NSString stringWithFormat:@"%@@gzhuarui.cn", openId];
	parameters[@"pass"] = muString;
	parameters[@"pass2"] = muString;
	DDLogWarn(@"-----测试-----parameters-000-----%@",parameters);
//	parameters[@"name"] = @"4EB2618888E358E8B777B0C03CC54BDE";
//	parameters[@"mail"] = @"4EB2618888E358E8B777B0C03CC54BDE@gzhuarui.cn";
//	parameters[@"pass"] =@"AHZ1VERZS2p9DRFkAX8jXyleAgE7BXdJW3V3YQE2DBw=";
//	parameters[@"pass2"] = @"AHZ1VERZS2p9DRFkAX8jXyleAgE7BXdJW3V3YQE2DBw=";

	
	[HRHTTPTool hr_postHttpWithURL:HRHTTP_UserRegister_URL parameters:parameters responseDict:^(id array, NSError *error) {
		if (array) {
			[SVProgressTool hr_dismiss];
			
			//注册成功之后登陆
			[HRServicesManager loginWithUsername:openId
										password:muString
										  result:^(NSError *error) {
											  
											  
											  if (error) {
												  [ErrorCodeManager showError:error];
												  
											  } else {
												  [SVProgressTool hr_dismiss];
												  HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
												  [self.navigationController pushViewController:tabBarVC animated:YES];
												  
											  }
										  }];
			
			
			return ;
		}
		if (error) {
			
			DDLogDebug(@"注册失败error %@", error);
			[self showRegisterError:error];
		}
	}];
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[self.view endEditing:YES];
	
	[self restoreTextName:self.userNameLabel textField:self.userNameField];
	[self restoreTextName:self.passwdLabel textField:self.passwdField];
	
}


- (void)loginButtonClick:(UIButton *)button
{
	[self backKeyBrody];
	
	if (self.userNameField.text.length == 0 && self.passwdField.text.length == 0) {
		
		[SVProgressTool hr_showErrorWithStatus:@"用户名或密码不能为空!"];
		return;
	}
	
	[SVProgressTool hr_showWithStatus:@"正在登陆..."];
	
	[HRServicesManager loginWithUsername:_userNameField.text
								password:_passwdField.text
								  result:^(NSError *error) {
									  
		  
		  if (error) {
			  [ErrorCodeManager showError:error];
			  
		  } else {
			  
			  [SVProgressTool hr_dismiss];
			  HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
			  [self.navigationController pushViewController:tabBarVC animated:YES];
			  
		  }
	  }];
	
}

//退出键盘
- (void)backKeyBrody
{
	[self.userNameField resignFirstResponder];
	[self.passwdField resignFirstResponder];
	
}

#pragma mark - 拷贝

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
	UILabel *textNameLabel = [[UILabel alloc] init];
	textNameLabel.text = textName;
	textNameLabel.font = [UIFont systemFontOfSize:18];
	textNameLabel.textColor = [UIColor grayColor];
	textNameLabel.frame = frame;
	return textNameLabel;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if (textField == self.userNameField) {
		[self diminishTextName:self.userNameLabel];
		[self restoreTextName:self.passwdLabel textField:self.passwdField];
		
	} else if (textField == self.passwdField) {
		[self diminishTextName:self.passwdLabel];
		[self restoreTextName:self.userNameLabel textField:self.userNameField];
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	if (textField == self.userNameField) {
		return [self.passwdField becomeFirstResponder];
	}else
	{
		[self loginButtonClick:self.loginButton];
		[self restoreTextName:self.passwdLabel textField:self.passwdField];
		return [self.passwdField resignFirstResponder];
	}
}
- (void)diminishTextName:(UILabel *)label
{
	[UIView animateWithDuration:0.5 animations:^{
		label.transform = CGAffineTransformMakeTranslation(0, -23);
		label.font = [UIFont systemFontOfSize:14];
	}];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
	[self textFieldTextChange:textFieled];
	if (self.chang) {
		[UIView animateWithDuration:0.5 animations:^{
			label.transform = CGAffineTransformIdentity;
			label.font = [UIFont systemFontOfSize:18];
		}];
	}else{
	}
	
}
- (void)textFieldTextChange:(UITextField *)textField
{
	if (textField.text.length != 0) {
		self.chang = NO;
		
	} else {
		self.chang = YES;
	}
}



#pragma mark - 错误提示
- (void)showRegisterError:(NSError *)error
{
//	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//	if (error == nil) {
//		return;
//	}
//	NSDictionary *dict = error.userInfo;
//	NSString * code = [dict valueForKeyPath:@"statusCode"];
//	NSString *str = [dict valueForKeyPath:@"body"];
//	if (str) {
//		DDLogInfo(@"str|%@|", str);
//		NSScanner *theScanner;
//		NSString *text = nil;
//		theScanner = [NSScanner scannerWithString:str];
//		
//		while ([theScanner isAtEnd] == NO) {
//			// find start of tag
//			[theScanner scanUpToString:@"<" intoString:NULL] ;
//			// find end of tag
//			[theScanner scanUpToString:@">" intoString:&text] ;
//			// replace the found tag with a space
//			//(you can filter multi-spaces out later if you wish)
//			str = [str stringByReplacingOccurrencesOfString:
//				   [NSString stringWithFormat:@"%@>", text]
//												 withString:@""];
//		}
//		DDLogInfo(@"str2|%@|", str);
//		
//		str = [str replaceUnicode:str];
//		NSRange range1 = [str rangeOfString:@":{"];
//		str = [str substringFromIndex:range1.location + 2];
//		NSRange range2 = [str rangeOfString:@"}"];
//		str = [str substringToIndex:range2.location - 1];
//		NSString *description = [NSString stringWithFormat:@"%@  %@", code,str];
//		DDLogInfo(@"description|%@|", description);
//		[SVProgressHUD showErrorWithStatus:description  ];
//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dimissTimer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//			[SVProgressHUD dismiss];
//		});
//	}else
//	{
//		
//		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
//	}
	
	
}

@end
