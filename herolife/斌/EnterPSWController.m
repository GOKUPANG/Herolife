//
//  EnterPSWController.m
//  herolife
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 huarui. All rights reserved.
//


/** 屏幕高度*/
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

#import "EnterPSWController.h"
#import "UIView+SDAutoLayout.h"
#import "WiFiListController.h"

#import "WaitController.h"
#import "WIFIListModel.h"
#import "UDPModel.h"
#import "HRPushMode.h"
#import "NextController.h"
@interface EnterPSWController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>


@property(nonatomic,strong)UIView * lineView2;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@property(nonatomic,strong)UITableView * tableView;
/** wifi名称 */
@property(nonatomic, weak)  UILabel * WIFILabel;
/**  */
@property(nonatomic, weak)  UITextField *WIFITextField;
/** 选中wifi时 传过来的值 */
@property(nonatomic, copy) NSString *name;
/** 选中wifi时 传过来的下标 */
@property(nonatomic, assign) NSInteger index;

@property(nonatomic, strong) HRUDPSocketTool  *udpSocket;


/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
/** 停留时间 */
@property(nonatomic, assign) int leftTime;
/** 停留时间 */
@property(nonatomic, assign) int wiftTime;

/** 定时器 */
@property (nonatomic, weak) NSTimer *wiftTimer;


@end


@implementation EnterPSWController


/** 停留时间 */
static int const HRTimeDuration = 300;


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
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
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",(long)PicNum];
        
        self.backImgView.image =[UIImage imageNamed:imgName];
    }
    
    
    
    NSLog(@"设置页面ViewWillappear");
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入密码";
    
    
//    UIImageView *BakView = [[UIImageView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
//    
//    BakView.image = [UIImage imageNamed:@"2"];
//    
//    [self.view addSubview:BakView];
    

    
    [self makeUI];
    
    
    [self MakeStartAddView];
    
	
	//haibo 全屏放回
	[self goBack];
	
	//haibo 隐藏底部条
	[self IsTabBarHidden:YES];
    
    [self addWifiTimer];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[SVProgressTool hr_dismiss];
	if (self.name.length > 0) {
		self.WIFILabel.text = self.name;
		return;
	}
	
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
-(void)makeUI
{
	//海波代码----------------------start-------------------------------------
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
    
    
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"3.jpg"];
    self.backImgView=backgroundImage;
    
    [self.view addSubview:self.backImgView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    

    
    
    
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"输入密码";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:navView];
	self.navView = navView;
	//海波代码----------------------end-------------------------------------
    UIView  * lineView1 = [[UIView alloc]init];
    
    [self.view addSubview:lineView1];
    
    lineView1.sd_layout
    .topSpaceToView(self.view,64+90)
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(1);
    
    lineView1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    
    
    
    //第二条线
    _lineView2 = [[UIView alloc]init];
    
    [self.view addSubview:_lineView2];
	
    _lineView2.sd_layout
    .topSpaceToView(lineView1,50)
    .leftEqualToView(lineView1)
    .rightEqualToView(lineView1)
    .heightIs(1);
    _lineView2.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.7];
    
    
    
    /** 第一行白线上面添加一个View*/
    
    UIView * WIFIView = [[UIView alloc]init];
    [self.view addSubview:WIFIView];
    
    WIFIView.sd_layout
    .bottomEqualToView(lineView1)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(46.0);
    
    
    
    /** 给这个第一行的View 添加一个手势事件 用于选择WiFi */
    
    UITapGestureRecognizer * WIFITap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WIFIClick)];
    
    [WIFIView addGestureRecognizer:WIFITap];
    
    
/** WIFILabel */
    
    UILabel * WIFILabel = [[UILabel alloc]init];
    [WIFIView addSubview:WIFILabel];
    
    WIFILabel.sd_layout
    .bottomSpaceToView(WIFIView,10)
    .leftSpaceToView(WIFIView,25)
    .widthIs(200)
    .heightIs (20);
    
    WIFILabel.textAlignment= NSTextAlignmentLeft;
    
  //  WIFILabel.text = @"";
    
    
    
    WIFILabel.textColor = [UIColor whiteColor];
	self.WIFILabel = WIFILabel;
	
    /** WiFi cell的 最右边的图片*/
    
    UIImageView *WIFIImageView  = [[UIImageView alloc]init];
    
    [WIFIView addSubview:WIFIImageView];
    
    WIFIImageView.sd_layout
    .bottomSpaceToView(WIFIView,8)
    .rightSpaceToView(WIFIView,25)
    .widthIs(13)
    .heightIs(18);
    
    WIFIImageView.image = [UIImage imageNamed:@"进入"];
    
    /** WiFi密码输入框*/
    
    UITextField *WIFITextField = [[UITextField alloc]init];
    WIFITextField.delegate = self;
    [self.view addSubview:WIFITextField];
    
    WIFITextField.sd_layout
    .bottomSpaceToView(_lineView2,10)
    .leftSpaceToView(self.view,25)
    .widthIs(HRUIScreenW - 70)
    .heightIs(22);
    WIFITextField.textColor = [UIColor whiteColor];
    
    WIFITextField.returnKeyType = UIReturnKeyDone;
    WIFITextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    WIFITextField.placeholder = @"请输入密码";
    [WIFITextField setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    WIFITextField.clearButtonMode =    UITextFieldViewModeAlways;
#ifdef DEBUG
	WIFITextField.text = @"HRKJ39026922";
#endif
  
    
	self.WIFITextField = WIFITextField;
    
    
    //斌修改11月8日
    
    //self.WIFITextField.secureTextEntry = YES;

    
    
    
    
    /** WIFI密码输入框最右边的图片 */
    
//    UIImageView *EyeimageView = [[UIImageView alloc]init];
//    [self.view addSubview:EyeimageView];
    
    
    UIButton * eyeBtn = [[UIButton alloc]init];
    
    [self.view addSubview:eyeBtn];
    
    
    
    eyeBtn.sd_layout
    .bottomSpaceToView(_lineView2,10)
    .rightSpaceToView(self.view,25)
    .widthIs(18)
    .heightIs(13);
    
   // EyeimageView.image = [UIImage imageNamed:@"睁眼"];
    
    
    [eyeBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateNormal];
    
    [eyeBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateSelected];
    
    eyeBtn.selected = NO ;
    
    
    [eyeBtn addTarget:self action:@selector(openEye:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.WIFITextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.WIFITextField resignFirstResponder];
    return YES;
}
-(void)openEye:(UIButton *)btn
{
    if (btn.selected == YES) {
        
        [btn setSelected:NO];
        self.WIFITextField.secureTextEntry = YES;

        
        
        
    }
    
    else{
        
        [btn setSelected:YES];
        
        self.WIFITextField.secureTextEntry = NO;
        

        
    }
}



#pragma mark - UI事件  -haibo
- (void)leftButtonClick:(UIButton *)btn
{
    
    //wifi数组清空
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *arr = [NSArray array];
    app.wifiNameArray = arr;
    
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -点击WiFiView 实现的方法
-(void)WIFIClick
{
    
    NSLog(@"点击了WIFI");
	WiFiListController *WiFiVC = [[WiFiListController alloc] init];
	__weak __typeof__(self) weakSelf = self;
	[WiFiVC selectWifiBlockWithBlock:^(NSString *name, NSInteger index) {
		__strong __typeof__ (weakSelf) strongSelf = weakSelf;
		strongSelf.WIFILabel.text = name;
		strongSelf.name = name;
		strongSelf.index = index;
	}];
	[self.navigationController pushViewController:WiFiVC animated:YES];
    
    
}

#pragma mark - 开始添加按钮的设置
-(void)MakeStartAddView
{
    
    UIView * StartView = [[UIView alloc]init];
    [self.view addSubview:StartView];
    
    StartView.sd_layout
    .topSpaceToView(_lineView2,50)
    .leftSpaceToView(self.view ,15)
    .rightSpaceToView(self.view,15)
    .heightIs(40);
    
    
    UILabel * StartLabel  = [[UILabel alloc]init];
    
    [StartView addSubview:StartLabel];
    
//    StartLabel.sd_layout
//    .topSpaceToView(StartView,10)
//    .bottomSpaceToView(StartView,10)
//    .leftSpaceToView(StartView,137.5/375.0 *SCREEN_W)
//    .rightSpaceToView(StartView,137.5/375.0 *SCREEN_W);
    
    StartLabel.sd_layout
    .topEqualToView(StartView)
    .bottomEqualToView(StartView)
    .leftEqualToView(StartView)
    .rightEqualToView(StartView);
    
    

    
    
    
    StartLabel.text = @"开始添加";
    
    StartLabel.textColor = [UIColor whiteColor];
    
    StartLabel.textAlignment = NSTextAlignmentCenter;
    
    
    StartView. backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    //给StartView添加边框效果
    
    StartView.layer.borderWidth = 1;
    StartView.layer.borderColor =[UIColor colorWithWhite:1.0 alpha:0.7].CGColor;
    
    
    
    //给 starView添加一个手势
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StartViewClick)];
    
    [StartView addGestureRecognizer:tap];
    
}


#pragma mark -点击开始添加实现的方法

-(void)StartViewClick
{
    
    NSLog(@"点击了开始添加");
	if (self.WIFILabel.text.length < 0.5 || self.WIFITextField.text.length < 0.5) {
		[SVProgressTool hr_showErrorWithStatus:@"wifi名或密码不能为空!"];
	}else
	{
		[self setupUDPSocket];
        
        [self addTimer];//wifi搜索需要时间, 这时我需要检测当前的wifi是否是wifi盒子的wifi, 如果切换到了用户的wifi才让跳转
		
	}
}

#pragma mark - haibo 建立UDP连接
- (void)setupUDPSocket
{
	[SVProgressTool hr_showWithStatus:@"等待手机自动连接网络..."];
	NSInteger index = 0;
	self.udpSocket = [HRUDPSocketTool shareHRUDPSocketTool];
	[self.udpSocket connectWithUDPSocket];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"set"] = @"4";
	dict[@"ssid"] = self.WIFILabel.text;
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	for (int i = 0; i < app.wifiNameArray.count -1; i++) {
        NSLog(@"wifiNameArray%lui%d",app.wifiNameArray.count -1,i);
		if ([app.wifiNameArray[i] isEqualToString:self.WIFILabel.text]) {
			index = i;
		}
	}
	dict[@"pass"] = self.WIFITextField.text;
    dict[@"auth"] = app.authlistArray[index];
    NSString *userName = [kUserDefault objectForKey:kDefaultsUserName];
    NSString *pass = [kUserDefault objectForKey:kDefaultsPassWord];
    
    dict[@"username"] = userName;
    dict[@"password"] = pass;
	
	NSString *sendString = [NSString stringWithUDPMsgDict:dict];
	
	[_udpSocket sendUDPSockeWithString:sendString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_udpSocket sendUDPSockeWithString:sendString];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_udpSocket sendUDPSockeWithString:sendString];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_udpSocket sendUDPSockeWithString:sendString];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_udpSocket sendUDPSockeWithString:sendString];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_udpSocket sendUDPSockeWithString:sendString];
    });
	
    NSLog(@"set = 4%@", sendString);
	
}

#pragma mark - tableView的UI设置

-(void)makeTableViewUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, self.view.bounds.size.width, 46.0 * 2) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
                  
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    _tableView.rowHeight = 46.0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self.view addSubview:_tableView];
    
    
  
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.text = @"输入密码";
        cell.textLabel.textColor = [UIColor whiteColor];
        
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}
#pragma mark - 添加wiftTime定时器
- (void)addWifiTimer
{
    self.wiftTime = HRTimeDuration;
    self.wiftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateWifiTimeLabel) userInfo:nil repeats:YES];
    
}
static NSString *wift;
- (void)updateWifiTimeLabel
{
    
    self.wiftTime--;
    
    //从单例中获取数据
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *fisterWifi = app.wifiNameArray.firstObject;
    
    DDLogWarn(@"--------连上了--------%d", self.wiftTime);
    if (fisterWifi.length > 0) {
        
        [SVProgressTool hr_dismiss];
        self.WIFILabel.text = fisterWifi;
        
        [self.wiftTimer invalidate];
        self.wiftTimer = nil;
        return;
    }
    
    if (self.wiftTime == 0) {
        [SVProgressTool hr_showErrorWithStatus:@"请求超时,请重试!"];
        [self.navigationController popViewControllerAnimated:YES];
        [self.wiftTimer invalidate];
        self.wiftTimer = nil;
    }
    
}

#pragma mark - 添加定时器
- (void)addTimer
{
	self.leftTime = HRTimeDuration;
    [self.timer invalidate];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
	
}
static NSString *wift;
- (void)updateTimeLabel
{
	
	self.leftTime--;
	DDLogWarn(@"--------连上了wifi--------%d", self.leftTime);
	wift = [NSString stringWithGetWifiName];
   
	if ([wift isEqualToString:@"互联网智能门锁"] || wift.length < 1) {
		
		
	}else
	{
			
        [SVProgressTool hr_dismiss];
        WaitController *waitVC = [[WaitController alloc] init];
        [self.navigationController pushViewController:waitVC animated:YES];
      
		[self.timer invalidate];
		self.timer = nil;
	}
	if (self.leftTime == 0) {
		
        [SVProgressTool hr_showErrorWithStatus:@"请求失败,该错误可能是输入的密码错误或是请求超时!"];
        
        for (UIViewController *VC in self.navigationController.childViewControllers) {
            if ([NSStringFromClass([VC class]) isEqualToString:@"NextController"]) {
                
                [self.navigationController popToViewController: VC animated:YES];
            }
        }
        
		[self.timer invalidate];
        self.timer = nil;
        
	}
	
}
- (void)dealloc
{
    [self.wiftTimer invalidate];
	[self.timer invalidate];
    self.wiftTimer = nil;
	self.timer = nil;
}

#pragma mark  - 海波代码
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
	[self IsTabBarHidden:YES];
	[SVProgressTool hr_dismiss];
    
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
