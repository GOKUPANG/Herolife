//
//  AppDelegate.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#define ShareSDKAppId @"164558e46c000"
//#define QQSDKAppId @"1105629306"
//#define QQSDKAppKey @"Ig2gYUcepC3rE9NH"

#define QQSDKAppId @"101350673"
#define QQSDKAppKey @"1aad5325072a03bb9a70033c0ca70cb8"
//友盟KEY
#define UMENG_APP_KEY @"57faf95be0f55a66910032ab"
//#define QQSDKAppId @"1105687414"
//#define QQSDKAppKey @"PsuNc7Du8MrvTW9H"

#import "AppDelegate.h"
#import "LoginController.h"
#import "HRTabBarViewController.h"
#import "HRNavigationViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "RegisterViewController.h"
#import "IracData.h"
#import "IrgmData.h"
#import "HRDOData.h"
#import "UIImageView+WebCache.h"
#import "HRSceneData.h"
#import "TipsLabel.h"
#import "Push.h"
#import "EnterPSWController.h"
#import "GoToSetUpController.h"
#import "DeviceListTcpModel.h"
#import "HRPushMode.h"
#import "EBForeNotification.h"
#import "DeviceAutherModel.h"
#import "DeviceListModel.h"
#import "GestureViewController.h"
#import "NewFeatureController.h"

#import "UMMobClick/MobClick.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<AsyncSocketDelegate, UNUserNotificationCenterDelegate>
/** time */
@property(nonatomic, strong) NSTimer *heartTimer;

@property (nonatomic, strong) AsyncSocket *socket;
@property (nonatomic, retain) NSTimer *connectTimer;

@property(nonatomic, strong) TipsLabel *tipsLabel;
/** UILabel */
@property(nonatomic, weak) UILabel *label;

@property(nonatomic, strong) HRUDPSocketTool  *udpSocket;
/** 停留时间 */
@property(nonatomic, assign) int leftTime;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
/** 超时定时器 */
@property(nonatomic, weak) NSTimer *overTimer;
@end
/** 停留时间 */
static int const HRTimeDuration = 3;


@implementation AppDelegate

/// 记录失败 连接次数
static NSInteger disconnectCount = 0;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//友盟统计
	[self addUmeng];
	//显示界面
	[self setupWindow];
	
	//集成ShareSDK
	[self addShareSDK];
	
    //获取手机UUID保存下来
    if (![kUserDefault objectForKey:kUserDefaultDeviceUUID]) {
        NSString *UUID = [NSString stringWithUUID];
        [kUserDefault setObject:UUID forKey:kUserDefaultDeviceUUID];
        [kUserDefault synchronize];
    }
	/******* 日志 ********/
#ifdef DEBUG
	[self setLogger];
#endif
	
	
	self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES]; // 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
	
	[self.connectTimer fire];
	//监听登入认证通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedLoginData:) name:kNotificationLogin object:nil];
	
	
	//处理iOS8本地推送不能收到
	float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
	if (sysVersion>=8.0) {
		UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
		UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
		[[UIApplication sharedApplication]registerUserNotificationSettings:setting];
	}
	
	[application setMinimumBackgroundFetchInterval:1.0];
	
	
	//添加通知
	[kNotification addObserver:self selector:@selector(receiveWiFiList) name:kNotificationReceiveWiFiList object:nil];
	
	//远程推送相关
	//监听点击事件
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dddd:) name:EBBannerViewDidClick object:nil];
	if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0 && [[[UIDevice currentDevice]systemVersion]floatValue] < 10.0)
		
	{
		
		[[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
																			
																			settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)
																			
																			categories:nil]];
		
		
    }else if([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0)
        
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
        
    }else{
		
		//注册启用push
		
		[[UIApplication sharedApplication]registerForRemoteNotificationTypes:
		 
		 (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
		
	}
    
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
	
	
	return YES;
}
#pragma mark - UNUserNotificationCenterDelegate - ios10 远程通知代理
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler//App在前台的时候收到推送执行的回调方法
{
    //获取通知数据
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    //App在后台的时候，点击推送信息，进入App后执行的 回调方法
    //获取通知数据
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
}
- (void)addUmeng
{
	
	UMConfigInstance.appKey = UMENG_APP_KEY;
	UMConfigInstance.channelId = nil;
	UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
	
	[MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
	
//		[MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:BATCH channelId:nil];
//	[MobClick startWithConfigure:<#(UMAnalyticsConfig *)#>]
//		[MobClick setAppVersion:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
//		[MobClick setCrashReportEnabled:YES];
}
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	//让启动图片显示久一些
	[NSThread sleepForTimeInterval:1.0];
	if([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
		
	{
		
		[[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
																			
																			settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)
																			
																			categories:nil]];
		
		[[UIApplication sharedApplication]registerForRemoteNotifications];
		
	}else{
		
		//这里还是原来的代码
		
		//注册启用push
		
		[[UIApplication sharedApplication]registerForRemoteNotificationTypes:
		 
		 (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
		
	}

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString *deToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@"" ] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	[kUserDefault setObject:deToken forKey:kUserDefaultUUID];
	[kUserDefault synchronize];
     NSLog(@"................token:%@", deToken);
   
    
    
    /*
     
     弹窗 弹出token 
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:deToken preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
     
     
     */
    
    
    
    
    
    
	
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	DDLogWarn(@"error inregisteration%@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	
	DDLogWarn(@"didReceiveRemoteNotification%@", userInfo);
	[EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
	
}

-(void)dddd:(NSNotification*)noti{
	NSLog(@"ddd,%@",noti);
}
static BOOL isOverTime = NO;
- (void)receiveWiFiList
{
	isOverTime = YES;
	[SVProgressTool hr_dismiss];
	UINavigationController *nav = (UINavigationController *)[NSObject activityViewController];
	
	for (UIViewController *topVC in nav.childViewControllers) {
		HRNavigationViewController *hrNav = (HRNavigationViewController *)topVC;
		for (id navVC in hrNav.childViewControllers) {
			
			NSLog(@"topVC%@", NSStringFromClass([navVC class]));
			if ([navVC isKindOfClass:[EnterPSWController class]]) {
				DDLogWarn(@"VC-%@",NSStringFromClass([navVC class]));
			}else if ([navVC isKindOfClass:[GoToSetUpController class]]) {
				DDLogWarn(@"VC-%@",NSStringFromClass([navVC class]));
				EnterPSWController *enterVC = [[EnterPSWController alloc] init];
				GoToSetUpController *gto = (GoToSetUpController *)navVC;
			[gto.navigationController pushViewController:enterVC animated:YES];
			}
//			{
//				//收到通知跳转到wifi 输入密码这个界面
//				EnterPSWController *enterVC = [[EnterPSWController alloc] init];
//				DDLogWarn(@"VC2-%@",NSStringFromClass([topController class]));
//				
//				[topController.navigationController pushViewController:enterVC animated:YES];
//				
//			}

		}
	}
	UIViewController *topController = nav.childViewControllers.lastObject;
	
//	UIViewController *topController = [AppDelegate currentViewController];
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
	
}
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
	
	DDLogWarn(@"-------------handleEventsForBackgroundURLSession--%@------------------", identifier);
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	DDLogInfo(@"234");
//	__block UIBackgroundTaskIdentifier bgTask;// 后台任务标识
//	// 结束后台任务
//	void (^endBackgroundTask)() = ^(){
//		[application endBackgroundTask:bgTask];
//		bgTask = UIBackgroundTaskInvalid;
//	};
//	
//	bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//		endBackgroundTask();
//	}];
//	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		
//
//		
//		
//	});
	//延时后台进程
	[self beginBackgroundTask];
	//后台任务
	[self endBackgroundTask];
}
- (void)beginBackgroundTask {
	UIBackgroundTaskIdentifier bgTask;
	UIApplication *application = [UIApplication sharedApplication];
	bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
		[self endBackgroundTask];
	}];
}

- (void)endBackgroundTask {
	UIBackgroundTaskIdentifier bgTask;
	UIApplication *application = [UIApplication sharedApplication];
	[application endBackgroundTask:bgTask];
	bgTask = UIBackgroundTaskInvalid;
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	//建立UDP连接
	[self setupUDPSocket];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[SVProgressTool hr_showWithStatus:@"正在加载数据, 请稍后..."];
		
		// 启动定时器
		isOverTime = NO;
		[_overTimer invalidate];
		//十秒之后如果没有数据就提示超时
		_overTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	});
	
	
	
	NSLog(@"noti:%@",notification);
	// 这里真实需要处理交互的地方
	// 获取通知所带的数据
//	NSString *notMess = [notification.userInfo objectForKey:@"key"];
}
- (void)startTimer
{
	if (!isOverTime) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时, 请重试!"];
		
		UIViewController *topController = [AppDelegate currentViewController];
		if ([topController isKindOfClass:[EnterPSWController class]]) {
			DDLogWarn(@"VC-%@",NSStringFromClass([topController class]));
		}else
		{
			[topController.navigationController popViewControllerAnimated:YES];
			
		}
	}
}
+ (UIViewController *)currentViewController
{
 UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
 // modal展现方式的底层视图不同
 // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
 UIView *firstView = [keyWindow.subviews firstObject];

 UIViewController *viewC ;
 UIResponder *responder = [firstView nextResponder];
 while (responder) {
	 if ([responder isKindOfClass:[UIViewController class]]) {
		viewC = (UIViewController *)responder;
	 }
	 responder = [responder nextResponder];
 }
	
 UIViewController *vc = viewC;
 if ([vc isKindOfClass:[UITabBarController class]]) {
	 UITabBarController *tab = (UITabBarController *)vc;
	 if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
		 UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
		 return [nav.viewControllers lastObject];
	 } else {
		 return tab.selectedViewController;
	 }
 } else if ([vc isKindOfClass:[UINavigationController class]]) {
	 UINavigationController *nav = (UINavigationController *)vc;
	 return [nav.viewControllers lastObject];
 } else {
	 return vc;
 }
 return nil;
}
- (UIViewController *)parentController
{
 UIResponder *responder = [self nextResponder];
 while (responder) {
	 if ([responder isKindOfClass:[UIViewController class]]) {
		 return (UIViewController *)responder;
	 }
	 responder = [responder nextResponder];
 }
 return nil;
}
- (UIViewController *)getCurrentVC
{
	UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
	
	while (topController.presentedViewController) {
		topController = topController.presentedViewController;
	}
	
	return topController;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSString *wifi = [NSString stringWithGetWifiName];
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	DDLogInfo(@"wifi----------------%@",wifi);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[SDWebImageManager sharedManager].imageCache clearMemory];
	[[SDWebImageManager sharedManager] cancelAll];
	
}

#pragma mark ***************************** Socket处理相关 ***************************

/**
 *  socket连接服务器
 */
- (void)connectToHost
{
	if(_socket==nil)
	{
		_socket=[[AsyncSocket alloc] initWithDelegate:self];
		NSError *error=nil;
		if(![_socket connectToHost:@SERVER_IP onPort:SERVER_PORT error:&error])
		{
			DDLogInfo(@"连接失败！");
		}
		else
		{
			DDLogInfo(@"已连接!");
		}
	}
	else
	{
		DDLogInfo(@"已连接!");
		
	}
	
}

- (void)disconnectionToHost
{
	_socket = nil;
	_socket.delegate = nil;
	[_socket disconnect];
}
- (void)sendMessageWithString:(NSString *)name
{
	NSString *loginname = name;
	
	NSData *data = [loginname dataUsingEncoding:NSUTF8StringEncoding];
	[_socket writeData:data withTimeout:-1 tag:0];
}

#pragma mark ***************************** AsyncScoket Delagate ***************************
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	DDLogInfo(@"连接到服务器onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);
	if (_socket.isConnected) {
		disconnectCount = 0;
	}
	[sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	
	[sock readDataWithTimeout: -1 tag: 0];
}
#pragma mark - label 懒加载
- (UILabel *)label
{
	if (!_label) {
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenW *0.15, (UIScreenH -64) *0.5, UIScreenW - UIScreenW *0.3, 50)];
		label.text = @"未连接到服务器!";
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:18];
		label.textColor = [UIColor redColor];
		label.backgroundColor = [UIColor themeColor];
		_label = label;
		
		
		[[UIApplication sharedApplication].keyWindow addSubview:label];
	}
	return _label;
}
- (TipsLabel *)tipsLabel
{
	if (!_tipsLabel) {
		_tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 64, UIScreenW, 30)];
		
		[[UIApplication sharedApplication].keyWindow addSubview:_tipsLabel];
	}
	return _tipsLabel;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
	DDLogInfo(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	DDLogError(@"将要断开连接onSocket:%p willDisconnectWithError:%@,code %ld", sock, err.description, (long)err.code);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	//	if (disconnectCount <= 3) {
	
	//断开连接了
	DDLogInfo(@"断开连接了onSocketDidDisconnect:%p", sock);
	//    NSString *msg = @"Sorry this connect is failure";
	_socket = nil;
	_socket.delegate = nil;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self connectToHost];
		disconnectCount++;
		NSString *passWold = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsPassWord];
		NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
		DDLogWarn(@"%@", userName);
		NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
		bodyDict[@"user"] = userName;
		bodyDict[@"pass"] = passWold;
		//登入认证  组帧
        NSString *UUID = [kUserDefault objectForKey:kUserDefaultDeviceUUID];
        NSString *token = [NSString stringWithFormat:@"ios+@+%@", UUID];
		NSString *str = [NSString stringWithPostTCPJsonVersion:@"0.0.1" status:@"200" token:token msgType:@"login" msgExplain:@"login" fromUserName:userName destUserName:@"huaruicloud" destDevName:@"huaruiPushServer" msgBodyStringDict:bodyDict];
		DDLogWarn(@"onSocket登入认证%@", str);
		NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
		
		[self.socket writeData:data withTimeout:-1 tag:0];
		if (disconnectCount >= 10) {
			
			[self.tipsLabel showText:@"未连接到服务器!" duration:666666666];
		}
		
	});
	
}

#pragma mark - 通知 方法 获得token
- (void)receviedLoginData:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	Push *push = [Push mj_objectWithKeyValues:dict[@"hrpush"]];
	[[NSUserDefaults standardUserDefaults] setObject:push.token forKey:PushToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
	return 10.0;
}
// 心跳连接
-(void)longConnectToSocket{
	
	// 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
	NSString *longConnect = @"hrhb\r\n\0";
	NSData  *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
	[_socket writeData:dataStream withTimeout:-1 tag:1];
	
}
#pragma mark - 懒加载
- (NSMutableArray *)iracArray
{
	if (!_iracArray) {
		_iracArray = [NSMutableArray array];
	}
	return _iracArray;
}
- (NSMutableArray *)irgmArray
{
	if (!_irgmArray) {
		_irgmArray = [NSMutableArray array];
	}
	return _irgmArray;
}
- (NSMutableArray *)doArray
{
	if (!_doArray) {
		_doArray = [NSMutableArray array];
	}
	return _doArray;
}
- (NSMutableArray *)sceneArray
{
	if (!_sceneArray) {
		_sceneArray = [NSMutableArray array];
	}
	return _sceneArray;
}
- (NSMutableArray *)autherArray
{
	if (!_autherArray) {
		_autherArray = [NSMutableArray array];
	}
	return _autherArray;
}
- (NSMutableArray *)homeArray
{
	if (!_homeArray) {
		_homeArray = [NSMutableArray array];
	}
	return _homeArray;
}
static NSString *sockDataStr = @"";
static NSUInteger lengthInteger = 0;
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	
	[self.tipsLabel dismiss];
	
	
 if (data.length > 0 ) {
		
	 NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	 
	// DDLogWarn(@"didReadData strData没截取  收到的数据%@", strData);
	 //如果是心跳包就不往下传值
	 if ([strData containsString:@"hrhb\r\n\0"]) {
		 //		 DDLogWarn(@"didReadData strData没截取  收到的数据%@", strData);
		 return;
	 }
	 
	 //下次 就可能没有length的情况
	 //截取  length字符串
	 if ([strData containsString:@"length\r\n"]) {
		 
		 lengthInteger = [strData rangeOfString:@"length\r\n" options:NSCaseInsensitiveSearch].location + [strData rangeOfString:@"length\r\n" options:NSCaseInsensitiveSearch].length;
		 
		 if (lengthInteger < 9 && lengthInteger > strData.length)
		 {return;}
		 
		 NSString *lengthStr = [strData substringFromIndex:lengthInteger];
		 
		 NSUInteger nowLength = [strData rangeOfString:@"\r\n" options:NSCaseInsensitiveSearch].location;
		 lengthStr = [lengthStr substringToIndex:nowLength];
		 NSUInteger lengthIteger = [lengthStr integerValue];
		 /// 得到的字符串要经过两次 截取
		 NSUInteger index = -1;
		 index = [strData rangeOfString:@"{" options:NSCaseInsensitiveSearch].location;
		 if (strData.length < index) {
			 return ;
		 }
		 
		 strData = [strData substringFromIndex:index];
		 
		 //用了个全局变量记录 第一次进来sockDataStr为空  如果长度小于 截取的长度 就会 在保存的全局变量 里 再拼接一次
		 sockDataStr = [NSString stringWithFormat:@"%@%@", sockDataStr, strData];
		 //如果接收到的字符串长度  小于 总长度 就什么都不做
		 if (![strData containsString:@"\r\n\0"] && sockDataStr.length != lengthIteger + 3) {
			 
			 return;
		 }
		 
		 [self sockDataStrWithString: sockDataStr];
		 
	 }else
	 {
		 sockDataStr = [NSString stringWithFormat:@"%@%@", sockDataStr, strData];
		 //如果接收到的字符串长度  小于 总长度 就什么都不做
		 if (![strData containsString:@"\r\n\0"] && sockDataStr.length != lengthInteger + 3) {
			 
			 return;
		 }
		 [self sockDataStrWithString: sockDataStr];
	 }
	 
 }
	[_socket readDataWithTimeout:-1 tag:0];
	// 处理完一个完整的帧  就要 清空全局变量
	sockDataStr = @"";
	lengthInteger = 0;
}

#pragma mark - 接收 数据 判断类型type
- (void)sockDataStrWithString:(NSString *)str
{
	
	NSUInteger nowIndex = [str rangeOfString:@"\r\n\0"].location;
	str = [str substringToIndex:nowIndex];
	
	/// 把截取好的字符串转换成UTF-8二进制数据
	NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
	/// 把二进制数据 转成JSON字典
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
	
	//如果有错误信息
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"error"])
	{
		
		//如果有设备不在线信息
		if ([jsonDict[@"hrpush"][@"desc"] containsString:@"push failed, target not online"])
		{
			DDLogInfo(@"接收到设备不在线 数据%@", jsonDict);
			[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNotOnline object:nil];
			
			return;
			
			
		}
		
		DDLogInfo(@"接收到错误 数据%@", jsonDict);
		return;
	}
	
	//登陆认证 数据
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"login"]) {
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogin object:nil userInfo:jsonDict];
		DDLogInfo(@"接收到登陆认证 数据%@", jsonDict);
	}
	
#pragma mark -  斌添加的代码
	
	
	//过滤服务器回复的pushok
	
	if ([jsonDict [@"hrpush"][@"desc"] isEqualToString:@"push ok"]) {
		NSLog(@"接收到服务器的返回push ok- 要过滤掉");
		
	}
	/****************************开锁接收数据的判断*****************************/
	
	else if ([jsonDict[@"msg"][@"types"] isEqualToString:@"hrsc"] && [jsonDict[@"msg"][@"control"] isEqualToString:@"1"]) {
		
		
		
		
		NSLog(@"接收到门锁状态的数据,正在请求动态密码");
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kDoorOnlineOrNot" object:nil userInfo:jsonDict];
		
		
		
	}
	
	
	else  if ([jsonDict[@"msg"][@"types"] isEqualToString:@"hrsc"] &&[jsonDict[@"msg"][@"control"] intValue] >2) {
		
		
		
		
		NSLog(@"接收到门锁开锁是否成功的数据");
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kDoorOpenOrNot" object:nil userInfo:jsonDict];
		
		
	}
	
	/************************** 斌添加的代码完毕 *************************************/
	
	
	
	//创建红外空调
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"create"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irac"]) {
		
		[self addCreateIracDict:jsonDict];
		DDLogInfo(@"接收到创建红外空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateIrac object:nil userInfo:jsonDict];
		
	}
	
	//删除红外空调
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"delete"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irac"]) {
		
		[self addDeleteIracDict:jsonDict];
		DDLogInfo(@"接收到删除空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteIrac object:nil userInfo:jsonDict];
		
	}
	//更新红外空调
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"update"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irac"]) {
		
		[self addUpdateIracDict:jsonDict];
		DDLogInfo(@"接收到更新空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateIrac object:nil userInfo:jsonDict];
		
	}
	//调试红外空调
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"testing"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irac"]) {
		
		[self addTestingIracDict:jsonDict];
		DDLogInfo(@"接收到调试空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTestingIrac object:nil userInfo:jsonDict];
		
	}
	//控制红外空调
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"control"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irac"]) {
		
		[self addControlIracDict:jsonDict];
		DDLogInfo(@"接收到控制空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationControlIrac object:nil userInfo:jsonDict];
		
	}
	
	//创建红外通用
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"create"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irgm"]) {
		
		[self addCreateIrgmDict:jsonDict];
		DDLogInfo(@"接收到创建红外空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateIrgm object:nil userInfo:jsonDict];
		
	}
	
	//删除红外通用
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"delete"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irgm"]) {
		
		[self addDeleteIrgmDict:jsonDict];
		DDLogInfo(@"接收到删除空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteIrgm object:nil userInfo:jsonDict];
		
	}
	//更新红外通用
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"update"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irgm"]) {
		
		[self addUpdateIrgmDict:jsonDict];
		DDLogInfo(@"接收到更新空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateIrgm object:nil userInfo:jsonDict];
		
	}
	//调试红外通用
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"testing"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irgm"]) {
		
		[self addTestingIrgmDict:jsonDict];
		DDLogInfo(@"接收到通用 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTestingIrgm object:nil userInfo:jsonDict];
		
	}
	//控制红外通用
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"control"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"irgm"]) {
		
		[self addControlIrgmDict:jsonDict];
		DDLogInfo(@"接收到控制空调 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationControlIrgm object:nil userInfo:jsonDict];
		
	}
	
	//创建开关
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"create"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"hrdo"]) {
		
		[self addCreateDoDict:jsonDict];
		DDLogInfo(@"接收到创建开关 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateDo object:nil userInfo:jsonDict];
		
	}
	
	//删除开关
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"delete"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"hrdo"]) {
		
		[self addDeleteDoDict:jsonDict];
		DDLogInfo(@"接收到删除开关 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteDo object:nil userInfo:jsonDict];
		
	}
	//更新开关
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"update"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"hrdo"]) {
		
		[self addUpdateDoDict:jsonDict];
		DDLogInfo(@"接收到更新开关 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateDo object:nil userInfo:jsonDict];
		
	}
	//调试开关
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"testing"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"hrdo"]) {
		
		[self addTestingDoDict:jsonDict];
		DDLogInfo(@"接收到调试开关 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTestingDo object:nil userInfo:jsonDict];
		
	}
	//控制开关
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"control"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"hrdo"]) {
		
		[self addControlDoDict:jsonDict];
		DDLogInfo(@"接收到控制开关 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationControlDo object:nil userInfo:jsonDict];
	}
	
	//文本交互
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"message"]) {
		
		//		DDLogInfo(@"接收到文本交互 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMessage object:nil userInfo:jsonDict];
	}
	
	//创建情景
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"create"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"scene"]) {
		[self addCreateSceneDict:jsonDict];
		DDLogInfo(@"接收到创建情景 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateScene object:nil userInfo:jsonDict];
		
	}
	//更新情景
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"update"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"scene"]) {
		[self addUpdataSceneDict:jsonDict];
		DDLogInfo(@"接收到更新情景 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpDataScene object:nil userInfo:jsonDict];
		
	}
	
	//删除情景
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"delete"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"scene"]) {
		[self addDeleteSceneDict:jsonDict];
		DDLogInfo(@"接收到删除情景 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteScene object:nil userInfo:jsonDict];
		
	}
	//控制情景
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"control"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"scene"]) {
		[self addControlSceneDict:jsonDict];
		DDLogInfo(@"接收到控制情景 数据%@", jsonDict);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationControlScene object:nil userInfo:jsonDict];
		
	}
#pragma mark - herolife 收到的相关数据
	//设备硬件状态
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"state"]) {
		DDLogInfo(@"接收设备硬件状态  数据%@", jsonDict);
		HRPushMode *mode = [HRPushMode mj_objectWithKeyValues:jsonDict[@"hrpush"]];
		self.pushMode = mode;
		
		DeviceListTcpModel *tcpMode = [DeviceListTcpModel mj_objectWithKeyValues:jsonDict[@"msg"]];
		self.deviceListModel = tcpMode;
		self.stateDictionary = jsonDict;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeviceState object:nil userInfo:jsonDict];
		
	}
	
	//家人授权成功数据
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"create"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"common"]) {
		DDLogInfo(@"家人授权成功数据%@", jsonDict);
		
		[self addCreateAutherDict:jsonDict];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceiveDeviceAutherInformation object:nil userInfo:jsonDict];
		return;
	}
	
	// 删除家人授权数据
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"delete"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"common"]) {
		
		DDLogInfo(@"删除家人授权数据%@", jsonDict);
		
		[self addDelegateAutherDict:jsonDict];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceiveDeleteAutherInformation object:nil userInfo:jsonDict];
		return;
	}
	
	
	// 修改家人授权数据
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"update"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"common"]) {
		
		DDLogInfo(@"修改家人授权数据%@", jsonDict);
		
		[self addModifyAutherDict:jsonDict];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceiveDeviceAutherInformation object:nil userInfo:jsonDict];
		return;
	}
	
	// 创建临时授权数据
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"set"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"common"]) {
		
		DDLogInfo(@"创建临时授权数据%@", jsonDict);
		//用同样的方法,因为那个数组保存的都是授权信息
		[self addCreateAutherDict:jsonDict];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceiveTempAutherInformation object:nil userInfo:jsonDict];
		return;
	}
	
	// 推送设置界面
	if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"update"] && [jsonDict[@"msg"][@"types"] isEqualToString:@"hrsc"]) {
		
		DDLogInfo(@"推送设置界面%@", jsonDict);
		
		[self addPushDeviceDict:jsonDict];
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceivePushDeviceInformation object:nil userInfo:jsonDict];
		return;
	}
}
#pragma mark - 保存  数据 相关
#pragma mark - 推送设置
- (void)addPushDeviceDict:(NSDictionary *)dict
{
	DeviceListModel *listModel = [DeviceListModel mj_objectWithKeyValues: dict[@"msg"]];
	NSMutableArray *muArr = [NSMutableArray array];
	for (DeviceListModel *mode in self.homeArray) {
		if ([mode.uuid isEqualToString: listModel.uuid] && [mode.did isEqualToString: listModel.did] && [mode.uid isEqualToString: listModel.uid])
		{
			mode.op = listModel.op;
		}
		[muArr addObject:mode];
	}
	self.homeArray = muArr;
	
}

#pragma mark - 创建临时授权
- (void)addCreateTempDict:(NSDictionary *)dict
{
}
#pragma mark - 授权管理
- (void)addModifyAutherDict:(NSDictionary *)dict
{
	DDLogWarn(@"addModifyAutherDict---%@%lu", self.homeArray, (unsigned long)self.homeArray.count);
	DeviceAutherModel *auther = [DeviceAutherModel mj_objectWithKeyValues: dict[@"msg"]];
	NSMutableArray *muArr = [NSMutableArray array];
	for (DeviceAutherModel *mode in self.autherArray) {
		if ([mode.uuid isEqualToString: auther.uuid] && [mode.did isEqualToString: auther.did] && [mode.uid isEqualToString: auther.uid])
		{
			mode.permit = auther.permit;
		}
		[muArr addObject:mode];
	}
	self.autherArray = muArr;
}
- (void)addDelegateAutherDict:(NSDictionary *)dict
{
	
	DeviceAutherModel *auther = [DeviceAutherModel mj_objectWithKeyValues: dict[@"msg"]];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:self.autherArray];
	
	DDLogWarn(@"NSMutableArray%@count-%lu", arr, (unsigned long)arr.count);
			  
	for (DeviceAutherModel *mode in arr) {
		
		if ([mode.uuid isEqualToString: auther.uuid] && [mode.did isEqualToString: auther.did])
		{
			[self.autherArray removeObject:mode];
			
		}
		
	}
	DDLogWarn(@"autherArray%@count-%lu", self.autherArray, (unsigned long)self.autherArray.count);
}
//创建
- (void)addCreateAutherDict:(NSDictionary *)dict
{
	
	DeviceAutherModel *data = [DeviceAutherModel mj_objectWithKeyValues:dict[@"msg"]];
	[self.autherArray addObject:data];
	DDLogWarn(@"NSMutableArray%@count-%lu", self.autherArray, (unsigned long)self.autherArray.count);
}
#pragma mark - 空调
//创建空调 帧
- (void)addCreateIracDict:(NSDictionary *)dict
{
	IracData *data = [IracData mj_objectWithKeyValues:dict[@"msg"]];
	
	[self.iracArray addObject:data];
}

//监听空调的删除帧
- (void)addDeleteIracDict:(NSDictionary *)dict
{
	IracData *irac = [IracData mj_objectWithKeyValues: dict[@"msg"]];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:self.iracArray];
	
	for (IracData *mode in arr) {
		
		if ([mode.uuid isEqualToString: irac.uuid] && [mode.mid isEqualToString: irac.mid] && [mode.did isEqualToString: irac.did] && [mode.uid isEqualToString: irac.uid])
		{
			[self.iracArray removeObject:mode];
			
		}
		
	}
	
}
//监听空调的更新帧
- (void)addUpdateIracDict:(NSDictionary *)dict
{
	IracData *irac = [IracData mj_objectWithKeyValues: dict[@"msg"]];
	NSMutableArray *muArr = [NSMutableArray array];
	for (IracData *mode in self.iracArray) {
		if ([mode.uuid isEqualToString: irac.uuid] && [mode.mid isEqualToString: irac.mid] && [mode.did isEqualToString: irac.did] && [mode.uid isEqualToString: irac.uid])
		{
			mode.title = irac.title;
			mode.brand = irac.brand;
			mode.model = irac.model;
		}
		[muArr addObject:mode];
	}
	self.iracArray = muArr;
}
//监听空调的测试帧
- (void)addTestingIracDict:(NSDictionary *)dict
{
}
//监听空调的控制帧
- (void)addControlIracDict:(NSDictionary *)dict
{
	IracData *irac = [IracData mj_objectWithKeyValues:dict[@"msg"]];
	//	NSMutableArray *arr = [NSMutableArray array];
	NSMutableArray *arr = [NSMutableArray array];
	for (IracData *mode in self.iracArray) {
		
		if ([mode.uuid isEqualToString: irac.uuid] && [mode.mid isEqualToString: irac.mid] && [mode.did isEqualToString: irac.did] && [mode.uid isEqualToString: irac.uid])
		{
			mode.switchOff = irac.switchOff;
			mode.mode = irac.mode;
			mode.temperature = irac.temperature;
			mode.windspeed = irac.windspeed;
			mode.winddirection = irac.winddirection;
		}
		
		[arr addObject:mode];
	}
	self.iracArray = arr;
	DDLogInfo(@"iracArray2--%@", self.iracArray);
	
}
#pragma mark - 通用
//创建通用 帧
- (void)addCreateIrgmDict:(NSDictionary *)dict
{
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
	
	[self.irgmArray addObject:data];
}

//监听通用的删除帧
- (void)addDeleteIrgmDict:(NSDictionary *)dict
{
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:self.irgmArray];
	for (IrgmData *mode in arr) {
		
		if ([mode.uuid isEqualToString: data.uuid] && [mode.mid isEqualToString: data.mid] && [mode.did isEqualToString: data.did] && [mode.uid isEqualToString: data.uid])
		{
			[self.irgmArray removeObject:mode];
			
		}
		
	}
	DDLogError(@"addDeleteIracDict--%@", self.irgmArray);
	
}
//监听通用的更新帧
- (void)addUpdateIrgmDict:(NSDictionary *)dict
{
	IrgmData *irac = [IrgmData mj_objectWithKeyValues: dict[@"msg"]];
	
	
	NSMutableArray *arr = [NSMutableArray array];
	for (IrgmData *mode in self.irgmArray) {
		if ([mode.uuid isEqualToString: irac.uuid] && [mode.mid isEqualToString: irac.mid] && [mode.did isEqualToString: irac.did] && [mode.uid isEqualToString: irac.uid])
		{
			mode.title = irac.title;
			mode.name01 = irac.name01;
			mode.name02 = irac.name02;
			mode.name03 = irac.name03;
		}
		
		[arr addObject:mode];
	}
	self.irgmArray = arr;
	
	
	DDLogError(@"addDeleteIracDict--%@", self.iracArray);
}
//监听通用的测试帧
- (void)addTestingIrgmDict:(NSDictionary *)dict
{
	IrgmData *irac = [IrgmData mj_objectWithKeyValues: dict[@"msg"]];
	NSMutableArray *arr = [NSMutableArray array];
	
	for (IrgmData *mode in self.irgmArray) {
		
		if ([mode.uuid isEqualToString: irac.uuid] && [mode.mid isEqualToString: irac.mid] && [mode.did isEqualToString: irac.did] && [mode.uid isEqualToString: irac.uid])
		{
			mode.state = irac.state;
			mode.op = irac.op;
			mode.param01 = irac.param01;
			mode.param02 = irac.param02;
			mode.param03 = irac.param03;
		}
		
		
		[arr addObject:mode];
	}
	self.irgmArray = arr;
}
//监听通用的控制帧
- (void)addControlIrgmDict:(NSDictionary *)dict
{
	IrgmData *irac = [IrgmData mj_objectWithKeyValues: dict[@"msg"]];
	//	NSMutableArray *arr = [NSMutableArray array];
	NSMutableArray *arr = [NSMutableArray array];
	for (IrgmData *mode in self.irgmArray) {
		
		if ([mode.uuid isEqualToString: irac.uuid] && [mode.mid isEqualToString: irac.mid] && [mode.did isEqualToString: irac.did] && [mode.uid isEqualToString: irac.uid])
		{
		}
		
		[arr addObject:mode];
	}
	self.irgmArray = arr;
	DDLogInfo(@"iracArray2--%@", self.iracArray);
	
}

#pragma mark - 开关相关方法
//创建开关 帧
- (void)addCreateDoDict:(NSDictionary *)dict
{
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict[@"msg"]];
	
	for (HRDOData *mode in self.doArray) {
		
		if ([mode.uuid isEqualToString: data.uuid])
		{
			//更新开关
			mode.title = data.title;
			mode.parameter = data.parameter;
			return;
			
		}
	}
	//创建开关
	[self.doArray addObject:data];
}

//监听开关的删除帧
- (void)addDeleteDoDict:(NSDictionary *)dict
{
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict[@"msg"]];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:self.doArray];
	for (HRDOData *mode in arr) {
		
		if ([mode.uuid isEqualToString: data.uuid] && [mode.mid isEqualToString: data.mid] && [mode.did isEqualToString: data.did] && [mode.uid isEqualToString: data.uid])
		{
			[self.doArray removeObject:mode];
			
		}
		
	}
	DDLogError(@"addDeletedoArray--%@", self.doArray);
	
}
//监听开关的更新帧
- (void)addUpdateDoDict:(NSDictionary *)dict
{
	HRDOData *doData = [HRDOData mj_objectWithKeyValues: dict[@"msg"]];
	
	
	NSMutableArray *arr = [NSMutableArray array];
	for (HRDOData *mode in self.doArray) {
		if ([mode.uuid isEqualToString: doData.uuid] && [mode.mid isEqualToString: doData.mid] && [mode.did isEqualToString: doData.did] && [mode.uid isEqualToString: doData.uid])
		{
			
			mode.title = doData.title;
			NSString *parameterNum = doData.parameter.firstObject;
			NSString *parameterOp = doData.parameter[1];
			NSString *parameterName = doData.parameter[2];
			NSString *parameterStatus = doData.parameter[3];
			if ([parameterNum isEqualToString:@"1"]) {
				mode.parameter = @[mode.parameter.firstObject, parameterOp, parameterName, parameterStatus, mode.parameter[4], mode.parameter[5], mode.parameter[6], mode.parameter[7], mode.parameter[8], mode.parameter[9]];
    
			}else if ([parameterNum isEqualToString:@"2"])
			{
				mode.parameter = @[mode.parameter.firstObject, parameterOp, mode.parameter[2], mode.parameter[3], parameterName, parameterStatus, mode.parameter[6], mode.parameter[7], mode.parameter[8], mode.parameter[9]];
				
			}else if ([parameterNum isEqualToString:@"3"])
			{
				mode.parameter = @[mode.parameter.firstObject, parameterOp, mode.parameter[2], mode.parameter[3], mode.parameter[4], mode.parameter[5], parameterName, parameterStatus, mode.parameter[8], mode.parameter[9]];
			}else if ([parameterNum isEqualToString:@"4"])
			{
				mode.parameter = @[mode.parameter.firstObject, parameterOp, mode.parameter[2], mode.parameter[3], mode.parameter[4], mode.parameter[5], mode.parameter[6], mode.parameter[7], parameterName, parameterStatus];
			}
		}
		
		[arr addObject:mode];
	}
	self.doArray = arr;
	
	
	DDLogError(@"addDeletedoArray--%@", self.doArray);
}
//监听开关的测试帧
- (void)addTestingDoDict:(NSDictionary *)dict
{
	
}
//监听开关的控制帧
- (void)addControlDoDict:(NSDictionary *)dict
{
	HRDOData *doData = [HRDOData mj_objectWithKeyValues: dict[@"msg"]];
	
	
	NSMutableArray *arr = [NSMutableArray array];
	for (HRDOData *mode in self.doArray) {
		if ([mode.uuid isEqualToString: doData.uuid] && [mode.mid isEqualToString: doData.mid] && [mode.did isEqualToString: doData.did] && [mode.uid isEqualToString: doData.uid])
		{
			NSString *parameterNum = doData.parameter.firstObject;
			NSString *parameterOp = doData.parameter[1];
			NSString *parameterName = doData.parameter[2];
			NSString *parameterStatus = doData.parameter[3];
			
			if ([parameterNum isEqualToString:@"1"]) {
				mode.parameter = @[mode.parameter.firstObject, parameterOp, parameterName, parameterStatus, mode.parameter[4], mode.parameter[5], mode.parameter[6], mode.parameter[7], mode.parameter[8], mode.parameter[9]];
    
			}else if ([parameterNum isEqualToString:@"2"])
			{
				mode.parameter = @[mode.parameter.firstObject, parameterOp, mode.parameter[2], mode.parameter[3], parameterName, parameterStatus, mode.parameter[6], mode.parameter[7], mode.parameter[8], mode.parameter[9]];
				
			}else if ([parameterNum isEqualToString:@"3"])
			{
				mode.parameter = @[mode.parameter.firstObject, parameterOp, mode.parameter[2], mode.parameter[3], mode.parameter[4], mode.parameter[5], parameterName, parameterStatus, mode.parameter[8], mode.parameter[9]];
			}else if ([parameterNum isEqualToString:@"4"])
			{
				mode.parameter = @[mode.parameter.firstObject, parameterOp, mode.parameter[2], mode.parameter[3], mode.parameter[4], mode.parameter[5], mode.parameter[6], mode.parameter[7], parameterName, parameterStatus];
			}
		}
		
		[arr addObject:mode];
	}
	self.doArray = arr;
	DDLogInfo(@"doArray--%@", self.doArray);
	
}
#pragma mark - 情景相关方法
//创建情景 帧
- (void)addCreateSceneDict:(NSDictionary *)dict
{
	HRSceneData *data = [HRSceneData mj_objectWithKeyValues:dict[@"msg"]];
	
	//创建开关
	[self.sceneArray addObject:data];
}
//更新情景 帧
- (void)addUpdataSceneDict:(NSDictionary *)dict
{
	HRSceneData *data = [HRSceneData mj_objectWithKeyValues:dict[@"msg"]];
	for (HRSceneData *sceneData in self.sceneArray) {
		if ([sceneData.uuid isEqualToString:data.uuid] && [sceneData.did isEqualToString:data.did] && [sceneData.mid isEqualToString:data.mid] && [sceneData.uid isEqualToString:data.uid]) {
			sceneData.data = data.data;
			sceneData.title = data.title;
			sceneData.picture = data.picture;
		}
	}
}
//删除情景 帧
- (void)addDeleteSceneDict:(NSDictionary *)dict
{
	HRSceneData *data = [HRSceneData mj_objectWithKeyValues:dict[@"msg"]];
	NSMutableArray *temp = [NSMutableArray array];
	for (HRSceneData *sceneData in self.sceneArray) {
		if ([sceneData.uuid isEqualToString:data.uuid] && [sceneData.did isEqualToString:data.did] && [sceneData.mid isEqualToString:data.mid] && [sceneData.uid isEqualToString:data.uid])
		{
			
			continue;
			
		}
		[temp addObject:sceneData];
	}
	self.sceneArray = temp;
}
//控制情景 帧
- (void)addControlSceneDict:(NSDictionary *)dict
{
	
}
#pragma mark - HTTP
//添加HTTP数据
- (void)addHTTPIracArray:(NSMutableArray *)array
{
	[self.iracArray removeAllObjects];
	self.iracArray = array;
}

- (void)addHTTPIrgmArray:(NSMutableArray *)array
{
	[self.irgmArray removeAllObjects];
	
	self.irgmArray = array;
	
}
- (void)addHTTPDoArray:(NSMutableArray *)array
{
	[self.doArray removeAllObjects];
	
	self.doArray = array;
	
}

- (void)addHTTPSceneArray:(NSMutableArray *)array
{
	[self.sceneArray removeAllObjects];
	
	self.sceneArray = array;
	
}

//授权表数组
- (void)addHTTPAutherArray:(NSMutableArray *)array
{
	[self.autherArray removeAllObjects];
	
	self.autherArray = array;
	
}
#pragma mark - 一些自定义的方法
- (void)addShareSDK
{
	/**
	 *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
	 *  在将生成的AppKey传入到此方法中。
	 *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
	 *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
	 *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
	 */
 [ShareSDK registerApp:ShareSDKAppId
  
	   activePlatforms:@[
						 @(SSDKPlatformTypeQQ)]
			  onImport:^(SSDKPlatformType platformType)
  {
	  switch (platformType)
	  {
		  case SSDKPlatformTypeQQ:
			  [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
			default:
			  break;
	  }
  }
	   onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
  {
	  
	  switch (platformType)
	  {
		  case SSDKPlatformTypeQQ:
			  [appInfo SSDKSetupQQByAppId:QQSDKAppId
								   appKey:QQSDKAppKey
								 authType:SSDKAuthTypeBoth];
			  break;
		
		  default:
			  break;
	  }
  }];
}
- (void)setupWindow
{
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	NSString *herolife = [kUserDefault objectForKey:@"fisteDownLoadHerolife"];
	if (herolife.length < 1) {
		NewFeatureController *feature = [[NewFeatureController alloc] init];
		self.window.rootViewController = feature;
		[kUserDefault setObject:@"fisteDownLoadHerolife" forKey:@"fisteDownLoadHerolife"];
		[kUserDefault synchronize];
		return;
	}
	
	
	LoginController *loginVC = [[LoginController alloc] init];
	HRNavigationViewController *nav = [[HRNavigationViewController alloc] initWithRootViewController:loginVC];
	HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
	
	if ([Login isLogined]) {
		
		// /从数据库中取手势密码
		NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
		NSString *pas = [HRSqlite hrSqliteReceiveUnlockWithUid:uid];
		
		//如果数据库中有就让他显示手势解锁界面
		if (pas && ![pas isKindOfClass:[NSNull class]]) {
			GestureViewController *gestureVc = [[GestureViewController alloc] init];
			DDLogInfo(@"Appdegate---pas%@", pas);
			gestureVc.type = GestureViewControllerTypeLogin;
			
			self.window.rootViewController = gestureVc;
			return;
		}
		
		//如果没有就让他显示tabbar界面
		self.window.rootViewController = tabBarVC;
	}else
	{
		self.window.rootViewController = nav;
	}
	
	[self.window makeKeyAndVisible];
}

#pragma mark - haibo 建立UDP连接
- (void)setupUDPSocket
{
	self.udpSocket = [HRUDPSocketTool shareHRUDPSocketTool];
	[self.udpSocket connectWithUDPSocket];
	[self addTimer];
}

#pragma mark - 添加定时器
- (void)addTimer
{
	self.leftTime = HRTimeDuration;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
	
}
static NSString *wift;
- (void)updateTimeLabel
{
	self.leftTime--;
	[self sendUDPSockeWithString:@"0"];
	
	if (self.leftTime == 1) {
		[self sendUDPSockeWithString:@"2"];
		[self.timer invalidate];
		self.timer = nil;
	}
	
	if (self.leftTime == 0) {
		
		[self.timer invalidate];
		self.timer = nil;
	}
	
}
/// 发送UDPSocke数据
- (void)sendUDPSockeWithString:(NSString *)string
{
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"set"] = string;
	NSString *sendString = [NSString stringWithUDPMsgDict:dict];
	
	[_udpSocket sendUDPSockeWithString:sendString];
}

-(void) setLogger {
	
	DDTTYLogger *logger = [DDTTYLogger sharedInstance];
	logger.colorsEnabled = YES;
	
	[logger setForegroundColor:[UIColor colorWithRed:219 green:44 blue:56 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagError];
	[logger setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:DDLogFlagWarning];
	
	[logger setForegroundColor:[UIColor colorWithRed:91 green:149 blue:207 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagInfo];
	
	[logger setForegroundColor:[UIColor colorWithRed:133 green:208 blue:107 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagDebug];
	
	[DDLog addLogger:logger];
}

@end
