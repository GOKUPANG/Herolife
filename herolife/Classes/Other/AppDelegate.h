//
//  AppDelegate.h
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) NSMutableArray *iracArray;
@property(nonatomic, strong) NSMutableArray *irgmArray;
@property(nonatomic, strong) NSMutableArray *doArray;
@property(nonatomic, strong) NSMutableArray *sceneArray;
//wift 名称
@property(nonatomic, strong) NSArray *wifiNameArray;
/** 授权列表 */
@property(nonatomic, strong) NSArray *authlistArray;
/** 信号强弱 */
@property(nonatomic, strong) NSArray *rssilistArray;
/** 第4步 连接用户自己的wifi 成功后保存的数据 */
@property(nonatomic, strong) NSDictionary *msgDictionary;
/**
 *  外界发数据的接口
 *
 *  @param name 字符串
 */
- (void)sendMessageWithString:(NSString *)name;
/**
 *  socket连接主机
 */
- (void)connectToHost;
/// 断开连接
- (void)disconnectionToHost;


#pragma mark - 空调相关方法
//创建空调 帧
- (void)addCreateIracDict:(NSDictionary *)dict;

//监听空调的删除帧
- (void)addDeleteIracDict:(NSDictionary *)dict;
//监听空调的更新帧
- (void)addUpdateIracDict:(NSDictionary *)dict;
//监听空调的测试帧
- (void)addTestingIracDict:(NSDictionary *)dict;
//监听空调的控制帧
- (void)addControlIracDict:(NSDictionary *)dict;

#pragma mark - HTTP
//监听空调的控制帧
- (void)addHTTPIracArray:(NSMutableArray *)array;
//监听通用控制帧
- (void)addHTTPIrgmArray:(NSMutableArray *)array;
- (void)addHTTPDoArray:(NSMutableArray *)array;
- (void)addHTTPSceneArray:(NSMutableArray *)array;
#pragma mark - 通用相关方法
//创建通用 帧
- (void)addCreateIrgmDict:(NSDictionary *)dict;
//监听通用的删除帧
- (void)addDeleteIrgmDict:(NSDictionary *)dict;
//监听通用的更新帧
- (void)addUpdateIrgmDict:(NSDictionary *)dict;
//监听通用的测试帧
- (void)addTestingIrgmDict:(NSDictionary *)dict;
//监听通用的控制帧
- (void)addControlIrgmDict:(NSDictionary *)dict;
#pragma mark - 开关相关方法
//创建开关 帧
- (void)addCreateDoDict:(NSDictionary *)dict;
//监听开关的删除帧
- (void)addDeleteDoDict:(NSDictionary *)dict;
//监听开关的更新帧
- (void)addUpdateDoDict:(NSDictionary *)dict;
//监听开关的测试帧
- (void)addTestingDoDict:(NSDictionary *)dict;
//监听开关的控制帧
- (void)addControlDoDict:(NSDictionary *)dict;

@end

