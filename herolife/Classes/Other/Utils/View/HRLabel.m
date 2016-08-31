//
//  HRLabel.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRLabel.h"

@implementation HRLabel

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		self.font = [UIFont systemFontOfSize:17];
		self.textAlignment = NSTextAlignmentCenter;
		self.textColor = [UIColor whiteColor];
		
	}
	return self;
}
@end
