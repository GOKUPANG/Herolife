//
//  RegisterViewController.m
//  xiaorui
//
//  Created by sswukang on 16/4/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "RegisterViewController.h"

//#import "AFHTTPSessionManager+Util.h"
//#import <AFNetworking.h>
#import "UIView+XD.h"
#import "InputText.h"



static NSTimeInterval const dimissTimer = 2;
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;
@property (nonatomic, weak)UITextField *emailText;
@property (nonatomic, weak)UILabel *emailTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;

@property (nonatomic, weak)UITextField *passwordTextRepeat;
@property (nonatomic, weak)UILabel *passwordTextNameRepeat;

@property (nonatomic, weak)UITextField *phoneText;
@property (nonatomic, weak)UILabel *phoneTextName;

@property (nonatomic, weak)UIImageView *userImageView;
@property (nonatomic, weak)UIImageView *emailImageView;
@property (nonatomic, weak)UIImageView *passwordImageView;
@property (nonatomic, weak)UIImageView *repPasswordImageView;
@property (nonatomic, weak)UIImageView *phoneImageView;
@property (nonatomic, weak)UIImageView *currentImageView;

@property (nonatomic, weak)UIButton *loginBtn;
@property (nonatomic, weak)UIButton *cancleBtn;

@property (nonatomic, assign) BOOL changUser;
@property (nonatomic, assign) BOOL changEmail;
@property (nonatomic, assign) BOOL changPsw;
@property (nonatomic, assign) BOOL changRep;
@property (nonatomic, assign) BOOL changPhone;
@property (nonatomic, assign) BOOL chang;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.hidden = NO;
	self.title = @"注册";
//	self.navigationItem.leftBarButtonItem = [UIBarButtonItem xmg_itemWithImage:<#(NSString *)#> highImage:<#(NSString *)#> target:<#(id)#> action:<#(SEL)#>]
	[self setupInputRectangle];
	
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.hidden = NO;
	
}
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self backKeyBrody];
//	[self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self backKeyBrody];
	//	[self.view endEditing:YES];
}
- (void)setupInputRectangle
{
	//用户名
	CGFloat centerX = self.view.width * 0.5;
	InputText *inputText = [[InputText alloc] init];
	CGFloat userY = 74;
	UITextField *userText = [inputText setupWithIcon:@"userName" textY:userY centerX:centerX point:nil];
	userText.delegate = self;
	self.userText = userText;
	self.userImageView = (UIImageView *)userText.leftView;
	[userText setReturnKeyType:UIReturnKeyNext];
	[userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:userText];
	
	UILabel *userTextName = [self setupTextName:@"用户名" frame:userText.frame];
	self.userTextName = userTextName;
	[self.view addSubview:userTextName];
	
	//密码
	CGFloat passwordY = CGRectGetMaxY(userText.frame) + 5;
	UITextField *passwordText = [inputText setupWithIcon:@"lock1" textY:passwordY centerX:centerX point:nil];
	[passwordText setReturnKeyType:UIReturnKeyNext];
	[passwordText setSecureTextEntry:YES];
	passwordText.delegate = self;
	self.passwordText = passwordText;
	self.passwordImageView = (UIImageView *)passwordText.leftView;
	[passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:passwordText];

	UILabel *passwordTextName = [self setupTextName:[NSString stringWithFormat:@"密  \t码"] frame:passwordText.frame];
	self.passwordTextName = passwordTextName;
	[self.view addSubview:passwordTextName];
	
	//确认密码
	CGFloat passwordRepeatY = CGRectGetMaxY(passwordText.frame) + 5;
	UITextField *passwordRepeat = [inputText setupWithIcon:@"lock1" textY:passwordRepeatY centerX:centerX point:nil];
	[passwordRepeat setReturnKeyType:UIReturnKeyNext];
	[passwordRepeat setSecureTextEntry:YES];
	passwordRepeat.delegate = self;
	self.passwordTextRepeat = passwordRepeat;
	self.repPasswordImageView = (UIImageView *)passwordRepeat.leftView;
	[passwordRepeat addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:passwordRepeat];
	
	UILabel *passwordRepeatTextName = [self setupTextName:@"确认密码" frame:passwordRepeat.frame];
	self.passwordTextNameRepeat = passwordRepeatTextName;
	[self.view addSubview:passwordRepeatTextName];
	
	//邮箱
	CGFloat emailY = CGRectGetMaxY(passwordRepeat.frame) + 5;
	UITextField *emailText = [inputText setupWithIcon:@"ic_email1" textY:emailY centerX:centerX point:nil];
	[emailText setReturnKeyType:UIReturnKeyNext];
	emailText.delegate = self;
	self.emailText = emailText;
	self.emailImageView = (UIImageView *)emailText.leftView;
	[emailText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:emailText];
	UILabel *emailTextName = [self setupTextName:@"常用邮箱" frame:emailText.frame];
	self.emailTextName = emailTextName;
	[self.view addSubview:emailTextName];
	
	//手机号码
	CGFloat phoneY = CGRectGetMaxY(emailText.frame) + 5;
	UITextField *phoneText = [inputText setupWithIcon:@"ic_phone1" textY:phoneY centerX:centerX point:nil];
	[phoneText setReturnKeyType:UIReturnKeyDone];
	[phoneText setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	phoneText.delegate = self;
	self.phoneText = phoneText;
	self.phoneImageView = (UIImageView *)phoneText.leftView;
	[phoneText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:phoneText];
	UILabel *phoneTextName = [self setupTextName:@"手机号码" frame:phoneText.frame];
	self.phoneTextName = phoneTextName;
	[self.view addSubview:phoneTextName];
	
	
	UIButton *loginBtn = [[UIButton alloc] init];
	loginBtn.width = HRUIScreenW *0.5 -50;
	
	loginBtn.height = 40;
	loginBtn.x = 20;
	loginBtn.y = CGRectGetMaxY(phoneText.frame) + 20;
	[loginBtn setTitle:@"注册" forState:UIControlStateNormal];
	[loginBtn setBackgroundColor:[UIColor colorWithRed:0 green:173 blue:255 alpha:1.0]];
	loginBtn.enabled = NO;
	loginBtn.layer.cornerRadius = loginBtn.height *0.5;
	self.loginBtn = loginBtn;
	
	[self loginBtnEnable];
	[loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginBtn];
	
	UIButton *cancelBtn = [[UIButton alloc] init];
	cancelBtn.width = loginBtn.width;
	cancelBtn.height = loginBtn.height;
	cancelBtn.x = HRUIScreenW - cancelBtn.width - 20;
	cancelBtn.y = CGRectGetMaxY(phoneText.frame) + 20;
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	[cancelBtn setBackgroundColor:[UIColor colorWithRed:0 green:173 blue:255 alpha:1.0]];
	cancelBtn.layer.cornerRadius = cancelBtn.height *0.5;
	self.cancleBtn = cancelBtn;
	[cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancelBtn];
}

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
	if (textField == self.userText) {
//		self.currentImageView.hidden = YES;
//		UIImageView *imageV = (UIImageView *)textField.leftView;
//		imageV.hidden = NO;
		[self diminishTextName:self.userTextName];
		[self restoreTextName:self.emailTextName textField:self.emailText];
		[self restoreTextName:self.passwordTextName textField:self.passwordText];
		[self restoreTextName:self.passwordTextNameRepeat textField:self.passwordTextRepeat];
		[self restoreTextName:self.phoneTextName textField:self.phoneText];
//		self.currentImageView = imageV;
		
	} else if (textField == self.passwordText) {
		self.userImageView.hidden = YES;
		self.passwordImageView.hidden = NO;
		self.repPasswordImageView.hidden = YES;
		self.emailImageView.hidden = YES;
		self.phoneImageView.hidden = YES;
//		self.currentImageView.hidden = YES;
//		UIImageView *imageV = (UIImageView *)textField.leftView;
//		imageV.hidden = NO;
		[self diminishTextName:self.passwordTextName];
		[self restoreTextName:self.userTextName textField:self.userText];
		[self restoreTextName:self.emailTextName textField:self.emailText];
		[self restoreTextName:self.passwordTextNameRepeat textField:self.passwordTextRepeat];
		[self restoreTextName:self.phoneTextName textField:self.phoneText];
//		self.currentImageView = imageV;
	} else if (textField == self.passwordTextRepeat) {
		self.userImageView.hidden = YES;
		self.passwordImageView.hidden = YES;
		self.repPasswordImageView.hidden = NO;
		self.emailImageView.hidden = YES;
		self.phoneImageView.hidden = YES;
//		self.currentImageView.hidden = YES;
//		UIImageView *imageV = (UIImageView *)textField.leftView;
//		imageV.hidden = NO;
		[self diminishTextName:self.passwordTextNameRepeat];
		[self restoreTextName:self.userTextName textField:self.userText];
		[self restoreTextName:self.emailTextName textField:self.emailText];
		[self restoreTextName:self.phoneTextName textField:self.phoneText];
		[self restoreTextName:self.passwordTextName textField:self.passwordText];
//		self.currentImageView = imageV;
	}else if (textField == self.emailText) {
		
		self.passwordImageView.hidden = YES;
		self.repPasswordImageView.hidden = YES;
		self.emailImageView.hidden = NO;
		self.phoneImageView.hidden = YES;
		self.userImageView.hidden = YES;
//		self.currentImageView.hidden = YES;
//		UIImageView *imageV = (UIImageView *)textField.leftView;
//		imageV.hidden = NO;
		[self diminishTextName:self.emailTextName];
		[self restoreTextName:self.userTextName textField:self.userText];
		[self restoreTextName:self.passwordTextName textField:self.passwordText];
		[self restoreTextName:self.passwordTextNameRepeat textField:self.passwordTextRepeat];
		[self restoreTextName:self.phoneTextName textField:self.phoneText];
//		self.currentImageView = imageV;
	}else if (textField == self.phoneText) {
		self.currentImageView.hidden = YES;
		UIImageView *imageV = (UIImageView *)textField.leftView;
		imageV.hidden = NO;
		[self diminishTextName:self.phoneTextName];
		[self restoreTextName:self.userTextName textField:self.userText];
		[self restoreTextName:self.emailTextName textField:self.emailText];
		[self restoreTextName:self.passwordTextName textField:self.passwordText];
		[self restoreTextName:self.passwordTextNameRepeat textField:self.passwordTextRepeat];
		self.currentImageView = imageV;
	}
	[self setUpHiddenImageViewWithTextField:textField];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.userText) {
		return [self.passwordText becomeFirstResponder];
	} else if (textField == self.passwordText){
		return [self.passwordTextRepeat becomeFirstResponder];
	} else if (textField == self.passwordTextRepeat) {
		return [self.emailText becomeFirstResponder];
	} else if (textField == self.emailText) {
		return [self.phoneText becomeFirstResponder];
	}else {
		[self loginBtnClick];
		[self restoreTextName:self.phoneTextName textField:self.phoneText];
		return [self.passwordText resignFirstResponder];
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
- (void)textFieldDidChange
{
	
	InputText *test = [[InputText alloc] init];
	test.iconImage.hidden = NO;
	if (self.userText.text.length != 0 && self.passwordText.text.length != 0 && self.passwordTextRepeat.text.length != 0 && self.emailText.text.length != 0 && self.phoneTextName.text.length != 0) {
		self.loginBtn.enabled = YES;
		[self loginBtnEnable];
		
	} else {
		self.loginBtn.enabled = NO;
		[self loginBtnEnable];
	}
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

	[self.view endEditing:YES];
	[self restoreTextName:self.userTextName textField:self.userText];
	[self restoreTextName:self.emailTextName textField:self.emailText];
	[self restoreTextName:self.passwordTextName textField:self.passwordText];
	[self restoreTextName:self.passwordTextNameRepeat textField:self.passwordTextRepeat];
	[self restoreTextName:self.phoneTextName textField:self.phoneText];
	
	[self setUpHiddenImageView];
}
#pragma mark - 判断 是否显示图片
- (void)setUpHiddenImageView
{
	//用户
	if (self.userText.text.length != 0) {
		self.userImageView.hidden = NO;
		
	}else{
		self.userImageView.hidden = YES;
	}
	//密码
	if (self.passwordText.text.length != 0) {
		self.passwordImageView.hidden = NO;
		
	}else{
		self.passwordImageView.hidden = YES;
	}
	//确认密码
	if (self.passwordTextRepeat.text.length != 0) {
		self.repPasswordImageView.hidden = NO;
		
	}else{
		self.repPasswordImageView.hidden = YES;
	}
	
	//email
	if (self.emailText.text.length != 0) {
		self.emailImageView.hidden = NO;
		
	}else{
		self.emailImageView.hidden = YES;
	}
	//手机
	if (self.phoneText.text.length != 0) {
		self.phoneImageView.hidden = NO;
		
	}else{
		self.phoneImageView.hidden = YES;
	}
}
- (void)setUpHiddenImageViewWithTextField:(UITextField *)textField
{
	if (textField == self.userText) {
		self.userImageView.hidden = NO;
		//密码
		if (self.passwordText.text.length != 0) {
			self.passwordImageView.hidden = NO;
			
		}else{
			self.passwordImageView.hidden = YES;
		}
		//确认密码
		if (self.passwordTextRepeat.text.length != 0) {
			self.repPasswordImageView.hidden = NO;
			
		}else{
			self.repPasswordImageView.hidden = YES;
		}
		
		//email
		if (self.emailText.text.length != 0) {
			self.emailImageView.hidden = NO;
			
		}else{
			self.emailImageView.hidden = YES;
		}
		//手机
		if (self.phoneText.text.length != 0) {
			self.phoneImageView.hidden = NO;
			
		}else{
			self.phoneImageView.hidden = YES;
		}

		
	} else if (textField == self.passwordText) {
		self.passwordImageView.hidden = NO;
		//用户
		if (self.userText.text.length != 0) {
			self.userImageView.hidden = NO;
			
		}else{
			self.userImageView.hidden = YES;
		}
		//确认密码
		if (self.passwordTextRepeat.text.length != 0) {
			self.repPasswordImageView.hidden = NO;
			
		}else{
			self.repPasswordImageView.hidden = YES;
		}
		
		//email
		if (self.emailText.text.length != 0) {
			self.emailImageView.hidden = NO;
			
		}else{
			self.emailImageView.hidden = YES;
		}
		//手机
		if (self.phoneText.text.length != 0) {
			self.phoneImageView.hidden = NO;
			
		}else{
			self.phoneImageView.hidden = YES;
		}

		
	} else if (textField == self.passwordTextRepeat) {
		self.repPasswordImageView.hidden = NO;
		//用户
		if (self.userText.text.length != 0) {
			self.userImageView.hidden = NO;
			
		}else{
			self.userImageView.hidden = YES;
		}
		//密码
		if (self.passwordText.text.length != 0) {
			self.passwordImageView.hidden = NO;
			
		}else{
			self.passwordImageView.hidden = YES;
		}
		
		//email
		if (self.emailText.text.length != 0) {
			self.emailImageView.hidden = NO;
			
		}else{
			self.emailImageView.hidden = YES;
		}
		//手机
		if (self.phoneText.text.length != 0) {
			self.phoneImageView.hidden = NO;
			
		}else{
			self.phoneImageView.hidden = YES;
		}

	}else if (textField == self.emailText) {
		self.emailImageView.hidden = NO;
		//用户
		if (self.userText.text.length != 0) {
			self.userImageView.hidden = NO;
			
		}else{
			self.userImageView.hidden = YES;
		}
		//密码
		if (self.passwordText.text.length != 0) {
			self.passwordImageView.hidden = NO;
			
		}else{
			self.passwordImageView.hidden = YES;
		}
		//确认密码
		if (self.passwordTextRepeat.text.length != 0) {
			self.repPasswordImageView.hidden = NO;
			
		}else{
			self.repPasswordImageView.hidden = YES;
		}
		
		//手机
		if (self.phoneText.text.length != 0) {
			self.phoneImageView.hidden = NO;
			
		}else{
			self.phoneImageView.hidden = YES;
		}

	}else if (textField == self.phoneText) {
		self.phoneImageView.hidden = NO;
		//用户
		if (self.userText.text.length != 0) {
			self.userImageView.hidden = NO;
			
		}else{
			self.userImageView.hidden = YES;
		}
		//密码
		if (self.passwordText.text.length != 0) {
			self.passwordImageView.hidden = NO;
			
		}else{
			self.passwordImageView.hidden = YES;
		}
		//确认密码
		if (self.passwordTextRepeat.text.length != 0) {
			self.repPasswordImageView.hidden = NO;
			
		}else{
			self.repPasswordImageView.hidden = YES;
		}
		
		//email
		if (self.emailText.text.length != 0) {
			self.emailImageView.hidden = NO;
			
		}else{
			self.emailImageView.hidden = YES;
		}

	}
	
}
static BOOL ispush = YES;
- (void)loginBtnClick
{
	[self backKeyBrody];
	//判断密码
	if (![self.passwordText.text isEqualToString:self.passwordTextRepeat.text]) {
		
		[SVProgressTool hr_showErrorWithStatus:@"两次输入的密码不一致,请重新输入!"];
		return;
	}
	//判断邮箱
	if (![self.emailText.text containsString:@"@"]) {
		[SVProgressTool hr_showErrorWithStatus:@"该邮箱号码格式错误,请重新输入!"];
		return;
	}
	//判断手机号码
	if (self.phoneText.text.length != 11) {
		[SVProgressTool hr_showErrorWithStatus:@"该手机号码格式错误,请重新输入!"];
		return;
	}
	[SVProgressTool hr_showWithStatus:@"正在注册..."];
//	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrPostManager];
//	
//	
//	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//	
//	parameters[@"name"] = self.userText.text;
//	parameters[@"mail"] = self.emailText.text;
//	parameters[@"pass"] = self.passwordText.text;
//	parameters[@"pass2"] = self.passwordTextRepeat.text;
//	parameters[@"field_phone[und][0][value]"] = self.phoneText.text;
//	
//	
//	[manager POST:HRAPI_XiaoRuiRegister_URL parameters: parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		
//		/// 这里返回的responseObject 不是json数据 是NSData数据
//	
//		[SVProgressHUD showSuccessWithStatus:@"注册成功!"];
//		
//		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//		dict[@"user"] = self.userText.text;
//		dict[@"pass"] = self.passwordTextRepeat.text;
//		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegister object:nil userInfo:dict];
//		[self.navigationController popViewControllerAnimated:YES];
//		
//		
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//		DDLogDebug(@"注册失败error %@", error);
//		[self showRegisterError:error];
//	}];

}
- (void)cancelBtnClick
{
	[self backKeyBrody];
	[self.navigationController popViewControllerAnimated:YES];
}
//退出键盘
- (void)backKeyBrody
{
	[self.userText resignFirstResponder];
	[self.passwordText resignFirstResponder];
	[self.passwordTextRepeat resignFirstResponder];
	[self.emailText resignFirstResponder];
	[self.phoneText resignFirstResponder];

}
- (void)loginBtnEnable
{
	if (self.loginBtn.enabled) {
		[self.loginBtn setBackgroundColor:[UIColor colorWithRed:0 green:173 blue:255 alpha:1.0]];
	}else{
		[self.loginBtn setBackgroundColor:[UIColor colorWithRed:0 green:173 blue:255 alpha:0.4]];
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
