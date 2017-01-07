//
//  GeneralInfraredCtrl.m
//  xiaorui
//
//  Created by sswukang on 15/12/23.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "GeneralInfraredCtrl.h"
#import "TipsLabel.h"
#import "IrgmData.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "PopEditMenuIrgmView.h"

@interface GeneralInfraredCtrl()


/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

/** TipsLabel */
@property(nonatomic, strong)TipsLabel *tipsLabel;

/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** blank */
@property(nonatomic, strong) UIView *blankView;

@property(nonatomic, weak) PopEditMenuIrgmView *popView;

/** 记录当前view */
@property(nonatomic, strong) UIView *currentView;





@end

@implementation GeneralInfraredCtrl

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
		[self initSubviews];
		//添加通知 监听
		[self addNotificationCenterObserver];
		//建立socket连接通道
		[self postTokenWithTCPSocket];
	}
	return self;
}
//添加弹框
- (void)addMenuView{
	
	UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.hr_width, self.hr_height)];
    
	blankView.backgroundColor = [UIColor clearColor];
	
	self.blankView = blankView;
	//	[self.view addSubview:blankView];
	
	self.popView = [[NSBundle mainBundle] loadNibNamed:@"PopEditMenuIrgmView" owner:self options:nil].firstObject;
	self.popView.frame = CGRectMake(30, UIScreenH *0.15, UIScreenW - 60, 195);
	self.popView.backgroundColor = [UIColor whiteColor];
	self.popView.layer.cornerRadius = 10;
	self.popView.layer.masksToBounds = YES;
	[self.blankView addSubview:self.popView];
	[self addSubview:self.blankView];
	self.blankView.hidden = YES;
	
	//添加手势
	[self addTapGesture];
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的测试帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlIrgm:) name:kNotificationControlIrgm object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUpdateIrgmWithTitle:) name:kNotificationUpdateIrgmWithTitle object:nil];
}

- (void)dealloc
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -  通知处理方法
- (void)addUpdateIrgmWithTitle:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
	self.irgmData = data;
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
//监听通用的测试帧
static BOOL isOvertime = NO;
- (void)receviedWithControlIrgm:(NSNotification *)notification
{
	isOvertime = YES;
	// 判断 是不是自己发过去  返回的帧
	NSDictionary *dict = notification.userInfo;
    [SVProgressTool hr_showSuccessWithStatus:@"控制成功!"];
	self.irgmData = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
	[self layoutIfNeeded];
	[self reloadInputViews];
	[self setNeedsLayout];
	[self setNeedsDisplay];
	
}
#pragma mark - set 方法
- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}
#pragma mark - 点击事件
- (void)studyControlBtnClick:(UIButton *)btn
{
	
	NSString *tag = [NSString stringWithFormat:@"%lu", btn.tag];
	NSInteger value = btn.tag;
	
	DDLogError(@"%@",self.irgmData);
	
	NSString *keyName;
	NSString *address;
	
	if (value >= 20) {
		NSInteger index = value - 20;
		if ([self.irgmData.param03[index] isEqualToString:@"None"])
		{
			[self.tipsLabel showText:@"该按钮未学习,请学习之后再控制" duration:4.0];
			return;
		}
		
		keyName = self.irgmData.name03[index];
		address = self.irgmData.param03[index];
		
	}else if (value >= 10) {
		
		NSInteger index = value -10;
		if ([self.irgmData.param02[index] isEqualToString:@"None"])
		{
			[self.tipsLabel showText:@"该按钮未学习,请学习之后再控制" duration:4.0];
			return;
		}
		keyName = self.irgmData.name02[index];
		address = self.irgmData.param02[index];
		
	}else if (value >= 0) {
		NSInteger index = value;
		if ([self.irgmData.param01[index] isEqualToString:@"None"])
		{
			[self.tipsLabel showText:@"该按钮未学习,请学习之后再控制" duration:4.0];
			return;
		}
		keyName = self.irgmData.name01[index];
		address = self.irgmData.param01[index];
	}
	
	
	NSArray *op = @[tag,keyName,address];
	[self sendDataToSocketWithOpArray:op];
	
}



#pragma mark - 传参组帧
- (void)sendDataToSocketWithOpArray:(NSArray *)array
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSArray *name01 = [NSArray array];
	NSArray *name02 = [NSArray array];
	NSArray *name03 = [NSArray array];
	NSArray *param01 = [NSArray array];
	NSArray *param02 = [NSArray array];
	NSArray *param03 = [NSArray array];
    
	NSString *str = [NSString stringWithIRGMVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"control"
											   desc:@"control desc message"
										srcUserName:user
										dstUserName:user
										 dstDevName:uuid
												uid:self.irgmData.uid
												mid:self.irgmData.mid
												did:self.irgmData.did
											   uuid:self.irgmData.uuid
											  types:self.irgmData.types
										 newVersion:self.irgmData.version
											  title:self.irgmData.title
											  brand:self.irgmData.brand
											created:self.irgmData.created
											 update:self.irgmData.update
											  state:self.irgmData.state
											picture:self.irgmData.picture
										   regional:self.irgmData.regional
												 op:array
											 name01:name01
											 name02:name02
											 name03:name03
											param01:param01
											param02:param02
											param03:param03];
	
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}

-(void) initSubviews {
    
    
	self.muteButton     = [[UIButton alloc] init];
	self.powerButton    = [[UIButton alloc] init];
	self.menuButton     = [[UIButton alloc] init];
	self.num1Button     = [[UIButton alloc] init];
	self.num2Button     = [[UIButton alloc] init];
	self.num3Button     = [[UIButton alloc] init];
	self.num4Button     = [[UIButton alloc] init];
	self.num5Button     = [[UIButton alloc] init];
	self.num6Button     = [[UIButton alloc] init];
	self.num7Button     = [[UIButton alloc] init];
	self.num8Button     = [[UIButton alloc] init];
	self.num9Button     = [[UIButton alloc] init];
	self.num0Button     = [[UIButton alloc] init];
	self.backButton     = [[UIButton alloc] init];
	self.selectButton   = [[UIButton alloc] init];
	self.leftUpButton     = [[UIButton alloc] init];
	self.leftDownButton   = [[UIButton alloc] init];
	self.rightUpButton    = [[UIButton alloc] init];
	self.rightDownButton  = [[UIButton alloc] init];
	self.dirLeftButton  = [[UIButton alloc] init];
	self.dirRightButton = [[UIButton alloc] init];
	self.dirUpButton    = [[UIButton alloc] init];
	self.dirDownButton  = [[UIButton alloc] init];
	self.okButton       = [[UIButton alloc] init];
    
    self.leftChannelLabel = [[UILabel alloc]init];
    self.rightVolumeLabel = [[UILabel alloc]init];
    
    //彬添加 左边的频道label   和右边的音量label
    
    [self addSubview:self.leftChannelLabel];
    [self addSubview:self.rightVolumeLabel];
    
    
    
    
    self.leftChannelLabel.text = @"频道";
    self.leftChannelLabel.font = [UIFont systemFontOfSize:20];
    self.leftChannelLabel.textColor = [UIColor whiteColor];
    self.leftChannelLabel.textAlignment= NSTextAlignmentCenter;
    
    self.rightVolumeLabel.text = @"音量";
    self.rightVolumeLabel.font = [UIFont systemFontOfSize:20];
    self.rightVolumeLabel.textColor = [UIColor whiteColor];
    self.rightVolumeLabel.textAlignment= NSTextAlignmentCenter;
    
	[self addSubview:self.muteButton];
	[self addSubview:self.muteButton];
	[self addSubview:self.powerButton];
	[self addSubview:self.menuButton];
	[self addSubview:self.num1Button];
	[self addSubview:self.num2Button];
	[self addSubview:self.num3Button];
	[self addSubview:self.num4Button];
	[self addSubview:self.num5Button];
	[self addSubview:self.num6Button];
	[self addSubview:self.num7Button];
	[self addSubview:self.num8Button];
	[self addSubview:self.num9Button];
	[self addSubview:self.num0Button];
	[self addSubview:self.backButton];
	[self addSubview:self.selectButton];
	[self addSubview:self.leftUpButton];
	[self addSubview:self.leftDownButton];
	[self addSubview:self.rightUpButton];
	[self addSubview:self.rightDownButton];
	[self addSubview:self.dirLeftButton];
	[self addSubview:self.dirRightButton];
	[self addSubview:self.dirUpButton];
	[self addSubview:self.dirDownButton];
	[self addSubview:self.okButton];
    
    self.LeftUPImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制频道上"]];
    self.LeftUPImgView.contentMode =  UIViewContentModeCenter;
    [self.leftUpButton addSubview:self.LeftUPImgView];
    
    
    self.LeftDownImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制频道下"]];
    self.LeftDownImgView.contentMode =  UIViewContentModeCenter;
    [self.leftDownButton addSubview:self.LeftDownImgView];

    
    self.RightUPImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制频道上"]];
    self.RightUPImgView.contentMode =  UIViewContentModeCenter;
    [self.rightUpButton addSubview:self.RightUPImgView];

    
    self.RightDownImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制频道下"]];
    self.RightDownImgView.contentMode =  UIViewContentModeCenter;
    [self.rightDownButton addSubview:self.RightDownImgView];
    
    self.FuckUPImgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制频道上"]];
    
    self.FuckUPImgView .contentMode= UIViewContentModeCenter;
    
    [self.dirUpButton addSubview:self.FuckUPImgView];
    
    
    
    self.FuckDownImgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制频道下"]];
    
    self.FuckDownImgView .contentMode= UIViewContentModeCenter;
    
    [self.dirDownButton addSubview:self.FuckDownImgView];
    
    
    self.FuckLeftImgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制左"]];
    
    self.FuckLeftImgView .contentMode= UIViewContentModeCenter;
    
    [self.dirLeftButton addSubview:self.FuckLeftImgView];

    
    self.FuckRightImgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小睿控制右"]];
    
    self.FuckRightImgView .contentMode= UIViewContentModeCenter;
    
    [self.dirRightButton addSubview:self.FuckRightImgView];
    
    
    
    
	[self.muteButton setBackgroundImage:[UIImage imageNamed:@"小睿控制静音"]forState:UIControlStateNormal];
	[self.powerButton setBackgroundImage:[UIImage imageNamed:@"小睿控制开关"]
								forState:UIControlStateNormal];
	[self.menuButton setBackgroundImage:[UIImage imageNamed:@"小睿控制功能"]
							   forState:UIControlStateNormal];
	[self.num1Button setBackgroundImage:[UIImage imageNamed:@"小睿控制1"]
							   forState:UIControlStateNormal];
	[self.num2Button setBackgroundImage:[UIImage imageNamed:@"小睿控制2"]
							   forState:UIControlStateNormal];
	[self.num3Button setBackgroundImage:[UIImage imageNamed:@"小睿控制3"]
							   forState:UIControlStateNormal];
	[self.num4Button setBackgroundImage:[UIImage imageNamed:@"小睿控制4"]
							   forState:UIControlStateNormal];
	[self.num5Button setBackgroundImage:[UIImage imageNamed:@"小睿控制5"]
							   forState:UIControlStateNormal];
	[self.num6Button setBackgroundImage:[UIImage imageNamed:@"小睿控制6"]
							   forState:UIControlStateNormal];
	[self.num7Button setBackgroundImage:[UIImage imageNamed:@"小睿控制7"]
							   forState:UIControlStateNormal];
	[self.num8Button setBackgroundImage:[UIImage imageNamed:@"小睿控制8"]
							   forState:UIControlStateNormal];
	[self.num9Button setBackgroundImage:[UIImage imageNamed:@"小睿控制9"]
							   forState:UIControlStateNormal];
	[self.num0Button setBackgroundImage:[UIImage imageNamed:@"小睿控制0"]
							   forState:UIControlStateNormal];
	[self.backButton setBackgroundImage:[UIImage imageNamed:@"小睿控制返回"]
							   forState:UIControlStateNormal];
	[self.selectButton setBackgroundImage:[UIImage imageNamed:@"小睿控制选节目"]
								 forState:UIControlStateNormal];
    
    
    
    UIImage * buttonImage = [UIImage  imageNamed:@"小睿控制上"];
    buttonImage = [buttonImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    
	[self.okButton setBackgroundImage:[UIImage imageNamed:@""]
							 forState:UIControlStateNormal];
    
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    
    [self.okButton setFont:[UIFont systemFontOfSize:22]];
    
	//绑定tag
	self.muteButton.tag     = 0;//静音
	self.powerButton.tag    = 1;//待机
	self.menuButton.tag     = 2;//菜单
	self.num1Button.tag     = 3;//1
	self.num2Button.tag     = 4;//2
	self.num3Button.tag     = 5;//3
	self.num4Button.tag     = 6;//4
	self.num5Button.tag     = 7;//5
	self.num6Button.tag     = 8;//6
	self.num7Button.tag     = 9;//7
	self.num8Button.tag     = 10;//8
	self.num9Button.tag     = 11;//9
	self.num0Button.tag     = 13;//0
	self.backButton.tag     = 12;//返回
	self.selectButton.tag   = 14;//-/--
	self.leftUpButton.tag    =15;//left-up
	self.leftDownButton.tag   = 21;//left-down
	self.rightUpButton.tag    = 17;//right-up
	self.rightDownButton.tag  = 23;//right-down
	self.dirLeftButton.tag  = 18;//方向-left
	self.dirRightButton.tag = 20;//方向-right
	self.dirUpButton.tag    = 16;//方向-up
	self.dirDownButton.tag  = 22;//方向-down
	self.okButton.tag       = 19;//OK
	
	//添加点击事件
	[self.muteButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.powerButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num1Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num2Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num3Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num4Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num5Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num6Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num7Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num8Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num9Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num0Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.backButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.selectButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.leftUpButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.leftDownButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.rightUpButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.rightDownButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirLeftButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirRightButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirUpButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirDownButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.okButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	//提示框
	[self addTipsLabel];
}
#pragma mark - 添加提示框
- (void)addTipsLabel
{
	
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
	[self addSubview:self.tipsLabel];
}
//

-(void)layoutSubviews {
    
    
    [super layoutSubviews];
    
	CGFloat width = self.bounds.size.width / 6.5f;
	CGFloat gapHorz = (self.bounds.size.width - width*3.f) / 4.f;
	CGFloat gapVert = (self.bounds.size.height - width*8.f) / 11.f;
    if (UIScreenW > 414) {
        
        width = self.bounds.size.width / 7.f;
        gapHorz = (self.bounds.size.width - width*3.f) / 4.f;
        gapVert = (self.bounds.size.height - width*8.f) / 11.f;
    }
	if (gapVert < 0 ) {
		gapVert = 5;
	}
	//静音
	[self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.left.equalTo(self).offset(gapHorz);
		make.top.equalTo(self.tipsLabel.mas_bottom).offset(10);
	}];
	//待机
	[self.powerButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width+gapVert, width+gapVert));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.muteButton.mas_centerY);
//		make.bottom.equalTo(self.muteButton.mas_bottom);
	}];
	//菜单
	[self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerY.equalTo(self.muteButton.mas_centerY);
		make.right.equalTo(self.mas_right).offset(-gapHorz);
	}];
	//1
	[self.num1Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.muteButton.mas_bottom).offset(gapVert*2);
	}];
	//2
	[self.num2Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.num1Button);
	}];
	//3
	[self.num3Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.num1Button);
	}];
	//4
	[self.num4Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.num1Button.mas_bottom).offset(gapVert);
	}];
	//5
	[self.num5Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.num4Button);
	}];
	//6
	[self.num6Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.num5Button);
	}];
	//7
	[self.num7Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.num4Button.mas_bottom).offset(gapVert);
	}];
	//8
	[self.num8Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.num7Button);
	}];
	//9
	[self.num9Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.num7Button);
	}];
	//返回
	[self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.num7Button.mas_bottom).offset(gapVert);
	}];
	//0
	[self.num0Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.backButton);
	}];
	//-/--
	[self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.backButton);
	}];
	//OK
	[self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
        if (UIScreenW <= 320) {
            
            make.top.equalTo(self.num0Button.mas_bottom).offset(gapVert + width);
        }else
        {
            
            make.top.equalTo(self.num0Button.mas_bottom).offset(gapVert*2 + width);
        }
	}];
	
	//left-up
	[self.leftUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.backButton).offset(-width*0.3);
		make.bottom.equalTo(self.okButton.mas_top);
	}];
    
   
    
    
    
    //在这里增加一个 音量 按钮或者label  左边中间
    
    
    [self.leftChannelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.centerX.equalTo(self.leftUpButton);
        make.top.equalTo(self.okButton.mas_top);

        
        
    }];
    
    
    
    [self.rightVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.centerX.equalTo(self.rightUpButton);
        make.top.equalTo(self.okButton.mas_top);
        

        
    }];
    
    
    
    [self.LeftUPImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.leftUpButton ).offset(20);
        
        make.centerX.equalTo(self.leftUpButton);
        
        
    }];
    
    
    [self.LeftDownImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.bottom.equalTo(self.leftDownButton ).offset(-20);
        
        make.centerX.equalTo(self.leftUpButton);
        
        
    }];
    
    
    
    
    [self.RightUPImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.rightUpButton ).offset(20);
        
        make.centerX.equalTo(self.rightUpButton);
        
        
    }];
    
    
    [self.RightDownImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.bottom.equalTo(self.rightDownButton ).offset(-20);
        
        make.centerX.equalTo(self.rightDownButton);
        
        
    }];
    
    
    
    
	//left-down
	[self.leftDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.leftUpButton);
		make.top.equalTo(self.okButton.mas_bottom);
	}];
	//right-up
	[self.rightUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.selectButton).offset(width*0.3);
		make.centerY.equalTo(self.leftUpButton);
	}];
	//right-down
	[self.rightDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.rightUpButton);
		make.centerY.equalTo(self.leftDownButton);
	}];
	//方向-up
	[self.dirUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.okButton);
		make.bottom.equalTo(self.okButton.mas_top);
	}];
	//方向-down
	[self.dirDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.okButton);
		make.top.equalTo(self.okButton.mas_bottom);
	}];
	//方向-left
	[self.dirLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerY.equalTo(self.okButton);
		make.right.equalTo(self.okButton.mas_left);
	}];
	//方向-right
	[self.dirRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerY.equalTo(self.okButton);
		make.left.equalTo(self.okButton.mas_right);
	}];
    
    
    //右边的中间音量按钮 或者label
    
    
    
    //频道上下左右按钮
    [self.FuckUPImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.dirUpButton ).offset(20);
        
        make.centerX.equalTo(self.dirUpButton);
        
        
    }];

    
    [self.FuckDownImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.dirDownButton ).offset(20);
        
        make.centerX.equalTo(self.dirDownButton);
        
        
    }];

    
    [self.FuckLeftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.dirLeftButton ).offset(20);
        
        make.centerX.equalTo(self.dirLeftButton);
        
        
    }];

    
    [self.FuckRightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.dirRightButton ).offset(20);
        
        make.centerX.equalTo(self.dirRightButton);
        
        
    }];
    
    
}


- (void)drawRect:(CGRect)rect {
	
	CAShapeLayer *leftLayer = [[CAShapeLayer alloc] init];
	leftLayer.frame = CGRectMake(
								 CGRectGetMinX(self.leftUpButton.frame),
								 CGRectGetMinY(self.leftUpButton.frame),
								 CGRectGetWidth(self.leftDownButton.frame),
								 CGRectGetMaxY(self.leftDownButton.frame)-CGRectGetMinY(self.leftUpButton.frame)
								 );
	leftLayer.cornerRadius = leftLayer.frame.size.width/2;
	leftLayer.borderColor = [UIColor colorWithHex:0xB3B3B3].CGColor;
	leftLayer.borderWidth = 1;
	[self.layer addSublayer:leftLayer];
	
	CAShapeLayer *rightLayer = [[CAShapeLayer alloc] init];
	rightLayer.frame = CGRectMake(
								 CGRectGetMinX(self.rightUpButton.frame),
								 CGRectGetMinY(self.rightUpButton.frame),
								 CGRectGetWidth(self.rightDownButton.frame),
								 CGRectGetMaxY(self.rightDownButton.frame)-CGRectGetMinY(self.rightUpButton.frame)
								 );
	rightLayer.cornerRadius = rightLayer.frame.size.width/2;
	rightLayer.borderColor = [UIColor colorWithHex:0xB3B3B3].CGColor;
	rightLayer.borderWidth = 1;
	[self.layer addSublayer:rightLayer];
	
	CAShapeLayer *centerLayer = [[CAShapeLayer alloc] init];
	centerLayer.frame = CGRectMake(
								  0,
								  0,
								  CGRectGetWidth(self.okButton.frame)*3,
								  CGRectGetWidth(self.okButton.frame)*3
								  );
	centerLayer.position = self.okButton.center;
	centerLayer.cornerRadius = centerLayer.frame.size.width/2;
	centerLayer.borderColor = [UIColor colorWithHex:0xB3B3B3].CGColor;
	centerLayer.borderWidth = 1;
	[self.layer addSublayer:centerLayer];
	
	//添加长按手势
	for (int value = 0; value < 30; value++) {
		if (value >= 20) {
			NSInteger index = value - 20;
			if (![self.irgmData.param03[index] isEqualToString:@"None"])
			{
				UIButton *btn = [self viewWithTag:value];
				[self addLongGestureWithBtn:btn];
			}
		}else if (value >= 10) {
			
			NSInteger index = value -10;
			if (![self.irgmData.param02[index] isEqualToString:@"None"])
			{
				UIButton *btn = [self viewWithTag:value];
				[self addLongGestureWithBtn:btn];
			}
			
		}else if (value >= 0) {
			NSInteger index = value;
			if (![self.irgmData.param01[index] isEqualToString:@"None"])
			{
				UIButton *btn = [self viewWithTag:value];
				[self addLongGestureWithBtn:btn];
			}
		}

	}
	
	
	
}
#pragma mark - 添加点击手势  点击退出键盘
- (void)addTapGesture
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	[self.blankView addGestureRecognizer:tap];
}
- (void)tapClick
{
	[self endEditing:YES];
}
#pragma mark - 添加长按手势
- (void)addLongGestureWithBtn:(UIButton *)btn
{
	UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureClickWithTag:)];
	[btn addGestureRecognizer:longGesture];
}

- (void)longGestureClickWithTag:(UILongPressGestureRecognizer *)longGesture
{
	
	if (longGesture.state == UIGestureRecognizerStateBegan) {
		
		//添加弹框
	if (self.currentView) {
	[self.currentView removeFromSuperview];
	}

	[self addMenuView];
	self.currentView = self.blankView;

	self.blankView.hidden = NO;
	self.popView.irgmData = self.irgmData;
	self.popView.tagBtn = longGesture.view.tag;
	NSLog(@"tag-%ld",longGesture.view.tag);
	}
}
@end
