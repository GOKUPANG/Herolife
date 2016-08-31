//
//  HRself.m
//  xiaorui
//
//  Created by sswukang on 16/4/7.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRTotalData.h"

@implementation HRTotalData

- (instancetype _Nullable)initWithDict:(NSDictionary * _Nullable)dict
{
	if (self = [super init]) {

		self.parameter = dict[@"parameter"];
		self.update = dict[@"update"];
		self.types = dict[@"types"];
		self.brand = dict[@"brand"];
		self.did = dict[@"did"];
		self.mid = dict[@"mid"];
		self.picture = dict[@"picture"];
		self.regional = dict[@"regional"];
		self.state = dict[@"state"];
		self.title = dict[@"title"];
		self.uid = dict[@"uid"];
		self.uuid = dict[@"uuid"];
		self.version = dict[@"version"];

	}
	return self;
}

+ (instancetype _Nullable)totalDataWithDict:(NSDictionary * _Nullable)dict
{
	return [[self alloc] initWithDict:dict];
}
#pragma mark - 归档底层调用的方法
/// 保存数据的时候调用
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.parameter forKey:@"parameter"];
	[aCoder encodeObject:self.update forKey:@"update"];
	[aCoder encodeObject:self.types forKey:@"types"];
	[aCoder encodeObject:self.brand forKey:@"brand"];
	[aCoder encodeObject:self.did forKey:@"did"];
	[aCoder encodeObject:self.mid forKey:@"mid"];
	[aCoder encodeObject:self.picture forKey:@"picture"];
	[aCoder encodeObject:self.regional forKey:@"regional"];
	[aCoder encodeObject:self.state forKey:@"state"];
	[aCoder encodeObject:self.title forKey:@"title"];
	[aCoder encodeObject:self.uid forKey:@"uid"];
	[aCoder encodeObject:self.uuid forKey:@"uuid"];
	[aCoder encodeObject:self.version forKey:@"version"];
	
}

/// 读数据的时候调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		
		self.parameter = [aDecoder decodeObjectForKey:@"parameter"];
		self.update = [aDecoder decodeObjectForKey:@"update"];
		self.types = [aDecoder decodeObjectForKey:@"types"];
		self.brand = [aDecoder decodeObjectForKey:@"brand"];
		self.did = [aDecoder decodeObjectForKey:@"did"];
		self.mid = [aDecoder decodeObjectForKey:@"mid"];
		self.picture = [aDecoder decodeObjectForKey:@"picture"];
		self.regional = [aDecoder decodeObjectForKey:@"regional"];
		self.state = [aDecoder decodeObjectForKey:@"state"];
		self.title = [aDecoder decodeObjectForKey:@"title"];
		self.uid = [aDecoder decodeObjectForKey:@"uid"];
		self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
		self.version = [aDecoder decodeObjectForKey:@"version"];
	}
	return self;
}

@end
