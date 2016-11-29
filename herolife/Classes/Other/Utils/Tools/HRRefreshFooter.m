//
//  HRRefreshFooter.m
//  herolife
//
//  Created by sswukang on 2016/11/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRRefreshFooter.h"

@implementation HRRefreshFooter

- (void)prepare
{
    [super prepare];
    
    // 根据拖拽的情况自动切换透明度
    self.automaticallyChangeAlpha = YES;
    // 隐藏时间
    self.stateLabel.textColor = [UIColor whiteColor];
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
