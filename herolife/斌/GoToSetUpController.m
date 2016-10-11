//
//  GoToSetUpController.m
//  herolife
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 huarui. All rights reserved.
//
#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
#define HRCommonScreenH (HRUIScreenH / 667 /2)
#define HRCommonScreenW (HRUIScreenW / 375 /2)

#import "GoToSetUpController.h"
#import "UIView+SDAutoLayout.h"

#import "EnterPSWController.h"


@interface GoToSetUpController ()

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 停留时间 */
@property(nonatomic, assign) int leftTime;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;





@end
/** 停留时间 */
static int const HRTimeDuration = 601;

@implementation GoToSetUpController


-(void)viewWillAppear:(BOOL)animated
{
    [self SetMyBackPic];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"2"];
    [self.view addSubview:backgroundImage];
    
	

    [self makeUI];
	//haibo 全屏放回
	[self goBack];
	
	//haibo 隐藏底部条
	[self IsTabBarHidden:YES];
}


-(void)SetMyBackPic
{
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImgView.image = [UIImage imageNamed:Defalt_BackPic];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImgView.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImgView.image =[UIImage imageNamed:imgName];
    }
    

}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.ConfirmBtn.enabled = YES;
    
    
    
}

-(void)makeUI
{
	
	//海波代码----------------------start-------------------------------------
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    
    self.backImgView = backgroundImage;
    
	[self.view addSubview:self.backImgView];
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"设置局域网";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:navView];
	self.navView = navView;
	CGRect rect = [UIScreen mainScreen].bounds;
	rect.origin.y = 64;
	//海波代码----------------------end-------------------------------------
	
    UIView * halfAlphaView = [[UIView alloc]initWithFrame:rect];
    
    [self.view addSubview:halfAlphaView];
    
    halfAlphaView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
	
    UIView * circleView  = [[UIView alloc]init];
    [self.view addSubview: circleView];
	
    circleView.sd_layout
    .topSpaceToView(self.view,64.0 + 65.0 * HRCommonScreenH)
    .leftSpaceToView(self.view,30.0 * HRCommonScreenW)
    .rightSpaceToView(self.view,30.0 * HRCommonScreenW)
    .heightIs(HRUIScreenW - 60.0 * HRCommonScreenW);
    
//    circleView.layer.cornerRadius = (HRUIScreenW - 60.0 * HRCommonScreenW)/2;
	
//    circleView.layer.masksToBounds = YES;
	
    
    
//    circleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];;
	
    
   
    
    _CircleImage  =  [[UIImageView alloc]init];
    
    [circleView addSubview:_CircleImage];
	
    _CircleImage.sd_layout
    .topSpaceToView(self.navView,55 *HRCommonScreenH)
//    .bottomSpaceToView(circleView,164.0*HRCommonScreenH)
    .leftSpaceToView(self.navView,230 * HRCommonScreenW)
    .rightSpaceToView(self.navView,230 * HRCommonScreenW);
    
//    _CircleImage.image = [UIImage imageNamed:@"手机背景"];
	
   // _CircleImage.backgroundColor = [UIColor greenColor];
    
	UIImageView *phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"手机背景"]];
	phoneImage.frame = CGRectMake(230 *HRCommonScreenW, 64 + 55 *HRCommonScreenH, (375* 2 - 460)*HRCommonScreenW , 564 * HRCommonScreenH);
	
	[self.view addSubview:phoneImage];
	UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"透明线"]];
//	CGRect rectLine = lineImage.frame;
//	rectLine.origin.y = CGRectGetMaxY(phoneImage.frame) + 25;
//	lineImage.frame = rectLine;
	lineImage.frame = CGRectMake(0, CGRectGetMaxY(phoneImage.frame) + 25 , self.view.hr_width , 400);
//	[lineImage sizeToFit];
	
	[self.view addSubview:lineImage];
	
    /** 去连接按钮*/
    
    UIButton * ConfirmBtn = [[UIButton alloc]init];
    
    [self.view addSubview:ConfirmBtn];
    
    
    ConfirmBtn.backgroundColor =[[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    ConfirmBtn.sd_layout
    .bottomSpaceToView(self.view,80.0 * HRCommonScreenH)
    .heightIs(80.0 * HRCommonScreenH)
    .widthIs(316.0 *HRCommonScreenW)
    .rightSpaceToView(self.view,217.0 *HRCommonScreenW);
    
    
    ConfirmBtn.layer.cornerRadius = 20.0/667.0 * HRUIScreenH;
    ConfirmBtn.clipsToBounds=YES;
    
    [ConfirmBtn setTitle:@"去连接" forState:UIControlStateNormal];
    
    [ConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    /** 点击确定按钮 事件*/
	[ConfirmBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
	
	self.ConfirmBtn = ConfirmBtn;
    
    
    /** 文字说明 View */
    
    UILabel * infoLabel = [[UILabel alloc ]init];
    
    [self.view addSubview:infoLabel];
    
    infoLabel.sd_layout
    .topSpaceToView(circleView,60.0 *HRCommonScreenH)
    .leftSpaceToView(self.view,46.0 *HRCommonScreenW )
    .rightSpaceToView(self.view , 40.0 *HRCommonScreenW)
    .bottomSpaceToView(ConfirmBtn,20.0 *HRCommonScreenH);
    
    infoLabel.textColor = [UIColor whiteColor];
    
    infoLabel.font= [UIFont systemFontOfSize:17];
    
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"请在iPhone“设置-无线局域网”中选择名称为“HEROLIFE_SC_AP”的无线网络，等待WiFi连接成功后返回此页";
    
    
    
	
    
}
//海波代码
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	//导航条
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
}
#pragma mark - 点击下一步按钮事件

-(void)nextStep:(UIButton *)btn
{
	//跳转到系统wifi界面
    if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
        
        NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }else
    {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
            
        }
    }
    
   
    NSLog(@"点击了下一步按钮");
	
	//三秒跳转下个界面-----------------海波代码start-------------------------------
	btn.enabled = NO;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		btn.enabled = NO;
		DDLogWarn(@"点击了下一步按钮");
	});
	
	[kNotification postNotificationName:kNotificationLocal object:nil];
	
	//添加定时器
	[self addTimer];
	//三秒跳转下个界面-----------------海波代码end-------------------------------
	
}
// 设置本地通知
- (void)registerLocalNotification:(NSInteger)alertTime {
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	// 设置触发通知的时间
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
	NSLog(@"fireDate=%@",fireDate);
	
	notification.fireDate = fireDate;
	// 时区
	notification.timeZone = [NSTimeZone defaultTimeZone];
	// 设置重复的间隔
	notification.repeatInterval = 0;
	
	// 通知内容
	notification.alertBody =  @"连接成功,点我返回!";
	notification.applicationIconBadgeNumber = 0;
	// 通知被触发时播放的声音
	notification.soundName = UILocalNotificationDefaultSoundName;
	// 通知参数
	NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
	notification.userInfo = userDict;
	
	// ios8后，需要添加这个注册，才能得到授权
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
		UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
																				 categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		// 通知重复提示的单位，可以是天、周、月
		notification.repeatInterval = 0;
	} else {
		// 通知重复提示的单位，可以是天、周、月
		notification.repeatInterval = 0;
	}
	
	// 执行通知注册
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
#pragma mark - 添加定时器
- (void)addTimer
{
	self.leftTime = HRTimeDuration;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
	
}
static NSString *wift;
- (void)updateTimeLabel
{
	
	self.leftTime--;
	DDLogWarn(@"--------连上了--------%d", self.leftTime);
	wift = [NSString stringWithGetWifiName];
	if ([wift isEqualToString:@"HEROLIFE_SC_AP"]) {
		
		
		[self registerLocalNotification:0.5];
		
		[self.timer invalidate];
		self.timer = nil;
	}
	if (self.leftTime == 0) {
		
		[self.timer invalidate];
		self.timer = nil;
	}
	
}
- (void)dealloc
{
	[self.timer invalidate];
	self.timer = nil;
}
#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  - 海波代码
- (void)viewWillDisappear:(BOOL)animated
{
	[self IsTabBarHidden:YES];
}
#pragma mark - 隐藏底部条 - 海波代码
- (void)IsTabBarHidden:(BOOL)hidden
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = hidden;
		}
	}
}

#pragma mark - 全屏放回 - 海波代码
- (void)goBack
{
	// 获取系统自带滑动手势的target对象
	id target = self.navigationController.interactivePopGestureRecognizer.delegate;
	// 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
	// 设置手势代理，拦截手势触发
	pan.delegate = self;
	// 给导航控制器的view添加全屏滑动手势
	[self.view addGestureRecognizer:pan];
	// 禁止使用系统自带的滑动手势
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	// 注意：只有非根控制器才有滑动返回功能，根控制器没有。
	// 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
	if (self.childViewControllers.count == 1) {
		// 表示用户在根控制器界面，就不需要触发滑动手势，
		return NO;
	}
	return YES;
}



@end
