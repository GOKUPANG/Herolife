//
//  WaitController.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "WaitController.h"

@interface WaitController ()
/** 头像 */
@property(nonatomic, weak) UIImageView *iconImage;
/** 动画图片 */
@property(nonatomic, weak) UIImageView *animImage;
/** 动画图片 */
@property(nonatomic, weak) UIView *animView;
/** 提示  label */
@property(nonatomic, weak) HRLabel *promptLabel;
/** 倒计时  label */
@property(nonatomic, weak) HRLabel *timeLabel;
/** 取消按钮 */
@property(nonatomic, weak) HRButton *cancelButton;
/** 头像底纹viwe */
@property(nonatomic, weak) UIView *eptView;
@end

@implementation WaitController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupViews];
}

#pragma mark - 内部方法
- (void)setupViews
{
	
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
	[self.view addSubview:backgroundImage];
	
	//头像底纹viwe
	UIView *eptView = [[UIView alloc] init];
	eptView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:eptView];
	self.eptView = eptView;
	
	//头像
	UIImageView *iconImage = [[UIImageView alloc] init];
	iconImage.image = [UIImage imageNamed:@"Default-568h@3x-1"];
	[self.view addSubview:iconImage];
	self.iconImage = iconImage;
	
	//动画图片
//	UIImageView *animImage = [[UIImageView alloc] init];
//	animImage.image = [UIImage imageNamed:@"Default-568h@3x-1"];
//	[self.view addSubview:animImage];
//	self.animImage = animImage;
	
	UIView *animView = [[UIView alloc] init];
	animView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:animView];
	self.animView = animView;
	
	
	//提示  label
	HRLabel *promptLabel = [[HRLabel alloc] init];
	promptLabel.text = @"正在添加智能门锁,请稍后...";
	[self.view addSubview:promptLabel];
	self.promptLabel = promptLabel;
	
	//倒计时  label
	HRLabel *timeLabel = [[HRLabel alloc] init];
	timeLabel.text = @"57秒";
	[self.view addSubview:timeLabel];
	self.timeLabel = timeLabel;
	
	//取消按钮
	HRButton *cancelButton = [HRButton buttonWithType:UIButtonTypeCustom];
	cancelButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[self.view addSubview:cancelButton];
	self.cancelButton = cancelButton;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	[self.eptView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.view).offset(HRCommonScreenH *178);
		make.centerX.equalTo(self.view);
		make.height.mas_equalTo(HRCommonScreenH *376);
		make.width.mas_equalTo(HRCommonScreenH *376);
		
	}];
	
	self.eptView.layer.cornerRadius = HRCommonScreenH *376*0.5;
	self.eptView.layer.masksToBounds = YES;
	
	
	[self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.eptView).offset(HRCommonScreenH *12);
		make.bottom.equalTo(self.eptView).offset(- HRCommonScreenH *12);
		make.left.equalTo(self.eptView).offset(HRCommonScreenH *12);
		make.right.equalTo(self.eptView).offset(- HRCommonScreenH *12);
		
	}];
	self.iconImage.layer.cornerRadius = HRCommonScreenH *352*0.5;
	self.iconImage.layer.masksToBounds = YES;
	
	[self.animView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.eptView.mas_bottom).offset(HRCommonScreenH *68);
		make.height.mas_equalTo(HRCommonScreenH *80);
		make.width.mas_equalTo(HRCommonScreenH *80);
		make.centerX.equalTo(self.eptView);
		
	}];
	self.animView.layer.cornerRadius = HRCommonScreenH *80*0.5;
	self.animView.layer.masksToBounds = YES;
	
	
	[self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.animView.mas_bottom).offset(HRCommonScreenH *320);
		make.centerX.equalTo(self.eptView);
		
	}];
	
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.promptLabel.mas_bottom).offset(HRCommonScreenH *10);
		make.centerX.equalTo(self.promptLabel);
		
	}];
	
	
	[self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.timeLabel.mas_bottom).offset(HRCommonScreenH *45);
		make.centerX.equalTo(self.promptLabel);
		make.height.mas_equalTo(HRCommonScreenH *134);
		make.width.mas_equalTo(HRCommonScreenH *134);
		
	}];
	
	self.cancelButton.layer.cornerRadius = HRCommonScreenH *134*0.5;
	self.cancelButton.layer.masksToBounds = YES;
}












@end
