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

static NSTimeInterval const dimissTimer = 2;
@interface RegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@property (nonatomic, weak)UITextField *userNameField;
@property (nonatomic, weak)UITextField *passwdField;
@property (nonatomic, weak)UITextField *passwdConfirmField;
@property (nonatomic, weak)UITextField *emailField;
@property (nonatomic, weak)UITextField *phoneField;

/** userNameField下划线 */
@property(nonatomic, weak) UIView *userLine;
/** passwdField下划线 */
@property(nonatomic, weak) UIView *passwdLine;
/** passwdConfirmField下划线 */
@property(nonatomic, weak) UIView *passwdConfirmLine;
/** emailField下划线 */
@property(nonatomic, weak) UIView *emailLine;
/** phoneField下划线 */
@property(nonatomic, weak) UIView *phoneLine;

/** 背景框view的Y值 */
@property(nonatomic, assign) CGRect backgroundViewFrame;
/** 背景框view */
@property(nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak)UIButton *registerButton;
@property (nonatomic, weak)UIButton *cancleBtn;
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;
@end

@implementation RegisterViewController



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        self.backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backgroundImage.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backgroundImage.image =[UIImage imageNamed:imgName];
    }
    
    
    
    NSLog(@"设置页面ViewWillappear");

}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setupViews];
	//全屏放回
	[self goBack];
	//监听器
	[self addObservers];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.backgroundViewFrame = self.backgroundView.frame;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	//动画
	[self setupAnimateWithIndex:0];
	[self.view endEditing:YES];
	
}


-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupViews
{
	
	self.navigationController.navigationBar.hidden = YES;
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] init];
	backgroundImage.image = [UIImage imageNamed:@"icon_bg.jpg"];
	[self.view addSubview:backgroundImage];
	self.backgroundImage = backgroundImage;
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:75 /255.0];
	backgroundView.layer.cornerRadius = 5;
	backgroundView.layer.masksToBounds = YES;
	[self.view addSubview:backgroundView];
	
	self.backgroundView = backgroundView;
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"注册";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
    
	[self.view addSubview:navView];
	self.navView = navView;
	
	//用户名
	self.userNameField = [self setupTextFieldWithImageName:@"用户" placeholder:@"用户名"];
    
    [self.userNameField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
	UIView *userLine = [[UIView alloc] init];
	userLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:userLine];
	self.userLine = userLine;
	
	//密码
	self.passwdField = [self setupTextFieldWithImageName:@"用户" placeholder:@"密码"];
    
    [self.passwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
	[self.passwdField setSecureTextEntry:YES];
	UIView *passwdLine = [[UIView alloc] init];
	passwdLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:passwdLine];
	self.passwdLine = passwdLine;
	
	//确认密码
	self.passwdConfirmField = [self setupTextFieldWithImageName:@"确认密码" placeholder:@"确认密码"];
    
    [self.passwdConfirmField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
	[self.passwdConfirmField setSecureTextEntry:YES];
    
	UIView *passwdConfirmLine = [[UIView alloc] init];
	passwdConfirmLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:passwdConfirmLine];
	self.passwdConfirmLine = passwdConfirmLine;
	
	//常用邮箱
	self.emailField = [self setupTextFieldWithImageName:@"邮箱" placeholder:@"常用邮箱"];
    [self.emailField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
	UIView *emailLine = [[UIView alloc] init];
    
	emailLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:emailLine];
	self.emailLine = emailLine;
	
	//手机号码
	self.phoneField = [self setupTextFieldWithImageName:@"手机" placeholder:@"手机号码"];
	[self.phoneField setReturnKeyType:UIReturnKeyGo];
    [self.phoneField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
	UIView *phoneLine = [[UIView alloc] init];
	phoneLine.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:phoneLine];
	self.phoneLine = phoneLine;
	//注册
	UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[registerButton setTitle:@"注册" forState:UIControlStateNormal];
	[registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	registerButton.layer.cornerRadius = 5;
	registerButton.layer.masksToBounds = YES;
	registerButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:75 /255.0];
	[registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
	[self.view addSubview:registerButton];
	self.registerButton = registerButton;
}

- (UITextField *)setupTextFieldWithImageName:(NSString *)imageName placeholder:(NSString *)placeholder
{
	UITextField *userNameField = [[UITextField alloc]init];
	userNameField.borderStyle = UITextBorderStyleNone;
	[userNameField setReturnKeyType:UIReturnKeyNext];
	userNameField.backgroundColor = [UIColor clearColor];
	userNameField.textColor = [UIColor whiteColor];
	[userNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
	//设置光标位置
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(0,0,HRCommonScreenW * 82,HRCommonScreenW * 100);
	[leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	leftButton.userInteractionEnabled = NO;
	leftButton.imageEdgeInsets = UIEdgeInsetsMake(HRCommonScreenW *32, HRCommonScreenW *20, HRCommonScreenW *32, HRCommonScreenW *20);
	
	userNameField.leftView = leftButton;
	userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	userNameField.leftViewMode = UITextFieldViewModeAlways;
	
	
	userNameField.font = [UIFont systemFontOfSize:14];
	userNameField.placeholder = placeholder;
	userNameField.textColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0];
	userNameField.delegate = self;
	[self.view addSubview:userNameField];
	return userNameField;
}
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
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
	
	[self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.top.equalTo(self.view);
	}];
	
	//背景框框
	[self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(HRCommonScreenW *86);
		make.right.equalTo(self.view).offset(- HRCommonScreenW *86);
		make.top.equalTo(self.backgroundImage.mas_top).offset(HRCommonScreenH *200 + 64);
		make.height.mas_equalTo(HRCommonScreenH *500);
	}];
	//用户名
	[self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.backgroundView);
		make.right.equalTo(self.backgroundView);
		make.top.equalTo(self.backgroundView);
		make.height.mas_equalTo(HRCommonScreenH *100);
	}];
	[self.userLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.userNameField);
		make.bottom.equalTo(self.userNameField);
		make.height.mas_equalTo(1);
	}];
	
	//密码
	[self.passwdField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.userNameField);
		make.top.equalTo(self.userNameField.mas_bottom);
		make.height.mas_equalTo(self.userNameField);
	}];
	[self.passwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.userLine);
		make.bottom.equalTo(self.passwdField.mas_bottom);
		make.height.mas_equalTo(self.userLine);
	}];
	
	//确认密码
	[self.passwdConfirmField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.passwdField);
		make.top.equalTo(self.passwdField.mas_bottom);
		make.height.mas_equalTo(self.passwdField);
	}];
	[self.passwdConfirmLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.userLine);
		make.bottom.equalTo(self.passwdConfirmField.mas_bottom);
		make.height.mas_equalTo(self.userLine);
	}];
	
	//常用邮箱
	[self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.passwdConfirmField);
		make.top.equalTo(self.passwdConfirmField.mas_bottom);
		make.height.mas_equalTo(self.passwdConfirmField);
	}];
	[self.emailLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.passwdConfirmLine);
		make.bottom.equalTo(self.emailField.mas_bottom);
		make.height.mas_equalTo(self.passwdConfirmLine);
	}];
	//手机号码
	[self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.emailField);
		make.top.equalTo(self.emailField.mas_bottom);
		make.height.mas_equalTo(self.emailField);
	}];
	[self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.emailLine).offset(5);
		make.right.equalTo(self.emailLine).offset(-5);
		make.bottom.equalTo(self.phoneField.mas_bottom);
		make.height.mas_equalTo(self.emailLine);
	}];
	
	//注册
	[self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.phoneField);
		make.top.equalTo(self.phoneField.mas_bottom).offset(HRCommonScreenH *50);
		make.height.mas_equalTo(HRCommonScreenH *80);
	}];

	
}
#pragma mark - 通知
- (void)addObservers
{
	[kNotification addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)showKeyboard:(NSNotification *)note
{
}
- (void)dealloc
{
	[kNotification removeObserver:self];
}
#pragma mark - UI事件
- (void)registerButtonClick:(UIButton *)btn
{
	[self.view endEditing:YES];
	//动画
	[self setupAnimateWithIndex:0];
	
	//判断密码
	if (![self.passwdField.text isEqualToString:self.passwdConfirmField.text]) {
		
		[SVProgressTool hr_showErrorWithStatus:@"两次输入的密码不一致,请重新输入!"];
		return;
	}
	//判断邮箱
	if (![self.emailField.text containsString:@"@"]) {
		[SVProgressTool hr_showErrorWithStatus:@"该邮箱号码格式错误,请重新输入!"];
		return;
	}
	//判断手机号码
	if (self.phoneField.text.length != 11) {
		[SVProgressTool hr_showErrorWithStatus:@"该手机号码格式错误,请重新输入!"];
		return;
	}
	if (self.userNameField.text.length > 0 && self.passwdField.text.length > 0 && self.passwdConfirmField.text.length > 0 && self.emailField.text.length > 0 && self.phoneField.text.length > 0) {
		
		
		
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"用户名或密码或确认密码或常用邮箱或手机号码不能为空!"];
		return;
	}
	
	[SVProgressTool hr_showWithStatus:@"正在注册..."];
	
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	parameters[@"name"] = self.userNameField.text;
	parameters[@"mail"] = self.emailField.text;
	parameters[@"pass"] = self.passwdField.text;
	parameters[@"pass2"] = self.passwdConfirmField.text;
	parameters[@"field_phone[und][0][value]"] = self.phoneField.text;
	
	
	[HRHTTPTool hr_postHttpWithURL:HRHTTP_UserRegister_URL parameters:parameters responseDict:^(id array, NSError *error) {
		if (array) {
			/// 这里返回的responseObject 不是json数据 是NSData数据
			
			[SVProgressHUD showSuccessWithStatus:@"注册成功!"];
			
			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			dict[@"user"] = self.userNameField.text;
			dict[@"pass"] = self.passwdConfirmField.text;
			[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegister object:nil userInfo:dict];
			[self.navigationController popViewControllerAnimated:YES];
			return ;
		}
		if (error) {
			
			DDLogDebug(@"注册失败error %@", error);
			[self showRegisterError:error openId:self.userNameField.text muString:self.passwdConfirmField.text];
		}
	}];

}

#pragma mark - 错误提示
- (void)showRegisterError:(NSError *)error openId:(NSString *)openId muString:(NSString *)muString
{
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	if (error == nil) {
		return;
	}
	NSDictionary *dict = error.userInfo;
	NSString * code = [NSString stringWithFormat:@"%@",[dict valueForKeyPath:@"statusCode"]];
	if ([code isEqualToString:@"200"]) {
		
		
		
		[SVProgressHUD showSuccessWithStatus:@"注册成功!"];
		
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[@"user"] = self.userNameField.text;
		dict[@"pass"] = self.passwdConfirmField.text;
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegister object:nil userInfo:dict];
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	NSString *str = [dict valueForKeyPath:@"body"];
	if (str) {
		DDLogInfo(@"str|%@|", str);
		NSScanner *theScanner;
		NSString *text = nil;
		theScanner = [NSScanner scannerWithString:str];
		
		while ([theScanner isAtEnd] == NO) {
			// find start of tag
			[theScanner scanUpToString:@"<" intoString:NULL] ;
			// find end of tag
			[theScanner scanUpToString:@">" intoString:&text] ;
			// replace the found tag with a space
			//(you can filter multi-spaces out later if you wish)
			str = [str stringByReplacingOccurrencesOfString:
				   [NSString stringWithFormat:@"%@>", text]
												 withString:@""];
		}
		DDLogInfo(@"str2|%@|", str);
		
		str = [str replaceUnicode:str];
		NSRange range1 = [str rangeOfString:@":{"];
		str = [str substringFromIndex:range1.location + 2];
		NSRange range2 = [str rangeOfString:@"}"];
		str = [str substringToIndex:range2.location - 1];
		NSString *description = [NSString stringWithFormat:@"%@  %@", code,str];
		DDLogInfo(@"description|%@|", description);
		[SVProgressHUD showErrorWithStatus:description  ];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[SVProgressHUD dismiss];
		});
	}else
	{
		
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if (textField == self.userNameField) {
		//动画
		[self setupAnimateWithIndex:1];
		
	} else if (textField == self.passwdField) {
		//动画
		[self setupAnimateWithIndex:2];
	} else if (textField == self.passwdConfirmField) {
		
		//动画
		[self setupAnimateWithIndex:3];
		
	}else if (textField == self.emailField) {
		NSString *pass = self.passwdField.text;
		DDLogInfo(@"length-------------------------%lu",(unsigned long)pass.length);
		if (self.passwdField.text.length < 0.1 &&self.passwdConfirmField.text.length < 0.1) {
			[SVProgressTool hr_showErrorWithStatus:@"密码或确认密码不能为空!"];
			return NO;
		}
		if (![self.passwdField.text isEqualToString:self.passwdConfirmField.text]) {
			[SVProgressTool hr_showErrorWithStatus:@"两次输入的密码不一样,请重新输入!"];
			return NO;
		}
		//动画
		[self setupAnimateWithIndex:4];
		
		
	}else if (textField == self.phoneField) {
		//动画
		[self setupAnimateWithIndex:5];
		
	}
	
	
	return YES;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.userNameField) {
		//动画
		[self setupAnimateWithIndex:1];
		return [self.passwdField becomeFirstResponder];
	} else if (textField == self.passwdField){
		[self setupAnimateWithIndex:2];
		return [self.passwdConfirmField becomeFirstResponder];
	} else if (textField == self.passwdConfirmField) {
		
		
		if (self.passwdField.text.length < 0.1 &&self.passwdConfirmField.text.length < 0.1) {
			[SVProgressTool hr_showErrorWithStatus:@"密码或确认密码不能为空!"];
			return NO;
		}
		if (![self.passwdField.text isEqualToString:self.passwdConfirmField.text]) {
			[SVProgressTool hr_showErrorWithStatus:@"两次输入的密码不一样,请重新输入!"];
			return NO;
		}
		[self setupAnimateWithIndex:3];
		return [self.emailField becomeFirstResponder];
	} else if (textField == self.emailField) {
		[self setupAnimateWithIndex:4];
		return [self.phoneField becomeFirstResponder];
	}else {
		[self setupAnimateWithIndex:5];
		[self registerButtonClick:self.registerButton];
		return [self.phoneField resignFirstResponder];
	}
}
//动画
- (void)setupAnimateWithIndex:(NSInteger)index
{
	
	//导航条
	[UIView animateWithDuration:0.25 animations:^{
		//背景框框
		[self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {

			make.top.equalTo(self.view).offset(64 + HRCommonScreenH *200 - HRCommonScreenH *50 * index);

		}];
		
	}completion:^(BOOL finished) {
		[self.view.layer removeAllAnimations];
	}];
	
}

@end
