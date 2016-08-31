//
//  HRTabBarButton.m
//  herolife
//
//  Created by sswukang on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRTabBarButton.h"

@implementation HRTabBarButton

- (void)setHighlighted:(BOOL)highlighted
{
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect rect = self.imageView.frame;
	rect.origin.y = 8;
	self.imageView.frame = rect;
	
	self.titleLabel.hr_centerX = self.imageView.hr_centerX;
	CGRect titleRect = self.titleLabel.frame;
	titleRect.origin.y = CGRectGetMaxY(rect) +2;
	self.titleLabel.frame = titleRect;
	
}
@end
