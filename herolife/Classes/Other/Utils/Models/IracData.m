//
//  IracData.m
//  xiaorui
//
//  Created by sswukang on 16/4/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "IracData.h"

@implementation IracData

- (instancetype _Nullable)initWithDict:(NSDictionary * _Nullable)dict
{
	if (self = [super init]) {
		
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
		self.model = dict[@"model"];
		self.switchOff = dict[@"switch"];
		self.mode = dict[@"mode"];
		self.temperature = dict[@"temperature"];
		self.windspeed = dict[@"windspeed"];
		self.winddirection = dict[@"winddirection"];
		
		
		self.status = dict[@"hrpush"][@"status"];
		self.type = dict[@"hrpush"][@"type"];
	}
	return self;
}

+ (instancetype _Nullable)totalDataWithDict:(NSDictionary * _Nullable)dict
{
	return [[self alloc] initWithDict:dict];
}

@end
