//
//  LoginController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "LoginController.h"
#import "RegisterViewController.h"

@interface LoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *passwdField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
//	self.backgroundImageView.image = [UIImage imageNamed:@"1 登录页.jpg"];
	self.backgroundImageView.image = [UIImage imageNamed:@""];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
	dict[NSAttachmentAttributeName] = [UIFont systemFontOfSize:20];
	self.passwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:dict];
	self.userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入帐号" attributes:dict];
	self.passwdField.delegate = self;
	self.userNameField.delegate = self;
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.userNameField) {
		return [self.passwdField becomeFirstResponder];
	}else
	{
		[self loginButtonClick:self.loginButton];
		return [self.passwdField resignFirstResponder];
	}
}
#pragma mark - UI事件
- (IBAction)loginButtonClick:(UIButton *)sender {
	NSLog(@"loginButtonClick");
}
- (IBAction)forgetButtonClick:(UIButton *)sender {
}
- (IBAction)registerButtonClick:(UIButton *)sender {
	RegisterViewController *registerVC = [[RegisterViewController alloc] init];
	[self presentViewController:registerVC animated:YES completion:nil];
}
- (IBAction)qqButtonClick:(UIButton *)sender {
	
}


@end
