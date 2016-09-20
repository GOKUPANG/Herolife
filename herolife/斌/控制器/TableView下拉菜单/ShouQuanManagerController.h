//
//  ShouQuanManagerController.h
//  herolife
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceAutherModel;
@class DeviceListModel;
@interface ShouQuanManagerController : UIViewController

/** 授权表模型数组 */
@property(nonatomic, strong) NSMutableArray<DeviceAutherModel *> *deviceAutherArray;
/** 传过来的上一个界面点击那一刻 的数据模型 */
@property(nonatomic, strong) DeviceListModel *listModel;
@end
