//
//  OpenLockController.h
//  herolife
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceListModel.h"

@interface OpenLockController : UIViewController
//** 上个界面传过来的模型 */
@property(nonatomic, strong) DeviceListModel * listModel;

/** 授权给我的用户名*/

@property(nonatomic,copy)NSString * AuthorUserName;




@end
