//
//  NewFeatureCell.m
//  herolife
//
//  Created by sswukang on 16/10/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "NewFeatureCell.h"
#import "HRTabBarViewController.h"
#import "LoginController.h"


@interface NewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *startButton;

@end

@implementation NewFeatureCell

- (UIButton *)startButton
{
	if (_startButton == nil) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		
		_startButton = btn;
		
		btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
		btn.frame = CGRectMake(0, UIScreenH - 72 - 30, HRCommonScreenW * 240, HRCommonScreenH* 60);
		btn.hr_centerX = UIScreenW * 0.5;
		[btn setTitle:@"点击进入" forState:UIControlStateNormal];
		btn.layer.cornerRadius = 5;
		btn.layer.masksToBounds = YES;
		// 监听按钮点击
		[btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
		
		[self.contentView addSubview:btn];
	}
	return _startButton;
}

// 点击立即体验按钮的时候调用
- (void)start
{
	// 跳转到主框架界面
	// 跳转方式:push,modal
	
	// 创建tabBarVc
	LoginController *vc = [[LoginController alloc] init];
	
	// 切换窗口的根控制器进行跳转
	[UIApplication sharedApplication].keyWindow.rootViewController = vc;
	
	CATransition *anim = [CATransition animation];
	anim.type = @"rippleEffect";
	anim.duration = 1;
	[[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
	
}
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
	if (indexPath.row == count - 1) { // 判断下是否是最后一个cell
		
		// 显示体验按钮
		self.startButton.hidden = NO;
		
	}else{
		// 隐藏体验按钮
		self.startButton.hidden = YES;
	}
}

- (UIImageView *)imageView
{
	if (_imageView == nil) {
		UIImageView *imageV = [[UIImageView alloc] init];
		
		_imageView = imageV;
		
		[self.contentView addSubview:imageV];
	}
	
	return _imageView;
}

- (void)setImage:(UIImage *)image
{
	_image = image;
	
	self.imageView.image = image;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.95);
	
	self.imageView.frame = self.bounds;
}


@end
