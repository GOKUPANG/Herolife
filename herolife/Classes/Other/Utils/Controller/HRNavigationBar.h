//
//  HRNavigationBar.h
//  herolife
//
//  Created by sswukang on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRNavigationBar : UIView
/** 标题label */
@property(nonatomic, weak) UILabel *titleLabel;
/** 左边 button */
@property(nonatomic, weak) UIButton *leftButton;
/** 右边Label */
@property(nonatomic, weak) UILabel *rightLabel;
@end
