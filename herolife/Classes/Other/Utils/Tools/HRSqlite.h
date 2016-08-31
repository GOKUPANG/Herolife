//
//  HRSqlite.h
//  xiaorui
//
//  Created by sswukang on 16/6/21.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HRTotalData;
@class HRMessageData;

@interface HRSqlite : NSObject


#pragma mark - 温湿度sqlite操作-----start-----------

/// 删除一个模型
+(void)deleteTempHumidWithModel:(HRTotalData *)model;

/// 添加一个模型
+ (void)addTempHumidWithModel:(HRTotalData *)model;

/// 添加一组数据
+ (void)addTempHumidWithArray:(NSArray *)modelArray;

/// 获取全部数据
+ (NSArray *)tempHumidBackWithUid:(NSString *)uid mid:(NSString *)mid type:(NSString *)type;
/// 保存用户手势密码
+ (void)saveUnlockWithUid:(NSString *)uid lockPassword:(NSString *)lockPassword;
/// 获取用户手势密码
+ (NSString *)hrSqliteReceiveUnlockWithUid:(NSString *)uid;
/// 删除用户手势密码
+ (void)hrSqliteDeleteUnlockWithUid:(NSString *)uid;
/// 保存文本交互信息
+ (void)hrSqliteSaveTextInteractionWithObject:(id)object;
/// 获取文本交互信息
+ (NSMutableArray *)hrSqliteReceiveTextInteractionWithUid:(NSString *)uid mid:(NSString *)mid;

/// 保存用户名称
+ (void)hrSqliteSaveUserName:(NSString *)userName;
/// 获取用户名称 
+ (NSArray *)hrSqliteReceiveUserName;

#pragma mark - 温湿度sqlite操作-----end-----------
@end
