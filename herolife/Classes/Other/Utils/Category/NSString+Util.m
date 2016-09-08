//
//  NSString+Util.m
//  xiaorui
//
//  Created by sswukang on 16/3/12.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NSString (Util)


/// 用户登录  认证  获得token
+ (NSString *)stringWithPostTCPJsonVersion:(NSString *)version status:(NSString *)status token:(NSString *)token msgType:(NSString *)msgType msgExplain:(NSString *)msgExplain fromUserName:(NSString *)fromUserName destUserName:(NSString *)destUserName destDevName:(NSString *)destDevName msgBodyStringDict:(NSDictionary *)msgBodyStringDict
{
	/// 获取用户UUID
	NSString *ramStr = [kUserDefault objectForKey:kUserDefaultUUID];
	
	NSMutableDictionary *msgFromDict = [NSMutableDictionary dictionary];
	fromUserName = fromUserName;
	msgFromDict[@"user"] = fromUserName;
	msgFromDict[@"dev"] = ramStr;
	
	NSMutableDictionary *msgDestDict = [NSMutableDictionary dictionary];
	
	msgDestDict[@"user"] = destUserName;
	msgDestDict[@"dev"] = destDevName;
	
	NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
	hrpushDict[@"version"] = version;
	hrpushDict[@"status"] = status;
	
	hrpushDict[@"time"] = [self loadCurrentDate];
	hrpushDict[@"token"] = token;
	hrpushDict[@"type"] = msgType;
	hrpushDict[@"desc"] = msgExplain;
	hrpushDict[@"src"] = msgFromDict;
	hrpushDict[@"dst"] = msgDestDict;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"hrpush"] = hrpushDict;
	dict[@"msg"] = msgBodyStringDict;
	
	NSData *jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
	
	NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
	
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
	
	NSString *footerStr = @"\r\n\0";
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
//	NSMutableString *urlString = [NSMutableString stringWithString:hrpush];
	
//	[urlString appendString:hrlength];
//	[urlString  appendFormat:@"%@", dictStr];
//	[urlString appendString:footerStr];
//	DDLogInfo(@"token-urlString-----%@", urlString);
//	DDLogInfo(@"组好的帧的用户登录认证  获得token-转码前--urlString---%@", urlString);
//	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	DDLogInfo(@"组好的帧的用户登录认证  获得token---urlString---%@", urlString);
	return urlString;
}

/// 红外空调 请求帧
+ (NSString *)stringWithIRACVersion:(NSString *)version status:(NSString *)status token:(NSString *)token type:(NSString *)type desc:(NSString *)desc srcUserName:(NSString *)srcUserName dstUserName:(NSString *)dstUserName dstDevName:(NSString *)dstDevName uid:(NSString *)uid mid:(NSString *)mid did:(NSString *)did uuid:(NSString *)uuid types:(NSString *)types newVersion:(NSString *)newVersion title:(NSString *)title brand:(NSString *)brand created:(NSString *)created update:(NSString *)update state:(NSString *)state picture:(NSArray *)picture regional:(NSArray *)regional model:(NSString *)model onSwitch:(NSString *)onSwitch mode:(NSString *)mode temperature:(NSString *)temperature windspeed:(NSString *)windspeed winddirection:(NSString *)winddirection {
	/// 获取用户UUID
	NSString *ramStr = [kUserDefault objectForKey:kUserDefaultUUID];
	
	NSMutableDictionary *msgFromDict = [NSMutableDictionary dictionary];
	//中文转换
//	srcUserName = [srcUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgFromDict[@"user"] = srcUserName;
	msgFromDict[@"dev"] = ramStr;
	
	NSMutableDictionary *msgDestDict = [NSMutableDictionary dictionary];
	//中文转换
//	dstUserName = [dstUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgDestDict[@"user"] = dstUserName;
	msgDestDict[@"dev"] = dstDevName;
	
	NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
	hrpushDict[@"version"] = version;
	hrpushDict[@"status"] = status;
	
	
	hrpushDict[@"time"] = [self loadCurrentDate];
	
	//从偏好设置里 取token
	hrpushDict[@"token"] = token;
	hrpushDict[@"type"] = type;
	hrpushDict[@"desc"] = desc;
	hrpushDict[@"src"] = msgFromDict;
	hrpushDict[@"dst"] = msgDestDict;
	
	NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
	msgDict[@"uid"] = uid;
	msgDict[@"mid"] = mid;
	msgDict[@"did"] = did;
	msgDict[@"uuid"] = uuid;
	msgDict[@"types"] = types;
	msgDict[@"version"] = newVersion;
	
//	title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//		title = [[[NSString alloc] initWithString:title] toUnicode];
	msgDict[@"title"] = title;
//	brand = [brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	brand = [[[NSString alloc] initWithString:brand] toUnicode];
//	brand = [brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgDict[@"brand"] = brand;
	msgDict[@"created"] = created;
	msgDict[@"update"] = update;
	msgDict[@"state"] = state;
	msgDict[@"picture"] = picture;
	msgDict[@"regional"] = regional;
	msgDict[@"model"] = model;
	msgDict[@"mode"] = mode;
	msgDict[@"switch"] = onSwitch;
	msgDict[@"temperature"] = temperature;
	msgDict[@"windspeed"] = windspeed;
	msgDict[@"winddirection"] = winddirection;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"hrpush"] = hrpushDict;
	dict[@"msg"] = msgDict;

	
	NSData *jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];

	NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
	
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
	
	NSString *footerStr = @"\r\n\0";
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
	
//	NSString *total = [NSString stringWithFormat:@"{\"hrpush\":{\"desc\":\"push desc message\",\"dst\":{\"user\":\"xiaoruitest\",\"dev\":\"%@\"},\"src\":{\"dev\":\"ioshaiboTextUUID\",\"user\":\"xiaoruitest\"},\"status\":\"200\",\"time\":\"2016-05-03 16:56:01\",\"token\":\"%@\",\"type\":\"create\",\"version\":\"0.0.1\"},\"msg\":{\"mode\":\"None\",\"model\":\"140\",\"switch\":\"None\",\"temperature\":\"None\",\"winddirection\":\"None\",\"windspeed\":\"None\",\"brand\":\"ddd\",\"created\":\"None\",\"did\":\"None\",\"mid\":\"2119\",\"picture\":[\"None\"],\"regional\":[\"None\"],\"state\":\"1\",\"title\":\"aaa\",\"types\":\"irac\",\"uid\":\"98\",\"update\":\"None\",\"version\":\"0.0.1\"}}",uuid,token];
	
//	urlString = [urlString toUnicode];
//	DDLogWarn(@"toUnicode----%@", urlString);
	return urlString;
//	return total;
}

/// 通用 请求帧
+ (NSString *)stringWithIRGMVersion:(NSString *)version status:(NSString *)status token:(NSString *)token type:(NSString *)type desc:(NSString *)desc srcUserName:(NSString *)srcUserName dstUserName:(NSString *)dstUserName dstDevName:(NSString *)dstDevName uid:(NSString *)uid mid:(NSString *)mid did:(NSString *)did uuid:(NSString *)uuid types:(NSString *)types newVersion:(NSString *)newVersion title:(NSString *)title brand:(NSString *)brand created:(NSString *)created update:(NSString *)update state:(NSString *)state picture:(NSArray *)picture regional:(NSArray *)regional op:(NSArray *)op name01:(NSArray *)name01 name02:(NSArray *)name02 name03:(NSArray *)name03 param01:(NSArray *)param01 param02:(NSArray *)param02 param03:(NSArray *)param03
{
	/// 获取用户UUID
	NSString *ramStr = [kUserDefault objectForKey:kUserDefaultUUID];
	
	NSMutableDictionary *msgFromDict = [NSMutableDictionary dictionary];
	//中文转换
	//	srcUserName = [srcUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgFromDict[@"user"] = srcUserName;
	msgFromDict[@"dev"] = ramStr;
	
	NSMutableDictionary *msgDestDict = [NSMutableDictionary dictionary];
	//中文转换
	//	dstUserName = [dstUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgDestDict[@"user"] = dstUserName;
	msgDestDict[@"dev"] = dstDevName;
	
	NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
	hrpushDict[@"version"] = version;
	hrpushDict[@"status"] = status;
	
	
	hrpushDict[@"time"] = [self loadCurrentDate];
	
	//从偏好设置里 取token
	hrpushDict[@"token"] = token;
	hrpushDict[@"type"] = type;
	hrpushDict[@"desc"] = desc;
	hrpushDict[@"src"] = msgFromDict;
	hrpushDict[@"dst"] = msgDestDict;
	
	NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
	msgDict[@"uid"] = uid;
	msgDict[@"mid"] = mid;
	msgDict[@"did"] = did;
	msgDict[@"uuid"] = uuid;
	msgDict[@"types"] = types;
	msgDict[@"version"] = newVersion;
	
//	title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	title = [[[NSString alloc] initWithString:title] toUnicode];
	msgDict[@"title"] = title;
//	brand = [[[NSString alloc] initWithString:brand] toUnicode];
//	brand = [brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	msgDict[@"brand"] = brand;
	msgDict[@"created"] = created;
	msgDict[@"update"] = update;
	msgDict[@"state"] = state;
	msgDict[@"picture"] = picture;
	msgDict[@"regional"] = regional;
	msgDict[@"op"] = op;
	msgDict[@"name01"] = name01;
	msgDict[@"name02"] = name02;
	msgDict[@"name03"] = name03;
	msgDict[@"param01"] = param01;
	msgDict[@"param02"] = param02;
	msgDict[@"param02"] = param03;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"hrpush"] = hrpushDict;
	dict[@"msg"] = msgDict;
	
	
	NSData *jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
	
	NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
	
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
	
	NSString *footerStr = @"\r\n\0";
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
	return urlString;
}

/// 开关 请求帧
+ (NSString *)stringWithHRDOVersion:(NSString *)version status:(NSString *)status token:(NSString *)token type:(NSString *)type desc:(NSString *)desc srcUserName:(NSString *)srcUserName dstUserName:(NSString *)dstUserName dstDevName:(NSString *)dstDevName uid:(NSString *)uid mid:(NSString *)mid did:(NSString *)did uuid:(NSString *)uuid types:(NSString *)types newVersion:(NSString *)newVersion title:(NSString *)title brand:(NSString *)brand created:(NSString *)created update:(NSString *)update state:(NSString *)state picture:(NSArray *)picture regional:(NSArray *)regional parameter:(NSArray *)parameter
{
	/// 获取用户UUID
	NSString *ramStr = [kUserDefault objectForKey:kUserDefaultUUID];
	
	NSMutableDictionary *msgFromDict = [NSMutableDictionary dictionary];
	//中文转换
	//	srcUserName = [srcUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgFromDict[@"user"] = srcUserName;
	msgFromDict[@"dev"] = ramStr;
	
	NSMutableDictionary *msgDestDict = [NSMutableDictionary dictionary];
	//中文转换
	//	dstUserName = [dstUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	msgDestDict[@"user"] = dstUserName;
	msgDestDict[@"dev"] = dstDevName;
	
	NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
	hrpushDict[@"version"] = version;
	hrpushDict[@"status"] = status;
	
	
	hrpushDict[@"time"] = [self loadCurrentDate];
	
	//从偏好设置里 取token
	hrpushDict[@"token"] = token;
	hrpushDict[@"type"] = type;
	hrpushDict[@"desc"] = desc;
	hrpushDict[@"src"] = msgFromDict;
	hrpushDict[@"dst"] = msgDestDict;
	
	NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
	msgDict[@"uid"] = uid;
	msgDict[@"mid"] = mid;
	msgDict[@"did"] = did;
	msgDict[@"uuid"] = uuid;
	msgDict[@"types"] = types;
	msgDict[@"version"] = newVersion;
	
//	title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//	title = [[[NSString alloc] initWithString:title] toUnicode];
	msgDict[@"title"] = title;
	//	brand = [[[NSString alloc] initWithString:brand] toUnicode];
//	brand = [brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	msgDict[@"brand"] = brand;
	msgDict[@"created"] = created;
	msgDict[@"update"] = update;
	msgDict[@"state"] = state;
	msgDict[@"picture"] = picture;
	msgDict[@"regional"] = regional;
	msgDict[@"parameter"] = parameter;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"hrpush"] = hrpushDict;
	dict[@"msg"] = msgDict;
	
	
	NSData *jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
	
	NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
	
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
	
	NSString *footerStr = @"\r\n\0";
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
	
	return urlString;
}

/// 情景 请求帧
+ (NSString *)stringWithSceneType:(NSString *)type did:(NSString *)did title:(NSString *)title picture:(NSArray *)picture data:(NSArray *)data
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送测试开关 请求帧
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUid];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracMid];
	NSArray *regional = [NSArray array];
	NSString *brand = [kUserDefault objectForKey:kdefaultsIracBrand];
		
		
	/// 获取用户UUID
	NSString *ramStr = [kUserDefault objectForKey:kUserDefaultUUID];
	
	NSMutableDictionary *msgFromDict = [NSMutableDictionary dictionary];
	
	msgFromDict[@"user"] = user;
	msgFromDict[@"dev"] = ramStr;
	
	NSMutableDictionary *msgDestDict = [NSMutableDictionary dictionary];
	
	msgDestDict[@"user"] = user;
	msgDestDict[@"dev"] = uuid;
	
	NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
	hrpushDict[@"version"] = @"0.0.1";
	hrpushDict[@"status"] = @"200";
	hrpushDict[@"time"] = [self loadCurrentDate];
	
	//从偏好设置里 取token
	hrpushDict[@"token"] = token;
	hrpushDict[@"type"] = type;
	hrpushDict[@"desc"] = [NSString stringWithFormat:@"%@ desc message", type];
	hrpushDict[@"src"] = msgFromDict;
	hrpushDict[@"dst"] = msgDestDict;
	
	NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
	msgDict[@"uid"] = uid;
	msgDict[@"mid"] = mid;
	msgDict[@"did"] = did;
	msgDict[@"uuid"] = uuid;
	msgDict[@"types"] = @"scene";
	msgDict[@"version"] = @"0.0.1";
	
	msgDict[@"title"] = title;
	msgDict[@"brand"] = brand;
	msgDict[@"created"] = @"None";
	msgDict[@"update"] = @"None";
	msgDict[@"state"] = @"1";
	msgDict[@"picture"] = picture;
	msgDict[@"regional"] = regional;
	
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	msgDict[@"data"] = jsonStr;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"hrpush"] = hrpushDict;
	dict[@"msg"] = msgDict;
	
	NSData *jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
	
	NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
	
	dictStr = [dictStr stringByReplacingOccurrencesOfString:@" " withString:@""];
	dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
	
	NSString *footerStr = @"\r\n\0";
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
	
	return urlString;
}
#pragma mark - UDP
/// UDP  请求帧
+ (NSString *)stringWithUDPMsgDict:(NSMutableDictionary *)msgDict
{
	
	NSMutableDictionary *msgFromDict = [NSMutableDictionary dictionary];
	
	msgFromDict[@"user"] = @"none";
	msgFromDict[@"dev"] = @"none";
	
	NSMutableDictionary *msgDestDict = [NSMutableDictionary dictionary];
	
	msgDestDict[@"user"] = @"none";
	msgDestDict[@"dev"] = @"none";
	
	NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
	hrpushDict[@"version"] = @"0.0.1";
	hrpushDict[@"status"] = @"200";
	hrpushDict[@"time"] = @"none";
	
	//从偏好设置里 取token
	hrpushDict[@"token"] = @"none";
	hrpushDict[@"type"] = @"set";
	hrpushDict[@"desc"] = @"none";
	hrpushDict[@"src"] = msgFromDict;
	hrpushDict[@"dst"] = msgDestDict;
	
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"hrpush"] = hrpushDict;
	dict[@"msg"] = msgDict;
	
	NSData *jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
	
	NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
	
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
	
	NSString *footerStr = @"\r\n\0";
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
	
	return urlString;

}
#pragma mark - 获取当前wifi的名称
+ (NSString *)stringWithGetWifiName
{
	NSString *wifiName = nil;
	CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
	if (!wifiInterfaces) {
		return nil;
	}
	NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
	for (NSString *interfaceName in interfaces) {
		CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
		if (dictRef) {
			NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
			NSLog(@"network info -> %@", networkInfo);
			wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
			CFRelease(dictRef);
		}
	}
	CFRelease(wifiInterfaces);
	return wifiName;
}

/// 获取用户UUID
+ (NSString *)stringWithUUID
{
	CFUUIDRef puuid = CFUUIDCreate(nil);
	CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
	NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
	NSMutableString *tmpResult = result.mutableCopy;
	// 去除“-”
	NSRange range = [tmpResult rangeOfString:@"-"];
	while (range.location != NSNotFound) {
		[tmpResult deleteCharactersInRange:range];
		range = [tmpResult rangeOfString:@"-"];
	}
	/// 如果每次UUID  在变化  那么就会报 设备找不到
//	DDLogInfo(@"UUID:%@",tmpResult);
//	return @"ioshaiboTextUUID";
	return tmpResult;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
	NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
	NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
	NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
	//旧方法
	//    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
	//新方法
	NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable  format:NULL  error:NULL];
	
	
	return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (NSString *) toUnicode
{
	NSUInteger length = [self length];
	NSMutableString *s = [NSMutableString stringWithCapacity:0];
	for (int i = 0;i < length; i++)
	{
		
		unichar _char = [self characterAtIndex:i];
		
		if (_char <= '9' && _char >= '0')
		{
			[s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
		}
		else if(_char >= 'a' && _char <= 'z')
		{
			[s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
		}
		else if(_char >= 'A' && _char <= 'Z')
		{
			[s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
		}
		else
		{
			[s appendFormat:@"\\u%x",[self characterAtIndex:i]];
		}
	}
	return s;
}
/// 获取当前时间
+ (NSString *)loadCurrentDate
{
	
	NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
	
	// 设置日期格式
	[dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
	
	
	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//	DDLogDebug(@"currentDate------------%@", [NSDate date]);
	return dateString;
}

-(NSString *)uppercaseFirstChar {
	if (self.length == 0) return self;
	if (self.length == 1) return self.uppercaseString;
	NSString *first = [self substringWithRange:NSMakeRange(0, 1)];
	NSString *tail = [self substringWithRange:NSMakeRange(1, self.length - 1)];
	return [NSString stringWithFormat:@"%@%@", first.uppercaseString, tail];
}

- (NSString *)md5Str
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}


- (NSString*) sha1Str
{
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

#pragma mark - 加密
+ (NSString *)hr_stringWithBase64
{
	NSString *userName = [kUserDefault objectForKey:kDefaultsUserName];
	NSString *passwold = [kUserDefault objectForKey:kDefaultsPassWord];
	//组帧
	NSString *str = [NSString stringWithFormat:@"{\"user\":\"%@\",\"pass\":\"%@\"}", userName,passwold];
	DDLogWarn(@"str--%@",str);
	char *result = hrencode((char *)[str UTF8String]);
	NSString *string = @(result);
	
//	NSString *string = nil;
	DDLogWarn(@"%@",string);
	return string;
}
+ (NSString *)hr_stringWithBase64String:(NSString *)baseString
{
	//组帧
	NSString *str = baseString;
	DDLogWarn(@"str--%@",str);
	char *result = hrencode((char *)[str UTF8String]);
	NSString *string = @(result);
	
	//	NSString *string = nil;
	DDLogWarn(@"%@",string);
	return string;
}
#pragma mark - C  base64加密

char *enlic2="437frhsRE5TW4Gfgki56y54yh64T5tHY65YRHTT45y45ygtaR4W64YUHE54YGR54Y45rfhy6u57hger8567ygvf43tftg44regft547get4345TGREY7587EGTDA5tg5";
char *base64_encode(const char* data, int data_len,char* out)
{
	char base[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	//int data_len = strlen(data);
	int prepare = 0;
	int ret_len;
	int temp = 0;
	char *ret = NULL;
	char *f = NULL;
	int tmp = 0;
	char changed[4];
	int i = 0;
	ret_len = data_len / 3;
	temp = data_len % 3;
	if (temp > 0)
	{
		ret_len += 1;
	}
	ret_len = ret_len*4 + 1;
	ret = (char *)malloc(ret_len);
	
	if ( ret == NULL)
	{
		printf("No enough memory.\n");
		exit(0);
	}
	memset(ret, 0, ret_len);
	f = ret;
	while (tmp < data_len)
	{
		temp = 0;
		prepare = 0;
		memset(changed, '\0', 4);
		while (temp < 3)
		{
			//printf("tmp = %d\n", tmp);
			if (tmp >= data_len)
			{
				break;
			}
			prepare = ((prepare << 8) | (data[tmp] & 0xFF));
			tmp++;
			temp++;
		}
		prepare = (prepare<<((3-temp)*8));
		//printf("before for : temp = %d, prepare = %d\n", temp, prepare);
		for (i = 0; i < 4 ;i++ )
		{
			if (temp < i)
			{
				changed[i] = 0x40;
			}
			else
			{
				changed[i] = (prepare>>((3-i)*6)) & 0x3F;
			}
			*f = base[changed[i]];
			//printf("%.2X", changed[i]);
			f++;
		}
	}
	*f = '\0';
	strcpy(out,ret);
	free(ret);
	return ret;
	
}

char *hrencode(char *pass)
{
	char *enlic = "TxFCFRcaUWhnRjw1FmtEFwoaRhRDFwVLWwACYhcJ";
	
	char ret[1024];
	printf("enlic2 len:%d\n",strlen(enlic2));
	int i=0;
	for (i=0; i < strlen(pass); i++) {
		
		char temp = (char)pass[i]^enlic2[i];
		printf("%d---|src--%c--enlic2--%c--temp---%c|\n",i, pass[i],enlic2[i], temp);
		ret[i]=temp;
		
	}
	ret[i]='\0';
	char result[64];
	base64_encode(ret,i,result);
	return result;
}

@end
