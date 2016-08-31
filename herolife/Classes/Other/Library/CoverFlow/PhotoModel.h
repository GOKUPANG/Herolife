//
//  DeviceListController.h
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//
@import UIKit;

@interface PhotoModel : NSObject

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *imageDescription;

+ (instancetype)modelWithImageNamed:(NSString *)imageNamed
                        description:(NSString *)description;

@end
