//
//  AddLockController.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AddLockController.h"
#import "HRTabBarViewController.h"

@interface AddLockController ()<UITextFieldDelegate>
/**  */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 打钩按钮 */
@property(nonatomic, weak) UIButton *gouButton;
/**成功添加智能门锁Label  */
@property(nonatomic, weak) HRLabel *lockLabel;
/** 请输入设备名称:Label */
@property(nonatomic, weak) HRLabel *deviceNameLabel;
/** 设备名称TextField */
@property(nonatomic, weak) UITextField *nameField;
/** 线 */
@property(nonatomic, weak) UIView *lineView;
/** 保存按钮 */
@property(nonatomic, weak) HRButton *saveButton;

@end

@implementation AddLockController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//初始化
	[self setupViews];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	DDLogWarn(@"AddLockController--------viewDidAppear");
}
- (void)setupViews
{
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
	[self.view addSubview:backgroundImage];
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	self.navigationController.navigationBar.hidden = YES;
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"添加成功";
	navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
	[self.view addSubview:navView];
	self.navView = navView;
	
	// 打钩按钮
	UIButton *gouButton = [UIButton buttonWithType:UIButtonTypeCustom];
	gouButton.userInteractionEnabled = NO;
	[gouButton setBackgroundImage:[UIImage imageNamed:@"成功"] forState:UIControlStateNormal];
	[self.view addSubview:gouButton];
	self.gouButton = gouButton;
	
	//成功添加智能门锁Label
	HRLabel *lockLabel = [[HRLabel alloc] init];
	lockLabel.text = @"成功添加智能门锁";
	[self.view addSubview:lockLabel];
	self.lockLabel = lockLabel;
	
	//设备名称TextField
	UITextField *nameField = [[UITextField alloc] init];
	nameField.textColor = [UIColor whiteColor];
	nameField.backgroundColor = [UIColor clearColor];
	
	nameField.borderStyle = UITextBorderStyleNone;
	[nameField setReturnKeyType:UIReturnKeyGo];
	nameField.backgroundColor = [UIColor clearColor];
	nameField.textColor = [UIColor colorWithRed:204 /255.0 green:204 /255.0  blue:204 /255.0  alpha:1.0];
	[nameField setClearButtonMode:UITextFieldViewModeWhileEditing];
	
	nameField.font = [UIFont systemFontOfSize:17];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSForegroundColorAttributeName] = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0];
	dict[NSAttachmentAttributeName] = [UIFont systemFontOfSize:17];
	nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入设备名称:" attributes:dict];
	nameField.delegate = self;
	[self.view addSubview:nameField];
	self.nameField = nameField;

	//线
	UIView *lineView = [[UIView alloc] init];
	lineView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:lineView];
	self.lineView = lineView;
	
	//保存按钮
	HRButton *saveButton = [HRButton buttonWithType:UIButtonTypeCustom];
	[saveButton setTitle:@"保存" forState:UIControlStateNormal];
	saveButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
	[saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside	];
	[self.view addSubview:saveButton];
	self.saveButton = saveButton;
	
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
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
	
	
	[self.gouButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH *76);
		make.centerX.equalTo(self.view);
	}];
	
	
	[self.lockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.gouButton.mas_bottom).offset(HRCommonScreenH *20);
		make.centerX.equalTo(self.view);
	}];
	
	
	[self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.lockLabel.mas_bottom).offset(HRCommonScreenH *215);
		make.centerX.equalTo(self.view);
		make.left.equalTo(self.view).offset(HRCommonScreenW *30);
	}];
	
	[self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.nameField.mas_bottom).offset(HRCommonScreenH *10);
		make.centerX.equalTo(self.view);
		make.left.equalTo(self.view).offset(HRCommonScreenW *10);
		make.height.mas_equalTo(1);
	}];
	
	
	[self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.lineView.mas_bottom).offset(HRCommonScreenH *100);
		make.centerX.equalTo(self.view);
		make.width.mas_equalTo(HRCommonScreenW * 260);
		make.height.mas_equalTo(HRCommonScreenH * 80);
	}];
	
	self.saveButton.layer.cornerRadius = HRCommonScreenH * 80 *0.5;
	self.saveButton.layer.masksToBounds = YES;
	
	
}
#pragma mark - UI事件
- (void)saveButtonClick:(UIButton *)btn
{
	[self.view endEditing:YES];
	
	[self createModifyLock];
}
- (void)createModifyLock
{
	if (self.nameField.text.length < 1) {
		[SVProgressTool hr_showErrorWithStatus:@"设备名不能为空!"];
		return;
	}
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"type"] = @"hrsc";
	parameters[@"title"] = self.nameField.text;
	
	DDLogWarn(@"parameters--%@---", parameters);
	NSString *httplast = [NSString stringWithFormat:@"%@%@", HRAPI_ModifyLock_URL, self.did];
	[HRHTTPTool hr_PutHttpWithURL:httplast parameters:parameters responseDict:^(id dictionary, NSError *error) {
		
		DDLogWarn(@"array--%@---error---%@", dictionary,error);
		if (error) {
			[ErrorCodeManager showError:error];
			return ;
		}
		NSDictionary *dict = (NSDictionary *)dictionary;
		if ([dict valueForKeyPath:@"nid"]) {
			
			[SVProgressTool hr_showSuccessWithStatus:@"添加成功!"];
			[self goToHomeList];
		}
		
	}];

}
- (void)goToHomeList
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = NO;
			for (UIButton *btn in view.subviews) {
				if (btn.tag == 1) {
					btn.selected = NO;
				}
				
				if (btn.tag == 2) {
					btn.selected = YES;
				}
			}
		}
	}
	self.tabBarController.selectedIndex = 1;
	[self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self saveButtonClick:self.saveButton];
	return YES;
}







@end
