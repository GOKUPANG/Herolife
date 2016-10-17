//
//  DeviceListController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

#define HRMyScreenH (HRUIScreenH / 667.0)
#define HRMyScreenW (HRUIScreenW / 375.0 )

#define HRAPI_UpdateDoorMess_URL @"http://183.63.118.58:9885/hrctest/?q=huaruiapi/node/%@"


#import "DeviceListController.h"
// Components
#import "YRCoverFlowLayout.h"

// Model
#import "PhotoModel.h"

// Cells
#import "CustomCollectionViewCollectionViewCell.h"
#import "DeviceListCell.h"
#import "OpenLockController.h"
#import "DoorLockRecordConroller.h"
#import "APPPSWController.h"
#import "ShouQuanManagerController.h"
#import "DeviceListModel.h"

#import "DeviceListTcpModel.h"
#import "HRPushMode.h"
#import "DeviceAutherModel.h"
#import "SRActionSheet.h"
#import "YXCustomAlertView.h"
#import "HRRefreshHeader.h"
#import "MJRefresh.h"
#import "DoorLockModel.h"
#import "TipsLabel.h"
#import "GTMBase64.h"

//加入系统自带密码库

//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>




#define HRNavigationBarFrame self.navigationController.navigationBar.bounds
@interface DeviceListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YXCustomAlertViewDelegate>

{
   // UIView *bg;
    
    UIView *bg ;
    
    UIVisualEffectView * bgView;
    UITextView *txt;
    UITextField * newDvNameField;
    
    UIButton * close;
    
    UIButton * comfirBtn ;
    
    UILabel * oldDeviceNameLB;
    
    UILabel * detailNameLB;
    
    UILabel *newDvName;

    
    
    CGFloat tfLength;
    NSConditionLock *lock;
}
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** <#name#> */
@property(nonatomic, weak) UICollectionView *collectionView;
/** 临时的站位view */
@property(nonatomic, weak) UIView *eptView;
/** 下拉列表按钮 */
@property(nonatomic, weak) UIButton *listButton;
/** <#name#> */
@property(nonatomic, weak) UITableView *tableView;
/** <#name#> */
@property(nonatomic, weak) UIImageView *listImageView;
/** <#name#> */
@property(nonatomic, weak) UILabel *listLabel;
/** <#name#> */
@property(nonatomic, weak) UIImageView *rightImageView;
/** <#name#> */
@property(nonatomic, weak) UIView *alphaView;
/** <#name#> */
@property(nonatomic, strong) NSMutableArray *photoModelArray;
/** UICollectionView布局 */
@property(nonatomic, weak) YRCoverFlowLayout *layout;

/** 背景图片*/
@property(nonatomic,strong)UIImageView *backImgView;
/** appDelegte */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** 存放设备列表HTTP模型数组 */
@property(nonatomic, strong) NSMutableArray *homeArray;
/**  */
@property(nonatomic, strong) NSTimer *timer;
/** <#name#> */
@property(nonatomic, strong) DeviceListModel *currentStateModel;

/** 我授权给别人的授权表模型数组 */
@property(nonatomic, strong) NSMutableArray *autherArray;
/** 我授权给别人的设备模型数组 */
@property(nonatomic, strong) NSMutableArray *autherDeviceArray;
/** 别人授权给我的授权表模型数组 */
@property(nonatomic, strong) NSMutableArray *autherPersonArray;
/** 别人授权给我的设备模型数组 */
@property(nonatomic, strong) NSMutableArray *personDeviceArray;
/** 最后一次操作的时间 */
@property(nonatomic, copy) NSString *lastOptionTime;
/** 目标设备不在线 提示框 */
@property(nonatomic, weak) UILabel *onLineLabel;




@property(nonatomic,strong) YXCustomAlertView *  FamilyAlertView;



/** 删除设备的登录密码输入框*/

@property(nonatomic,strong)UITextField * pswTF;
/** 保存 点击时的设备信息数据 */
@property(nonatomic, strong) DeviceListModel *showLockModel;
/** 下拉刷新的UITableView */
@property(nonatomic, weak) UITableView *eptTable;
/** 保存门锁记录查询 page = 0 的数组 */
@property(nonatomic, strong) NSMutableArray *queryArray;


@property(nonatomic, strong) TipsLabel *tipsLabel;

@end

@implementation DeviceListController
//定时60s查询设备状态
NSInteger const timerDuration = 60.0;

#pragma mark - label 懒加载
- (UILabel *)onLineLabel
{
	if (!_onLineLabel) {
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenW *0.28, UIScreenH * 0.8, UIScreenW - UIScreenW *0.56, 32)];
		label.text = @"";
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:17];
		label.textColor = [UIColor whiteColor];
		label.layer.cornerRadius = 5;
		label.layer.masksToBounds = YES;
		
		label.backgroundColor = [UIColor blackColor];
		_onLineLabel = label;
		
		
		[[UIApplication sharedApplication].keyWindow addSubview:label];
	}
	return _onLineLabel;
}
- (TipsLabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(UIScreenW *0.28, UIScreenH * 0.8, UIScreenW - UIScreenW *0.56, 32)];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_tipsLabel];
    }
    return _tipsLabel;
}
- (NSMutableArray *)queryArray
{
	if (!_queryArray) {
		_queryArray = [NSMutableArray array];
	}
	return _queryArray;
}
- (NSMutableArray *)homeArray
{
	if (!_homeArray) {
		_homeArray = [NSMutableArray array];
	}
	return _homeArray;
}

- (NSMutableArray *)autherArray
{
	if (!_autherArray) {
		_autherArray = [NSMutableArray array];
	}
	return _autherArray;
}
- (NSMutableArray *)autherDeviceArray
{
	if (!_autherDeviceArray) {
		_autherDeviceArray = [NSMutableArray array];
	}
	return _autherDeviceArray;
}
- (NSMutableArray *)autherPersonArray
{
	if (!_autherPersonArray) {
		_autherPersonArray = [NSMutableArray array];
	}
	return _autherPersonArray;
}
- (NSMutableArray *)personDeviceArray
{
	if (!_personDeviceArray) {
		_personDeviceArray = [NSMutableArray array];
	}
	return _personDeviceArray;
}
-(void)viewWillAppear:(BOOL)animated
{
	for (UINavigationController *nav in self.tabBarController.childViewControllers) {
		UIViewController *VC = nav.childViewControllers.firstObject;
		NSLog(@"viewVC--%@", NSStringFromClass([VC class]));
	}
    NSInteger  PicNum =  [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
		
        self.backImgView.image = [UIImage imageNamed:@"1.jpg"];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImgView.image =[UIImage imageWithContentsOfFile:path];
    }else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImgView.image =[UIImage imageNamed:imgName];
    }
	
}

- (NSMutableArray *)photoModelArray
{
	if (!_photoModelArray) {
		_photoModelArray = [NSMutableArray array];
	}
	return _photoModelArray;
}
static NSString *cellID = @"cellID";
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	//初始化
	[self setupViews];
	
	//注册
	[self.tableView registerClass:[DeviceListCell class] forCellReuseIdentifier:cellID];
	[self.collectionView registerClass:[CustomCollectionViewCollectionViewCell class] forCellWithReuseIdentifier:kCustomCellIdentifier];
	
	//建立连接 -- 用户登录认证
	[self postTokenWithTCPSocket];
	
	//下拉刷新
	[self addRefresh];
	//通知
	[self addObserverNotification];
    
    [self addLongGesture];
	[self addSwipeGestureRecognizer];
	
}

#pragma mark - 通知
- (void)addObserverNotification
{
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	
	[kNotification addObserver:self selector:@selector(receiveDeviceState:) name:kNotificationDeviceState object:nil];
	//监听删除授权
	[kNotification addObserver:self selector:@selector(receiveDeleteAutherDevice:) name:kNotificationReceiveDeleteAutherInformation object:nil];
	
	//监听通知 刷新数据
	[kNotification addObserver:self selector:@selector(receivePostRefresh:) name:kNotificationPostRefresh object:nil];
	
	
}

- (void)receivePostRefresh:(NSNotification *)note
{
	//重新获取数据
	[self getRefreshHttpRequset];
}

static BOOL isOvertime = NO;
- (void)receiveDeleteAutherDevice:(NSNotification *)note
{
	[SVProgressHUD showSuccessWithStatus:@"删除成功!"];
	NSDictionary *dict = note.userInfo;
	NSString *uuid = dict[@"msg"][@"uuid"];
	NSMutableArray *mu = [NSMutableArray array];
	for (DeviceListModel *model in self.homeArray) {
		if ([model.uuid isEqualToString:uuid]) {//如果要删除的UUID 和设备列表数组里的UUID是一样的就删除
			continue;
		}
		
		[mu addObject:model];
	}
	//清空当前数据
	self.currentStateModel.uuid = @"";
	self.homeArray = mu;
	//重新获取数据
	[self getHttpRequset];
	[self.collectionView reloadData];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_dismiss];
    
//    [self showOnLineLabelWithTitle:@"目标设备不在线!"];
    [self.tipsLabel showText:@"目标设备不在线!" duration:2];
	self.lastOptionTime = @"";
		NSString *uuid = self.currentStateModel.uuid;
		
		NSMutableArray *homeMu = [NSMutableArray array];
		for (DeviceListModel *model  in self.homeArray) {
			if ([model.uuid isEqualToString:uuid]) {
				
				model.state = @"0";
				model.online = @"on";
				model.level = @"";
				
			}
			// 重新给锁添加 数组图片
			if ([model.types isEqualToString:@"hrsc"]) {
				
				
				[homeMu addObject:model];
			}
			self.homeArray = homeMu;
		}
	
    
    //重新设置列表按钮的图片和文字
    if (self.homeArray.count > 0) {
        self.listLabel.text = self.currentStateModel.title;
        self.listImageView.image = [UIImage imageNamed:@"空心离线"];
    }else
    {
        self.listLabel.text = @"";
        self.listImageView.image = [UIImage imageNamed:@""];
    }
		[self.tableView reloadData];
		[self.collectionView reloadData];
	
}
#pragma mark - 目标不在线弹框Label
- (void)showOnLineLabelWithTitle:(NSString *)title
{
    self.onLineLabel.text = title;
    self.onLineLabel.hidden = YES;
    [UIView animateWithDuration:0.01 animations:^{
        self.onLineLabel.alpha = 0.0;
//        [self.onLineLabel removeFromSuperview];
    } completion:^(BOOL finished) {
        
        self.onLineLabel.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.onLineLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.onLineLabel.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                self.onLineLabel.hidden = YES;
                [self.onLineLabel removeFromSuperview];
            }];
        }];
    }];
    
}
// 921修改
- (void)receiveDeviceState:(NSNotification *)note
{
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	HRPushMode *mode = app.pushMode;
	DeviceListTcpModel *tcpModel = app.deviceListModel;
	if (mode.type.length > 0) {
		
		
		NSString *uuid = mode.src[@"dev"];
		
		NSMutableArray *homeMu = [NSMutableArray array];
		for (DeviceListModel *model  in self.homeArray) {
			if ([model.uuid isEqualToString:uuid]) {
				
				model.state = tcpModel.state;
				model.online = tcpModel.online;
				model.level = tcpModel.level;
				
			}
			// 重新给锁添加 数组图片
			if ([model.types isEqualToString:@"hrsc"]) {
				
			
			[homeMu addObject:model];
		}
		self.homeArray = homeMu;
		}
		
		if ([uuid isEqualToString:self.currentStateModel.uuid]) {
			
			self.listLabel.text = self.currentStateModel.title;
			
			//修改921
			//按钮图片
			if ([tcpModel.state isEqualToString:@"1"]) {
				self.listImageView.image = [UIImage imageNamed:@"空心在线"];
			}else
			{
				
				self.listImageView.image = [UIImage imageNamed:@"空心离线"];
			}
		}
		
		[self.tableView reloadData];
		[self.collectionView reloadData];
	}
	
}
#pragma mark - 内部方法
//初始化
- (void)setupViews
{
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    
    self.backImgView = backgroundImage;
    
	[self.view addSubview:self.backImgView];
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"设备列表";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;
	
	//cover flow
	YRCoverFlowLayout *layout = [[YRCoverFlowLayout alloc] init];
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
	collectionView.backgroundColor = [UIColor clearColor];
	collectionView.showsHorizontalScrollIndicator = NO;
	collectionView.dataSource = self;
	collectionView.delegate = self;
	
	layout.maxCoverDegree = -40.8;
	layout.coverDensity = 0.02;
	layout.minCoverOpacity = 1.0;
	layout.minCoverScale = 0.89;
	
	[self.view addSubview:collectionView];
	self.layout = layout;
	self.collectionView = collectionView;
	
	
	//下拉列表按钮
	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:listButton];
	self.listButton = listButton;
	
	UIImageView *listImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
	CGRect rect = listImageView.frame;
	rect.origin = CGPointMake(HRUIScreenW *10, 0);
	listImageView.frame = rect;
	[listButton addSubview:listImageView];
	self.listImageView = listImageView;
	
	UILabel *listLabel = [[UILabel alloc] init];
	listLabel.text = @"  ";
	listLabel.textAlignment = NSTextAlignmentCenter;
	listLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	listLabel.textColor = [UIColor whiteColor];
	if (HRUIScreenH < 667) {
		listLabel.font = [UIFont systemFontOfSize:12];
	}else
	{
		listLabel.font = [UIFont systemFontOfSize:17];
		
	}
	[listButton addSubview:listLabel];
	self.listLabel = listLabel;
	
	UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉符号"]];
	rightImageView.frame = rect;
	[listButton addSubview:rightImageView];
	rightImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
	self.rightImageView = rightImageView;
	//半透明框
	UIView *alphaView = [[UIView alloc] init];
	alphaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"半透明框"]];
	[self.view addSubview:alphaView];
	self.alphaView = alphaView;
	
	//发光框
	UIImageView *helImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发光边框"]];
	//表格
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
	tableView.delegate        = self;
	tableView.dataSource      = self;
	tableView.bounces = NO;
	tableView.scrollEnabled = NO;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.backgroundView = helImageView;
	tableView.rowHeight = HRCommonScreenH * 111.5;
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:tableView];
	
	self.tableView = tableView;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[_collectionView reloadData];
	});
	
	[self IsTabBarHidden:NO];
}
- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	
	[_layout invalidateLayout];
}

#pragma mark - 隐藏底部条
- (void)IsTabBarHidden:(BOOL)hidden
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = hidden;
		}
	}
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	//collectionView相关
	
	_layout.itemSize = (CGSize){
		HRCommonScreenW *290,//原来是272
		HRCommonScreenW *290};
	
	[_collectionView setNeedsLayout];
	[_collectionView layoutIfNeeded];
	[_collectionView reloadData];
	
	//导航条
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	//collectionView
	[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(HRCommonScreenW * 30);
		make.right.equalTo(self.view).offset(- HRCommonScreenW * 30);
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH *62);
		make.height.mas_equalTo(HRCommonScreenW * 290);
	}];
	
	//列表按钮
	[self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.collectionView.mas_bottom).offset(HRCommonScreenH *32);
		make.centerX.equalTo(self.view);
//		make.width.mas_equalTo(HRCommonScreenW * 271);
		make.width.mas_equalTo(HRCommonScreenW * 350);
		make.height.mas_equalTo(30);
	}];
	
	
	//列表按钮里左边的图片
	[self.listImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.listButton).offset(10);
		make.bottom.equalTo(self.listButton).offset(-5);
		make.top.equalTo(self.listButton).offset(5);
		make.width.mas_equalTo(20);
	}];
	
	//列表按钮里的文本
	[self.listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.listButton);
        

		make.left.equalTo(self.listImageView.mas_right).offset(4);
		
		//make.width.mas_equalTo(HRCommonScreenW * 226);
	}];
    
       
	//列表按钮里的右边图片
	[self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.listButton).offset(- 10);
		make.centerY.equalTo(self.listButton);
		make.height.mas_equalTo(8);
		make.left.equalTo(self.listLabel.mas_right).offset(8);
	}];
	
	[self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.listButton.mas_bottom).offset(HRCommonScreenH *140);
		make.left.equalTo(self.view).offset(HRCommonScreenW * 10);
		make.right.equalTo(self.view).offset(- HRCommonScreenW * 10);
		make.height.mas_equalTo(HRCommonScreenH * 446);
	}];
	self.listButton.layer.cornerRadius = self.listButton.hr_height *0.5;
	self.listButton.layer.masksToBounds = YES;
	
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.top.equalTo(self.alphaView);
	}];
	
}

#pragma mark - UI事件
- (void)listButtonClick:(UIButton *)btn
{
	btn.selected = !btn.selected;
	if (btn.selected) {
		
		self.rightImageView.layer.transform = CATransform3DMakeRotation(M_PI* 2, 0, 0, 1);
	}else
	{
		self.rightImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
		
	}
	//修改921
	NSMutableArray *titleArray = [NSMutableArray array];
	NSMutableArray *iconArray = [NSMutableArray array];
	
	for (DeviceListModel *home in self.homeArray) {
		NSString *title = home.title;
		[titleArray addObject:title];
		if ([home.state isEqualToString:@"1"]) {
			
			[iconArray addObject:@"空心在线"];
		}else
		{
			[iconArray addObject:@"空心离线"];
			
		}
		
	}
	
	[FTPopOverMenu showForSender:btn
						withMenu:titleArray
				  imageNameArray:iconArray
					   doneBlock:^(NSInteger selectedIndex) {
						   btn.selected = NO;
						   self.rightImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
						   if (self.homeArray.count == 1) {//做判断点击某一行时让UICOllection旋转到对应的位置
							   
							   DeviceListModel *home = self.homeArray.firstObject;
							   self.currentStateModel = home;
							   [self setUpListButtonContent];
							   [self.collectionView setContentOffset:CGPointMake(1 * HRCommonScreenW *345 *2, 0) animated:YES];
						   }else if (self.homeArray.count == 2) {//做判断点击某一行时让UICOllection旋转到对应的位置
							   if (selectedIndex == 0) {
								   
								   DeviceListModel *home = self.homeArray.firstObject;
								   self.currentStateModel = home;
								   [self setUpListButtonContent];
								   [self.collectionView setContentOffset:CGPointMake(1 * HRCommonScreenW *345 *2, 0) animated:YES];
							   }else if (selectedIndex == 1) {
								   
								   DeviceListModel *home = self.homeArray.lastObject;
								   self.currentStateModel = home;
								   [self setUpListButtonContent];
								   [self.collectionView setContentOffset:CGPointMake(2 * HRCommonScreenW *345 *2, 0) animated:YES];
							   }
						   }else
						   {
							   //显示选择的title
							   DeviceListModel *home = self.homeArray[selectedIndex];
   
							   self.currentStateModel = home;
							   [self setUpListButtonContent];
							   
							   [self.collectionView setContentOffset:CGPointMake(selectedIndex * HRCommonScreenW *345 *2, 0) animated:YES];
						   }
						   
						   [self addTimer];
						   
						   [self.tableView reloadData];
						   NSLog(@"done block. do something. selectedIndex : %ld", (long)selectedIndex);
						   
					   } dismissBlock:^{
						   btn.selected = NO;
						   self.rightImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
						   NSLog(@"user canceled. do nothing.");
						   
					   }];
	
	
}
#pragma mark - tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil) {
		cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor clearColor];
	
	switch (indexPath.row) {
  case 0:
		{
			if (self.currentStateModel.state.length < 0.5) {
				cell.leftImage.image = [UIImage imageNamed:@"开锁首页"];
			}else
			{
				NSInteger states = [self.currentStateModel.state integerValue];
				switch (states) {
					case 5:
					{
						
						cell.leftImage.image = [UIImage imageNamed:@"禁止开锁"];
					}
						break;
						
					default:
					{
						
						cell.leftImage.image = [UIImage imageNamed:@"开锁首页"];
					}
						break;
				}
				
			}
			cell.leftLabel.text = @"手机开锁";
			if (self.currentStateModel.level.length < 0.5) {
//				cell.minLabel.text =  @"";
//				cell.rightLabel.text = self.lastOptionTime;
                
                cell.rightLabel.text = @"";
			}else
			{
//				if (self.queryArray.count > 0) {
//					for (DoorLockModel *model in self.queryArray) {
//						if ([model.title containsString:@"开锁操作"]) {
//							
//							NSString *title = model.title;
//							NSRange range = [title rangeOfString:@"|"];
//							
//							NSString *time = [title substringToIndex:range.location];
//							
//							cell.rightLabel.text = time;
//							break;
//						}
//					}
//				}
//				cell.minLabel.text = [NSString stringWithFormat:@"剩余电量%@", self.currentStateModel.level];
                
                cell.rightLabel.text = [NSString stringWithFormat:@"剩余电量%@", self.currentStateModel.level];;
			}
		}
			break;
  case 1:
		{
			
			cell.leftImage.image = [UIImage imageNamed:@"记录"];
			cell.leftLabel.text = @"记录查询";
//			cell.rightLabel.text = self.lastOptionTime;
//			if (self.currentStateModel.level.length < 0.5) {
//				cell.minLabel.text =  @"";
//				cell.rightLabel.text = self.lastOptionTime;
//			}else
//			{
//				
//				if (self.queryArray.count > 0) {
//					DoorLockModel *model = self.queryArray.firstObject;
//					
//					NSString *title = model.title;
//					NSRange range = [title rangeOfString:@"|"];
//					
//					NSString *time = [title substringToIndex:range.location];
//					
//					cell.rightLabel.text = time;
//				
//			}
//		}
		}
			break;
  case 2:
		{
			
			cell.leftImage.image = [UIImage imageNamed:@"密码首页"];
			cell.leftLabel.text = @"密码管理";
		}
			break;
  case 3:
		{
			
			cell.leftImage.image = [UIImage imageNamed:@"授权"];
			cell.leftLabel.text = @"授权管理";
		}
			break;
			
  default:
			break;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	DDLogInfo(@"%ld", (long)indexPath.row);
	
	switch (indexPath.row) {
		case  0:
			
		{
			OpenLockController * OLC = [OpenLockController new];
			
			// 直接
			for (DeviceAutherModel *auther in self.autherPersonArray) {
    
				if ([auther.uuid isEqualToString: self.currentStateModel.uuid]) {
					NSArray *arr = auther.permit;
					if ([arr[0] isEqualToString:@"1"]) {
						
						OLC.listModel = self.currentStateModel;
						OLC.AuthorUserName = auther.admin;
						[self.navigationController pushViewController:OLC animated:YES];
						
					}else
					{
						[SVProgressTool hr_showErrorWithStatus:@"该锁当前用户无权限控制门锁!"];
					}
					return ;
				}
			}
            if (!self.currentStateModel) {
                
//                [self showOnLineLabelWithTitle:@"未添加门锁"];
                [self.tipsLabel showText:@"未添加门锁" duration:2.0];
                return;
            }
			OLC.listModel = self.currentStateModel;
			[self.navigationController pushViewController:OLC animated:YES];
			
		}
			
			break;
			
		case 1:
		{
			
			DoorLockRecordConroller *  DLC = [DoorLockRecordConroller new];
			
			// 直接
			for (DeviceAutherModel *auther in self.autherPersonArray) {
    
				if ([auther.uuid isEqualToString: self.currentStateModel.uuid]) {
					NSArray *arr = auther.permit;
					if ([arr[1] isEqualToString:@"1"]) {
						
						DLC.listModel = self.currentStateModel;
                        DLC.AuthorUserName = auther.admin ;
                        
						[self.navigationController pushViewController:DLC animated:YES];
						
					}else
					{
						[SVProgressTool hr_showErrorWithStatus:@"该锁当前用户无权限记录查询!"];
					}
					return ;
				}
			}
			
            if (!self.currentStateModel) {
                
                [self.tipsLabel showText:@"未添加门锁" duration:2.0];
                return;
            }
			DLC.listModel = self.currentStateModel;
			[self.navigationController pushViewController:DLC animated:YES];
			
		}
			break;
			
			
		case 2:
		{
			
			APPPSWController * PSWC = [APPPSWController new];
			
			// 直接
			for (DeviceAutherModel *auther in self.autherPersonArray) {
    
				if ([auther.uuid isEqualToString: self.currentStateModel.uuid]) {
					NSArray *arr = auther.permit;
					if ([arr[2] isEqualToString:@"1"]) {
						
						PSWC.listModel = self.currentStateModel;
						[self.navigationController pushViewController:PSWC animated:YES];
						
					}else
					{
						[SVProgressTool hr_showErrorWithStatus:@"该锁当前用户无权限密码管理!"];
					}
					return ;
				}
			}
			
            if (!self.currentStateModel) {
                
                [self.tipsLabel showText:@"未添加门锁" duration:2.0];
                return;
            }
			PSWC.listModel = self.currentStateModel;
			
			
			
			[self.navigationController pushViewController:PSWC animated:YES];
			
		}
			
			break;
			
		case 3:
		{
			ShouQuanManagerController *SQC = [ShouQuanManagerController new];
			// 别人授权给我的数据和当前点击的数据里的UUID进行比较,看是否有有权限跳转
			for (DeviceAutherModel *auther in self.autherPersonArray) {
    
				if ([auther.uuid isEqualToString: self.currentStateModel.uuid]) {
					NSArray *arr = auther.permit;
					if ([arr[3] isEqualToString:@"1"]) {
						SQC.listModel = self.currentStateModel;
						[self.navigationController pushViewController:SQC animated:YES];
						
					}else
					{
						[SVProgressTool hr_showErrorWithStatus:@"该锁当前用户无权限授权管理!"];
					}
					return ;
				}
			}
			
            if (!self.currentStateModel) {
                
                [self.tipsLabel showText:@"未添加门锁" duration:2.0];
                return;
            }
			SQC.listModel = self.currentStateModel;
			
			[self.navigationController pushViewController:SQC animated:YES];
			
			
		}
			
			break;
			
		default:
			break;
	}
	
	
}

#pragma mark - UICollectionViewDelegate/Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.photoModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CustomCollectionViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCellIdentifier
																							 forIndexPath:indexPath];
		cell.photoModel = self.photoModelArray[indexPath.row];
	
	return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	DDLogInfo(@"%f", scrollView.contentOffset.x);
	
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self setupContentOffsetWithScrollView:scrollView];
	
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self setupContentOffsetWithScrollView:scrollView];
}
- (void)setupContentOffsetWithScrollView:(UIScrollView *)scrollView
{
	
	CGFloat totalconsizeW = HRCommonScreenW *345 *2 ;
	if (scrollView.contentOffset.x < 0.0) {
		return;
	}
	
	int index = scrollView.contentOffset.x / totalconsizeW;
	int yu = (int)scrollView.contentOffset.x % (int)totalconsizeW;
	
	if (yu >= HRCommonScreenW *345 *2 *0.5) {
		index += 1;
	}
	DDLogInfo(@"index%d", index);
	DDLogInfo(@"yu%d", yu);
//	NSArray *arr = @[@"22", @"22"];
	if (self.homeArray.count == 1) {
		
		DeviceListModel *home = self.homeArray.firstObject;
		self.currentStateModel = home;
		[self setUpListButtonContent];
		[self.collectionView setContentOffset:CGPointMake(1 * HRCommonScreenW *345 *2, 0) animated:YES];
	}else if (self.homeArray.count == 2) {
		
		if (index == 0) {
			
			DeviceListModel *home = self.homeArray.firstObject;
			self.currentStateModel = home;
			[self setUpListButtonContent];
			[self.collectionView setContentOffset:CGPointMake((1) * HRCommonScreenW *345 *2, 0) animated:YES];
		}else if (index == 1) {
			
			DeviceListModel *home = self.homeArray.firstObject;
			self.currentStateModel = home;
			[self setUpListButtonContent];
			[self.collectionView setContentOffset:CGPointMake((1) * HRCommonScreenW *345 *2, 0) animated:YES];
		}else if (index == 2) {
			
			DeviceListModel *home = self.homeArray.lastObject;
			self.currentStateModel = home;
			[self setUpListButtonContent];
			[self.collectionView setContentOffset:CGPointMake((2) * HRCommonScreenW *345 *2, 0) animated:YES];
		}
		
	}else
	{
		//显示选择的title
		DeviceListModel *home = self.homeArray[index];
		
		self.currentStateModel = home;
		[self setUpListButtonContent];
		[self.collectionView setContentOffset:CGPointMake(index * HRCommonScreenW *345 *2, 0) animated:YES];
		
	}
	
	[self.tableView reloadData];
	[self addTimer];
	
}

- (void)setUpListButtonContent
{
    
    //重新设置列表按钮的图片和文字
    if (self.homeArray.count > 0) {
        
        self.listLabel.text = self.currentStateModel.title;
        if ([self.currentStateModel.state isEqualToString:@"1"]) {
        self.listImageView.image = [UIImage imageNamed:@"空心在线"];
    }else
    {
        
        self.listImageView.image = [UIImage imageNamed:@"空心离线"];
    }
        
    }else
    {
        self.listLabel.text = @"";
        self.listImageView.image = [UIImage imageNamed:@""];
    }
	
}
#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
	NSString *passWold = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsPassWord];
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	DDLogWarn(@"%@", userName);
	NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
	bodyDict[@"user"] = userName;
	bodyDict[@"pass"] = passWold;
	
	// 设备令牌可能还没有,需要延时 一下
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
        //登入认证  组登入认证
        NSString *UUID = [kUserDefault objectForKey:kUserDefaultDeviceUUID];
        NSString *token = [NSString stringWithFormat:@"ios+@+%@", UUID];
        NSString *str = [NSString stringWithPostTCPJsonVersion:@"0.0.1" status:@"200" token:token msgType:@"login" msgExplain:@"login" fromUserName:userName destUserName:@"huaruicloud" destDevName:@"huaruiPushServer" msgBodyStringDict:bodyDict];
        DDLogWarn(@"onSocket登入认证%@", str);
		[self.appDelegate sendMessageWithString:str];
		
		
	});
	
}
#pragma mark - 下拉刷新
- (void)addRefresh
{
	UITableView *eptTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, HRUIScreenW, 50) style:UITableViewStylePlain];
	eptTable.backgroundColor = [UIColor clearColor];
	eptTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:eptTable];
	
	eptTable.mj_header = [HRRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHttpRequset)];
	[eptTable.mj_header beginRefreshing];
	self.eptTable = eptTable;
}

- (void)addSwipeGestureRecognizer
{
	UISwipeGestureRecognizer *recognizer;
	
	recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeDown:)];
	
	[recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
	[self.view addGestureRecognizer:recognizer];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)swipe
{
	[self.eptTable.mj_header beginRefreshing];
}

- (void)getRefreshHttpRequset
{
    /// 从偏好设置里加载数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *user = [userDefault objectForKey:kDefaultsUserName];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"user"] = user;
    HRWeakSelf
    [HRHTTPTool hr_getHttpWithURL:HRAPI_LockInFo_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        [self.eptTable.mj_header endRefreshing];
        if (error) {
            [ErrorCodeManager showError:error];
            NSLog(@"HRAPI_LockInFo_URL-error--%@", error);
            return ;
        }
        
        DDLogWarn(@"获取设备信息HTTP请求%@", responseObject);
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf.homeArray removeAllObjects];
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
        }
        
        [weakSelf.homeArray removeAllObjects];
        NSArray *responseArr = (NSArray*)responseObject;
        
        for (NSDictionary *dict in responseArr) {
            
            DeviceListModel *home = [DeviceListModel mj_objectWithKeyValues:dict];
            if ([home.types isEqualToString:@"hrsc"]) {
                //修改921
                [weakSelf.homeArray addObject:home];
            }
        }
        weakSelf.appDelegate.homeArray = weakSelf.homeArray;
        
        //判断当前的mode是否为空, 如果为空就让他等于数组的第一个值, 如果不为空就让他等于当前值, 刷新是刷新的当前的数组个数和状态
            
        weakSelf.currentStateModel = weakSelf.homeArray.firstObject;
        if (weakSelf.homeArray.count >= 3) {
            
            
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            
            self.collectionView.userInteractionEnabled = YES;
        }
        //显示占位图片
        [self setUp3DEptPictureWithHomeArray:weakSelf.homeArray];
        
        weakSelf.listLabel.text = weakSelf.currentStateModel.title;
        if ([weakSelf.currentStateModel.state isEqualToString:@"1"]) {
            weakSelf.listImageView.image = [UIImage imageNamed:@"空心在线"];
        }else
        {
            
            weakSelf.listImageView.image = [UIImage imageNamed:@"空心离线"];
        }
        
        [self.tableView reloadData];
        
        //定时60s查询设备状态
        [self addTimer];
        
        //获得设备授权表
        [self addAutherList];
        
    }];
    
}
#pragma mark - 获取设备信息  发送HTTP请求
- (void)getHttpRequset
{
	/// 从偏好设置里加载数据
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSString *user = [userDefault objectForKey:kDefaultsUserName];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"user"] = user;
	HRWeakSelf
	[HRHTTPTool hr_getHttpWithURL:HRAPI_LockInFo_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
		[self.eptTable.mj_header endRefreshing];
		if (error) {
			[ErrorCodeManager showError:error];
			NSLog(@"HRAPI_LockInFo_URL-error--%@", error);
			return ;
		}
		
		DDLogWarn(@"获取设备信息HTTP请求%@", responseObject);
		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
		if (![responseObject isKindOfClass:[NSArray class]]) {
			[weakSelf.homeArray removeAllObjects];
			DDLogDebug(@"responseObject不是NSArray");
			return;
		}
		//去除服务器发过来的数据里没有值的情况
		if (((NSArray*)responseObject).count < 1 ) {
			DDLogDebug(@"responseObject count == 0");
		}
		
		[weakSelf.homeArray removeAllObjects];
		NSArray *responseArr = (NSArray*)responseObject;
		
		for (NSDictionary *dict in responseArr) {
			
			DeviceListModel *home = [DeviceListModel mj_objectWithKeyValues:dict];
			if ([home.types isEqualToString:@"hrsc"]) {
				//修改921
			[weakSelf.homeArray addObject:home];
		}
		}
		weakSelf.appDelegate.homeArray = weakSelf.homeArray;
		DDLogWarn(@"---------weakSelf.appDelegate.homeArray%@count%lu--------", weakSelf.appDelegate.homeArray, (unsigned long)weakSelf.appDelegate.homeArray.count);
		
		//判断当前的mode是否为空, 如果为空就让他等于数组的第一个值, 如果不为空就让他等于当前值, 刷新是刷新的当前的数组个数和状态
		if (self.currentStateModel.uuid.length < 1) {
			
            weakSelf.currentStateModel = weakSelf.homeArray.firstObject;
            //显示占位图片
            [self setUp3DEptPictureWithHomeArray:weakSelf.homeArray];
		}else
		{
            int index = 0;
			for (DeviceListModel *model in weakSelf.homeArray) {
				if ([model.uuid isEqualToString:weakSelf.currentStateModel.uuid]) {//取出和当前的UUID一样的这条数据覆盖掉,currentStateModel数据- 代表刷新的是当前cell和当前列表的数据, 不让文字换成其他的, cell也不让他滚动
					weakSelf.currentStateModel = model;
                    index++;
				}
			}
            if (index) {//更新当前currentStateModel数据
                
                [self setUp3DEptPictureWithHomeArray:weakSelf.homeArray];
                
            }else//如果为0就代表是用户删除设备的操作,就让重新赋值
            {
                weakSelf.currentStateModel = weakSelf.homeArray.firstObject;
                //显示占位图片
                [self setUp3DEptPictureWithHomeArray:weakSelf.homeArray];
            }
		}
		
        
        //重新设置列表按钮的图片和文字
        if (weakSelf.homeArray.count > 0) {
            
            weakSelf.listLabel.text = weakSelf.currentStateModel.title;
            if ([weakSelf.currentStateModel.state isEqualToString:@"1"]) {
                weakSelf.listImageView.image = [UIImage imageNamed:@"空心在线"];
            }else
            {
                
                weakSelf.listImageView.image = [UIImage imageNamed:@"空心离线"];
            }
            
        }else
        {
            weakSelf.listLabel.text = @"";
            weakSelf.listImageView.image = [UIImage imageNamed:@""];
        }
        
		[self.tableView reloadData];
		
		//定时60s查询设备状态
		[self addTimer];
		
		//获得设备授权表
		[self addAutherList];
		
	}];
	
}
#pragma mark - 就显示3D效果占位图片
- (void)setUp3DEptPictureWithHomeArray:(NSArray *)homeArray
{
    [self.photoModelArray removeAllObjects];
    if (homeArray.count == 0) {//如果只有一个设备 就显示两张占位图片
        
        [self.photoModelArray addObject:
         [PhotoModel modelWithImageNamed:@"锁-透明"
                             description:@""]];
        [self.photoModelArray addObject:
         [PhotoModel modelWithImageNamed:@"锁-透明"
                             description:@""]];
        [self.photoModelArray addObject:
         [PhotoModel modelWithImageNamed:@"锁-透明"
                             description:@""]];
        [self.collectionView setContentOffset:CGPointMake(1 * HRCommonScreenW *345 *2, 0) animated:NO];
        self.collectionView.userInteractionEnabled = NO;
        
    }else if (homeArray.count == 1) {//如果只有一个设备 就显示两张占位图片
		
		[self.photoModelArray addObject:
		 [PhotoModel modelWithImageNamed:@"锁-透明"
							 description:@""]];
		[self.photoModelArray addObject:
		 [PhotoModel modelWithImageNamed:@"锁虚线"
							 description:@""]];
		[self.photoModelArray addObject:
		 [PhotoModel modelWithImageNamed:@"锁-透明"
							 description:@""]];
        [self.collectionView setContentOffset:CGPointMake(1 * HRCommonScreenW *345 *2, 0) animated:NO];
        self.collectionView.userInteractionEnabled = YES;
	}else if (homeArray.count == 2) {//如果只有两个设备 就显示1张占位图片
		
		[self.photoModelArray addObject:
		 [PhotoModel modelWithImageNamed:@"锁-透明"
							 description:@""]];
		[self.photoModelArray addObject:
		 [PhotoModel modelWithImageNamed:@"锁虚线"
							 description:@""]];
		[self.photoModelArray addObject:
		 [PhotoModel modelWithImageNamed:@"锁虚线"
							 description:@""]];
		
        [self.collectionView setContentOffset:CGPointMake(1 * HRCommonScreenW *345 *2, 0) animated:NO];
        self.collectionView.userInteractionEnabled = YES;
	}else
	{
		for (DeviceListModel *home in homeArray) {
			[self.photoModelArray addObject:
			 [PhotoModel modelWithImageNamed:@"锁虚线"
								 description:@""]];
			
        }
        
        self.collectionView.userInteractionEnabled = YES;
	}
    [self.collectionView reloadData];
}
#pragma mark - 获得设备授权表 HTTP
- (void)addAutherList
{
	//我授权给别人的数据, 请求下来的数据要传到授权列表界面
	NSString *username = [kUserDefault objectForKey:kDefaultsUserName];
	NSString *url = [NSString stringWithFormat:@"%@%@", HRAPI_LockAutherUserList_URL,username];
	url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	
	HRWeakSelf
	[HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
		
		if (error) {
			[ErrorCodeManager showError:error];
			return ;
		}
		DDLogWarn(@"获得我授权给别人的授权表 HTTP%@", responseObject);
		
		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
		if (![responseObject isKindOfClass:[NSArray class]]) {
			[weakSelf.autherArray removeAllObjects];
			DDLogDebug(@"responseObject不是NSArray");
			return;
		}
		//去除服务器发过来的数据里没有值的情况
		if (((NSArray*)responseObject).count < 1 ) {
			DDLogDebug(@"responseObject count == 0");
		}
		
		AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
		[app.autherArray removeAllObjects];
		[weakSelf.autherArray removeAllObjects];
		[weakSelf.autherDeviceArray removeAllObjects];
		
		NSArray *responseArr = (NSArray*)responseObject;
		NSMutableArray *mb = [NSMutableArray array];
		for (NSDictionary *dict in responseArr) {
			DeviceAutherModel *auther = [DeviceAutherModel mj_objectWithKeyValues:dict];
			[weakSelf.autherArray addObject:auther];
			
			[mb addObject:auther];
			for (DeviceListModel *listModel in weakSelf.homeArray) {
				if ([listModel.uuid isEqualToString:auther.uuid]) {
					[weakSelf.autherDeviceArray addObject:listModel];
				}
			}
			
		}
		
		[app addHTTPAutherArray:mb];
		
	}];
	
	//别人授权给我的数据, 请求下来的数据要在本界面显示
	username = [kUserDefault objectForKey:kDefaultsUserName];
	url = [NSString stringWithFormat:@"%@%@", HRAPI_LockAutherPersonList_URL,username];
	url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	
	[HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
		
		if (error) {
			[ErrorCodeManager showError:error];
			return ;
		}
		DDLogWarn(@"别人授权给我的授权表数据%@", responseObject);
		
		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
		if (![responseObject isKindOfClass:[NSArray class]]) {
			[weakSelf.autherPersonArray removeAllObjects];
			DDLogDebug(@"responseObject不是NSArray");
			return;
		}
		//去除服务器发过来的数据里没有值的情况
		if (((NSArray*)responseObject).count < 1 ) {
			DDLogDebug(@"responseObject count == 0");
			return;
		}
		
		[weakSelf.autherPersonArray removeAllObjects];
		NSArray *responseArr = (NSArray*)responseObject;
		
		for (NSDictionary *dict in responseArr) {
			DeviceAutherModel *auther = [DeviceAutherModel mj_objectWithKeyValues:dict];
			[weakSelf.autherPersonArray addObject:auther];
			
			
		}
		
		[weakSelf addDeviceAutherInformation];
	}];
	
}

#pragma mark - 获得授权设备信息 HTTP
- (void)addDeviceAutherInformation
{
	NSString *uuidAllString = @"";
	for (int i = 0; i < self.autherPersonArray.count ; i++) {
		DeviceAutherModel *auther = [DeviceAutherModel mj_objectWithKeyValues:self.autherPersonArray[i]];
		
		uuidAllString = [NSString stringWithFormat:@"%@%@|", uuidAllString, auther.uuid];
	}
	uuidAllString = [uuidAllString substringToIndex:uuidAllString.length - 1];
	
	NSString *url = [NSString stringWithFormat:@"%@(%@)", HRAPI_LockAutherInformation_URL,uuidAllString];
	
	DDLogWarn(@"获得授权设备信息 url1%@", url);
	url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	
	
	DDLogWarn(@"获得授权设备信息 url2%@", url);
	HRWeakSelf
	[HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
		DDLogWarn(@"获得授权设备信息 HTTP-array:%@---error:%@", responseObject,error);
		
		if (error) {
			[ErrorCodeManager showError:error];
			return ;
		}
		
		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
		if (![responseObject isKindOfClass:[NSArray class]]) {
			[weakSelf.personDeviceArray removeAllObjects];
			DDLogDebug(@"responseObject不是NSArray");
			return;
		}
		//去除服务器发过来的数据里没有值的情况
		if (((NSArray*)responseObject).count < 1 ) {
			DDLogDebug(@"responseObject count == 0");
			return;
		}
		
		[weakSelf.personDeviceArray removeAllObjects];
		NSArray *responseArr = (NSArray*)responseObject;
		
		for (NSDictionary *dict in responseArr) {
			DeviceListModel *auther = [DeviceListModel mj_objectWithKeyValues:dict];
			[weakSelf.personDeviceArray addObject:auther];
			
			[weakSelf.homeArray addObject:auther];
		}
		
		
		[self.photoModelArray removeAllObjects];
		
		//判断当前的mode是否为空, 如果为空就让他等于数组的第一个值, 如果不为空就让他等于当前值, 刷新是刷新的当前的数组个数和状态
		if (self.currentStateModel.uuid.length < 1) {
			
			weakSelf.currentStateModel = weakSelf.homeArray.firstObject;
            
            //显示占位图片
            [self setUp3DEptPictureWithHomeArray:weakSelf.homeArray];
		}else
		{
            int index = 0;
			for (DeviceListModel *model in weakSelf.homeArray) {
				if ([model.uuid isEqualToString:weakSelf.currentStateModel.uuid]) {//取出和当前的UUID一样的这条数据覆盖掉,currentStateModel数据
					weakSelf.currentStateModel = model;
                    index++;
					
				}
			}
            
            if (index) {
                
            }else
            {
                weakSelf.currentStateModel = weakSelf.homeArray.firstObject;
                //显示占位图片
                [self setUp3DEptPictureWithHomeArray:weakSelf.homeArray];
            }
		}
        
        //重新设置列表按钮的图片和文字
        if (weakSelf.homeArray.count > 0) {
            
            weakSelf.listLabel.text = weakSelf.currentStateModel.title;
            if ([weakSelf.currentStateModel.state isEqualToString:@"1"]) {
                weakSelf.listImageView.image = [UIImage imageNamed:@"空心在线"];
            }else
            {
                
                weakSelf.listImageView.image = [UIImage imageNamed:@"空心离线"];
            }
            
        }else
        {
            weakSelf.listLabel.text = @"";
            weakSelf.listImageView.image = [UIImage imageNamed:@""];
        }
		
		[weakSelf.tableView reloadData];
		[weakSelf.collectionView reloadData];
		
		
	}];
}


#pragma mark -删除门锁 HTTP

-(void)deleteDoor
{
	
	[SVProgressTool hr_showWithStatus:@"正在删除..."];
	// 判断是否有权限修改用户名
	for (DeviceAutherModel *auther in self.autherPersonArray) {
		
		//别人授权的设备
		if ([auther.uuid isEqualToString: self.showLockModel.uuid]) {
			
			[self sendDataDeleteAuthorWithDeviceAutherModel: auther];
			
			return;
		}
		
	}
	
    
    //删除授权信息
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableArray *mu = [NSMutableArray array];
    for (DeviceAutherModel *model in app.autherArray) {
        if ([model.uuid isEqualToString: self.showLockModel.uuid]) {
            
            [mu addObject:model];
            
        }
        
    }
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0; i < mu.count; i++) {
            dispatch_group_enter(serviceGroup);
            DeviceAutherModel *model = mu[i];
            
            NSString *url = [NSString stringWithFormat:@"%@%@", HRAPI_UpdateDoorPsw_URL, model.did];
            
            [HRHTTPTool hr_DeleteHttpWithURL:url parameters:nil responseDict:^(id array, NSError *error) {
                NSLog(@"删除授权记录arr%@err%@", array, error);
                if (error) {
                    [SVProgressTool hr_showErrorWithStatus:@"删除设备失败,请重试!"];
                    dispatch_group_leave(serviceGroup);
                    return ;
                }
                
                dispatch_group_leave(serviceGroup);
            }];

            dispatch_group_wait(serviceGroup, DISPATCH_TIME_FOREVER);
            NSLog(@"第%d次", i);
        }
        dispatch_group_notify(serviceGroup, dispatch_get_global_queue(0, 0), ^{
            
            NSString *did = self.showLockModel.did;
            NSString *url = [NSString stringWithFormat:@"%@%@", HRAPI_UpdateDoorPsw_URL, did];
            HRWeakSelf
            [HRHTTPTool hr_DeleteHttpWithURL:url parameters:nil responseDict:^(id array, NSError *error) {
                
                NSLog(@"删除设备arr%@err%@", array, error);
                if (error != nil) {
                    
                    [ErrorCodeManager showError:error];
                    return ;
                }
                
                //请求成功
                NSMutableArray *mb = [NSMutableArray array];
                for (DeviceListModel *model in weakSelf.homeArray) {
                    if ([model.uuid isEqualToString:weakSelf.showLockModel.uuid] && [model.did isEqualToString:weakSelf.showLockModel.did]) {
                        continue;
                    }
                    [mb addObject:model];
                }
                //homearray里的数据重新赋值
                weakSelf.homeArray = mb;
                
                //重新设置3D图片
                [self setUp3DEptPictureWithHomeArray: weakSelf.homeArray];
                
                //重新设置列表按钮的图片和文字
                if (weakSelf.homeArray.count > 0) {
                    
                    weakSelf.currentStateModel = weakSelf.homeArray.firstObject;
                    weakSelf.listLabel.text = weakSelf.currentStateModel.title;
                    //修改921
                    //按钮图片
                    if ([self.currentStateModel.state isEqualToString:@"1"]) {
                        self.listImageView.image = [UIImage imageNamed:@"空心在线"];
                    }else
                    {
                        
                        self.listImageView.image = [UIImage imageNamed:@"空心离线"];
                    }
                }else
                {
                    weakSelf.currentStateModel = nil;
                    weakSelf.listLabel.text = @"";
                    //修改921
                    //按钮图片
                    if ([self.currentStateModel.state isEqualToString:@"1"]) {
                        self.listImageView.image = [UIImage imageNamed:@""];
                    }else
                    {
                        
                        self.listImageView.image = [UIImage imageNamed:@""];
                    }
                }
                
                [weakSelf.tableView reloadData];
                [weakSelf.collectionView reloadData];
                
                DDLogInfo(@"删除门锁%@error%@", array,error);
                [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
                
                
            }];
        });
    });

}

#pragma mark - 更新门锁信息 HTTP
-(void)updateDoor
{
	NSString *did = self.showLockModel.did;
	NSString *url = [NSString stringWithFormat:@"%@%@",HRAPI_ModifyLock_URL, did];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"type"] = self.showLockModel.types;
	parameters[@"title"] = newDvNameField.text;
	
	[HRHTTPTool hr_PutHttpWithURL:url parameters:parameters responseDict:^(id array, NSError *error) {
		//这里array 是字典nid = 474601;uri = "http://183.63.118.58:9885/hrctest/?q=huaruiapi/node/474601";
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        if (array) {
            [self getHttpRequset];
        }
		DDLogInfo(@"更新门锁信息-%@error%@", array, error);
	}];
	
}

- (void)dealloc
{
	[kNotification removeObserver:self];
	[self.timer invalidate];
}
#pragma mark -  给collectionView添加长按手势

-(void)addLongGesture
{
	UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
	longPressGr.minimumPressDuration = 0.7;
	longPressGr.delegate = self;
	longPressGr.delaysTouchesBegan = YES;
	[self.collectionView addGestureRecognizer:longPressGr];
}

#pragma mark - 长按collectionView触发的方法
-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer

{
	if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
		return;
	}
	CGPoint p = [gestureRecognizer locationInView:self.collectionView];
	
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
	if (indexPath == nil){
		NSLog(@"couldn't find index path");
	} else {
		
		NSLog(@"couldn't find index path%ld", indexPath.row);
		//判断数组的个数进行传值
		if (self.homeArray.count == 1) {//当homeArray为1时
			if (indexPath.row == 1) {
				self.showLockModel = self.homeArray.firstObject;
				[self showSheet];
			}
		}else if (self.homeArray.count == 2) {//当homeArray为2时
			if (indexPath.row == 1) {
				
				self.showLockModel = self.homeArray.firstObject;
				[self showSheet];
			}else if (indexPath.row == 2) {
				
				self.showLockModel = self.homeArray.lastObject;
				[self showSheet];
			}
		}else//当homeArray为>=3时
		{
			self.showLockModel = self.homeArray[indexPath.row];
			[self showSheet];
			
		}
		
		
	}
}

#pragma mark - 长按时判断是否弹出Sheet
- (void)showSheet
{
	// 判断是否有权限修改用户名
	for (DeviceAutherModel *auther in self.autherPersonArray) {
		
		//别人授权的设备
		if ([auther.uuid isEqualToString: self.currentStateModel.uuid]) {
			NSString *title = [NSString stringWithFormat:@"%@(授权设备)", self.currentStateModel.title];
            
			[SRActionSheet sr_showActionSheetViewWithTitle:title cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"删除设备"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                
				if (index == 0) {
					
					//删除设备
					[self deleteDoorUI];
				}
				
				else if (index == 1){
					
					[self beginANimation];
				}
				
			}];
			return;
		}
		
	}
	
	//自己创建的设备
	[SRActionSheet sr_showActionSheetViewWithTitle:self.showLockModel.title cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"删除设备", @"修改设备别名",@"更新设备信息"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
		
		if (index == 0) {//删除按钮
			NSString *iconString;
            //qq头像
            
            iconString = [kUserDefault objectForKey:kDefaultsQQIconURL];
            
            if (iconString.length > 0) {
                [self deleteQQDoorUI];
            } else
            {
               
            //删除设备
             [self deleteDoorUI];
                
            }
            
			
		}else if (index == 1){//修改设备名称
			
			[self beginANimation];
			
		}else//更新设备信息
        {
            //更新设备信息UI
            NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
            if (qqName.length > 0) {
                [self updateQQDeviceInformationUI];
            }else
            {
                [self updateDeviceInformationUI];
                
            }
            
        }
    }];
}

#pragma mark - 更新设备信息相关方法

#pragma mark - 用户名和密码的加密
- (NSString *)encryptionWithPassWorldAndUserName
{
    NSString *userName = [kUserDefault objectForKey:kDefaultsUserName];
    NSString *passwold = [kUserDefault objectForKey:kDefaultsPassWord];
    //组帧
    NSString *str = [NSString stringWithFormat:@"{\"user\":\"%@\",\"pass\":\"%@\"}", userName,passwold];
    NSString *hrkey = @"437frhsRE5TW4Gfgki56y54yh64T5tHY65YRHTT45y45ygtaR4W64YUHE54YGR54Y45rfhy6u57hger8567ygvf43tftg44regft547get4345TGREY7587EGTDA5tg5";
    //	NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    NSMutableString *muString =[NSMutableString string];
    for (int i = 0; i < str.length; i++) {
        
        char tempChar = [str characterAtIndex:i];
        char hrkeyChar = [hrkey characterAtIndex:i];
        char temp = (char)tempChar^hrkeyChar;
        
        NSString *charStr = [NSString stringWithFormat:@"%c", temp];
        [muString appendString:charStr];
        //		[stringArray addObject:charStr];
    }
    
    DDLogWarn(@"%@",[GTMBase64 encodeBase64String:muString]);
    return [GTMBase64 encodeBase64String:muString];
    //	return [AddDeviceView base64StringFromText:str];
    //	return muString;
}


#pragma mark - HTTP
- (void)httpWithUpdataDoor
{
    
    
    DeviceListModel * model  = self.currentStateModel ;
    
    //组帧
    NSString *muString = [self encryptionWithPassWorldAndUserName];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"hrsc";
    parameters[@"field_licence[und][0][value]"] = muString;
    
    NSLog(@"model的types是%@",model.types);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
    [manager PUT:[NSString stringWithFormat:HRAPI_UpdateDoorMess_URL, model.did] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdataXiaoRui object:nil];
        
        
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showSuccessWithStatus:@"更新门锁设备信息成功!" ];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogDebug(@"%@", error);
        [ErrorCodeManager showError:error];
    }];
    
}





#pragma mark - 自定义弹框 activityView
- (void)addHudWith:(NSString *)text
{
	[SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0x444444]];
	[SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xFFFFFF]];
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
	SVProgressHUD.defaultStyle = SVProgressHUDStyleDark;
	SVProgressHUD.minimumDismissTimeInterval = 0.5;
	[SVProgressHUD showWithStatus:text];
}

#pragma mark -删除门锁UI设置
-(void)deleteDoorUI
{
	
	CGFloat dilX = 25;
	CGFloat dilH = 150;
	YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
	
	
	// alertV.tag = tag;
	alertV.delegate = self;
	alertV.titleStr = @"删除设备";
	
	
	CGFloat loginX = 200 *HRCommonScreenH;
	
	
	//密码相关view
	UILabel * paswdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
	
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
	
	
	pwdField.textColor = [UIColor whiteColor];
	
	/** 标记这个输入框*/
	pwdField.tag = 7;
	
	
	
	self.pswTF = pwdField;
	
	
	[alertV addSubview:self.pswTF];
	
	
	
	self.FamilyAlertView = alertV;
	
	
	[UIView animateWithDuration:0.5 animations:^{
		
		self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
		
		self.FamilyAlertView.alpha=1;
		
	} completion:^(BOOL finished) {
		
		
		
		
	}];
	
}
#pragma mark -删除门锁 QQ用户 UI设置
-(void)deleteQQDoorUI
{
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"删除设备";
    
    
    [alertV addSubview:self.pswTF];
    
    
    
    self.FamilyAlertView = alertV;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.FamilyAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}


#pragma mark -更新设备信息UI设置
-(void)updateDeviceInformationUI
{
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
     alertV.tag = 20;
    alertV.delegate = self;
    alertV.titleStr = @"更新设备信息";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    
    //密码相关view
    UILabel * paswdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
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
    
    
    pwdField.textColor = [UIColor whiteColor];
    
    /** 标记这个输入框*/
    pwdField.tag = 7;
    
    
    
    self.pswTF = pwdField;
    
    
    [alertV addSubview:self.pswTF];
    
    
    
    self.FamilyAlertView = alertV;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.FamilyAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
}

#pragma mark -更新设备信息 QQ用户UI设置
-(void)updateQQDeviceInformationUI
{
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.tag = 20;
    alertV.delegate = self;
    alertV.titleStr = @"更新设备信息";
    
    
    
    
    self.FamilyAlertView = alertV;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.FamilyAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
}



-(void)beginANimation
{
	bg = [[UIView alloc] initWithFrame:self.view.frame];
	
	bg.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
	
	CGFloat dilX = 25;
	CGFloat dilH = 200;
	
	bgView =   [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
	
	bgView.frame =   CGRectMake(KScreenW/2, 64+40, 0, dilH);
	
	bgView.layer.cornerRadius = 15;
	
	bgView.clipsToBounds = YES;
	
	[bg addSubview:bgView];
	
	CGFloat loginX = 200 *HRCommonScreenH;
	
	
	oldDeviceNameLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, loginX, 32)];
	
	oldDeviceNameLB.text = @"设备名称";
	oldDeviceNameLB.textColor = [UIColor whiteColor];
	
	oldDeviceNameLB.textAlignment = NSTextAlignmentLeft;
	
	
	[bgView addSubview:oldDeviceNameLB];
	
	
	detailNameLB = [[UILabel alloc]initWithFrame:CGRectMake(loginX  + 10, 30,  KScreenW-50 -  loginX*1.2 ,32)];
	
	detailNameLB.text = self.currentStateModel.title;
	
	detailNameLB.textColor = [UIColor whiteColor];
	
	detailNameLB.textAlignment = NSTextAlignmentLeft;
	
	[bgView addSubview:detailNameLB];
	
	/** 新设备名称  */
	
	newDvName = [[UILabel alloc]initWithFrame:CGRectMake(5, 80, loginX, 32)];
	newDvName.text = @"新设备名称";
	newDvName.textColor = [UIColor whiteColor];
	
	newDvName.textAlignment = NSTextAlignmentLeft;
	
	[bgView addSubview:newDvName];
	
	
	CGFloat fieldLength =  KScreenW-50 -  loginX*1.2;
	
	tfLength  = loginX +fieldLength/2;
	
	
	newDvNameField = [[UITextField alloc]initWithFrame:CGRectMake((loginX +fieldLength/2), 80,0, 32)];
	
	
	
	newDvNameField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	
	newDvNameField.leftViewMode = UITextFieldViewModeAlways;
	
	UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
	
	newDvNameField.leftView = leftView1;
	newDvNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	newDvNameField.layer.borderWidth = 1;
	newDvNameField.layer.cornerRadius = 10;
	
	newDvNameField.textColor = [UIColor whiteColor];
	
	newDvNameField.backgroundColor = [UIColor orangeColor];
	
	[bgView addSubview:newDvNameField];
	
	//确定按钮
	
	comfirBtn  =  [[UIButton alloc]init];
	[bgView addSubview:comfirBtn];
	
	
	comfirBtn.sd_layout
	.bottomSpaceToView(bgView , 20.0 * HRMyScreenH)
	.rightSpaceToView(bgView,98.0 *HRMyScreenW)
	.widthIs(130.0 *HRMyScreenW)
	.heightIs(45.0 *HRMyScreenH);
	
	comfirBtn.layer.cornerRadius = 15;
	comfirBtn.clipsToBounds = YES;
	comfirBtn.layer.borderWidth = 1;
	
	[comfirBtn setTitle:@"确定" forState:UIControlStateNormal];
	
	
	comfirBtn.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
	
	
	
	
	comfirBtn.backgroundColor = [UIColor clearColor];
	
	
	
	/** ************  确定按钮*/
	[comfirBtn addTarget:self action:@selector(comfirClick) forControlEvents:UIControlEventTouchUpInside];
	
	close = [[UIButton alloc] initWithFrame:CGRectMake(KScreenW-30-30, 110, 20, 20)];
	[close setTitle:@"X" forState:UIControlStateNormal];
	[close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:bg];
	
	txt = [[UITextView alloc] initWithFrame:CGRectMake((KScreenW-60)/2, (bgView.frame.size.height-30)/2, 0, 30)];
	txt.layer.cornerRadius = 10;
	txt.layer.masksToBounds =YES;
	[UIView animateWithDuration:0.5 animations:^{
		
		
		bgView.frame =CGRectMake(dilX, 64+40, HRUIScreenW - 50, dilH);
		
	} completion:^(BOOL finished) {
		[bg addSubview:close];
		[UIView animateWithDuration:0.6 animations:^{
			
			newDvNameField.frame = CGRectMake(loginX, 80,  KScreenW-50 -  loginX*1.2, 32);
			
			txt.frame = CGRectMake(30, (bgView.frame.size.height-30)/2, KScreenW-120, 30);
		}];
		
	}];
	
	
	
	
}

#pragma mark - 修改门锁名称弹窗确定

-(void)comfirClick
{
	
	if ( newDvNameField.text.length == 0 ) {
		[bgView.layer shake];
		return;
		
	}
	
	//先判断 是不是自己的锁 自己的锁就删除这个锁 ，不是自己的锁就取消授权
	
	
	[self updateDoor];
	
	
	[self closeView];
	
}

-(void)closeView{
	
	
	
	comfirBtn.alpha= 0;
	
	oldDeviceNameLB.alpha = 0 ;
	
	detailNameLB.alpha = 0 ;
	
	newDvName.alpha = 0 ;
	
	[UIView animateWithDuration:0.6 animations:^{
		txt.frame = CGRectMake((KScreenW-60)/2, (bgView.frame.size.height-30)/2, 0, 30);
		
		newDvNameField.frame = CGRectMake(tfLength, 80,0, 32);
		
		
		
		
		
		
		close.transform = CGAffineTransformMakeRotation(M_PI);
		close.transform = CGAffineTransformMakeScale(0.1, 0.1);
	} completion:^(BOOL finished) {
		[close removeFromSuperview];
		[UIView animateWithDuration:0.5 animations:^{
			//bgView.frame = CGRectMake(KScreenW/2,150, 0, KScreenH-300);
			bgView.frame = CGRectMake(KScreenW/2,(bgView.frame.size.height+104.0)/2, 0, 0);
			
		} completion:^(BOOL finished) {
			[bg removeFromSuperview];
		}];
	}];
	
}



#pragma mark -删除门锁弹窗   第三方demo代理方法

- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex==0) {
		
		[UIView animateWithDuration:0.5 animations:^{
			
			
			CGRect AlertViewFrame = customAlertView.frame;
			
			AlertViewFrame.origin.y = 0;
			
			customAlertView.alpha = 0;
			
			
			
			customAlertView.frame = AlertViewFrame;
			
		} completion:^(BOOL finished) {
			
			
			[customAlertView dissMiss];
			
			
		}];
	}else{
		
		
        
		//处理删除门锁事件
		
		NSLog(@"输入框的字符串是%@",self.pswTF.text);
        NSString *qqName = [kUserDefault objectForKey:kNSUserDefaultsNickname];
        if (qqName.length > 0) {
            
        }else
        {
            if (self.pswTF.text.length == 0 ) {
                [customAlertView.layer shake];
                return;
                
            }
            
            NSString * passWord = [kUserDefault objectForKey:kDefaultsPassWord];
            
            
            if (![self.pswTF.text isEqualToString:passWord]) {
                
                [customAlertView.layer shake];
                NSLog(@"密码不正确");
                
                
                return;
                
            }

            
        }
				
        if (customAlertView.tag == 20) {
            [self httpWithUpdataDoor];
        }else
        {
            
            [self deleteDoor];
        }
        
		
		
		[UIView animateWithDuration:0.8 animations:^{
			
			
			CGRect AlertViewFrame = customAlertView.frame;
			
			AlertViewFrame.origin.y = HRUIScreenH ;
			
			
			customAlertView.frame = AlertViewFrame;
			
			customAlertView.alpha = 0;
			
			
		} completion:^(BOOL finished) {
			
			
			[customAlertView dissMiss];
			
		}];
		
		
	}
}


- (void)removeHudWith:(NSString *)text
{
	if(text){//判断 成功/失败 结尾
		if ([text hasSuffix:@"成功"]||[text hasSuffix:@"全部"]) {
			[SVProgressHUD showSuccessWithStatus:text];
		} else {
			[SVProgressHUD showErrorWithStatus:text];
		}
	}
	
	[SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0x444444]];
	[SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xFFFFFF]];
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	SVProgressHUD.defaultStyle = SVProgressHUDStyleDark;
	
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
		[SVProgressHUD dismiss];
	});
}

#pragma mark - 取消授权 socket
- (void)sendDataDeleteAuthorWithDeviceAutherModel:(DeviceAutherModel *)mode
{
	NSString *dstUUId = mode.uuid;
	NSString *did = mode.did;
	
	NSString *str = [NSString stringWithSocketDelegateFamilyLockWithDstUuid:dstUUId lockUUID:dstUUId did:did devUser:mode.admin];
	[self.appDelegate sendMessageWithString:str];
	
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
		[_timer invalidate];
	}
}

#pragma mark - 定时器相关
- (void)addTimer
{
	[self.timer invalidate];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		DeviceListModel *testModel = self.currentStateModel;
		//获取page = 0的门锁记录
		[self getHttpRequsetWithLockRecord];
		
		for (DeviceAutherModel *model in self.autherPersonArray) {//目标设备的名字要填,别人授权给我的管理员名字
			if ([model.uuid isEqualToString:testModel.uuid]) {
				
				
				[self sendSocketQuaryDeviceOnLineWithUser:model.admin dev:testModel.uuid];
			}
		}
		
	});
	self.timer = [NSTimer scheduledTimerWithTimeInterval:timerDuration target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}


- (void)updateTimer
{
	DeviceListModel *testModel = self.currentStateModel;
	
	for (DeviceAutherModel *model in self.autherPersonArray) {//目标设备的名字要填,别人授权给我的管理员名字
		if ([model.uuid isEqualToString:testModel.uuid]) {
			
			
			[self sendSocketQuaryDeviceOnLineWithUser:model.admin dev:testModel.uuid];
		}
	}
	
	
}

#pragma mark - 定时60s查询设备状态
- (void)sendSocketQuaryDeviceOnLineWithUser:(NSString *)user dev:(NSString *)dev
{
	[self.appDelegate connectToHost];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"user"] = user;
	dict[@"dev"] = dev;
	NSString *str = [NSString stringWithSocketQuaryDeviceOnLineWithDst:dict];
	DDLogWarn(@"sendSocketQuaryDeviceOnLine-%@", str);
	[self.appDelegate sendMessageWithString:str];
	
}


#pragma mark - 获取设备信息  发送HTTP请求
- (void)getHttpRequsetWithLockRecord
{
	/// 从偏好设置里加载数据
	NSString *uuid = self.currentStateModel.uuid;
	//NSString *url = [NSString stringWithFormat:@"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev-hrsc-ml&uuid=%@&sy=(unlock|batlow|ltnolock|errlimt)&page=%d", uuid, indexCount];
	NSString *url = [NSString stringWithFormat:@"%@%@&sy=(unlock|batlow|ltnolock|errlimt)&page=%d",HRAPI_RecordeLock_URL,uuid,0];
	url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	
	HRWeakSelf
	[HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
		[self.tableView.mj_header endRefreshing];
		if (error) {
			[ErrorCodeManager showError:error];
			return ;
		}
		
		DDLogWarn(@"记录查询HTTP请求%@", responseObject);
		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
		if (![responseObject isKindOfClass:[NSArray class]]) {
			//			[weakSelf.queryArray removeAllObjects];
			DDLogDebug(@"responseObject不是NSArray");
			return;
		}
		//去除服务器发过来的数据里没有值的情况
		if (((NSArray*)responseObject).count < 1 ) {
			DDLogDebug(@"responseObject count == 0");
			return;
		}
		
		[weakSelf.queryArray removeAllObjects];
		NSArray *responseArr = (NSArray*)responseObject;
		
		for (NSDictionary *dict in responseArr) {
			DoorLockModel *lockModel = [DoorLockModel mj_objectWithKeyValues:dict];
			[weakSelf.queryArray addObject:lockModel];
		}
		
		[self.tableView reloadData];
	}];
}



@end
