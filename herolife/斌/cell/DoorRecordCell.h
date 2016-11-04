//
//  DoorRecordCell.h
//  herolife
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DoorLockModel;
@interface DoorRecordCell : UITableViewCell

/** 三个label*/

/** 时间 */
@property(nonatomic,strong)UILabel * timeLabel;

/** 用户名 */
@property(nonatomic,strong)UILabel * userNameLabel ;

/** 操作记录 */
@property(nonatomic,strong)UILabel * recordLabel;
/** 选中图片 */
@property(nonatomic, weak) UIImageView *selectImageView;
/** <#name#> */
@property(nonatomic, strong) DoorLockModel *lockModel;







@end
