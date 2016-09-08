//
//  NSString+Util.h
//  xiaorui
//
//  Created by sswukang on 16/3/12.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

///大写第一个字母
-(NSString *)uppercaseFirstChar;

- (NSString *)md5Str;
- (NSString*) sha1Str;
/// TCP请求组帧
+ (NSString *)stringWithPostTCPJsonVersion:(NSString *)version status:(NSString *)status token:(NSString *)token msgType:(NSString *)msgType msgExplain:(NSString *)msgExplain fromUserName:(NSString *)fromUserName destUserName:(NSString *)destUserName destDevName:(NSString *)destDevName msgBodyStringDict:(NSDictionary *)msgBodyStringDict;
/// 红外空调 请求帧
+ (NSString *)stringWithIRACVersion:(NSString *)version status:(NSString *)status token:(NSString *)token type:(NSString *)type desc:(NSString *)desc srcUserName:(NSString *)srcUserName dstUserName:(NSString *)dstUserName dstDevName:(NSString *)dstDevName uid:(NSString *)uid mid:(NSString *)mid did:(NSString *)did uuid:(NSString *)uuid types:(NSString *)types newVersion:(NSString *)newVersion title:(NSString *)title brand:(NSString *)brand created:(NSString *)created update:(NSString *)update state:(NSString *)state picture:(NSArray *)picture regional:(NSArray *)regional model:(NSString *)model onSwitch:(NSString *)onSwitch mode:(NSString *)mode temperature:(NSString *)temperature windspeed:(NSString *)windspeed winddirection:(NSString *)winddirection;
/// 通用 请求帧
+ (NSString *)stringWithIRGMVersion:(NSString *)version status:(NSString *)status token:(NSString *)token type:(NSString *)type desc:(NSString *)desc srcUserName:(NSString *)srcUserName dstUserName:(NSString *)dstUserName dstDevName:(NSString *)dstDevName uid:(NSString *)uid mid:(NSString *)mid did:(NSString *)did uuid:(NSString *)uuid types:(NSString *)types newVersion:(NSString *)newVersion title:(NSString *)title brand:(NSString *)brand created:(NSString *)created update:(NSString *)update state:(NSString *)state picture:(NSArray *)picture regional:(NSArray *)regional op:(NSArray *)op name01:(NSArray *)name01 name02:(NSArray *)name02 name03:(NSArray *)name03 param01:(NSArray *)param01 param02:(NSArray *)param02 param03:(NSArray *)param03;

/// 开关 请求帧
+ (NSString *)stringWithHRDOVersion:(NSString *)version status:(NSString *)status token:(NSString *)token type:(NSString *)type desc:(NSString *)desc srcUserName:(NSString *)srcUserName dstUserName:(NSString *)dstUserName dstDevName:(NSString *)dstDevName uid:(NSString *)uid mid:(NSString *)mid did:(NSString *)did uuid:(NSString *)uuid types:(NSString *)types newVersion:(NSString *)newVersion title:(NSString *)title brand:(NSString *)brand created:(NSString *)created update:(NSString *)update state:(NSString *)state picture:(NSArray *)picture regional:(NSArray *)regional parameter:(NSArray *)parameter;
/// 情景 请求帧
+ (NSString *)stringWithSceneType:(NSString *)type did:(NSString *)did title:(NSString *)title picture:(NSArray *)picture data:(NSArray *)data;


/// UDP  请求帧
+ (NSString *)stringWithUDPMsgDict:(NSMutableDictionary *)msgDict;

///获取当前wifi的名称
+ (NSString *)stringWithGetWifiName;

/// 获取当前时间
+ (NSString *)loadCurrentDate;
/// 获取用户UUID
+ (NSString *)stringWithUUID;
- (NSString *) toUnicode;
/**
 *  unicode转中文
 *
 *  @param unicodeStr unicode字符串
 *
 *  @return 转换好的中文
 */
- (NSString *)replaceUnicode:(NSString *)unicodeStr;
/**
 *  c语音 base64加密
 *
 *  @return 加密好的数据
 */
+ (NSString *)hr_stringWithBase64;
+ (NSString *)hr_stringWithBase64String:(NSString *)baseString;
@end
