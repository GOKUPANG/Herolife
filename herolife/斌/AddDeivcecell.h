//
//  AddDeivcecell.h
//  herolife
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeivcecell : UITableViewCell


/** 三个label*/

/** 设备图标 */
@property(nonatomic,strong)UIImageView * phoneImage;


/** 设备名称 */
@property(nonatomic,strong)UILabel * DeviceNameLabel ;

/** 进入图标 */
@property(nonatomic,strong)UIImageView * TurninImage;

/** 分割线*/

@property(nonatomic,strong)UIView *  FenGeXian;



@end
