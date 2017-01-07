//
//  testBut.m
//  xiaorui
//
//  Created by sswukang on 16/5/5.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "testBut.h"

@implementation testBut

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		
		self.backgroundColor = [UIColor redColor];
	}
	return self;
}
- (void)awakeFromNib
{
	[super awakeFromNib];
	self.backgroundColor = [UIColor colorWithR:39 G:180 B:245 alpha:1.0];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.layer.cornerRadius = self.hr_width * 0.5;
	
}

@end
