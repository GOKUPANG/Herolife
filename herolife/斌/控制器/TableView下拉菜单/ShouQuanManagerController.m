//
//  ShouQuanManagerController.m
//  herolife
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ShouQuanManagerController.h"
#import "ViewOfCustomerTableViewCell.h"
#import "CustomerInfoSectionView.h"
#import "FTPopOverMenu.h"
#import "YXCustomAlertView.h"
#import "SRActionSheet.h"
#import "DeviceListModel.h"
#import "DeviceAutherModel.h"
#import "AutherTimePickView.h"

#define MENU_HEADER_VIEW_KEY    @"headerview"
#define MENU_OPENED_KEY         @"open"
#define FILTER_TITLE_KEY        @"title"
#define FILTER_ITEMS_KEY        @"values"
#define FILTER_IMAGES_KEY        @"image"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//查看开锁密码  文字key
#define RecordeLockPassword @"查看开锁密码"
static NSString *ViewOfCustomerTableViewCellIdentifier = @"ViewOfCustomerTableViewCellIdentifier";

@interface ShouQuanManagerController ()<UITableViewDataSource,UITableViewDelegate,CustomerInfoSectionViewDelegate,SRActionSheetDelegate, AutherTimePickViewDelegate>

@property(nonatomic,strong)UITableView *listTableView;

/** ept */
@property(nonatomic, strong) UIView *eptView;

#pragma mark -原来的数据源  决定有多少个section 要修改
/** 待修改  */
@property(nonatomic,strong)NSMutableArray *dataArray;


@property (assign, nonatomic) NSInteger openedSection;


@property(nonatomic,strong)NSArray *cellArray;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar * navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView * backImgView;

/**  增加密码名字输入框*/

@property(nonatomic,strong)UITextField *       AddPswNameField;

/**  家人分享用户名输入框*/
@property(nonatomic,strong)UITextField *       AddPswNumberField;


/** 家人分享弹窗*/
@property(nonatomic,strong)YXCustomAlertView * FamilyAlertView;


/** 临时分享弹窗*/
@property(nonatomic,strong)YXCustomAlertView * TemporaryAlertView;


/** 临时授权手机号码输入框*/

@property(nonatomic,strong)UITextField * PhoneTfield;



/** 临时授权时间输入框*/

@property(nonatomic,strong)AutherTimePickView * TimeTfield;

/** 远程开锁滑块的值  */
@property(nonatomic, copy) NSString *remoteOnLock;
/** 记录查询滑块的值  */
@property(nonatomic, copy) NSString *recordQuery;
/** <#name#> */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** <#name#> */
@property(nonatomic, weak) UISwitch * OpenLockSWitch;
/** <#name#> */
@property(nonatomic, weak) UISwitch * recordSWitch;
/** 用户名密码输入框 */
@property(nonatomic, weak) UITextField *pwdField;
/** 取消授权 - 用户名密码输入框 */
@property(nonatomic, weak) UITextField *pwdAutherField;
/** 记录当前选择的小时 */
@property(nonatomic, copy) NSString *hour;
/** 记录当前选择的分钟 */
@property(nonatomic, copy) NSString *minute;
/** 用户管理员密码输入框 */
@property(nonatomic, weak) UITextField *manageField;
/** 弹框密码 label */
@property(nonatomic, weak) UILabel * paswdLabel;
/** 当前锁的UUID */
@property(nonatomic, copy) NSString *currentUuid;
@end

@implementation ShouQuanManagerController

#pragma mark - haibo set方法
- (void)setListModel:(DeviceListModel *)listModel
{
	_listModel = listModel;
	self.currentUuid = listModel.uuid;
	// 我授权给别人的数据和当前点击的数据里的UUID进行比较,看是否有有权限跳转
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	DDLogWarn(@"获得我授权给别人的授权表setListModel%@count-%lu", app.autherArray, (unsigned long)app.autherArray.count);
	NSMutableArray *mu = [NSMutableArray array];
	for (DeviceAutherModel *model in app.autherArray) {
		if ([model.uuid isEqualToString: listModel.uuid]) {
			
			[mu addObject:model];
			
		}
		
	}
	self.deviceAutherArray = mu;
	[self.listTableView reloadData];
	
}
#pragma mark - tabbar 设置
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


#pragma mark - 导航条左边返回方法
-(void)popToLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
	
	//初始化值
	self.remoteOnLock = @"0";
	self.recordQuery = @"0";
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	self.appDelegate = appDelegate;
	
	
    self.openedSection = NSNotFound;
    _dataArray = [[NSMutableArray alloc]init];
   // _listTableView要显示的section数目
    for (int i = 0; i < self.deviceAutherArray.count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"55555" forKey:@"detail"];
        [_dataArray addObject:dic];
        
    }
	
    #pragma mark -这里决定下拉的cell的数目
    _cellArray = @[@"1",@"2"];//下拉显示的cell的数量
	
    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    self.backImgView             = backgroundImage;
    
    [self.view addSubview:self.backImgView];
    
    UIView *view                 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor         = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];

    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"授权管理";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    
    
    navView.rightLabel.text = @"添加";
    
    navView.rightLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddShouQuan:)];
    
    [navView.rightLabel addGestureRecognizer:tap];

    self.navView = navView;

    
    
    
    
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10.f, 64.f,CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 20.f, [[UIScreen mainScreen] applicationFrame].size.height - 20.f)  style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerClass:[ViewOfCustomerTableViewCell class] forCellReuseIdentifier:ViewOfCustomerTableViewCellIdentifier];
    _listTableView.allowsSelection = YES;
    _listTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_listTableView];
	
	//通知
	[self addObserverNotification];
	
}


#pragma mark ----------------- haibo 通知相关
- (void)addObserverNotification
{
	[kNotification addObserver:self selector:@selector(receiveAutherInformation) name:kNotificationReceiveDeviceAutherInformation object:nil];
	
	[kNotification addObserver:self selector:@selector(receiveAutherInformation) name:kNotificationReceiveDeleteAutherInformation object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	
	//临时授权
	[kNotification addObserver:self selector:@selector(receiveTempAutherInformation) name:kNotificationReceiveTempAutherInformation object:nil];
	
}
static BOOL isOvertime = NO;
- (void)receiveTempAutherInformation
{
	
	// 更新数据
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	DDLogWarn(@"获得我授权给别人的授权表setListModel%@count-%lu", app.autherArray, (unsigned long)app.autherArray.count);
	NSMutableArray *mu = [NSMutableArray array];
	for (DeviceAutherModel *model in app.autherArray) {
		if ([model.uuid isEqualToString: _listModel.uuid]) {
			
			[mu addObject:model];
			
		}
		
	}
	
	self.deviceAutherArray = mu;
	
	// _listTableView要显示的section数目
	for (int i = 0; i < self.deviceAutherArray.count; i++)
	{
		NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
		[dic setValue:@"55555" forKey:@"detail"];
		[_dataArray addObject:dic];
		
	}
	
	[self.listTableView reloadData];
	
	
	[UIView animateWithDuration:0.5 animations:^{
		
		
		CGRect AlertViewFrame = self.FamilyAlertView.frame;
		
		AlertViewFrame.origin.x = HRUIScreenW;
		
		
		self.TemporaryAlertView.frame = AlertViewFrame;
		
		self.TemporaryAlertView.alpha = 0;
		
	} completion:^(BOOL finished) {
		
		
		[self.TemporaryAlertView dissMiss];
		
	}];
	
	isOvertime = YES;
	[SVProgressTool hr_showSuccessWithStatus:@"临时授权成功!"];
}
- (void)receiveAutherInformation
{
	[self dismissCustomAlertView];
	isOvertime = YES;
	[self.deviceAutherArray removeAllObjects];
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	DDLogWarn(@"receiveAutherInformationreceiveAutherInformation%@%lu", app.autherArray, app.autherArray.count);
	
	NSMutableArray *mu = [NSMutableArray array];
	for (DeviceAutherModel *model in app.autherArray) {
		if ([model.uuid isEqualToString: self.currentUuid]) {
			
			[mu addObject:model];
			
		}
		
	}
	self.deviceAutherArray = mu;
	
	[_dataArray removeAllObjects];
	for (int i = 0; i < self.deviceAutherArray.count; i++)
	{
		NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
		[dic setValue:@"55555" forKey:@"detail"];
		[_dataArray addObject:dic];
		
	}
	[SVProgressTool hr_dismiss];
	
	//删除之后让openedSection重新为空
	self.openedSection = NSNotFound;
	[self.listTableView reloadData];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}

#pragma mark - 添加和修改授权弹窗UI设置
-(void)makeModifyFamilyAlerViewWithTitle:(NSString *)title userInteractionEnabled:(BOOL)userInteractionEnabled text:(NSString *)text tag:(NSInteger)tag remoteSwich:(NSString *)remoteSwich recordeSwich:(NSString *)recordeSwich
{
	/** FixAlertView;
	 AddAlertView;
	 FixField;
	 AddPswNameField;
	 AddPswNumberField;
	 */
	
	CGFloat dilX = 25;
	CGFloat dilH = 230 + 55;
	YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
	
	
	alertV.tag = tag;
	alertV.delegate = self;
	alertV.titleStr = title;

	
	CGFloat loginX = 200 *HRCommonScreenH;
	
	
	//qq用户
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
	
	//密码相关view
	UILabel * paswdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
	if (qqName && qqName.length > 0) {
		paswdLabel.hidden = YES;
	}else
	{
		paswdLabel.hidden = NO;
	}
	[alertV addSubview:paswdLabel];
	paswdLabel.text = @"用户密码";
	paswdLabel.textColor = [UIColor whiteColor];
	
	paswdLabel.textAlignment = NSTextAlignmentCenter;
	
	UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
	pwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	pwdField.secureTextEntry = YES;
	UIView *leftpPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	
	pwdField.leftViewMode = UITextFieldViewModeAlways;
	pwdField.leftView = leftpPwdView;
	
	
	pwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	pwdField.layer.borderWidth = 1;
	pwdField.layer.cornerRadius = 4;
	
	pwdField.placeholder = @"请输入用户登陆密码";
    [pwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
	pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	if (qqName && qqName.length > 0) {
		pwdField.hidden = YES;
	}else
	{
		pwdField.hidden = NO;
	}
	pwdField.textColor = [UIColor whiteColor];
	self.pwdField = pwdField;
	
	[alertV addSubview:pwdField];
	

	
	UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
	
	[alertV addSubview:numberLabel];
	numberLabel.text = @"用户名";
	numberLabel.textColor = [UIColor whiteColor];
	
	numberLabel.textAlignment = NSTextAlignmentCenter;
	
	
	
	
	
	UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 100, alertV.frame.size.width -  loginX*1.2, 32)];
	loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	
	loginPwdField.leftViewMode = UITextFieldViewModeAlways;
	loginPwdField.leftView = leftView;
	
	
	loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	loginPwdField.layer.borderWidth = 1;
	loginPwdField.layer.cornerRadius = 4;
	
	loginPwdField.placeholder = @"想要授权的用户";
    [loginPwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
	loginPwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	
	loginPwdField.textColor = [UIColor whiteColor];
	
	
	
	
	
	/***********************远程开锁开关**************************************/
	
	UISwitch * OpenLockSWitch = [[UISwitch alloc]initWithFrame:CGRectMake(alertV.frame.size.width -  70, 150, 0, 0)];
	if (remoteSwich.length < 0.5) {
		OpenLockSWitch.on = NO;
		self.remoteOnLock = @"0";
	}else
	{
		if ([remoteSwich isEqualToString:@"0"]) {
			self.remoteOnLock = @"0";
			OpenLockSWitch.on = NO;
		}else if ([remoteSwich isEqualToString:@"1"]) {
			
			OpenLockSWitch.on = YES;
			self.remoteOnLock = @"1";
		}
	}
	OpenLockSWitch.tag = 10;
	[OpenLockSWitch addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventValueChanged];
	
	
	
	UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, loginX, 32)];
	
	[alertV addSubview:PswLabel];
	PswLabel.text = @"远程开锁";
	PswLabel.textColor = [UIColor whiteColor];
	
	PswLabel.textAlignment = NSTextAlignmentCenter;
	
	
	
	UILabel * recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, loginX, 32)];
	
	[alertV addSubview:recordLabel];
	recordLabel.text = @"记录查询";
	recordLabel.textColor = [UIColor whiteColor];
	
	recordLabel.textAlignment = NSTextAlignmentCenter;
	
	
	
	/*****************************记录查询开关**************************************/
	
	UISwitch * recordSWitch = [[UISwitch alloc]initWithFrame:CGRectMake(alertV.frame.size.width -  70, 200, 0, 0)];
	
	recordSWitch.tag = 11;
	
	if (recordeSwich.length < 0.5) {
		recordSWitch.on = NO;
		self.recordQuery = @"0";
	}else
	{
		if ([recordeSwich isEqualToString:@"0"]) {
			self.recordQuery = @"0";
			recordSWitch.on = NO;
		}else if ([recordeSwich isEqualToString:@"1"]) {
			self.recordQuery = @"1";
			recordSWitch.on = YES;
		}
	}
	[recordSWitch addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventValueChanged];
	alertV.alpha=0;
	
	self.AddPswNumberField = loginPwdField;
	self.AddPswNumberField.text = text;
	self.AddPswNumberField.userInteractionEnabled = userInteractionEnabled;
	
	
	self.FamilyAlertView = alertV;
	
	[alertV addSubview:self.AddPswNumberField];
	
	[alertV addSubview: OpenLockSWitch];
	[alertV addSubview:recordSWitch];
	
	self.OpenLockSWitch = OpenLockSWitch;
	self.recordSWitch = recordSWitch;
	
	[UIView animateWithDuration:0.5 animations:^{
		
		self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
		
		self.FamilyAlertView.alpha=1;
		
	} completion:^(BOOL finished) {
		
		
		//  [customAlertView dissMiss];
		
		
	}];
	
}

#pragma mark - 删除授权弹窗UI设置
-(void)makeDelegateAlerViewWithTitle:(NSString *)title tag:(NSInteger)tag
{
	/** FixAlertView;
	 AddAlertView;
	 FixField;
	 AddPswNameField;
	 AddPswNumberField;
	 */
	
	CGFloat dilX = 25;
	CGFloat dilH = 230 + 55 - 50 *2;
	YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
	
	
	alertV.tag = tag;
	alertV.delegate = self;
	alertV.titleStr = title;
	
	
	CGFloat loginX = 200 *HRCommonScreenH;
	
	//判断是否是QQ用户如果是就不让显示输入密码
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
		//密码相关view
	UILabel * paswdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
	
	[alertV addSubview:paswdLabel];
	if (qqName && qqName.length > 0) {
		paswdLabel.hidden = YES;
	}else
	{
		
		paswdLabel.hidden = NO;
	}
	paswdLabel.text = @"用户密码";
	paswdLabel.textColor = [UIColor whiteColor];
	
	paswdLabel.textAlignment = NSTextAlignmentCenter;
	self.paswdLabel = paswdLabel;
	
	UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
	pwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	pwdField.secureTextEntry = YES;
	UIView *leftpPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	
	pwdField.leftViewMode = UITextFieldViewModeAlways;
	pwdField.leftView = leftpPwdView;
	
	
	pwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	pwdField.layer.borderWidth = 1;
	pwdField.layer.cornerRadius = 4;
	if (qqName && qqName.length > 0) {
		pwdField.hidden = YES;
	}else
	{
		
		pwdField.hidden = NO;
	}
	pwdField.placeholder = @"请输入用户登陆密码";
    
    [pwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
	pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	
	pwdField.textColor = [UIColor whiteColor];
	self.pwdAutherField = pwdField;
	
	[alertV addSubview:pwdField];
	
	
	
	self.FamilyAlertView = alertV;
	
	
	[UIView animateWithDuration:0.5 animations:^{
		
		self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
		
		self.FamilyAlertView.alpha=1;
		
	} completion:^(BOOL finished) {
		
		
		
		
	}];
	
}

#pragma mark - switch 事件
- (void)switchButtonClick:(UISwitch *)sender
{
	if (sender.tag == 10) {//远程开锁
		
		self.remoteOnLock = sender.isOn ? @"1" : @"0";
		DDLogWarn(@"sender.isOn--%@", sender.isOn ? @"1" : @"0");
	}else if (sender.tag == 11) {//记录查询
		
		self.recordQuery = sender.isOn ? @"1" : @"0";
	}
}

#pragma mark - 临时分享弹窗

-(void)makeTemporaryAlertView
{
    CGFloat dilX = 25;
    CGFloat dilH = 200 + 55 + 50;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
	alertV.tag = 11;
    alertV.delegate = self;
    alertV.titleStr = @"临时授权";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
	
	//qq用户
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];

	//用户名密码相关
	UILabel * paswdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
	
	[alertV addSubview:paswdLabel];
	paswdLabel.text = @"用户密码";
	paswdLabel.textColor = [UIColor whiteColor];
	
	paswdLabel.textAlignment = NSTextAlignmentCenter;
	if (qqName && qqName.length > 0) {
		paswdLabel.hidden = YES;
	}else
	{
		paswdLabel.hidden = NO;
	}
	
	UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
	pwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	pwdField.secureTextEntry = YES;
	UIView *leftpPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	
	pwdField.leftViewMode = UITextFieldViewModeAlways;
	pwdField.leftView = leftpPwdView;
	if (qqName && qqName.length > 0) {
		pwdField.hidden = YES;
	}else
	{
		pwdField.hidden = NO;
	}
	
	pwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	pwdField.layer.borderWidth = 1;
	pwdField.layer.cornerRadius = 4;
	pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
	pwdField.placeholder = @"请输入用户App登陆密码";
    [pwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
	
	pwdField.textColor = [UIColor whiteColor];
	self.pwdField = pwdField;
	
	[alertV addSubview:pwdField];
	
	
	//管理员密码相关
	UILabel * manageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
	
	[alertV addSubview:manageLabel];
	manageLabel.text = @"管理员密码";
	manageLabel.textColor = [UIColor whiteColor];
	
	manageLabel.textAlignment = NSTextAlignmentCenter;
	
	
	UITextField *manageField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 100, alertV.frame.size.width -  loginX*1.2, 32)];
	manageField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	manageField.secureTextEntry = YES;
	UIView *manageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	
	manageField.leftViewMode = UITextFieldViewModeAlways;
	manageField.leftView = manageView;
	
	
	manageField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	manageField.layer.borderWidth = 1;
	manageField.layer.cornerRadius = 4;
	manageField.clearButtonMode = UITextFieldViewModeWhileEditing;
	manageField.placeholder = @"请输入用户管理员密码";
    [manageField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
	
	manageField.textColor = [UIColor whiteColor];
	self.manageField = manageField;
	
	[alertV addSubview:manageField];
	
	// 手机号码相关
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = @"手机号码";
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
	
    UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 150, alertV.frame.size.width -  loginX*1.2, 32)];
    loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
	
	loginPwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    loginPwdField.leftViewMode = UITextFieldViewModeAlways;
    loginPwdField.leftView = leftView;
    
    
    loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginPwdField.layer.borderWidth = 1;
    loginPwdField.layer.cornerRadius = 4;
    
    loginPwdField.placeholder = @"授权对象的手机号码";
    [loginPwdField setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    loginPwdField.textColor = [UIColor whiteColor];
	
	
    AutherTimePickView *timeFiled = [[AutherTimePickView alloc] initWithFrame:CGRectMake(loginX, 200, alertV.frame.size.width -  loginX*1.2, 32)];
	
	timeFiled.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	
	
	timeFiled.delegate = self;
	timeFiled.leftViewMode = UITextFieldViewModeAlways;
	
	UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	timeFiled.leftView = leftView1;
	
	
	timeFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	timeFiled.layer.borderWidth = 1;
	timeFiled.layer.cornerRadius = 4;
	
	timeFiled.placeholder = @"授权时长";
    [timeFiled setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
	
	timeFiled.textColor = [UIColor whiteColor];
	
    UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, loginX, 32)];
    
    [alertV addSubview:PswLabel];
    PswLabel.text = @"时间";
    PswLabel.textColor = [UIColor whiteColor];
    
    PswLabel.textAlignment = NSTextAlignmentCenter;
    
    
    alertV.alpha=0;
    
    self.PhoneTfield = loginPwdField;
    
    self.TimeTfield = timeFiled;
    
    
    self.TemporaryAlertView = alertV;
    
    [alertV addSubview:self.PhoneTfield];
    
    [alertV addSubview:self.TimeTfield];
	
	
    [UIView animateWithDuration:0.5 animations:^{
        
        self.TemporaryAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.TemporaryAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
		
        
        
    }];

}

#pragma mark - YXCustomAlertViewDelegate 家人分享与临时授权的弹窗选中 -发送socket数据

- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (customAlertView.tag == 10) {//家人分享
		
		if (buttonIndex == 1) {
			
			//分享给家人的soket请求
			[self addFimalyAutherWithCustomAlertView:customAlertView];
		}
	}else if (customAlertView.tag == 11) {//临时授权
	
		if (buttonIndex == 1) {
			
			//临时授权
			[self addTemporaryAuther];
		}
		
	}else if (customAlertView.tag == 12) {//修改授权信息
		
		if (buttonIndex == 1) {
			
			//修改授权信息
			[self addModifyAuther];
		}
     }else if (customAlertView.tag == 13) {//删除授权信息
		
		 
		 if (buttonIndex == 1) {
			 
			//删除授权信息
			[self sendDataDeleteAuthor];
		 }
		 
	 }else if (customAlertView.tag == 14) {//查询门锁密码
		 
		 
		 if (buttonIndex == 1) {
			 
			 ////查询门锁密码
			 //判断label是否为门锁密码, 如果是, 用户点击确定按钮就要让弹框消失
			 if ([self.paswdLabel.text isEqualToString:@"门锁密码"]) {
				 
				 [UIView animateWithDuration:0.3 animations:^{
					 
					 CGRect AlertViewFrame = customAlertView.frame;
					 
					 AlertViewFrame.origin.x = -50;
					 
					 customAlertView.alpha = 0;
					 
					 customAlertView.frame = AlertViewFrame;
					 
				 } completion:^(BOOL finished) {
					 
					 [customAlertView dissMiss];
					 
				 }];

			 }else
			 {
				 
				 [self sendDataQueryLockPassword];
			 }
		 }
		 
	 }
	
	if (buttonIndex==0) {
		
    [UIView animateWithDuration:0.3 animations:^{
		
        CGRect AlertViewFrame = customAlertView.frame;
        
        AlertViewFrame.origin.x = -50;
        
        customAlertView.alpha = 0;
		
        customAlertView.frame = AlertViewFrame;
		
    } completion:^(BOOL finished) {
		
        [customAlertView dissMiss];
		
    }];
		
   }
}

#pragma mark - 临时授权
- (void)addTemporaryAuther
{
	
	//qq用户
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
	if (qqName && qqName.length > 0) {
		
		if (self.PhoneTfield.text.length < 0.5 || self.TimeTfield.text.length < 0.5 || self.manageField.text.length < 0.5) {
			
			[SVProgressTool hr_showErrorWithStatus:@"管理员密码或手机号码或时间不能为空!"];
			[self.FamilyAlertView.layer shake];
			return;
		}
		if (self.PhoneTfield.text.length != 11 ) {
			
			[SVProgressTool hr_showErrorWithStatus:@"该手机号码格式错误,请重新输入!"];
			[self.FamilyAlertView.layer shake];
			return;
		}
	}else
	{
		
		if (self.pwdField.text.length < 0.5 || self.PhoneTfield.text.length < 0.5 || self.TimeTfield.text.length < 0.5 || self.manageField.text.length < 0.5) {
			
			[SVProgressTool hr_showErrorWithStatus:@"用户或管理员密码或手机号码或时间不能为空!"];
			[self.FamilyAlertView.layer shake];
			return;
		}
		if (self.PhoneTfield.text.length != 11 ) {
			
			[SVProgressTool hr_showErrorWithStatus:@"该手机号码格式错误,请重新输入!"];
			[self.FamilyAlertView.layer shake];
			return;
		}
		
		NSString *paswd = [kNSUserDefaults objectForKey:kDefaultsPassWord];
		if (![self.pwdField.text isEqualToString:paswd]) {
			
			[SVProgressTool hr_showErrorWithStatus:@"密码错误, 请重新输入密码!"];
			[self.FamilyAlertView.layer shake];
			return;
		}
	}
	
	
	
	[SVProgressTool hr_showWithStatus:@"正在临时授权..."];
	
	
	NSArray *permit = @[@"1",@"none",@"none",@"none"];
	NSString *base64pswd = [NSString hr_stringWithBase64String:self.manageField.text];
	//这里不是传用户app密码
	NSArray *person = @[base64pswd, self.PhoneTfield.text];
	
	NSString *str = [NSString stringWithSocketAddTemporaryAutherLockWithlockUUID:self.currentUuid person:person permit:permit autherTime:[NSString stringWithFormat:@"%@:%@", self.hour,self.minute]];
	[self.appDelegate sendMessageWithString:str];
	
	DDLogWarn(@"发送临时授权%@", str);
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}

#pragma mark - 取消授权
- (void)sendDataDeleteAuthor
{
		NSString *paswd = [kNSUserDefaults objectForKey:kDefaultsPassWord];
		
		//qq用户
		NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
		if (qqName && qqName.length > 0) {
			
		}else
		{
			
			if (![self.pwdAutherField.text isEqualToString:paswd]) {
				
				[SVProgressTool hr_showErrorWithStatus:@"密码错误, 请重新输入密码!"];
				[self.FamilyAlertView.layer shake];
				return;
			}
		}
		
		[SVProgressTool hr_showWithStatus:@"正在删除授权..."];
		
		DeviceAutherModel *mode = self.deviceAutherArray[selectIndexPath];
		NSString *dstUUId = mode.uuid;
		NSString *did = mode.did;
//		NSString *dstUUId = self.listModel.uuid;
//		NSString *did = self.listModel.did;
		
		
		NSString *str = [NSString stringWithSocketDelegateFamilyLockWithDstUuid:dstUUId lockUUID:dstUUId did:did];
		DDLogInfo(@"取消授权%@", str);
		[self.appDelegate sendMessageWithString:str];
		
		// 启动定时器
		[_timer invalidate];
		isOvertime = NO;
		isShowOverMenu = NO;
		_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	
}
#pragma mark - 查看门锁密码
- (void)sendDataQueryLockPassword
{
	//qq用户
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
	if (qqName && qqName.length > 0) {
		
	}else
	{
		NSString *paswd = [kNSUserDefaults objectForKey:kDefaultsPassWord];
		if (![self.pwdAutherField.text isEqualToString:paswd]) {
			
			[SVProgressTool hr_showErrorWithStatus:@"密码错误, 请重新输入密码!"];
			[self.FamilyAlertView.layer shake];
			return;
		}
	}
	
	
		[SVProgressTool hr_showWithStatus:@"正在查看开锁密码..."];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[SVProgressTool hr_dismiss];
			self.paswdLabel.text = @"门锁密码";
			
			DeviceAutherModel *mode = self.deviceAutherArray[selectIndexPath];
			
			self.pwdAutherField.secureTextEntry = NO;
			self.pwdAutherField.userInteractionEnabled = NO;
			self.pwdAutherField.text = mode.person.firstObject;
		});
		
	
}

#pragma mark - 修改授权信息
- (void)addModifyAuther
{
	
	[self.appDelegate connectToHost];
	
	NSString *uerName = [kUserDefault objectForKey:kDefaultsUserName];
	
	//qq用户
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
	if (qqName && qqName.length > 0) {
		
	}else
	{
		if (self.pwdField.text.length < 0.5) {
			[SVProgressTool hr_showErrorWithStatus:@"密码不能为空,请输入密码!"];
			return;
		}else
		{
			if (![self.pwdField.text isEqualToString:uerName]) {
				
				[SVProgressTool hr_showErrorWithStatus:@"密码不正确,请输入密码!"];
			}
		}
	}
	
	
	//在这里发送添加家人账号的socket请求
	NSArray *permit = @[self.remoteOnLock,self.recordQuery,@"none",@"none"];
	DeviceAutherModel *model = self.deviceAutherArray[selectIndexPath];
	
	NSString *authorizedUser = self.AddPswNumberField.text;
	NSArray *person = @[@"none", authorizedUser];
	NSString *str = [NSString stringWithSocketModifyFamilyLockWithlockUUID:self.listModel.uuid did:model.did person:person permit:permit];
	
	[self.appDelegate sendMessageWithString:str];
	
	[SVProgressTool hr_showWithStatus:@"正在修改授权用户..."];
	// 设置超时
	isOvertime = NO;
	isShowOverMenu = NO;
	// 启动定时器
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	DDLogInfo(@"----------------发送修改授权家人数据%@", str);

}
#pragma mark - 分享给家人的soket请求
- (void)addFimalyAutherWithCustomAlertView:(YXCustomAlertView *)customAlertView
{
	
	NSString *psw = [kUserDefault objectForKey:kDefaultsPassWord];
	NSString *userName = [kUserDefault objectForKey:kDefaultsUserName];
	//qq用户
	NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
	
	if (qqName && qqName.length > 0) {
	}else
	{
		if (self.pwdField.text.length < 0.5) {
			[SVProgressTool hr_showErrorWithStatus:@"密码不能为空,请输入密码!"];
			[customAlertView.layer shake];
			return;
		}else
		{
			if (![self.pwdField.text isEqualToString:psw]) {
				
				[SVProgressTool hr_showErrorWithStatus:@"密码不正确,请输入密码!"];
				[customAlertView.layer shake];
				
				return;
			}
		}
	}
	
	if (self.AddPswNumberField.text.length < 0.5) {
		
		[SVProgressTool hr_showErrorWithStatus:@"用户名不能为空!"];
		[customAlertView.layer shake];
		return;
	}
	
	if ([self.AddPswNumberField.text isEqualToString:userName]) {
		
		[SVProgressTool hr_showErrorWithStatus:@"不能授权给自己!"];
		[customAlertView.layer shake];
		return;
	}
	
	[self.appDelegate connectToHost];
	
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	//该用户名已存在, 请重新输入用户名
	for (DeviceAutherModel *model in self.deviceAutherArray) {
		if ([model.person.lastObject isEqualToString:self.AddPswNumberField.text]) {
			[SVProgressTool hr_showErrorWithStatus:@"该用户已授权, 请重新输入用户名!"];
			[customAlertView.layer shake];
			return;
		}
	}
	
	//发送HTTP校验服务器有没有该用户
	NSString *url = [NSString stringWithFormat:@"%@%@",HRAPI_Checkuser_URL, self.AddPswNumberField.text];
	
	url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	[HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
		
		if (error) {
			
			[SVProgressTool hr_showErrorWithStatus:@"该用户名不存在,请重新输入!"];
			return ;
		}
		
		DDLogWarn(@"用户名校验HTTP请求%@", responseObject);
		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
		if (![responseObject isKindOfClass:[NSArray class]]) {
			
			DDLogDebug(@"responseObject不是NSArray");
			[SVProgressTool hr_showErrorWithStatus:@"该用户名不存在,请重新输入!"];
			return;
		}
		//去除服务器发过来的数据里没有值的情况
		if (((NSArray*)responseObject).count < 1 ) {
			DDLogDebug(@"responseObject count == 0");
			[SVProgressTool hr_showErrorWithStatus:@"该用户名不存在,请重新输入!"];
			return;
		}
		
		NSArray *arr = (NSArray *)responseObject;
		NSDictionary *dictarr = arr.firstObject;
		NSString *uid = [dictarr valueForKeyPath:@"uid"];
		if (uid.length < 1) {
			[SVProgressTool hr_showErrorWithStatus:@"该用户名不存在,请重新输入!"];
		}
		
		//在这里发送添加家人账号的socket请求
		NSArray *permit = @[self.remoteOnLock,self.recordQuery,@"none",@"none"];
		
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[@"user"] = user;
		dict[@"dev"] = self.currentUuid;
		
		NSString *authorizedUser = self.AddPswNumberField.text;
		NSArray *person = @[@"none", authorizedUser];
		NSString *user = [kUserDefault objectForKey:kDefaultsUserName];
		NSString *str = [NSString stringWithSocketAddFamilyLockWithDst:dict lockUUID:self.currentUuid admin:user person:person permit:permit];
		
		[self.appDelegate sendMessageWithString:str];
		
		[SVProgressTool hr_showWithStatus:@"正在添加授权用户..."];
		// 设置超时
		isOvertime = NO;
		isShowOverMenu = NO;
		// 启动定时器
		[_timer invalidate];
		_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
		DDLogInfo(@"----------------发送授权家人数据%@", str);
		
		
	}];

}
#pragma mark - 退出弹框动画
- (void)dismissCustomAlertView
{
	
	[UIView animateWithDuration:0.5 animations:^{
		
		
		CGRect AlertViewFrame = self.FamilyAlertView.frame;
		
		AlertViewFrame.origin.x = HRUIScreenW;
		
		
		self.FamilyAlertView.frame = AlertViewFrame;
		
		self.FamilyAlertView.alpha = 0;
		
	} completion:^(BOOL finished) {
		
		
		[self.FamilyAlertView dissMiss];
		
	}];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}

#pragma mark -增加授权

-(void)AddShouQuan: (UITapGestureRecognizer*)tap

{

    [FTPopOverMenu showForSender:self.navView.rightLabel withMenu:@[@"家人分享",@"临时授权"]
                       doneBlock:^(NSInteger selectedIndex) {
                           
                       /** 在这里增加弹窗*/
                           
                           //选中第一个家人分享
                           if (selectedIndex ==0) {
							   
//							   [self makeFamilyAlerViewWithTitle:@"家人分享" userInteractionEnabled:YES text:@"" tag:10 remoteSwich:@"" recordeSwich:@""];
							   
							   [self makeModifyFamilyAlerViewWithTitle:@"家人分享" userInteractionEnabled:YES text:@""  tag:10 remoteSwich:@"" recordeSwich:@""];

                           }
                           
                           
                           //选中第二个临时授权
                           
                           else{
                               
                               [self makeTemporaryAlertView ];
                               
                           }
                           
                
                           
                       } dismissBlock:^{
                           
                       }];

}



#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.deviceAutherArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //根据字典里的MENU_OPENED_KEY的值来显示或者隐藏下拉的cell
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:section];
    return [[sectionInfo objectForKey:MENU_OPENED_KEY] boolValue] ? [_cellArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}



#pragma mark - 每组的头部视图的设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    CustomerInfoSectionView *view = [dic objectForKey:MENU_HEADER_VIEW_KEY];
    if (!view)
    {
        view = [[CustomerInfoSectionView alloc]init];

        //在这里写入头部视图的信息
		DeviceAutherModel *listModel = self.deviceAutherArray[section];
		NSString *autherName = listModel.person.lastObject;
		NSString *time;
		if ([listModel.time isEqualToString:@"none"]) {
			time = @"永久";
		}else
		{
			time = listModel.time;
		}
        [view initWithImgName:@"邮箱" userNameLabel:autherName timeLabel:time section:section delegate:self];
        
        
        [dic setObject:view forKey:MENU_HEADER_VIEW_KEY];
		
        
    }
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewOfCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ViewOfCustomerTableViewCellIdentifier forIndexPath:indexPath];
	
	DeviceAutherModel *autherModel = self.deviceAutherArray[indexPath.section];
	
	
	
	if (indexPath.row ==0) {
		cell.nameLabel.text = @"远程开锁";
		
		if ([autherModel.permit.firstObject isEqualToString:@"1"]) {
			cell.warnImgView.image = [UIImage imageNamed:@"授权选择"] ;
		}else
		{
			
			cell.warnImgView.image = [UIImage imageNamed:@"未选择.png"] ;
		}
	}
	
	else{
		
		cell.nameLabel.text = @"操作查询";
		if ([autherModel.permit[1] isEqualToString:@"1"]) {
			cell.warnImgView.image = [UIImage imageNamed:@"授权选择"] ;
		}else
		{
			
			cell.warnImgView.image = [UIImage imageNamed:@"未选择.png"] ;
		}
	}

	
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    return cell;
}
#pragma mark - 选中cell 出现底部弹出框;
///记录点击的是哪一组
static NSInteger selectIndexPath = 0;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 这里应该要把cell所在的组数传下去才能相应的修改 */
	selectIndexPath = indexPath.section;
	DeviceAutherModel *mode = self.deviceAutherArray[indexPath.section];
	NSString *name = mode.person.lastObject;
	if ([mode.time isEqualToString:@"none"]) {
		//判断是否是家人授权, 如果是就不让查看门锁密码, 如果不是就查看门锁密码
		[SRActionSheet sr_showActionSheetViewWithTitle:name
									 cancelButtonTitle:@"取消"
								destructiveButtonTitle:@""
									 otherButtonTitles:@[@"取消该授权", @"修改授权信息"]
											  delegate:self];
	}else
	{
		
		//如果是临时授权, 就让查看门锁密码,并且不如修改授权信息
		[SRActionSheet sr_showActionSheetViewWithTitle:name
									 cancelButtonTitle:@"取消"
								destructiveButtonTitle:@""
									 otherButtonTitles:@[@"取消该授权", RecordeLockPassword]
											  delegate:self];
	}
}


#pragma mark -底部弹出sheet选中方法
-(void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index
{
    
    /** 0 是取消该授权
        1 是修改授权信息
       -1 是取消*/
	
	if (index == 0) {//取消该授权
		[self makeDelegateAlerViewWithTitle:@"取消授权" tag:13];
		
	}else if (index == 1) {//修改授权信息
		
		
		DeviceAutherModel *model = self.deviceAutherArray[selectIndexPath];
		if ([model.time isEqualToString:@"none"]) {
			
			NSString *name = self.deviceAutherArray[selectIndexPath].person.lastObject;
			NSString *remoteSwich = self.deviceAutherArray[selectIndexPath].permit.firstObject;
			NSString *recordeSwich = self.deviceAutherArray[selectIndexPath].permit[1];
			
			[self makeModifyFamilyAlerViewWithTitle:@"修改授权信息" userInteractionEnabled:NO text:name tag : 12 remoteSwich:remoteSwich recordeSwich:recordeSwich];
			
		}else
		{
			//查看门锁密码 弹框
			[self makeDelegateAlerViewWithTitle:RecordeLockPassword tag:14];
		}
		
		
		
	}
    NSLog(@"%ld", index);
    
}
#pragma mark Section header delegate

-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
{
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:sectionHeaderView.section];
    [sectionInfo setObject:[NSNumber numberWithBool:YES] forKey:MENU_OPENED_KEY];//将当前打开的section标记为1
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_cellArray count]; i++)
    {
		
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }//点击显示下拉的cell，将其加入到indexPathsToInsert数组中
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openedSection;
    if (previousOpenSectionIndex != NSNotFound)//有点开的section，这样打开新的section下拉菜单时要把先前的scetion关闭
    {
        NSMutableDictionary *previousOpenSectionInfo = [_dataArray objectAtIndex:previousOpenSectionIndex];
        CustomerInfoSectionView *previousOpenSection = [previousOpenSectionInfo objectForKey:MENU_HEADER_VIEW_KEY];
        [previousOpenSectionInfo setObject:[NSNumber numberWithBool:NO] forKey:MENU_OPENED_KEY];
        [previousOpenSection toggleOpenWithUserAction:NO];//箭头方向改变
        [UIView animateWithDuration:.3 animations:^{
            previousOpenSection.arrow.transform = CGAffineTransformIdentity;
        }];
        for (int i = 0; i < [_cellArray count]; i++)//将要关闭的cell写入indexPathsToDelete数组中
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;//系统提供的显示下拉cell菜单动画
    UITableViewRowAnimation deleteAnimation;//关闭下拉菜单动画
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.listTableView beginUpdates];
    [self.listTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];//将之前插入到indexPathsToInsert数组中的cell都插入显示出来
    [self.listTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];//将之前打开得下拉菜单关闭
    [self.listTableView endUpdates];
    self.openedSection = sectionOpened;
}

-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:sectionHeaderView.section];
    [sectionInfo setObject:[NSNumber numberWithBool:NO] forKey:MENU_OPENED_KEY];
    NSInteger countOfRowsToDelete = [self.listTableView numberOfRowsInSection:sectionClosed];
    if (countOfRowsToDelete > 0)
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.listTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openedSection = NSNotFound;
}
#pragma mark - AutherTimePickViewDelegate
- (void)autherTimePickView:(AutherTimePickView *)autherTimePickView hour:(NSString *)hour minute:(NSString *)minute
{
	self.hour = hour;
	self.minute = minute;
	self.TimeTfield.text = [NSString stringWithFormat:@"%@ : %@", hour,minute];
}
//解码
//const char base[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
//char *base64_encode(const char* data, int data_len,char* out)
//{
//	//int data_len = strlen(data);
//	int prepare = 0;
//	int ret_len;
//	int temp = 0;
//	char *ret = NULL;
//	char *f = NULL;
//	int tmp = 0;
//	char changed[4];
//	int i = 0;
//	ret_len = data_len / 3;
//	temp = data_len % 3;
//	if (temp > 0)
//	{
//		ret_len += 1;
//	}
//	ret_len = ret_len*4 + 1;
//	ret = (char *)malloc(ret_len);
//	
//	if ( ret == NULL)
//	{
//		printf("No enough memory.\n");
//		exit(0);
//	}
//	memset(ret, 0, ret_len);
//	f = ret;
//	while (tmp < data_len)
//	{
//		temp = 0;
//		prepare = 0;
//		memset(changed, '\0', 4);
//		while (temp < 3)
//		{
//			if (tmp >= data_len)
//			{
//				break;
//			}
//			prepare = ((prepare << 8) | (data[tmp] & 0xFF));
//			tmp++;
//			temp++;
//		}
//		prepare = (prepare<<((3-temp)*8));
//		for (i = 0; i < 4 ;i++ )
//		{
//			if (temp < i)
//			{
//				
//				printf("test...\n")	;
//				changed[i] = 0x40;
//			}
//			else
//			{
//				changed[i] = (prepare>>((3-i)*6)) & 0x3F;
//			}
//			*f = base[changed[i]];
//			f++;
//		}
//	}
//	*f = '\0';
//	strcpy(out,ret);
//	free(ret);
//	return ret;
//	
//}
//int hrdecode(char *result,char *src)
//{
//	char ret[250];
//	int ret_len= base64_decode(src,ret,strlen(src));
//	int i=0;
//	for (i=0; i < ret_len; i++) {
//		char temp = (char)ret[i]^enlic2[i];
//		result[i]=temp;
//		
//	}
//	result[i] = '\0';
//	int len= strlen(result);
//	return len;
//}

@end
