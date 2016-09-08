//
//  HRRefreshHeader.m
//  herolife
//
//  Created by sswukang on 16/9/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRRefreshHeader.h"

@implementation HRRefreshHeader

- (void)prepare
{
	[super prepare];
	
	// 根据拖拽的情况自动切换透明度
	self.automaticallyChangeAlpha = YES;
	// 隐藏时间
	self.lastUpdatedTimeLabel.hidden = YES;
	self.stateLabel.textColor = [UIColor whiteColor];
	self.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
	// 设置文字颜色
}
/**
 *  摆放子控件
 */
- (void)placeSubviews
{
	[super placeSubviews];
	
}

@end
