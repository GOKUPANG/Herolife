//
//  PushSettingController.m
//  herolife
//
//  Created by PongBan on 16/9/7.
//  Copyright © 2016年 huarui. All rights reserved.
//
#define HRMyScreenH (HRUIScreenH / 667.0)
#define HRMyScreenW (HRUIScreenW / 375.0 )


#import "PushSettingController.h"
#import "YXCustomAlertView.h"
#import "NSString+PushSet.h"
#import "CALayer+Anim.h"


@interface PushSettingController ()<YXCustomAlertViewDelegate>

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;


/** OP数组 */

@property(nonatomic,strong) NSMutableArray * OPArray;


/**  对方联系号码 输入框*/

@property(nonatomic,strong) UITextField * FriendPhoneTF;

/**  挟持提醒人 输入框*/

@property(nonatomic,strong) UITextField * FriendNameTF;


/**  自己的名字 输入框*/
@property(nonatomic,strong) UITextField * MyNameTF;


/**  门锁地点 输入框*/
@property(nonatomic,strong) UITextField * DoorAddressTF;


/**  防撬提醒人手机号码 输入框*/
@property(nonatomic,strong) UITextField * FanQiaoPhoneTF;


/**  防撬提醒人 输入框*/
@property(nonatomic,strong) UITextField * FanQiaoNameTF;

/** 防撬提醒弹出框*/
@property(nonatomic,strong)YXCustomAlertView * FanQiaoAlertView;

/** 劫持提醒弹出框*/

@property(nonatomic,strong)YXCustomAlertView * KidnapAlertView;




@property(nonatomic,copy)NSString *  FriendPhone;

@property(nonatomic,copy)NSString *  FriendName;

@property(nonatomic,copy)NSString *  MyName;

@property(nonatomic,copy)NSString *  DoorAddress;

@property(nonatomic,copy)NSString *  FanQiaoPhone;

@property(nonatomic,copy)NSString *  FanQiaoName;


@property(nonatomic, weak) AppDelegate *appDelegate;
/** 目标设备不在线 提示框 */
@property(nonatomic, weak) UILabel *onLineLabel;
/**  */
@property(nonatomic, strong) NSTimer *timer;


@end

@implementation PushSettingController
#pragma mark - label 懒加载
- (UILabel *)onLineLabel
{
	if (!_onLineLabel) {
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenW *0.28, UIScreenH * 0.8, UIScreenW - UIScreenW *0.56, 32)];
		label.text = @"目标设备不在线!";
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:17];
		label.textColor = [UIColor whiteColor];
		label.layer.cornerRadius = 5;
		label.layer.masksToBounds = YES;
		//		label.backgroundColor = [UIColor themeColor];
		
		label.backgroundColor = [UIColor blackColor];
		_onLineLabel = label;
		
		
		[[UIApplication sharedApplication].keyWindow addSubview:label];
	}
	return _onLineLabel;
}

- (void)setListModel:(DeviceListModel *)listModel
{
	_listModel = listModel;
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	DDLogWarn(@"获得我授权给别人的授权表setListModel%@count-%lu", app.homeArray, (unsigned long)app.homeArray.count);
	for (DeviceListModel *model in app.homeArray) {
		if ([model.uuid isEqualToString: listModel.uuid]) {
			
			_listModel = model;
			
		}
		
	}
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //	self.tabBarController.view.hidden = YES;
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = YES;
        }
    }
    
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = NO;
        }
    }
}


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 导航条 设置
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


- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    self.backImgView = backgroundImage;
    
    
    [self.view addSubview:self.backImgView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"应用";
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    
    self.navView = navView;
    
    
    /***************** 获取门锁op数组 *******************/
	
	[self makeBaseUI];
    
    
    /***************** 与服务器建立socket连接 *******************/
    
    [self postTokenWithTCPSocket];
    
    /***************** 设置原来的op  *******************/

    [self setString ];
    

	//添加通知
	[self addObserverNotification];
	
}
#pragma mark - 通知
- (void)addObserverNotification
{
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	
	[kNotification addObserver:self selector:@selector(receivePushDeviceInformation:) name:kNotificationReceivePushDeviceInformation object:nil];
	
}

static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_dismiss];
	self.onLineLabel.backgroundColor = [UIColor blackColor];
	[UIView animateWithDuration:0.01 animations:^{
		self.onLineLabel.alpha = 0.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^{
			self.onLineLabel.alpha = 1.0;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
				self.onLineLabel.alpha = 0.0;
				
			} completion:^(BOOL finished) {
				
				[self.onLineLabel removeFromSuperview];
			}];
		}];
	}];
	
	
}
// 921修改
static BOOL isOvertime = NO;
- (void)receivePushDeviceInformation:(NSNotification *)note
{
	isOvertime = YES;
	[SVProgressTool hr_dismiss];
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
-(void)setString
{
    self.FriendPhone = [self.listModel.op objectAtIndex:4];
    self.FriendName  = [self.listModel.op objectAtIndex:5];
    self.MyName      = [self.listModel.op objectAtIndex:6];
    self.DoorAddress = [self.listModel.op objectAtIndex:7];
    self.FanQiaoPhone= [self.listModel.op objectAtIndex:8];
    self.FanQiaoName = [self.listModel.op objectAtIndex:9];
}


#pragma mark - 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate connectToHost];
    self.appDelegate = appDelegate;
    
}


#pragma mark - 界面设置
-(void)makeBaseUI
{
   /****************************** 头像下面的线 ******************************/
    
    UIView * lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    
    [self.view addSubview:lineView1];
    
    lineView1.sd_layout
    .topSpaceToView(self.view,64+95*HRMyScreenH )
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .heightIs(1);
    
    /****************************** 头像 ******************************/
    
    UIImageView *headImgView = [[UIImageView alloc]init];
    [self.view addSubview:headImgView];
    
    headImgView.sd_layout
    .bottomSpaceToView(lineView1,5)
    .leftSpaceToView(self.view,15)
    .widthIs(60 *HRMyScreenH)
    .heightIs(60 *HRMyScreenH);
    
    headImgView.layer.cornerRadius = 30 *HRMyScreenH;
    headImgView.layer.masksToBounds = YES;
  //  headImgView.image = [UIImage imageNamed:@"4.jpg"];
    
    
    
    
    NSString *iconString;
    //QQ头像
    iconString = [kUserDefault objectForKey:kDefaultsQQIconURL];
    if (iconString.length > 0) {
        
        NSURL *url = [NSURL URLWithString:iconString];
        [headImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
    }else
    {
        iconString = [kUserDefault objectForKey:kDefaultsIconURL];
        if (iconString.length > 0) {
            NSURL *url = [NSURL URLWithString:iconString];
            [headImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
            
        }else
        {
            headImgView.image = [UIImage imageNamed:@"头像占位图片.jpg"];
            
        }
        
    }
    
    
    
    
    /****************************** 头像名字Label ******************************/
    
    

    UILabel * headLabel = [[UILabel alloc]init];
    [self.view addSubview:headLabel];

    headLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
  
    
    
    headLabel.textColor = [UIColor whiteColor];
    
    NSString * userName  = [kUserDefault objectForKey:kDefaultsUserName];
    
    NSString *qqName;
    //QQ头像
    qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
    if (qqName.length > 0) {
        userName = @"当前用户为QQ用户";
    }
    
    headLabel.text = userName ;
    
    
    headLabel.sd_layout
    .bottomSpaceToView(lineView1,30 * HRMyScreenH)
    .leftSpaceToView(headImgView,10)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
/****************************** 第二条线基本推送下面的线 ******************************/
    
    
    UIView * lineView2 =[[UIView alloc]init];
    lineView2.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    [self.view addSubview:lineView2];
    
    lineView2.sd_layout
    .topSpaceToView(lineView1,43.5 * HRMyScreenH)
    .leftEqualToView(lineView1)
    .rightEqualToView(lineView1)
    .heightIs(1);
    
    #pragma mark - 基本推送label
    
    //基本推送label
    
    UILabel *pushLabel = [[UILabel alloc]init];
    pushLabel .textColor = [UIColor whiteColor];
    pushLabel.text = @"基本推送";
    pushLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * HRMyScreenH];
    [self.view addSubview:pushLabel];
    
    pushLabel.sd_layout
    .bottomSpaceToView(lineView2,10 * HRMyScreenH)
    .leftSpaceToView(self.view,15)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    /****************************** 第三条线推送1 ******************************/
    
    UIView *lineView3 = [[UIView alloc]init];
    [self.view addSubview:lineView3];
    lineView3.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView3.sd_layout
    .topSpaceToView(lineView2,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 * HRMyScreenW)
    .rightEqualToView(lineView2)
    .heightIs(1);
    
    
   
    
    
    
    
     /****************************** 第四条线推送2 ******************************/
    
    UIView *lineView4 = [[UIView alloc]init];
    [self.view addSubview:lineView4];
    lineView4.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView4.sd_layout
    .topSpaceToView(lineView3,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView3)
    .heightIs(1);


    /****************************** 第5条线推送3 ******************************/
    
    UIView *lineView5 = [[UIView alloc]init];
    [self.view addSubview:lineView5];
    lineView5.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView5.sd_layout
    .topSpaceToView(lineView4,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView4)
    .heightIs(1);
    
    
    /****************************** 第6条线推送4 ******************************/
    
    UIView *lineView6 = [[UIView alloc]init];
    [self.view addSubview:lineView6];
    lineView6.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView6.sd_layout
    .topSpaceToView(lineView5,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView5)
    .heightIs(1);
    


    /****************************** 第7条线短信推送 ******************************/
    
    UIView *lineView7 = [[UIView alloc]init];
    [self.view addSubview:lineView7];
    lineView7.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView7.sd_layout
    .topSpaceToView(lineView6,68.0 * HRMyScreenH)
    .leftSpaceToView(self.view,5)
    .rightEqualToView(lineView6)
    .heightIs(1);
    
    
    /****************************** 第8条线短信推送1 ******************************/
    
    UIView *lineView8 = [[UIView alloc]init];
    [self.view addSubview:lineView8];
    lineView8.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView8.sd_layout
    .topSpaceToView(lineView7,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView7)
    .heightIs(1);

    /****************************** 第9条线短信推送2 ******************************/
    
    UIView *lineView9 = [[UIView alloc]init];
    [self.view addSubview:lineView9];
    lineView9.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView9.sd_layout
    .topSpaceToView(lineView8,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView8)
    .heightIs(1);

    /****************************** 推送开关 ******************************/

    
#pragma mark -基本推送开关
    
    
   
    
    UISwitch * SW1 = [[UISwitch alloc]init];
    [self.view addSubview:SW1];
    
    
    
    
    
    SW1.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView3,5)
    .heightIs(0)
    .widthIs(0);
    
    
    UISwitch * SW2 = [[UISwitch alloc]init];
    [self.view addSubview:SW2];
    
    SW2.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView4,5)
    .heightIs(0)
    .widthIs(0);
    
    
    UISwitch * SW3 = [[UISwitch alloc]init];
    [self.view addSubview:SW3];
    
    
    
    SW3.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView5,5)
    .heightIs(0)
    .widthIs(0);
    
    
    UISwitch * SW4 = [[UISwitch alloc]init];
    [self.view addSubview:SW4 ];
    
    SW4 .sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView6,5)
    .heightIs(0)
    .widthIs(0);
    
    
    #pragma mark - 短信推送开关
    
    
    UISwitch * MSW1 = [[UISwitch alloc]init];
    [self.view addSubview:MSW1];
    
    
    MSW1.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView8,5)
    .heightIs(0)
    .widthIs(0);
    
    
    
    UISwitch * MSW2 = [[UISwitch alloc]init];
    [self.view addSubview:MSW2];
    
    
    
    
    MSW2.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView9,5)
    .heightIs(0)
    .widthIs(0);
    
    
    /** 劫持提醒开关触发的方法*/
    
    [MSW1 addTarget:self action:@selector(KidNapOnOFF:) forControlEvents:UIControlEventValueChanged];
    
    
    /** 防撬提醒开关触发的方法*/
    
    [MSW2 addTarget:self action:@selector(TamperOnOFF:) forControlEvents:UIControlEventValueChanged];
    
    
    /** 给6个开关控件加上tag值*/
    SW1.tag  = 1 ;
    SW2.tag  = 2 ;
    SW3.tag  = 3 ;
    SW4.tag  = 4 ;
    MSW1.tag = 5 ;
    MSW2.tag = 6 ;
  


    
    
    #pragma mark -推送开关状态的设置
    
    
    
    
     self.OPArray = [NSMutableArray arrayWithArray:self.listModel.op];
    NSLog(@"为什么没来到这里呢oparray内容是%@",self.OPArray);


    /**
     oparray内容是(
     0,
     0,
     1,
     1,
     对方联系号码    18888888888,
     挟持提醒人   NETC,
     自己的名字   NETC,
     门锁地点    GUANGZHOU,
     手机号码 18888888888,
     防撬提醒人 NETC
     )
     */
    
    int SW1Status = [self.OPArray.firstObject intValue];
    int SW2Status = [[self.OPArray objectAtIndex:1]intValue];
    int SW3Status = [[self.OPArray objectAtIndex:2]intValue];
    int SW4Status = [[self.OPArray objectAtIndex:3]intValue];
    

    
    
    NSString *FriendPhone =[self.OPArray objectAtIndex:4];
  //  NSString *FriendName =[self.OPArray objectAtIndex:5];
  //  NSString *MyName =[self.OPArray objectAtIndex:6];
  //  NSString *DoorAddress =[self.OPArray objectAtIndex:7];
    NSString *FanQiaoPhone =[self.OPArray objectAtIndex:8];
  //  NSString *FanQiaoName =[self.OPArray objectAtIndex:9];
    
    
    
    [SW1 setOn:SW1Status];
    [SW2 setOn:SW2Status];
    [SW3 setOn:SW3Status];
    [SW4 setOn:SW4Status];
    
    if ([FriendPhone isEqualToString:@"none"] ) {
        
        [MSW1 setOn:0];
        
    }
    
    else{
        [MSW1 setOn:1];
        
    }
    
    
    if ([FanQiaoPhone isEqualToString:@"none"]) {
        [MSW2 setOn:0];
        
    }
  
    else{
        [MSW2 setOn:1];
        
    }
    
    BOOL isOpen =  SW3.on;
    
    NSLog(@"%d",isOpen);
    
    
    NSLog(@"%@",isOpen?@"YES":@"NO");
    

    
    /******************************  短信推送Label ******************************/
    
    UILabel *MessLabel = [[UILabel alloc]init];
    UILabel *MessLabel1 = [[UILabel alloc]init];
     UILabel *MessLabel2 = [[UILabel alloc]init];
    [self.view addSubview:MessLabel];
    [self.view addSubview:MessLabel1];
     [self.view addSubview:MessLabel2];
    
    
   
    MessLabel .textColor = [UIColor whiteColor];
    MessLabel.text = @"短信推送";
    MessLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * HRMyScreenH];
   

    
    MessLabel.sd_layout
    .bottomSpaceToView(lineView7,10*HRMyScreenH)
    .leftSpaceToView(self.view,15)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
    
    MessLabel1 .textColor = [UIColor whiteColor];
    MessLabel1.text = @"劫持提醒";
    MessLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
    
    MessLabel1.sd_layout
    .bottomSpaceToView(lineView8,10 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 * HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
   
    MessLabel2 .textColor = [UIColor whiteColor];
    MessLabel2.text = @"防撬报警";
    MessLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
   
    
    MessLabel2.sd_layout
    .bottomSpaceToView(lineView9,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
    /****************************** 基本推送Label *********************************/
    
    UILabel *PushLabel1 = [[UILabel alloc]init];
    UILabel *PushLabel2 = [[UILabel alloc]init];
    UILabel *PushLabel3 = [[UILabel alloc]init];
    UILabel *PushLabel4 = [[UILabel alloc]init];
    [self.view addSubview:PushLabel1];
    [self.view addSubview:PushLabel2];
    [self.view addSubview:PushLabel3];
    [self.view addSubview:PushLabel4];
    
    
    //Label的基本设置
    
    PushLabel1 .textColor = [UIColor whiteColor];
    PushLabel1.text = @"门锁操作信息推送";
    PushLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
    PushLabel2 .textColor = [UIColor whiteColor];
    PushLabel2.text = @"低电量提醒推送";
    PushLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];

    PushLabel3 .textColor = [UIColor whiteColor];
    PushLabel3.text = @"长时间未开锁提醒推送(72h)";
    PushLabel3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];

    PushLabel4 .textColor = [UIColor whiteColor];
    PushLabel4.text = @"闯入风险提醒推送";
    PushLabel4.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
    
    
    
    /****************************** 基本推送Label的布局 *********************************/

    
    PushLabel1.sd_layout
    .bottomSpaceToView(lineView3,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    PushLabel2.sd_layout
    .bottomSpaceToView(lineView4,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);

    
    PushLabel3.sd_layout
    .bottomSpaceToView(lineView5,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);

    PushLabel4.sd_layout
    .bottomSpaceToView(lineView6,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);

    #pragma mark -保存按钮的创建
    /****************************** 保存按钮的创建 *********************************/

    UIButton * SaveBtn = [[UIButton alloc]init];
    [self.view addSubview:SaveBtn];
    
    SaveBtn.sd_layout
    .bottomSpaceToView(self.view , 30.0 * HRMyScreenH)
    .rightSpaceToView(self.view,122.0 *HRMyScreenW)
    .widthIs(130.0 *HRMyScreenW)
    .heightIs(40.0 *HRMyScreenH);
    
    
    SaveBtn.layer.cornerRadius = 20.0 * HRMyScreenH;
    SaveBtn.layer.masksToBounds = YES;
    
   /** 
    UIBlurEffect *blurEffect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //可以看见的毛玻璃
    
    UIVisualEffectView *VisualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    //将这个view覆盖整个图片
    
    VisualEffectView.frame = SaveBtn.frame;
    
    
    //添加到图片上去
    
    
    [SaveBtn addSubview:VisualEffectView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testtttt)];
    [VisualEffectView addGestureRecognizer:tap];

    */
  
    
    [SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    
    [SaveBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:0xc6f0ff alpha:0.7]] forState:UIControlStateHighlighted];
    
     [SaveBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.3]] forState:UIControlStateNormal];
    
    [SaveBtn addTarget:self action:@selector(SaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    
    
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



#pragma mark -劫持提醒开关方法

-(void)KidNapOnOFF:(UISwitch *)Switch
{
    NSLog(@"劫持提醒");
    
    
    if (Switch.on) {
        [self makeKidnapAlertView];
    }
    
    
    else
    {
        self.FriendPhone = @"none";
        self.FriendName= @"none";
        self.MyName = @"none";
        self.DoorAddress = @"none" ;
        
        
        
    }
}


#pragma mark -防撬提醒开关方法

-(void)TamperOnOFF:(UISwitch *)Switch
{
    NSLog(@"防撬提醒");
    
    
    
    BOOL isOpen = Switch.on;
    
    if (isOpen) {
        
        [self makeFanQiaoAlerView];
      
        
    }
    
    else{
        
        
        self.FanQiaoPhone = @"none";
        self.FanQiaoName= @"none";
        
        
    }
    
    
    
    
    
}


#pragma mark -劫持提醒弹出框
-(void)makeKidnapAlertView
{
    CGFloat dilX = 25;
    CGFloat dilH = 290;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"劫持提醒";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = @"手机号码";
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
    loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    
    loginPwdField.leftViewMode = UITextFieldViewModeAlways;
    loginPwdField.leftView = leftView;
    
    
    loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginPwdField.layer.borderWidth = 1;
    loginPwdField.layer.cornerRadius = 4;
    
    loginPwdField.placeholder = @"对方常用手机";
    
    [loginPwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    loginPwdField.textColor = [UIColor whiteColor];
    
    
    
    
    UITextField * PSWNameField = [[UITextField alloc]initWithFrame:CGRectMake(loginX, 100, alertV.frame.size.width -  loginX*1.2, 32)];
    
    PSWNameField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    
    
    PSWNameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    PSWNameField.leftView = leftView1;
    
    
    PSWNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    PSWNameField.layer.borderWidth = 1;
    PSWNameField.layer.cornerRadius = 4;
    
    PSWNameField.placeholder = @"对方称呼";
    [PSWNameField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    PSWNameField.textColor = [UIColor whiteColor];
    
    
    
    
    
    
    UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
    
    [alertV addSubview:PswLabel];
    PswLabel.text = @"对方称呼";
    PswLabel.textColor = [UIColor whiteColor];
    
    PswLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    UITextField * MyNameField = [[UITextField alloc]initWithFrame:CGRectMake(loginX, 150, alertV.frame.size.width -  loginX*1.2, 32)];
    
    MyNameField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    
    
    MyNameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    MyNameField.leftView = leftView2;
    
    
    MyNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    MyNameField.layer.borderWidth = 1;
    MyNameField.layer.cornerRadius = 4;
    
    MyNameField.placeholder = @"您的称呼";
    
    [MyNameField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    MyNameField.textColor = [UIColor whiteColor];
    
    
    
    
    
    
    UILabel * MyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, loginX, 32)];
    
    [alertV addSubview:MyNameLabel];
    MyNameLabel.text = @"您的称呼";
    MyNameLabel.textColor = [UIColor whiteColor];
    
    MyNameLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    UITextField * DoorAdressField = [[UITextField alloc]initWithFrame:CGRectMake(loginX, 200, alertV.frame.size.width -  loginX*1.2, 32)];
    
    DoorAdressField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    
    
    DoorAdressField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    DoorAdressField.leftView = leftView3;
    
    
    DoorAdressField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    DoorAdressField.layer.borderWidth = 1;
    DoorAdressField.layer.cornerRadius = 4;
    
    DoorAdressField.placeholder = @"门锁所在地";
    [DoorAdressField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    DoorAdressField.textColor = [UIColor whiteColor];
    
    
    
    
    
    
    UILabel * DoorAdressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, loginX, 32)];
    
    [alertV addSubview:DoorAdressLabel];
    DoorAdressLabel.text = @"门锁地点";
    DoorAdressLabel.textColor = [UIColor whiteColor];
    
    DoorAdressLabel.textAlignment = NSTextAlignmentCenter;

    
    
    
    
    alertV.alpha=0;
    
    self.FriendPhoneTF = loginPwdField;
    
    self.FriendNameTF = PSWNameField;
    
    self.MyNameTF = MyNameField;
    
    self.DoorAddressTF = DoorAdressField;
    
    
    
    [alertV addSubview:self.FriendPhoneTF];
    [alertV addSubview:self.FriendNameTF];
    [alertV addSubview:self.MyNameTF];
    [alertV addSubview:self.DoorAddressTF];
    
    self.KidnapAlertView = alertV;
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.KidnapAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-120);
        
        self.KidnapAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        //  [customAlertView dissMiss];
        
        
    }];
    
}

    


#pragma mark -防撬提醒弹出框

-(void)makeFanQiaoAlerView
{
    /** FixAlertView;
     AddAlertView;
     FixField;
     AddPswNameField;
     AddPswNumberField;
     */
    CGFloat dilX = 25;
    CGFloat dilH = 200;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"防撬提醒";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = @"手机号码";
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
    loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    
    loginPwdField.leftViewMode = UITextFieldViewModeAlways;
    loginPwdField.leftView = leftView;
    
    
    loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginPwdField.layer.borderWidth = 1;
    loginPwdField.layer.cornerRadius = 4;
    
    loginPwdField.placeholder = @"提醒人的手机";
    
    [loginPwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    loginPwdField.textColor = [UIColor whiteColor];
    
    
    
    
    UITextField * PSWNameField = [[UITextField alloc]initWithFrame:CGRectMake(loginX, 100, alertV.frame.size.width -  loginX*1.2, 32)];
    
    PSWNameField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    
    
    PSWNameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    PSWNameField.leftView = leftView1;
    
    
    PSWNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    PSWNameField.layer.borderWidth = 1;
    PSWNameField.layer.cornerRadius = 4;
    
    PSWNameField.placeholder = @"防撬提醒人姓名";
    [PSWNameField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    PSWNameField.textColor = [UIColor whiteColor];
    
    
    UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
    
    [alertV addSubview:PswLabel];
    PswLabel.text = @"防撬提醒人";
    PswLabel.textColor = [UIColor whiteColor];
    
    PswLabel.textAlignment = NSTextAlignmentCenter;
    
    
    alertV.alpha=0;
    
    self.FanQiaoPhoneTF = loginPwdField;
    
    self.FanQiaoNameTF = PSWNameField;
    
    
    self.FanQiaoAlertView = alertV;
    
    [alertV addSubview:self.FanQiaoPhoneTF];
    
    [alertV addSubview:self.FanQiaoNameTF];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.FanQiaoAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.FanQiaoAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        //  [customAlertView dissMiss];
        
        
    }];
    
}

#pragma mark - 毛玻璃点击
-(void)testtttt
{
    /**
         UISwitch * msw1 = [self.view viewWithTag:5];
     UISwitch * msw2 = [self.view viewWithTag:6];
     
     */
    
    
    
    
}

#pragma mark -保存按钮点击方法
-(void)SaveBtnClick
{
    NSLog(@"点击了保存");
    /** 先搞定最重要的op数组  */
    
    
    UISwitch * sw1 = [self.view viewWithTag:1];
    UISwitch * sw2 = [self.view viewWithTag:2];
    UISwitch * sw3 = [self.view viewWithTag:3];
    UISwitch * sw4 = [self.view viewWithTag:4];
    UISwitch * msw1 = [self.view viewWithTag:5];
    UISwitch * msw2 = [self.view viewWithTag:6];
    
    int s1 = sw1.on;
    int s2 = sw2.on;
    int s3 = sw3.on;
    int s4 = sw4.on;
    NSString * str1 = [NSString stringWithFormat:@"%d",s1];
    NSString * str2 = [NSString stringWithFormat:@"%d",s2];
    NSString * str3 = [NSString stringWithFormat:@"%d",s3];
    NSString * str4 = [NSString stringWithFormat:@"%d",s4];
    
    if (!msw1.on) {
        
        self.FriendPhone = @"none";
        self.FriendName = @"none";
        self.MyName = @"none";
        self.DoorAddress = @"none";
        

           }
   
    if (!msw2.on) {
        self.FanQiaoPhone = @"none";
        self.FanQiaoName= @"none";
        
    }
    
    
    NSArray * opArray = [NSArray arrayWithObjects:str1,str2,str3,str4,self.FriendPhone,self.FriendName,self.MyName,self.DoorAddress,self.FanQiaoPhone,self.FanQiaoName, nil];
    
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushToken"];
    
    NSString * srcUserName  =  [kUserDefault objectForKey:kDefaultsUserName];
    
    NSString * UUID = [kUserDefault objectForKey:kUserDefaultUUID];
    
    DeviceListModel *model = self.listModel;
    
    
    NSString * uid = model.uid;
    
    
    NSString * did  =  model.did;
    
    NSString * DoorUUID  = model.uuid;
    
    NSString * title = model.title;
    
    NSString * msgVersion = model.version;
    
    NSString * brand = model.brand;
    
    NSString * level = model.level;
    
    NSString * state = model.state;
    
    
    NSString * online = model.online;
    
    
    NSString * RequestStr = [NSString stringwithHRPushSetVersion:@"0.01"
                                                          status:@"200"
                                                           token:token
                                                            type:@"update"                       desc:@"none"
                                                     srcUserName:srcUserName
                                                      srcDevName:UUID
                                                     dstUserName:srcUserName dstDevName:DoorUUID
                                                        msgTypes:@"hrsc"
                                                           title:title
                                                             uid:uid
                                                             did:did
                                                            uuid:DoorUUID
                                                      msgVersion:msgVersion
                                                           brand:brand
                                                           level:level
                                                           state:state
                                                          online:online
                                                              op:opArray  ];
    
    NSLog(@"请求的字符串是%@",RequestStr);
    
    
    
    [self.appDelegate sendMessageWithString:RequestStr];
	
	[SVProgressTool hr_showWithStatus:@"正在保存推送设置..."];
	// 设置超时
	isOvertime = NO;
	isShowOverMenu = NO;
	// 启动定时器
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];

}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}

#pragma mark - YXCustomAlertViewDelegate 劫持提醒与防撬提醒的弹窗选中

- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        
        if (customAlertView == self.KidnapAlertView) {
            
            UISwitch * msw1 =  [self.view viewWithTag:5];
            
            msw1.on = NO;
            
            
        }
        
        
        else{
            UISwitch *msw2 =   [self.view viewWithTag:6];
            
            msw2.on = NO;
            
            
        }
        
        

    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        CGRect AlertViewFrame = customAlertView.frame;
        
        AlertViewFrame.origin.x = HRUIScreenW;
        
        customAlertView.alpha = 0;
        
        customAlertView.frame = AlertViewFrame;
        
        
    } completion:^(BOOL finished) {
        
        
        [customAlertView dissMiss];
        
        
    }];

}
    
    
    if (buttonIndex == 1) {
        
        if (customAlertView == self.KidnapAlertView) {
            
            if (self.FriendPhoneTF.text.length == 0||self.FriendNameTF.text.length==0||self.MyNameTF.text.length==0||self.DoorAddressTF.text.length==0) {
                
                
                [customAlertView.layer shake];
                
                return;
                
            }
            
            else
            {
             self.FriendPhone = self.FriendPhoneTF.text ;
              self.FriendName = self.FriendNameTF.text;
                  self.MyName = self.MyNameTF.text  ;
             self.DoorAddress = self.DoorAddressTF.text ;
            }
        }
        
        
        else{
            
            if (self.FanQiaoPhoneTF.text.length == 0||self.FanQiaoNameTF.text.length==0) {
                
                
                [customAlertView.layer shake];
                
                return;
                
            }
            
            else{
        self.FanQiaoPhone =  self.FanQiaoPhoneTF.text ;
        self.FanQiaoName  =  self.FanQiaoNameTF.text  ;
            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            CGRect AlertViewFrame = customAlertView.frame;
            
            AlertViewFrame.origin.x = HRUIScreenW;
            
            
            customAlertView.frame = AlertViewFrame;
            
            customAlertView.alpha = 0;
            
            
        
        } completion:^(BOOL finished) {
            
            
            [customAlertView dissMiss];
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
