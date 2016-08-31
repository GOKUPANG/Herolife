//
//  HRInfraredDevice.h
//  HuaruiAI
//
//  Created by sswukang on 15/11/24.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

///红外设备类型
typedef NS_ENUM(NSInteger, HRInfraredDeviceType) {
	///通用类型
    HRInfraredDeviceTypeGeneral = 1,
	///空调
    HRInfraredDeviceTypeAir     = 2,
	///电视
	HRInfraredDeviceTypeTV     = 3
};

///红外设备
@interface HRInfraredDevice : NSObject

@property (nonatomic, assign) HRInfraredDeviceType deviceType;
@property (nonatomic, copy) NSString *name;



@end

@interface HRDODevice : NSObject

@end






