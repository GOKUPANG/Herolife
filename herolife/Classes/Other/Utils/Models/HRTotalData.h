//
//  HRTotalData.h
//  xiaorui
//
//  Created by sswukang on 16/4/7.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRTotalData : NSObject<NSCoding>
/** 设备品牌 */
@property(nonatomic, copy) NSString *brand;
/** 设备创建时间 */
@property(nonatomic, copy) NSString *created;
/** 子设备ID(小睿是主属设备，设备ID为主属设备ID) */
@property(nonatomic, copy) NSString *did;
/** 主属设备id, 该设备是子设备，它的主机id */
@property(nonatomic, copy) NSString *mid;
/** 设备参数 */
@property(nonatomic, strong) NSArray *parameter;
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

@property(nonatomic, copy) NSString *addr;

- (instancetype _Nullable)initWithDict:(NSDictionary * _Nullable)dict;
+ (instancetype _Nullable)totalDataWithDict:(NSDictionary * _Nullable)dict;
@end
