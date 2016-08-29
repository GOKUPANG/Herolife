//
//  WiFiListCell.h
//  herolife
//
//  Created by sswukang on 16/8/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WiFiListCell : UITableViewCell

/** 打钩 图片 */
@property(nonatomic, weak)  UIImageView *leftImage;
/** 文字 */
@property(nonatomic, weak) UILabel *leftLabel;
/** 锁图标 按钮 */
@property(nonatomic, weak) UIButton *LockButton;
/** wifi信号图片 */
@property(nonatomic, weak) UIImageView *wifiImage;
/** 线 */
@property(nonatomic, weak) UIView *lineView;
@end
