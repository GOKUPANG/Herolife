//
//  CreateXRHttpTools.h
//  xiaorui
//
//  Created by sswukang on 16/7/20.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateXRHttpTools : NSObject

/**
 *  创建红外地址码
 *
 *  @param mid          小睿mid
 *  @param title        用户输入的小睿 名称
 *  @param responseDict 返回请求成功字典
 *  @param result       返回请求失败信息
 */
+ (void)postHttpCreateIrdevWithMid:(NSString *)mid title:(NSString *)title responseDict:(void(^)(NSDictionary *dict))responseDict result:(void(^)(NSError *error))result;
/**
 *  创建单火地址码
 *
 *  @param mid          小睿mid
 *  @param title        用户输入的小睿 名称
 *  @param responseDict 返回请求成功字典
 *  @param result       返回请求失败信息
 */
+ (void)postHttpCreateSingleswitchWithMid:(NSString *)mid title:(NSString *)title responseDict:(void(^)(NSDictionary *dict))responseDict result:(void(^)(NSError *error))result;

@end
