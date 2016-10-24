//
//  HRUser.h
//  HuaruiAI
//
//  Created by sswukang on 15/11/26.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRUser : NSObject<NSCoding>


///用户ID
@property (nonatomic, assign) NSInteger userID;
///名字
@property (nonatomic, copy)  NSString * name;
///密码
@property (nonatomic, copy) NSString *password;
///邮箱
@property (nonatomic, copy) NSString *mail;
///主题
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *signatureFormat;
///创建时间
@property (nonatomic, strong) NSDate *createdTime;
///
@property (nonatomic, strong) NSDate *accessTime;
///登陆时间
@property (nonatomic, strong) NSDate *loginTime;
///状态
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *timeZone;
@property (nonatomic, copy) NSString *language;
///头像文件名
@property (nonatomic, copy) NSString *portraitFileName;
///头像url
@property (nonatomic, copy) NSString *portraitURL;
///用户头像
@property (nonatomic, strong) UIImage *portraitImage;

///角色，（认证用户，管理员，开发者...）
@property (nonatomic, copy) id roles;

+(instancetype _Nullable) userFromiDictionary: (NSDictionary * _Nonnull)dict;
+(instancetype _Nullable) userFromJSONResponse:(NSDictionary * _Nonnull)json;

- (instancetype _Nullable)initWithDict:(NSDictionary * _Nullable)dict;
+ (instancetype _Nullable)userWithDict:(NSDictionary * _Nullable)dict;




@end
