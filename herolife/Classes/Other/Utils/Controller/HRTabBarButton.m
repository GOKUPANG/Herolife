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
	self.imageView.hr_centerX = self.hr_width * 0.5;
	self.imageView.hr_y = 5;
	self.titleLabel.hr_y = self.imageView.hr_height + 4;
	self.titleLabel.hr_height = self.hr_height - self.titleLabel.hr_y ;
	self.titleLabel.hr_centerX = self.hr_width * 0.5;
}
@end
