//
//  TipsLabel.m
//  xiaorui
//
//  Created by sswukang on 16/5/4.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "TipsLabel.h"

@interface TipsLabel ()

/** timer */
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation TipsLabel
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		self.opaque = false;
		self.hidden = true;
		self.textColor = [UIColor whiteColor];
		self.font = [UIFont systemFontOfSize:15];
		self.textAlignment = NSTextAlignmentCenter;
		self.backgroundColor = [UIColor colorWithRed:244/255.0 green:162/255.0 blue:0/255.0 alpha:1];
		self.hr_height = frame.size.height;
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
}
- (void)showText:(NSString *)text duration:(double)duration
{
	if (!self.hidden) {  //如果还显示
		//先隐藏
		[UIView animateWithDuration:0.3 animations:^{
			
			self.alpha = 0;
		} completion:^(BOOL finished) {
			self.hidden = YES;
			[self showText:text duration:duration];
		}];
		return;
	}
	
	self.text = text;
	self.hidden = NO;
	
	[UIView animateWithDuration:0.3 animations:^{
		
		self.alpha = 1;
	} completion:nil];
	
	if (_timer != nil){
		[_timer invalidate];
	}
	
	_timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timeup:) userInfo:nil repeats:NO];
	
}

- (void)timeup:(NSTimer *)timer
{
	if (!self.hidden) {
		[self dismiss];
	}
}
- (void)dismiss
{
	[UIView animateWithDuration:0.3 animations:^{
		
		self.alpha = 0;
	} completion:^(BOOL finished) {
		self.hidden = YES;
	}];
}



@end
