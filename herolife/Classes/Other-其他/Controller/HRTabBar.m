//
//  HRTabBar.m
//  herolife
//
//  Created by sswukang on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRTabBar.h"
#import "HRTabBarButton.h"

@interface HRTabBar()
/** 扫描 */
@property(nonatomic, weak) HRTabBarButton *qrButton;
/** 首页 */
@property(nonatomic, weak) HRTabBarButton *homeButton;
/** 设置 */
@property(nonatomic, weak) HRTabBarButton *setButton;
@property (nonatomic, weak) UIButton *selectdeBtn;
@end
@implementation HRTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
		self.qrButton = [self setupButtonWithImage:@"扫描白" selectImage:@"扫描蓝" tag:1 title:@"扫描"];
		self.homeButton = [self setupButtonWithImage:@"首页白" selectImage:@"首页蓝" tag:2 title:@"首页"];
		self.qrButton = [self setupButtonWithImage:@"设置白" selectImage:@"设置蓝" tag:3 title:@"设置"];
		[self btnClick:self.homeButton];
	}
	return self;
}
- (HRTabBarButton *)setupButtonWithImage:(NSString *)image selectImage:(NSString *)selectImage tag:(NSInteger)tag title:(NSString *)title
{
	HRTabBarButton *button = [HRTabBarButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithRed:196.0 / 255 green:238.0/ 255 blue:253.0/ 255 alpha:1.0] forState:UIControlStateSelected];
	button.titleLabel.font = [UIFont systemFontOfSize:14];
	[button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = tag;
	[self addSubview:button];
	return button;
}
// 点击tabBar上的按钮就会调用
- (void)btnClick:(UIButton *)btn
{
	_selectdeBtn.selected = NO;
	btn.selected = YES;
	_selectdeBtn = btn;
	
	// 通知tabBarVc切换控制器
	if ([_delegate respondsToSelector:@selector(hrTabBar:didClickBtn:)]) {
		[_delegate hrTabBar:self didClickBtn:btn.tag];
	}
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGFloat btnW = self.hr_width / 3;
	CGFloat btnH = self.hr_height;
	CGFloat btnX = 0;
	CGFloat btnY = 0;
	for (int i = 0; i < 3; i++) {
		
		UIButton *btn = self.subviews[i];
		
		btnX = i * btnW;
		
		btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
	}
	
}
@end
