//
//  DoorLockRecordConroller.h
//  herolife
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceListModel;

@interface DoorLockRecordConroller : UIViewController

/** name */
@property(nonatomic, strong) DeviceListModel *listModel;

/** 授权用户用户名 */
@property(nonatomic,copy)NSString * AuthorUserName ;

@end
