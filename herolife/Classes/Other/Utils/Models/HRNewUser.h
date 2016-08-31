//
//  HRNewUser.h
//  xiaorui
//
//  Created by sswukang on 16/5/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRNewUser : NSObject

///用户ID
@property (nonatomic, copy) NSString *uid;
///名字
@property (nonatomic, copy)  NSString *name;
///邮箱
@property (nonatomic, copy) NSString *mail;
///主题
@property (nonatomic, copy) NSString *theme;

@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *signature_format;
///创建时间
@property (nonatomic, strong) NSString *created;
///
@property (nonatomic, strong) NSString *access;
///登陆时间
@property (nonatomic, strong) NSString *login;
///状态
@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *timezone;
@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSDictionary *picture;


@end
