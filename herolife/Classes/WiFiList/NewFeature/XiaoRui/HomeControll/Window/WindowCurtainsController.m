//
//  WindowCurtainsController.m
//  xiaorui
//
//  Created by sswukang on 16/5/19.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "WindowCurtainsController.h"
#import "HRDOData.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
@interface WindowCurtainsController ()
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** 背景图 */
@property(nonatomic, weak) UIImageView *backImageView;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** 窗帘图 */
@property(nonatomic, weak) UIImageView *windowImageView;
/** 开 */
@property(nonatomic, weak) UIButton *openButton;
/** 关 */
@property(nonatomic, weak) UIButton *shutButton;
/** 暂停 */
@property(nonatomic, weak) UIButton *suspendButton;

@end

@implementation WindowCurtainsController

- (void)setDoData:(HRDOData *)doData
{
	_doData = doData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//初始化
	[self setUpView];
	//建立连接
	[self postTokenWithTCPSocket];
	//添加通知
	[self addNotificationCenterObserver];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.suspendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-HRCommonScreenH * 346);
    }];
    
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.suspendButton.mas_left).offset( - HRCommonScreenW * 50);
        make.bottom.equalTo(self.view).offset(-HRCommonScreenH * 246);
        
    }];
    
    [self.shutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.suspendButton.mas_right).offset(HRCommonScreenW * 50);
        make.bottom.equalTo(self.openButton);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self setUpBackGroungImage];
}

- (void)setUpBackGroungImage
{
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImageView.image = [UIImage imageNamed:@"1.jpg"];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImageView.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImageView.image =[UIImage imageNamed:imgName];
    }
    
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
//初始化
- (void)setUpView
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    backImageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:backImageView];
    UIView *eptView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    eptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:eptView];
    
    HRNavigationBar *navBar = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    
    [navBar.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    navBar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [self.view addSubview: navBar];
    
    navBar.titleLabel.text = @"窗帘";
    UIImageView *windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH - 64)];
    windowImageView.highlightedImage = [UIImage imageNamed:@"开3"];
    windowImageView.image = [UIImage imageNamed:@"开0"];
    self.windowImageView = windowImageView;
    [self.view addSubview:windowImageView];
	
    //开
    UIButton *openButton = [UIButton buttonWithType: UIButtonTypeCustom];
    openButton.frame = CGRectMake(50, 100, 100, 100);
    [openButton setBackgroundImage:[UIImage imageNamed:@"小睿窗帘开"] forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [openButton setBackgroundImage:[UIImage imageNamed:@"开-拷贝"] forState:UIControlStateHighlighted];
    [self.view addSubview: openButton];
    self.openButton = openButton;
    
    //关
    UIButton *shutButton = [UIButton buttonWithType: UIButtonTypeCustom];
    shutButton.frame = CGRectMake(150, 100, 100, 100);
    [shutButton setBackgroundImage:[UIImage imageNamed:@"小睿窗帘关"] forState:UIControlStateNormal];
    
    [shutButton addTarget:self action:@selector(shutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shutButton setBackgroundImage:[UIImage imageNamed:@"关-拷贝"] forState:UIControlStateHighlighted];
    [self.view addSubview: shutButton];
    self.shutButton = shutButton;
    
    //暂停
    UIButton *suspendButton = [UIButton buttonWithType: UIButtonTypeCustom];
    suspendButton.frame = CGRectMake(100, 100, 100, 100);
    [suspendButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    
    [suspendButton addTarget:self action:@selector(stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [suspendButton setBackgroundImage:[UIImage imageNamed:@"暂停-拷贝"] forState:UIControlStateHighlighted];
    [self.view addSubview: suspendButton];
    self.suspendButton = suspendButton;
    
	// 根据parameter 里的status  来显示图片状态
	if ([self.doData.parameter[2] isEqualToString:@"1"]) {
		windowImageView.highlighted = NO;
	}else if ([self.doData.parameter[2] isEqualToString:@"0"]) {
		windowImageView.highlighted = YES;
	}else if ([self.doData.parameter[2] isEqualToString:@"2"]) {
		windowImageView.highlighted = NO;
	}
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听开关的控制帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlIrac:) name:kNotificationControlDo object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
#pragma mark -  通知处理方法
//是否超时
static BOOL isOvertime = NO;

//监听空调的控制帧
- (void)receviedWithControlIrac:(NSNotification *)notification
{
	
	[SVProgressHUD dismiss];
	isOvertime = YES;
	DDLogError(@"userInfo=-----%@", notification.userInfo);
	NSDictionary *dict = notification.userInfo;
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict[@"msg"]];
	
	// 把服务器返回的四个数据 重组 成一个新数组
	NSArray *parameter = @[data.parameter.firstObject, data.parameter[2], data.parameter[3]];
	//替换
	data.parameter = parameter;
	//重新赋值
	self.doData = data;//里面只有三个参数
	
	//根据doData 里status 显示不同的数据
	if ([self.doData.parameter[2] isEqualToString:@"1"]) {
		self.windowImageView.highlighted = NO;
	}else if ([self.doData.parameter[2] isEqualToString:@"0"]) {
		self.windowImageView.highlighted = YES;
	}else if ([self.doData.parameter[2] isEqualToString:@"2"]) {
		self.windowImageView.highlighted = NO;
	}
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}

#pragma mark - UI事件
- (void)openBtnClick:(UIButton *)sender {//开
	
	[self controlDoBulbWithData:self.doData status:@"1"];
	
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)stopBtnClick:(UIButton *)sender {//停止
	[self controlDoBulbWithData:self.doData status:@"2"];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)shutBtnClick:(UIButton *)sender {//关
	[self controlDoBulbWithData:self.doData status:@"0"];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}
#pragma mark - 窗帘控制
- (void)controlDoBulbWithData:(HRDOData *)data status:(NSString *)status
{
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送开关 控制请求帧
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSString *channelNumber = data.parameter.firstObject;
	NSString *op = @"None";
	
	NSArray *parameter = @[channelNumber, op, data.parameter[1], status];
	
	NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"control" desc:@"control desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:data.uid mid:data.mid did:data.did uuid:data.uuid types:@"hrdo" newVersion:data.version title:data.title brand:data.brand created:data.created update:data.update state:data.state picture:data.picture regional:data.regional parameter:parameter];
	
	DDLogWarn(@"-------发送开关 控制请求帧-------dostr%@", str);
	[self.appDelegate sendMessageWithString:str];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[SVProgressHUD dismiss];
}
- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
