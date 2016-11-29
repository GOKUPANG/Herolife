//
//  XiaoRuiNewQRcode.m
//  xiaorui
//
//  Created by sswukang on 16/7/19.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "XiaoRuiNewQRcode.h"

#import "QRCodeController.h"
#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AddNewDeviceViewController.h"
#import "CreateXiaoRui.h"
#import "HRQrButton.h"
#import "ManualController.h"

@interface XiaoRuiNewQRcode ()
/** 保存扫描到的数据 */
@property(nonatomic, copy) NSString *arText;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

/** 二维码按钮 */
@property(nonatomic, weak) HRQrButton *qrButton;
/** 二维码Label */
@property(nonatomic, weak) UILabel *qrLabel;
/** 手动添加按钮 */
@property(nonatomic, weak) HRQrButton *manualButton;
/** 手动添加label */
@property(nonatomic, weak) UILabel *manualLabel;
/** <#name#> */
@property(nonatomic, weak) HRNavigationBar *navView;

@end
@implementation XiaoRuiNewQRcode

+ (instancetype)shareXiaoRuiNewQRcode
{
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setupViews];
}
//- (IBAction)addButtonClick:(UIButton *)sender {
//	[kNotification postNotificationName:kNotificationQRCodeManualCreateXiaoRui object:nil];
//}
- (IBAction)qrCodeButton:(UIButton *)sender {
	QRTools *qrTools = [[QRTools alloc] init];
	[qrTools intoQRCodeVC];
}
- (void)setupViews
{
	
	
	HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, HRUIScreenW, HRNavH)];
	navView.titleLabel.text = @"添加设备";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	self.navView = navView;
	[self addSubview:navView];
	
    
	/// 自己添加的按钮
	//二维码按钮
	HRQrButton *leftButton= [HRQrButton buttonWithType:UIButtonTypeCustom];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"新增二维码"] forState:UIControlStateNormal];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"新增发光二维"] forState:UIControlStateSelected];
	[leftButton addTarget:self action:@selector(qrcodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:leftButton];
	
	self.qrButton = leftButton;
	
	
	UILabel *qrLabel = [[UILabel alloc] init];
	qrLabel.hr_centerX = leftButton.hr_centerX;
	qrLabel.backgroundColor = [UIColor clearColor];
	qrLabel.textColor = [UIColor whiteColor];
	qrLabel.textAlignment = NSTextAlignmentCenter;
	qrLabel.font = [UIFont systemFontOfSize:14];
	qrLabel.text = @"扫描添加";
	
	[self addSubview:qrLabel];
	self.qrLabel = qrLabel;
	
	//手动添加按钮
	HRQrButton *rightButton= [HRQrButton buttonWithType:UIButtonTypeCustom];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"新增手动"] forState:UIControlStateNormal];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"新增发光手"] forState:UIControlStateSelected];
	[rightButton addTarget:self action:@selector(manualButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:rightButton];
	self.manualButton = rightButton;
	
	UILabel *rightLabel = [[UILabel alloc] init];
	rightLabel.hr_centerX = rightButton.hr_centerX;
	rightLabel.backgroundColor = [UIColor clearColor];
	rightLabel.textColor = [UIColor whiteColor];
	rightLabel.textAlignment = NSTextAlignmentCenter;
	rightLabel.font = [UIFont systemFontOfSize:14];
	rightLabel.text = @"按类型添加";
	
	[self addSubview:rightLabel];
	self.manualLabel = rightLabel;
	
	self.qrButton.showsTouchWhenHighlighted = NO;
	self.manualButton.showsTouchWhenHighlighted = NO;
	self.manualButton.showsTouchWhenHighlighted = NO;
	self.manualButton.highlighted = NO;
	
}
- (void)layoutSubviews
{
	[super layoutSubviews];
		
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self);
		make.top.equalTo(self).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	[self.qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self).offset(- HRCommonScreenW * 134);
		make.bottom.equalTo(self).offset(- HRCommonScreenH * 64 - 49);
		
	}];
	[self.qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.qrLabel);
		make.bottom.equalTo(self.qrLabel.mas_top).offset(- HRCommonScreenH * 10);
		make.height.width.mas_offset(45);
		
	}];
	[self.manualLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.qrLabel);
		make.centerX.equalTo(self).offset(HRCommonScreenW * 134);
	}];
	[self.manualButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.manualLabel);
		make.bottom.equalTo(self.manualLabel.mas_top).offset(- HRCommonScreenH * 10);
		make.height.width.mas_offset(45);
		
	}];
	
}
#pragma mark - UI事件
- (void)qrcodeButtonClick:(UIButton *)btn
{
	self.qrButton.selected = YES;
	self.manualButton.selected = NO;
}
- (void)manualButtonClick:(UIButton *)btn
{
	self.qrButton.selected = NO;
	self.manualButton.selected = YES;
	UINavigationController *nav = (UINavigationController *)[NSObject activityViewController];
	for (UIViewController *VC in nav.childViewControllers) {
		
		DDLogInfo(@"NSStringFromClass%@", NSStringFromClass([VC class]));
		
		if ([NSStringFromClass([VC class]) isEqualToString:@"HRNavigationViewController"]) {
			UINavigationController *navi = (UINavigationController *)VC;
            for (UIViewController *fistVC in navi.childViewControllers) {
            
			
			DDLogInfo(@"HRNavigationViewController.subviews%@", NSStringFromClass([fistVC class]));
			if ([NSStringFromClass([fistVC class]) isEqualToString:@"AddNewDeviceViewController"]) {
                
                AddNewDeviceViewController *addNew = (AddNewDeviceViewController *)fistVC;
				ManualController *manulVC = [[ManualController alloc] init];
				
				[addNew.navigationController pushViewController:manulVC animated:NO];
                return;
			}
            
            }
		}
	}
	
}



@end
