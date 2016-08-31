//
//  AFHTTPSessionManager+Util.h
//  HuaruiAI
//
//  Created by sswukang on 15/11/26.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (Util)

+(instancetype) hrManager;

+ (instancetype)hrPostManager;

@end
