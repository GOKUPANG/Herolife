//
//  Push.m
//  03.群聊客户端
//
//  Created by 海波 on 16/4/17.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "Push.h"

@implementation Push

- (instancetype)initWithPushDict:(NSDictionary *)pushDict
{
    if (self = [super init]) {
        
		self.version = pushDict[@"hrpush"][@"version"];
		self.status = pushDict[@"hrpush"][@"status"];
		self.time = pushDict[@"hrpush"][@"time"];
		self.token = pushDict[@"hrpush"][@"token"];
		
		self.type = pushDict[@"hrpush"][@"type"];
		self.desc = pushDict[@"hrpush"][@"desc"];
		self.fromUserName = pushDict[@"hrpush"][@"src"][@"user"];
		self.fromDevName = pushDict[@"hrpush"][@"src"][@"dev"];
		self.destUserName = pushDict[@"hrpush"][@"dst"][@"user"];
		self.destDevName = pushDict[@"hrpush"][@"dst"][@"dev"];
		
    }
    return self;
}
+ (instancetype)pushWithPushDict:(NSDictionary *)pushDict
{
    return [[self alloc] initWithPushDict:pushDict];
}

#pragma mark - 归档底层调用的方法
/// 保存数据的时候调用
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.version forKey:@"version"];
	[aCoder encodeObject:self.status forKey:@"status"];
	[aCoder encodeObject:self.time forKey:@"time"];
	[aCoder encodeObject:self.type forKey:@"type"];
	[aCoder encodeObject:self.desc forKey:@"desc"];
	[aCoder encodeObject:self.fromUserName forKey:@"fromUserName"];
	[aCoder encodeObject:self.fromDevName forKey:@"fromDevName"];
	[aCoder encodeObject:self.destUserName forKey:@"destUserName"];
	[aCoder encodeObject:self.destDevName forKey:@"destDevName"];
	
}

/// 读数据的时候调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		
		self.version = [aDecoder decodeObjectForKey:@"version"];
		self.status = [aDecoder decodeObjectForKey:@"status"];
		self.time = [aDecoder decodeObjectForKey:@"time"];
		self.type = [aDecoder decodeObjectForKey:@"type"];
		self.desc = [aDecoder decodeObjectForKey:@"desc"];
		self.fromUserName = [aDecoder decodeObjectForKey:@"fromUserName"];
		self.fromDevName = [aDecoder decodeObjectForKey:@"fromDevName"];
		self.destUserName = [aDecoder decodeObjectForKey:@"destUserName"];
		self.destDevName = [aDecoder decodeObjectForKey:@"destDevName"];
	}
	return self;
}


@end
