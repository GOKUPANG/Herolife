
//
//  HRSceneData.m
//  xiaorui
//
//  Created by sswukang on 16/7/7.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRSceneData.h"

@implementation HRSceneData
+ (instancetype)hrsceneDataWithDict:(NSDictionary *)dict
{
	HRSceneData *data = [[HRSceneData alloc] init];
	data.data = dict[@"data"];
	return data;
}
@end
