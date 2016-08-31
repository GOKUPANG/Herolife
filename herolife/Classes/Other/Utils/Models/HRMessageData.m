//
//  HRMessageData.m
//  xiaorui
//
//  Created by sswukang on 16/5/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRMessageData.h"

@implementation HRMessageData

#pragma mark - 归档底层调用的方法
/// 保存数据的时候调用
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	
	[aCoder encodeObject:self.version forKey:@"version"];
	[aCoder encodeObject:self.status forKey:@"status"];
	[aCoder encodeObject:self.token forKey:@"token"];
	[aCoder encodeObject:self.type forKey:@"type"];
	[aCoder encodeObject:self.desc forKey:@"desc"];
	[aCoder encodeObject:self.mid forKey:@"mid"];
	[aCoder encodeObject:self.src forKey:@"src"];
	[aCoder encodeObject:self.dst forKey:@"dst"];
	[aCoder encodeObject:self.uid forKey:@"uid"];
	[aCoder encodeObject:self.did forKey:@"did"];
	[aCoder encodeObject:self.uuid forKey:@"uuid"];
	[aCoder encodeObject:self.created forKey:@"created"];
	[aCoder encodeObject:self.title forKey:@"title"];
	[aCoder encodeObject:self.mess forKey:@"mess"];
	
}

/// 读数据的时候调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		
		self.version = [aDecoder decodeObjectForKey:@"version"];
		self.status = [aDecoder decodeObjectForKey:@"status"];
		self.token = [aDecoder decodeObjectForKey:@"token"];
		self.type = [aDecoder decodeObjectForKey:@"type"];
		self.desc = [aDecoder decodeObjectForKey:@"desc"];
		
		self.mid = [aDecoder decodeObjectForKey:@"mid"];
		self.src = [aDecoder decodeObjectForKey:@"src"];
		self.dst = [aDecoder decodeObjectForKey:@"dst"];
		self.uid = [aDecoder decodeObjectForKey:@"uid"];
		self.did = [aDecoder decodeObjectForKey:@"did"];
		
		self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
		self.created = [aDecoder decodeObjectForKey:@"created"];
		self.title = [aDecoder decodeObjectForKey:@"title"];
		self.mess = [aDecoder decodeObjectForKey:@"mess"];
		
	}
	return self;
}


@end
