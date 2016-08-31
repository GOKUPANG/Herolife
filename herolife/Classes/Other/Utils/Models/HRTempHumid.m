//
//  HRTempHumid.m
//  xiaorui
//
//  Created by 海波 on 16/3/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRTempHumid.h"

@implementation HRTempHumid

+(instancetype) tempHumidFromJSONResponse:(NSDictionary *)json {
 
    HRTempHumid *tempHumid = [[HRTempHumid alloc] init];
    tempHumid.parameter = json[@"parameter"];
	tempHumid.update = json[@"update"];
	tempHumid.types = json[@"types"];
    tempHumid.brand = json[@"brand"];
    tempHumid.did = json[@"did"];
    tempHumid.mid = json[@"mid"];
    tempHumid.picture = json[@"picture"];
    tempHumid.regional = json[@"regional"];
    tempHumid.state = json[@"state"];
    tempHumid.title = json[@"title"];
    tempHumid.uid = json[@"uid"];
    tempHumid.uuid = json[@"uuid"];
    tempHumid.version = json[@"version"];

    return tempHumid;
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
