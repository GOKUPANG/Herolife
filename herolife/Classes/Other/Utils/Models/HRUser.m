//
//  HRUser.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/26.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "HRUser.h"

#define kLoginUserDict	@"user_dict"

@interface HRUser ()


@end


@implementation HRUser

- (instancetype _Nullable)initWithDict:(NSDictionary *)dict
{
	if (self = [super init]) {
		
		if (!dict) return nil;
//		if (!dict[@"user"]) return nil;
		
		self.name = dict[@"name"];
		self.password = dict[@"password"];
		NSDictionary *dict = [NSDictionary dictionary];
		
		
		if ([dict valueForKeyPath:@"url"]) {
			self.userID = [dict[@"picture"][@"uid"] integerValue];
			
			self.portraitURL = dict[@"picture"][@"url"];
			
		}
//		NSDictionary *userDict = dict[@"user"];
//		self.userID           = dict[@"user"][@"uid"];
//		self.mail             = dict[@"user"][@"mail"];
//		self.theme            = dict[@"user"][@"theme"];
//		self.signature        = dict[@"user"][@"signature"];
//		self.signatureFormat  = dict[@"user"][@"signature_format"];
//		self.status           = dict[@"user"][@"status"];
//		self.timeZone         = dict[@"user"][@"timezone"];
//		self.language         = dict[@"user"][@"language"];
//		
//		if (dict[@"user"][@"picture"][@"filename"]) {
//			self.portraitFileName = dict[@"user"][@"picture"][@"filename"];
//		}
//		
//		if (dict[@"user"][@"picture"][@"filename"]) {
//			self.portraitURL = dict[@"user"][@"picture"][@"url"];
//		}
		
//		self.userID           = userDict[@"uid"];
//		self.mail             = userDict[@"mail"];
//		self.theme            = userDict[@"theme"];
//		self.signature        = userDict[@"signature"];
//		self.signatureFormat  = userDict[@"signature_format"];
//		self.status           = userDict[@"status"];
//		self.timeZone         = userDict[@"timezone"];
//		self.language         = userDict[@"language"];
//		
//		if (userDict[@"picture"][@"filename"]) {
//			self.portraitFileName = userDict[@"picture"][@"filename"];
//		}
//		
//		if (userDict[@"picture"][@"filename"]) {
//			self.portraitURL = userDict[@"picture"][@"url"];
//		}
		
		//
		
//		NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"+8"];
//		self.loginTime = [[NSDate allocWithZone:(__bridge struct _NSZone *)(zone)] initWithTimeIntervalSince1970:[userDict[@"login"] doubleValue]];
		
	}
	return self;
}
+ (instancetype _Nullable)userWithDict:(NSDictionary *)dict
{
	return [[self alloc] initWithDict:dict];
}




+(instancetype _Nullable) userFromJSONResponse:(NSDictionary *)json {
//	if (!json && json == nil) return nil;
//	HRUser *user = [[HRUser alloc] init];
//	
//	user.userID           = [json[@"uid"] integerValue];
//	user.name             = [json valueForKeyPath:@"name"];
//	user.mail             = [json valueForKeyPath:@"mail"];
//	user.theme            = [json valueForKeyPath:@"theme"];
//	user.signature        = [json valueForKeyPath:@"signature"];
//	user.signatureFormat  = [json valueForKeyPath:@"signature_format"];
//	user.status           = [json[@"status"] integerValue];
//	user.timeZone         = [json valueForKeyPath:@"timezone"];
//	user.language         = [json valueForKeyPath:@"language"];
	
	if (!json) return nil;
	HRUser *user = [[HRUser alloc] init];
	NSDictionary *userDict = json[@"user"];
	
	user.userID           = [userDict[@"uid"] integerValue];
	user.name             = userDict[@"name"];
	user.mail             = userDict[@"mail"];
	user.theme            = userDict[@"theme"];
	user.signature        = userDict[@"signature"];
	user.signatureFormat  = userDict[@"signature_format"];
	user.status           = [userDict[@"status"] integerValue];
	user.timeZone         = userDict[@"timezone"];
	user.language         = userDict[@"language"];
	
	user.portraitFileName = [userDict valueForKeyPath:@"filename"];
	user.portraitURL      = [userDict valueForKeyPath:@"url"];
	user.portraitImage = [userDict valueForKeyPath:@"portraitImage"];
//	user.portraitFileName = userDict[@"picture"][@"filename"];
//	user.portraitURL      = userDict[@"picture"][@"url"];
	
	NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"+8"];
	user.loginTime = [[NSDate allocWithZone:(__bridge struct _NSZone *)(zone)] initWithTimeIntervalSince1970:[userDict[@"login"] doubleValue]];
	
	return user;
}

- (void) setPortraitURL:(NSString *)portraitURL {
	if (_portraitURL == portraitURL) return;
	_portraitURL = portraitURL;
	
	///必须保证portraitFileName不为空
	if (!self.portraitFileName) return;
	
	dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSFileManager *manager = [NSFileManager defaultManager];
		NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
		NSString *filePath = [NSString stringWithFormat:@"%@/portrait", path];
		if (![manager fileExistsAtPath:filePath]) {	//目录不存在，创建目录
			[manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		filePath = [NSString stringWithFormat:@"%@/%@", filePath, self.portraitFileName];
//		NSLog(@"头像路径：%@", filePath);
		if ([manager fileExistsAtPath:filePath]) { //文件已经存在
			self.portraitImage = [UIImage imageWithContentsOfFile:filePath];
			return;
		}
		NSError *error;
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitURL] options:NSDataReadingUncached error:&error];
		if (error) {
			NSLog(@"下载用户头像失败：%@", error.localizedDescription );
		} else {
			BOOL success = [manager createFileAtPath:filePath contents:imageData attributes:nil];
			NSLog(@"下载用户头像完成！写入文件结果：%d", success);
			self.portraitImage = [UIImage imageWithData:imageData];
		}
	});
	
}

#pragma mark - static method

+(instancetype _Nullable) userFromiDictionary: (NSDictionary *)dict {
	if (dict) {
		HRUser *user = [[HRUser alloc] init];
		for (NSString *key in dict.allKeys) {
			[user setValue:dict[key] forKey:key];
		}
		return user;
	}
	return nil;
}

#pragma mark - 归档底层调用的方法
/// 保存数据的时候调用
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInteger: self.userID forKey:@"userID"];
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.mail forKey:@"mail"];
	[aCoder encodeObject:self.theme forKey:@"theme"];
	[aCoder encodeObject:self.signature forKey:@"signature"];
	[aCoder encodeObject:self.signatureFormat forKey:@"signatureFormat"];
	[aCoder encodeInteger:self.status forKey:@"status"];
	[aCoder encodeObject:self.timeZone forKey:@"timeZone"];
	[aCoder encodeObject:self.language forKey:@"language"];
	[aCoder encodeObject:self.portraitFileName forKey:@"portraitFileName"];
	[aCoder encodeObject:self.portraitURL forKey:@"portraitURL"];
	[aCoder encodeObject:self.portraitImage forKey:@"portraitImage"];
//	[aCoder encodeObject:self.loginTime forKey:@"loginTime"];
	
}

/// 读数据的时候调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		
		self.userID = [aDecoder decodeIntegerForKey:@"userID"];
		self.name = [aDecoder decodeObjectForKey:@"name"];
		self.mail = [aDecoder decodeObjectForKey:@"mail"];
		self.theme = [aDecoder decodeObjectForKey:@"theme"];
		self.signature = [aDecoder decodeObjectForKey:@"signature"];
		self.signatureFormat = [aDecoder decodeObjectForKey:@"signatureFormat"];
		self.status = [aDecoder decodeIntegerForKey:@"status"];
		self.timeZone = [aDecoder decodeObjectForKey:@"timeZone"];
		self.language = [aDecoder decodeObjectForKey:@"language"];
		self.portraitFileName = [aDecoder decodeObjectForKey:@"portraitFileName"];
		self.portraitURL = [aDecoder decodeObjectForKey:@"portraitURL"];
		self.portraitImage = [aDecoder decodeObjectForKey:@"portraitImage"];
//		self.loginTime = [aDecoder decodeObjectForKey:@"loginTime"];
	}
	return self;
}



@end
