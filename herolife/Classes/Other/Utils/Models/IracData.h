//
//  IracData.h
//  xiaorui
//
//  Created by sswukang on 16/4/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IracData : NSObject

/** 设备品牌 */
@property(nonatomic, copy) NSString *brand;
/** 设备创建时间 */
@property(nonatomic, copy) NSString *created;
/** 子设备ID(小睿是主属设备，设备ID为主属设备ID) */
@property(nonatomic, copy) NSString *did;
/** 主属设备id, 该设备是子设备，它的主机id */
@property(nonatomic, copy) NSString *mid;
/** 设备图标 */
@property(nonatomic, strong) NSArray *picture;
/** 设备区域归属 */
@property(nonatomic, strong) NSArray *regional;
/** 设备状态 */
@property(nonatomic, copy) NSString *state;
/** 设备名称 */
@property(nonatomic, copy) NSString *title;
/** 设备类型, 小睿的温湿度为:"humiture" */
@property(nonatomic, copy) NSString *types;
/** 该设备所属用户ID, 该ID下可能有多个设备 */
@property(nonatomic, copy) NSString *uid;
/** 设备信息更新时间 */
@property(nonatomic, copy) NSString *update;
/** 设备唯一标识 */
@property(nonatomic, copy) NSString *uuid;
/** 设备本版号 */
@property(nonatomic, copy) NSString *version;
/**型号  */
@property(nonatomic, copy) NSString *model;
/** FF： 开，00：关，其余参数无效 */
@property(nonatomic, copy) NSString *switchOff;
/** 00：自动  01：制冷   02：除湿    03：送风   04：制暖  */
@property(nonatomic, copy) NSString *mode;
/**温度值 范围：10H - 1EH （16-31度）其余无效  */
@property(nonatomic, copy) NSString *temperature;
/** 00 = 自动  01=1档   02=2档    03=3档  其余无效 */
@property(nonatomic, copy) NSString *windspeed;
/** 00 = 自动摆风  01手动摆风  其余无效 */
@property(nonatomic, copy) NSString *winddirection;

/**消息类型, 作为处理该条消息类型使用,None为无类型  */
@property(nonatomic, copy) NSString *type;
/**请求  或响应 的状态码  */
@property(nonatomic, copy) NSString *status;

- (instancetype _Nullable)initWithDict:(NSDictionary * _Nullable)dict;
+ (instancetype _Nullable)iracDataWithDict:(NSDictionary * _Nullable)dict;
@end
