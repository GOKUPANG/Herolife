//
//  HRButton.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRButton.h"

@implementation HRButton



- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		[self setTitle:@"取消" forState:UIControlStateNormal];
		self.titleLabel.font = [UIFont systemFontOfSize:17];
		self.titleLabel.textColor = [UIColor whiteColor];
	}
	return self;
}

@end
