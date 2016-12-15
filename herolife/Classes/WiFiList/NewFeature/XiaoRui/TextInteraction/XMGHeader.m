//
//  XMGHeader.m
//  6期-百思不得姐
//
//  Created by xiaomage on 15/12/11.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGHeader.h"

@interface XMGHeader()
/** logo */
@property (nonatomic, weak) UIImageView *logoView;
@end

@implementation XMGHeader

- (void)prepare
{
    [super prepare];
    
//    UIImageView *logoView = [[UIImageView alloc] init];
//    logoView.image = [UIImage imageNamed:@"ico_login_xiaorui"];
//    [self addSubview:logoView];
//    self.logoView = logoView;
	
    // 根据拖拽的情况自动切换透明度
    self.automaticallyChangeAlpha = YES;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字颜色
//    self.stateLabel.textColor = [UIColor yellowColor];
}
/**
 *  摆放子控件
 */
- (void)placeSubviews
{
    [super placeSubviews];
    
//    self.logoView.hr_x = 0;
//    self.logoView.hr_width = self.hr_width * 0.5;
//    self.logoView.hr_height = 100;
//    self.logoView.hr_y = - self.logoView.hr_height;
}
@end
