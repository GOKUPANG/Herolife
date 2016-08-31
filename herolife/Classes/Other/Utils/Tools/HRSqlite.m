//
//  HRSqlite.m
//  xiaorui
//
//  Created by sswukang on 16/6/21.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRSqlite.h"
#import "HRTotalData.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "HRMessageData.h"
#import <MJExtension.h>
#define HrUserName @"userName"

@implementation HRSqlite
static FMDatabase *_db;

static NSInteger const HrHumitureId = 10;
static NSInteger const HrPm2_5Id = 11;
static NSInteger const HrVocId = 12;
//获取小睿信息KEY
static NSInteger const HrXiaoruiId = 13;
//用户手势密码KEY
static NSInteger const HrUnlockPasswordId = 14;
//用户文本交互KEY
static NSInteger const HrTextInteractionId = 15;
//用户名称KEY
static NSInteger const HrUserNameId = 16;

+ (void)initialize{
	
	NSString *filePath = HRSqliteFileName(@"totalData")
	DDLogDebug(@"%@", filePath);
	//创建数据库
	_db = [FMDatabase databaseWithPath:filePath];
	
	[_db open];
	
	if (![_db open]) {
		return;
	}
	//创建表
	[_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_hrvocpmtemp(id integer PRIMARY KEY AUTOINCREMENT,uid integer ,mid integer,typeid integer, pm2_5 blob, voc blob , humiture blob , xiaorui blob );"];
	
}

+ (void)addTempHumidWithModel:(HRTotalData *)model
{
	
	//归档
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
	
	if ([model.types isEqualToString:@"humiture"]) {
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,mid,typeid,humiture) VALUES(%ld,%ld,%ld,%@);",(long)[model.uid integerValue],[model.mid integerValue],HrHumitureId, data];
		
	}else if ([model.types isEqualToString:@"pm2_5"]) {
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,mid,typeid,pm2_5) VALUES(%ld,%ld,%ld,%@);",(long)[model.uid integerValue],[model.mid integerValue],HrPm2_5Id, data];
	}else if ([model.types isEqualToString:@"voc"]) {
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,mid,typeid,voc) VALUES(%ld,%ld,%ld,%@);",(long)[model.uid integerValue],[model.mid integerValue],HrVocId, data];
		
	}else if ([model.types isEqualToString:@"xiaorui"]) {
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,mid,typeid,xiaorui) VALUES(%ld,%ld,%ld,%@);",(long)[model.uid integerValue],[model.mid integerValue],HrXiaoruiId, data];
	}

}

/// 添加文本交互数据
+ (void)addTextInteractionWithModel:(HRMessageData *)model
{
	//归档
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
	
	if (![_db columnExists:@"textInteraction" inTableWithName:@"t_hrvocpmtemp"]) {
		NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE t_hrvocpmtemp ADD textInteraction blob"];
		[_db executeUpdate:alertStr];
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,mid,typeid,textInteraction) VALUES(%ld,%ld,%ld,%@);",(long)[model.uid integerValue],[model.mid integerValue],HrTextInteractionId, data];
	}else
	{
		NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE t_hrvocpmtemp ADD textInteraction blob"];
		[_db executeUpdate:alertStr];
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,mid,typeid,textInteraction) VALUES(%ld,%ld,%ld,%@);",(long)[model.uid integerValue],[model.mid integerValue],HrTextInteractionId, data];
	}

}

+ (void)addTempHumidWithArray:(NSArray *)modelArray
{
	
	HRTotalData *firstModel = modelArray.lastObject;
	if (!firstModel.uid) {
		return;
	}
	
    [_db open];
	
	NSString *sqlDelete;
	if ([firstModel.types isEqualToString:@"humiture"]) {
		sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and mid  = %ld and typeid  = %ld;", (long)[firstModel.uid integerValue], (long)[firstModel.mid integerValue], (long)HrHumitureId];
		
	}else if ([firstModel.types isEqualToString:@"pm2_5"]) {
		sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and mid  = %ld and typeid  = %ld;", (long)[firstModel.uid integerValue], (long)[firstModel.mid integerValue], (long)HrPm2_5Id];
		
	}else if ([firstModel.types isEqualToString:@"voc"]) {
		sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and mid  = %ld and typeid  = %ld;", (long)[firstModel.uid integerValue], (long)[firstModel.mid integerValue], (long)HrVocId];
	}else if ([firstModel.types isEqualToString:@"xiaorui"]) {
		sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and mid  = %ld and typeid  = %ld;", (long)[firstModel.uid integerValue], (long)[firstModel.mid integerValue], (long)HrXiaoruiId];
	}
	
	//3.删除该用户该类型的数据
	[_db executeUpdate:sqlDelete];
	
	//5.再添加本条传过来的数据
	for (HRTotalData *model in modelArray) {
		[self addTempHumidWithModel:model];
	}
}

+(void)deleteTempHumidWithModel:(HRTotalData *)model{
	
	[_db executeUpdateWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE deal_id=%@", model.types];
	
}

+ (NSArray *)tempHumidBackWithUid:(NSString *)uid mid:(NSString *)mid type:(NSString *)type
{
	NSString *sql;
	if ([type isEqualToString:@"humiture"]) {
	
		sql = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp WHERE uid = %ld and mid = %ld and typeid = %ld;",(long)[uid integerValue], [mid integerValue], HrHumitureId];
		
	}else if ([type isEqualToString:@"pm2_5"]) {
		
		sql = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp WHERE uid = %ld and mid = %ld and typeid = %ld;",(long)[uid integerValue], [mid integerValue], HrPm2_5Id];
		
	}else if ([type isEqualToString:@"voc"]) {
		sql = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp WHERE uid = %ld and mid = %ld and typeid = %ld;",(long)[uid integerValue], [mid integerValue], HrVocId];
		
	}else if ([type isEqualToString:@"xiaorui"]) {
		sql = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp WHERE uid = %ld and mid = %ld and typeid = %ld;",(long)[uid integerValue], [mid integerValue], HrXiaoruiId];
	}

	
	FMResultSet *set = [_db executeQuery:sql];
	
	//3. 获取数据 --> 获取模型的二进制数据  --> 还原成模型 --> 并且添加到数组中返回
	NSMutableArray *tempArray = [NSMutableArray array];
	
	while ([set next]) {
		
		NSData *data = [set objectForColumnName:type];
		HRTotalData *dealModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		
		[tempArray addObject:dealModel];
		
	}
	return tempArray;
	
}

/// 保存用户手势密码
+ (void)saveUnlockWithUid:(NSString *)uid lockPassword:(NSString *)lockPassword
{
		if (![_db columnExists:@"lockPassword" inTableWithName:@"t_hrvocpmtemp"]) {
			NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE t_hrvocpmtemp ADD lockPassword text"];
			[_db executeUpdate:alertStr];
			
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,typeid,lockPassword) VALUES(%ld,%ld,%@);",(long)[uid integerValue],HrUnlockPasswordId, lockPassword];
		}else
		{
			NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and typeid  = %ld;", (long)[uid integerValue], (long)HrUnlockPasswordId];
			//3.删除该用户该类型的数据
			[_db executeUpdate:sqlDelete];
			
			[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(uid,typeid,lockPassword) VALUES(%ld,%ld,%@);",(long)[uid integerValue],HrUnlockPasswordId, lockPassword];
		}
}
/// 获取用户手势密码
+ (NSString *)hrSqliteReceiveUnlockWithUid:(NSString *)uid
{
	
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp WHERE uid = %ld;",(long)[uid integerValue]];
	
	FMResultSet *set = [_db executeQuery:sql];
	
	NSString *pas;
	while ([set next]) {
		pas = [set objectForColumnName:@"lockPassword"];
		
	}
	return pas;
}

/// 删除用户手势密码
+ (void)hrSqliteDeleteUnlockWithUid:(NSString *)uid
{
	NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and typeid  = %ld;", (long)[uid integerValue], (long)HrUnlockPasswordId];
	//3.删除该用户该类型的数据
	[_db executeUpdate:sqlDelete];
}


/// 保存文本交互信息
// 先查询再取出->取出数据保存在数组中, 再在该数组中添加本条数据,添加之后再看看该数组元素个数是否大于1500,如果是就删除第一条,让后再把该数组保存到数据库中
+ (void)hrSqliteSaveTextInteractionWithObject:(id)object
{
	//把传过来的数据转换成模型数据
	HRMessageData *firstModel = [HRMessageData mj_objectWithKeyValues:object];
	if (!firstModel.uid) {
	return;
	}

	[_db open];
	
	//查找数据string
	NSString *sqlId = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp where uid = %ld and mid = %ld and typeid = %ld;", (long)[firstModel.uid integerValue],(long)[firstModel.mid integerValue], (long)HrTextInteractionId];
	//1先查询本用户保存的数据信息->根据uid来查本用户的数据信息
	FMResultSet *set = [_db executeQuery:sqlId];

	// 获取数据 --> 获取模型的二进制数据  --> 还原成模型 --> 并且添加到数组中返回
	NSMutableArray *tempArray = [NSMutableArray array];

	while ([set next]) {

	//2.取出该用户该类型的数据
		NSData *data = [set objectForColumnName:@"textInteraction"];
		HRMessageData *dealModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		
		//把查询的结果存数组里
		[tempArray addObject:dealModel];

	}
	
	//把传过来的数据添加进数组
	[tempArray addObject: firstModel];
	
	//判断数组长度是否大于1500条,是就删除第一条
	if (tempArray.count > 1500) {
	[tempArray removeObject:tempArray.firstObject];
		
	}
	
	//删除数据string
	NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM t_hrvocpmtemp WHERE uid = %ld and mid = %ld and typeid  = %ld;", (long)[firstModel.uid integerValue], (long)[firstModel.mid integerValue], (long)HrTextInteractionId];
	//3.删除该用户该类型的数据
	[_db executeUpdate:sqlDelete];
	
	//4. 存入该用户该类型的数据
	for (HRMessageData *model in tempArray) {
		
	[self addTextInteractionWithModel:model];
	}
	
}
/// 获取文本交互信息
+ (NSMutableArray *)hrSqliteReceiveTextInteractionWithUid:(NSString *)uid mid:(NSString *)mid
{
	
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_hrvocpmtemp WHERE uid = %ld and mid = %ld and typeid = %ld;",(long)[uid integerValue], [mid integerValue], HrTextInteractionId];

	FMResultSet *set = [_db executeQuery:sql];
	
	//3. 获取数据 --> 获取模型的二进制数据  --> 还原成模型 --> 并且添加到数组中返回
	NSMutableArray *tempArray = [NSMutableArray array];
	
	while ([set next]) {
		
		NSData *data = [set objectForColumnName:@"textInteraction"];
		HRMessageData *dealModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		
		[tempArray addObject:dealModel];
		
	}
	return tempArray;
}

/// 保存用户名称
+ (void)hrSqliteSaveUserName:(NSString *)userName
{
	if (![_db open]) {
		return;
	}
	
	if (![_db columnExists:HrUserName inTableWithName:@"t_hrvocpmtemp"]) {
		NSString *alterName = [NSString stringWithFormat:@"ALTER TABLE t_hrvocpmtemp ADD %@ text;", HrUserName];
		[_db executeUpdate:alterName];
		
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(typeid, userName) VALUES(%ld,%@);", HrUserNameId, userName];
	}else
	{
		//先查询有没有相同的名字,如果有就不添加
		NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_hrvocpmtemp WHERE typeid = %ld;", HrUserNameId];
		FMResultSet *set = [_db executeQuery:sql];
		
		while ([set next]) {
			NSString * name = [set objectForColumnName:HrUserName];
			if ([name isEqualToString:userName]) {
				return;
			}
		}
		NSString *path = HRSqliteFileName(@"hahah")
		NSLog(@"path%@", path);
		[_db executeUpdateWithFormat:@"INSERT INTO t_hrvocpmtemp(typeid, userName) VALUES(%ld,%@);", HrUserNameId, userName];
	}
}
/// 获取用户名称
+ (NSArray *)hrSqliteReceiveUserName
{
	FMResultSet *set = [_db executeQueryWithFormat:@"SELECT *FROM t_hrvocpmtemp WHERE typeid = %ld;", HrUserNameId];
	NSMutableArray *arr = [NSMutableArray array];
	while ([set next]) {
		NSString *name = [set objectForColumnName:HrUserName];
		[arr addObject:name];
	}
	return arr;
}



@end
