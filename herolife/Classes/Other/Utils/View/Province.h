//
//  Province.h
//  08-注册界面(了解)
//
//  Created by xiaomage on 15/9/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject

// 描述省有哪些城市
@property (nonatomic, strong) NSArray *cities;

// 描述省会名称
@property (nonatomic, strong) NSString *name;

+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
