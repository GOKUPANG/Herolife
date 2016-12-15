//
//  HomeControllController.h
//  herolife
//
//  Created by sswukang on 2016/12/14.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceListModel;

@interface HomeControllController : UIViewController
/**设备模型 */
@property(nonatomic, strong) DeviceListModel *deviceModel;
@end
