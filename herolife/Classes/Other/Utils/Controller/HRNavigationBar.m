//
//  HRNavigationBar.m
//  herolife
//
//  Created by sswukang on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRNavigationBar.h"

@interface HRNavigationBar ()

@end

@implementation HRNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		//标题
		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.font = [UIFont systemFontOfSize: 18];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
		[self addSubview:titleLabel];
		self.titleLabel = titleLabel;
		//左边view
		UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, - HRCommonScreenW *30, 5, HRCommonScreenW - HRCommonScreenW *30);
		[self addSubview:leftButton];
		self.leftButton = leftButton;
		
		//右边label
		UILabel *rightLabel = [[UILabel alloc] init];
		rightLabel.font = [UIFont systemFontOfSize: 14];
		rightLabel.textAlignment = NSTextAlignmentCenter;
		rightLabel.textColor = [UIColor whiteColor];
		[self addSubview:rightLabel];
		self.rightLabel = rightLabel;
		
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
	}];
	
	[self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(0);
		make.bottom.equalTo(self).offset(0);
		make.top.equalTo(self).offset(0);
		make.width.mas_offset(HRNavH);
	}];
	[self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(- HRCommonScreenW *30);
		make.centerY.equalTo(self);
	}];
}
#pragma mark - UI事件
- (void)leftButtonClick:(UIButton *)btn
{
	UINavigationController *nav = (UINavigationController *)[NSObject activityViewController];
	UIViewController *VC = nav.childViewControllers.lastObject;
	
	DDLogWarn(@"%@", NSStringFromClass([VC class]));
	if ([@"HRTabBarViewController" isEqualToString:NSStringFromClass([VC class]) ]) {
		
	}else
	{
		
		[VC.navigationController popViewControllerAnimated:YES];
	}
}
@end
