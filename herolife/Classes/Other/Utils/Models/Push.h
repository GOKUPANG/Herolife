//
//  Push.h
//  03.群聊客户端
//
//  Created by 海波 on 16/4/17.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Push : NSObject<NSCoding>

/**消息本版*/
@property(nonatomic, copy) NSString *version;

/**接口状态, 返回代码
 200  正常推送数据包
 201  错误，推送json数据格式错误
 202  拒绝服务，源用户或设备未认证
 203  拒绝服务，token令牌错误
 204  未开放该服务
 205  HRPUSH协议错误
 220  推送应答，目标用户设备在线并成功推送消息
 221  推送失败，目标用户(设备)不在线
 222  服务错误
 223  目标设备错误
 224  目标用户不存在
 225  目标设备不存在
 226  推送消息体格式错误
 240  用户认证成功
 241  该用户名下同名设备已经登陆
 242  登陆信息错误
 243  登陆失败次数超过最大限制
 244  登陆失败,户名不存在
 245  登陆失败,密码错误
 246  登陆失败,用户名或密码错误
 247  服务器内部错误
 */
@property(nonatomic, copy) NSString *status;

/**服务器传输时间  */
@property(nonatomic, copy) NSString *time;

/**会话令牌, 未认证用户返回None  */
@property(nonatomic, copy) NSString *token;

/**消息类型, 作为处理该条消息类型使用,None为无类型  */
@property(nonatomic, copy) NSString *type;

/**消息说明, 为消息主题msgBody格式说明, 如约定好,则可为None  */
@property(nonatomic, copy) NSString *desc;

/**数据来源,username@devname, 设备名可以根据本机名称(UUID)或者自定义，匿名 anonymous@anonymous 不允许请求。  */
@property(nonatomic, copy) NSString *src;

/**数据目标,username@devname,目标设备名称(UUID)或者自定义,转发目标依据。  */
@property(nonatomic, copy) NSString *dst;

/**消息内容主体,通常为完成json字符串、字符串和None为无数据  */
@property(nonatomic, copy) NSString *msg;
/**  */
@property(nonatomic, copy) NSString *fromUserName;
/**  */
@property(nonatomic, copy) NSString *fromDevName;
/**  */
@property(nonatomic, copy) NSString *destUserName;
/**  */
@property(nonatomic, copy) NSString *destDevName;
- (instancetype)initWithPushDict:(NSDictionary *)pushDict;
+ (instancetype)pushWithPushDict:(NSDictionary *)pushDict;

@end
