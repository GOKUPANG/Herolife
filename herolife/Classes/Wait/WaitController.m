//
//  WaitController.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "WaitController.h"
#import "AddLockController.h"
#import "HRTabBar.h"
#import <objc/message.h>

@interface WaitController ()
/** 头像 */
@property(nonatomic, weak) UIImageView *iconImage;
/** 动画图片 */
@property(nonatomic, weak) UIImageView *animImage;
/** 动画图片 */
@property(nonatomic, weak) UIView *animView;
/** 提示  label */
@property(nonatomic, weak) HRLabel *promptLabel;
/** 倒计时  label */
@property(nonatomic, weak) HRLabel *timeLabel;
/** 取消按钮 */
@property(nonatomic, weak) HRButton *cancelButton;
/** 头像底纹viwe */
@property(nonatomic, weak) UIView *eptView;

/** 停留时间 */
@property(nonatomic, assign) int leftTime;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;



@end

@implementation WaitController
/** 停留时间 */
static int const HRTimeDuration = 30;





- (void)viewDidLoad {
    [super viewDidLoad];
	
	DDLogWarn(@"wifi----------WaitController-------%@", [NSString stringWithGetWifiName]);
	[self setupViews];
	//添加定时器
	[self addTimer];
	[self sendHTTPData];
	
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	DDLogWarn(@"WaitController--------viewDidAppear");
}
#pragma mark - HTTP
- (void)sendHTTPData
{
	//先去查询, HTTP查询如果有数据就去更新, 如果没有就创建&uid=uid&type=hrsc&uuid=uuid
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	NSDictionary *msg = app.msgDictionary;
	NSString *ssid = msg[@"uuid"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//	NSString *user = [kUserDefault objectForKey:kDefaultsUserName];  这里去掉user这个字段
//	dict[@"user"] = user;
	dict[@"types"] = @"hrsc";
	dict[@"uuid"] = ssid;
	[HRHTTPTool hr_getHttpWithURL:HRAPI_QueryLock_URL parameters:dict responseDict:^(id dictionary, NSError *error) {
		DDLogWarn(@"array--%@---error---%@", dictionary,error);
		DDLogWarn(@"class--%@", [dictionary class]);
		
		if (error) {
			[ErrorCodeManager showError:error];
			
			return ;
		}
		if ([[dictionary class] isSubclassOfClass:[NSArray class]]) {
			NSArray *arr = (NSArray *)dictionary;
			if (arr.count > 0) {
				
				for (NSDictionary *dict in arr) {
					NSString *uuid = [dict valueForKeyPath:@"uuid"];
					NSString *uid = [dict valueForKeyPath:@"uid"];
					NSString *defaultUid = [kUserDefault objectForKey:kDefaultsUid];
					if ([uuid isEqualToString:ssid]) {
						AddLockController *addLockVC = [[AddLockController alloc] init];
						if ([defaultUid isEqualToString:uid]) {
							
							addLockVC.did = [dict valueForKeyPath:@"did"];
							[self.navigationController pushViewController:addLockVC animated:YES];
						}else
						{
							[SVProgressTool hr_showErrorWithStatus:@"该门锁在其他帐号上已经添加,请在其他帐号上删除该门锁,再重试!"];
							dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
								
								[self.navigationController popViewControllerAnimated:YES];
							});
						}
					}
				}
			}else
			{
				//创建门锁HTTP
				[self createLockHTTPWithUUID:ssid];
				
			}
		}

	}];
	
}
#pragma mark - 创建门锁HTTP
- (void)createLockHTTPWithUUID:(NSString *)uuid
{
	NSString *licence = [NSString hr_stringWithBase64];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"type"] = @"hrsc";
	dict[@"field_uuid[und][0][value]"] = uuid;
	dict[@"field_version[und][0][value]"] = @"dev version";
	dict[@"title"] = @"智能门锁";
	dict[@"field_brand[und][0][value]"] = @"dev brand";
	dict[@"field_licence[und][0][value]"] = licence;
	dict[@"field_level[und][0][value]"] = @"90%";
	dict[@"field_state[und][0][value]"] = @"0";
	dict[@"field_online[und][0][value]"] = @"off";
	dict[@"field_op[und][0][value]"] = @"1";
	dict[@"field_op[und][1][value]"] = @"1";
	dict[@"field_op[und][2][value]"] = @"1";
	dict[@"field_op[und][3][value]"] = @"1";
	dict[@"field_op[und][4][value]"] = @"none";
	dict[@"field_op[und][5][value]"] = @"none";
	dict[@"field_op[und][6][value]"] = @"none";
	dict[@"field_op[und][7][value]"] = @"none";
	dict[@"field_op[und][8][value]"] = @"none";
	dict[@"field_op[und][9][value]"] = @"none";
	
	[HRHTTPTool hr_postHttpWithURL:HRAPI_AddLock_URL parameters:dict responseDict:^(id dictionary, NSError *error) {
		
		if (error) {
			[ErrorCodeManager showError:error];
			return ;
		}
		NSDictionary *dict = (NSDictionary *)dictionary;
		AddLockController *addLockVC = [[AddLockController alloc] init];
		addLockVC.did = [dict valueForKeyPath:@"nid"];
		[self.navigationController pushViewController:addLockVC animated:YES];
		DDLogWarn(@"createLockHTTP--%@---error---%@", dictionary,error);
		
	}];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	
	NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
	
	if (!PicNum) {
		
		
		
		self.backImgView.image = [UIImage imageNamed:@"1.jpg"];
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

#pragma mark - 内部方法
- (void)setupViews
{
	
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"icon_bg.jpg"];
    self.backImgView = backgroundImage;
	[self.view addSubview:self.backImgView];
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//头像底纹viwe
	UIView *eptView = [[UIView alloc] init];
	eptView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:eptView];
	self.eptView = eptView;
	
	//头像
	UIImageView *iconImage = [[UIImageView alloc] init];
	NSString *iconString;
	//QQ头像
	iconString = [kUserDefault objectForKey:kDefaultsQQIconURL];
	if (iconString.length > 0) {
		
		NSURL *url = [NSURL URLWithString:iconString];
		[iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
	}else
	{
		iconString = [kUserDefault objectForKey:kDefaultsIconURL];
		if (iconString.length > 0) {
			NSURL *url = [NSURL URLWithString:iconString];
			[iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
			
		}else
		{
			iconImage.image = [UIImage imageNamed:@"头像占位图片.jpg"];
			
		}
		
	}

	
	[self.view addSubview:iconImage];
	self.iconImage = iconImage;
	//动画图片
//	UIImageView *animImage = [[UIImageView alloc] init];
//	animImage.image = [UIImage imageNamed:@"Default-568h@3x-1"];
//	[self.view addSubview:animImage];
//	self.animImage = animImage;
	
	UIView *animView = [[UIView alloc] init];
	animView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:animView];
	self.animView = animView;
	
	//动画控件
//	NVActivityIndicatorView *actView = [[NVActivityIndicatorView alloc] initWithFrame:<#(CGRect)#>;
//	actView.frame = CGRectMake(0, 0, 200, 200);
//	actView.padding = 20;
//	[actView setValue:@"UIDynamicItemCollisionBoundsTypeEllipse" forKeyPath:@"collisionBoundsType"];
//	
//	[actView startAnimation];
//	[self.animView addSubview:actView];
	
	
	//提示  label
	HRLabel *promptLabel = [[HRLabel alloc] init];
	promptLabel.text = @"正在添加智能门锁,请稍后...";
	[self.view addSubview:promptLabel];
	self.promptLabel = promptLabel;
	
	//倒计时  label
	HRLabel *timeLabel = [[HRLabel alloc] init];
	NSString *title = [NSString stringWithFormat:@"%zd秒", self.leftTime];
	timeLabel.text = title;
	[self.view addSubview:timeLabel];
	self.timeLabel = timeLabel;
	
	//取消按钮
	HRButton *cancelButton = [HRButton buttonWithType:UIButtonTypeCustom];
	cancelButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	[cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[self.view addSubview:cancelButton];
	self.cancelButton = cancelButton;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	[self.eptView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.view).offset(HRCommonScreenH *178);
		make.centerX.equalTo(self.view);
		make.height.mas_equalTo(HRCommonScreenH *376);
		make.width.mas_equalTo(HRCommonScreenH *376);
		
	}];
	
	self.eptView.layer.cornerRadius = HRCommonScreenH *376*0.5;
	self.eptView.layer.masksToBounds = YES;
	
	
	[self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.eptView).offset(HRCommonScreenH *12);
		make.bottom.equalTo(self.eptView).offset(- HRCommonScreenH *12);
		make.left.equalTo(self.eptView).offset(HRCommonScreenH *12);
		make.right.equalTo(self.eptView).offset(- HRCommonScreenH *12);
		
	}];
	self.iconImage.layer.cornerRadius = HRCommonScreenH *352*0.5;
	self.iconImage.layer.masksToBounds = YES;
	
	[self.animView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.eptView.mas_bottom).offset(HRCommonScreenH *68);
		make.height.mas_equalTo(HRCommonScreenH *80);
		make.width.mas_equalTo(HRCommonScreenH *80);
		make.centerX.equalTo(self.eptView);
		
	}];
	self.animView.layer.cornerRadius = HRCommonScreenH *80*0.5;
	self.animView.layer.masksToBounds = YES;
	
	
	[self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.animView.mas_bottom).offset(HRCommonScreenH *320);
		make.centerX.equalTo(self.eptView);
		
	}];
	
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.promptLabel.mas_bottom).offset(HRCommonScreenH *10);
		make.centerX.equalTo(self.promptLabel);
		
	}];
	
	
	[self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.timeLabel.mas_bottom).offset(HRCommonScreenH *45);
		make.centerX.equalTo(self.promptLabel);
		make.height.mas_equalTo(HRCommonScreenH *134);
		make.width.mas_equalTo(HRCommonScreenH *134);
		
	}];
	
	self.cancelButton.layer.cornerRadius = HRCommonScreenH *134*0.5;
	self.cancelButton.layer.masksToBounds = YES;
}

#pragma mark - 添加定时器
- (void)addTimer
{
	self.leftTime = HRTimeDuration;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
	
	
}

- (void)updateTimeLabel
{
	self.leftTime--;
	// 更新文字
	NSString *title = [NSString stringWithFormat:@"%zd秒", self.leftTime];
	self.timeLabel.text = title;
	if (self.leftTime == 0) {
		
		[self cancelButtonClick:self.cancelButton];
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
		
		[self.timer invalidate];
	}
	
}

- (void)dealloc
{
	[self.timer invalidate];
}

- (void)cancelButtonClick:(UIButton *)btn
{
	for (UIView *view  in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
//            HRTabBar *tabBar = (HRTabBar *)view;
            view.hidden = NO;
            for (UIButton *btn in view.subviews) {
                if (btn.tag == 1) {
                    btn.selected = NO;
                }
                
                if (btn.tag == 2) {
                    btn.selected = YES;
                    [kNotification postNotificationName:kNotificationInitializationSelecteButton object:nil];
                }
            }
        }

	}
    
    [kNotification postNotificationName:kNotificationPostRefresh object:nil];
	self.tabBarController.selectedIndex = 1;
	[self.navigationController popToRootViewControllerAnimated:YES];
}






@end
