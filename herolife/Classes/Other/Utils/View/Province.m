//
//  Province.m
//  08-注册界面(了解)
//
//  Created by xiaomage on 15/9/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "Province.h"

@implementation Province


+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    Province *p = [[self alloc] init];
	
	p.cities = dict[@"indexs"];
	p.name = dict[@"brand"];
//    [p setValuesForKeysWithDictionary:dict];
	
    return p;
}

@end
