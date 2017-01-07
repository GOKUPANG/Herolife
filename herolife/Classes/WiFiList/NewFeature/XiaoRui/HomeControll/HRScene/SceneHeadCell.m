//
//  SceneHeadCell.m
//  xiaorui
//
//  Created by sswukang on 16/6/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneHeadCell.h"
#import "SceneCollectionCell.h"
#import "SceneCell.h"
#import "SceneModellView.h"
#import "HRDOData.h"
#import "IracData.h"
#import "IrgmData.h"
#import "ScenePickerView.h"
#import "HRSceneData.h"
#import "SceneController.h"

//UITableView rowHeigh
#define rowH 50
//UITableView sectionHeight
#define sectionHeight 50
@interface SceneHeadCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
/// 更换图标按钮
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
/// 情景图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
/** 图片名称数组 */
@property(nonatomic, strong) NSArray *iconArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewMinY;
/// collection的父view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionEptViewH;
@property (weak, nonatomic) IBOutlet UITextField *sceneNameField;
/**
 *  导航卡下面这个高度为1的view
 */
@property (weak, nonatomic) IBOutlet UIView *barEptView;
/**
 *  导航卡下面会移动的view
 */
@property (weak, nonatomic) IBOutlet UIView *moveView;

@property (weak, nonatomic) IBOutlet UIButton *airDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *TVDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *currcyDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *doDeviceBtn;
/** <#name#> */
@property (weak, nonatomic) IBOutlet UIView *shadowUpView;
@property (weak, nonatomic) IBOutlet UIView *shadowDownView;
@property (weak, nonatomic) IBOutlet UITableView *scenceTableView;
/**
 *  中间调view
 */
@property (weak, nonatomic) IBOutlet UIView *middleContainer;
/** 记录中间条 的最小Y */
@property(nonatomic, assign) CGFloat middleContainerMixY;
/** UIView */
@property(nonatomic, weak) UIView *tabBarView;
/** UIButton */
@property(nonatomic, weak) UIButton *editButton;
/** UIButton */
@property(nonatomic, weak) UIButton *addDeviceButton;
/** UIView */
@property(nonatomic, weak) UIView *lineBarView;
/** UIButton */
@property(nonatomic, weak) UIButton *completeButton;
/** UIButton */
@property(nonatomic, weak) UIButton *currentButton;

/**
 *  头部图片的最小Y值
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewMinY;
/**
 *  textfiled的容器视图
 */
@property (weak, nonatomic) IBOutlet UIView *scenceNameView;
/** CGRect */
@property(nonatomic, assign) CGFloat scenceNameViewMaxY;
/**  */
@property(nonatomic, strong) NSMutableArray *doArray;
@property(nonatomic, strong) NSMutableArray *currencyArray;
@property(nonatomic, strong) NSMutableArray *airArray;
@property(nonatomic, strong) NSMutableArray *tvArray;
/** 秒 */
@property(nonatomic, copy) NSString *seconds;
/** 分 */
@property(nonatomic, copy) NSString *everyMinute;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *doTextArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *currencyTextArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *airTextArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *tvTextArray;

/** tablecell的滑块状态数组 */
@property(nonatomic, strong) NSMutableArray *doSwicherArray;
/** 总的情景数组 */
@property(nonatomic, strong) NSMutableArray *sceneArray;
/**  */
@property(nonatomic, strong) AppDelegate *appDelegate;
/** 底部窗口view */
@property(nonatomic, weak) UIView *picker;
/** 存放通用picker文字 的数组 */
@property(nonatomic, strong) NSMutableArray *gmPickerArray;
/** 存放电视picker文字 的数组 */
@property(nonatomic, strong) NSMutableArray *tvPickerArray;
/** 存放通用按钮number 的数组 */
@property(nonatomic, strong) NSMutableArray *gmNumberArray;
/** 存放电视按钮number 的数组 */
@property(nonatomic, strong) NSMutableArray *tvNumberArray;
/**  */
@property(nonatomic, strong) NSTimer *timer;
/** <#name#> */
@property(nonatomic, weak) UIWindow *tempWindow;
/** <#是否连接#> */
@property(nonatomic, assign) BOOL isSaveButtonClick;
@end
@implementation SceneHeadCell
#pragma mark - 懒加载
- (NSArray *)iconArray
{
	if (!_iconArray) {
		_iconArray = @[
					   @"ico_scene_athome_clicked",
					   @"ico_scene_romance_clicked",
					   @"ico_scene_meeting_clicked",
					   @"ico_scene_repast_clicked",
					   @"ico_scene_sleeping_clicked",
					   @"ico_scene_air_open",
					   @"ico_scene_air_close",
					   @"ico_scene_leavehome_clicked",
					   @"ico_scene_gettingup_clicked",
					   @"ico_scene_working_clicked",
					   @"ico_scene_relaxation_clicked",
					   @"ico_scene_media_clicked",
					   @"ico_scene_recreation_clicked",
					   @"ico_scene_reading_clicked",
					   @"ico_scene_athome_clicked",
					   @"ico_scene_curtainopen_clicked",
					   @"ico_scene_curtainclose_clicked",
					   @"ico_scene_curtainstop_clicked",
					   @"ico_scene_sports_clicked"
					   ];
	}
	return _iconArray;
}
- (NSMutableArray *)tvNumberArray
{
	if (_tvNumberArray == nil) {
		_tvNumberArray = [NSMutableArray array];
	}
	return _tvNumberArray;
}
- (NSMutableArray *)gmNumberArray
{
	if (_gmNumberArray == nil) {
		_gmNumberArray = [NSMutableArray array];
	}
	return _gmNumberArray;
}
- (NSMutableArray *)tvPickerArray
{
	if (_tvPickerArray == nil) {
		_tvPickerArray = [NSMutableArray array];
	}
	return _tvPickerArray;
}
- (NSMutableArray *)gmPickerArray
{
	if (_gmPickerArray == nil) {
		_gmPickerArray = [NSMutableArray array];
	}
	return _gmPickerArray;
}
/**
 *  tabelview 每行显示的内容
 */
- (NSMutableArray *)doArray
{
	if (_doArray == nil) {
		_doArray = [NSMutableArray array];
	}
	return _doArray;
}

- (NSMutableArray *)currencyArray
{
	if (_currencyArray == nil) {
		_currencyArray = [NSMutableArray array];
	}
	return _currencyArray;
}

- (NSMutableArray *)airArray
{
	if (_airArray == nil) {
		_airArray = [NSMutableArray array];
	}
	return _airArray;
}

- (NSMutableArray *)tvArray
{
	if (_tvArray == nil) {
		_tvArray = [NSMutableArray array];
	}
	return _tvArray;
}

- (NSMutableArray *)doTextArray
{
	if (_doTextArray == nil) {
		_doTextArray = [NSMutableArray array];
	}
	return _doTextArray;
}

- (NSMutableArray *)currencyTextArray
{
	if (_currencyTextArray == nil) {
		_currencyTextArray = [NSMutableArray array];
	}
	return _currencyTextArray;
}

- (NSMutableArray *)airTextArray
{
	if (_airTextArray == nil) {
		_airTextArray = [NSMutableArray array];
	}
	return _airTextArray;
}

- (NSMutableArray *)tvTextArray
{
	if (_tvTextArray == nil) {
		_tvTextArray = [NSMutableArray array];
	}
	return _tvTextArray;
}
- (NSMutableArray *)doSwicherArray
{
	if (_doSwicherArray == nil) {
		_doSwicherArray = [NSMutableArray array];
	}
	return _doSwicherArray;
}

- (NSMutableArray *)sceneArray
{
	if (_sceneArray == nil) {
		_sceneArray = [NSMutableArray array];
	}
	return _sceneArray;
}
#pragma mark - set 方法
- (void)setSceneData:(HRSceneData *)sceneData
{
	_sceneData = sceneData;
	if (sceneData) {
		self.sceneNameField.text = sceneData.title;
		NSString *picture = sceneData.picture.lastObject;
		NSInteger index = [picture integerValue] - 1;
		self.iconImageView.image = [UIImage imageNamed:self.iconArray[index]];
		
		//清空数组
		[self.doArray removeAllObjects];
		[self.currencyArray removeAllObjects];
		[self.tvArray removeAllObjects];
		[self.airArray removeAllObjects];
		[self.doSwicherArray removeAllObjects];
		//延时时间数组
		[self.doTextArray removeAllObjects];
		[self.tvTextArray removeAllObjects];
		[self.currencyTextArray removeAllObjects];
		[self.airTextArray removeAllObjects];
		
		
		[self.gmPickerArray removeAllObjects];
		[self.tvPickerArray removeAllObjects];
		[self.gmNumberArray removeAllObjects];
		[self.tvNumberArray removeAllObjects];
		
		NSMutableArray *scene = [NSMutableArray array];
		
		if (sceneData.data.length < 4) {
			[self.scenceTableView reloadData];
			return;
		}
		//把字符串分割成数组
		NSArray *sceneArray = [sceneData.data componentsSeparatedByString:@"],"];
		for (int i = 0; i < sceneArray.count; i++) {
			if (i == 0) {
				NSString *str = sceneArray[i];
				str = [str substringFromIndex:1];
				str = [NSString stringWithFormat:@"%@]",str];
				[scene addObject:str];
			}else if (i == sceneArray.count -1)
			{
				NSString *str = sceneArray[i];
				str = [str substringToIndex:str.length - 1];
				[scene addObject:str];
			}else
			{
				NSString *str = sceneArray[i];
				str = [NSString stringWithFormat:@"%@]",str];
				[scene addObject:str];
			};
		}
		
		// 又把数组中每个字符串,取出来分割成单独的数组元素
		
		for (NSString *sceneStr in scene) {
			NSMutableArray *arr = [NSMutableArray array];
			NSArray *tempArr = [sceneStr componentsSeparatedByString:@","];
			for (int i = 0; i < tempArr.count; i++) {
				if (i == 0) {
					
					NSString *fist = tempArr[i];
					NSRange startLocation = [fist rangeOfString:@"[\""];
					NSRange endLocation = [fist rangeOfString:@"\"" options:NSBackwardsSearch];
					NSRange range = NSMakeRange(startLocation.location + startLocation.length, endLocation.location - startLocation.location - startLocation.length);
					fist = [fist substringWithRange:range];
					[arr addObject:fist];
				}else if (i == tempArr.count - 1)
				{
					NSString *last = tempArr[i];
					last = [last substringFromIndex:1];
					NSRange range = [last rangeOfString:@"\"]"];
					last = [last substringToIndex:range.location];
					[arr addObject:last];
				}else
				{
					NSString *magin = tempArr[i];
					magin = [magin substringFromIndex:1];
					NSRange range = [magin rangeOfString:@"\""];
					magin = [magin substringToIndex:range.location];
					[arr addObject:magin];

				}
			}
			
			//取出did判断类型
			if ([arr[1] isEqualToString:@"hrdo"]) {
				
				//从单例里面遍历保存的数组
				for (HRDOData *data in self.appDelegate.doArray) {
					//判断取出的did和data的did是否是一样 的
					if ([data.did isEqualToString:arr.firstObject]) {
						/**
						 *  第一个字节： 0/1/2/3  ---- 分别表示 第1 2 3  4 开关
						    第二个字节： 0: 关
							1: 开
							2: 暂停, 零火/单火类型选择暂停时设置为0（关）
							3: 无效
						 */
						//取出dada数组里第3个元素的第一个字节进行判断
						if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
							//给模型重新赋值之后,保存在self.doArray数组中
							[self addDoArray:arr data:data index:2 number:@"0"];
						}else if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
							
							[self addDoArray:arr data:data index:4 number:@"1"];
						}else if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"2"]) {
							
							[self addDoArray:arr data:data index:6 number:@"2"];
						}else if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"3"]) {
							
							[self addDoArray:arr data:data index:8 number:@"3"];
						}
					}
				}
				
				
				//延时时间数组
				NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
				[self.doTextArray addObject:str];
				
				//滑块转态
				[self.doSwicherArray addObject:[arr[2] substringFromIndex:1]];
				
				
			}else if ([arr[1] isEqualToString:@"irac"]) {//空调
				//从单例里面遍历保存的数组
				for (IracData *data in self.appDelegate.iracArray) {
					//判断取出的did和data的did是否是一样 的
					if ([data.did isEqualToString:arr.firstObject]) {
						[self addAirArray:arr data:data];
					}
				//延时时间数组
				NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
				[self.airTextArray addObject:str];
				
				}
    
			}else if ([arr[1] isEqualToString:@"irgm"]) {// 通用 和电视
				//从单例里面遍历保存的数组
				for (IrgmData *data in self.appDelegate.irgmArray) {
					//判断取出的did和data的did是否是一样 的
					if ([data.did isEqualToString:arr.firstObject]) {
						if ([data.picture.lastObject isEqualToString:@"1"]) {//电视
							
							[self addTvArray:arr data:data];
							//延时时间数组
							NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
							[self.tvTextArray addObject:str];
						}else if ([data.picture.lastObject isEqualToString:@"2"]) {//通用 红外
							
							[self addCurrencyArray:arr data:data];
							//延时时间数组
							NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
							[self.currencyTextArray addObject:str];
							
						}
					}
					
					
				}
    
			}
		}
	}
	
	
	[self.scenceTableView reloadData];
}
#pragma mark - 添加cell数组
//开关
- (void)addDoArray:(NSArray *)arr data:(HRDOData *)data index:(NSInteger)index number:(NSString *)number
{
	NSDictionary *dict = [NSDictionary dictionary];
	HRDOData *doData = [HRDOData mj_objectWithKeyValues:dict];
	doData.did = arr.firstObject;
	doData.title =  data.parameter[index];
	NSString *str = [arr[2] substringFromIndex:1];
	doData.parameter = @[[NSString stringWithFormat:@"%ld", [number integerValue] + 1], data.parameter[index], str];
	doData.picture =  data.picture;
	doData.types = data.types;
	[self.doArray addObject:doData];
}
- (void)addAirArray:(NSArray *)arr data:(IracData *)data
{
	NSDictionary *dict = [NSDictionary dictionary];
	IracData *airData = [IracData mj_objectWithKeyValues:dict];
	airData.did = arr.firstObject;
	airData.title =  data.title;
	airData.types = data.types;
	airData.version =  arr[2];
	[self.airArray addObject:airData];
}
- (void)addCurrencyArray:(NSArray *)arr data:(IrgmData *)data
{
	NSDictionary *dict = [NSDictionary dictionary];
	IrgmData *currencyData = [IrgmData mj_objectWithKeyValues:dict];
	currencyData.did = arr.firstObject;
	currencyData.title =  data.title;
	currencyData.types = data.types;
	currencyData.param01 = data.param01;
	currencyData.param02 = data.param02;
	currencyData.param03 = data.param03;
	currencyData.name01 = data.name01;
	currencyData.name02 = data.name02;
	currencyData.name03 = data.name03;
	
	// 添加按钮文字 数组
	for (int i = 0; i < 10; i++) {
		if ([data.param01[i] isEqualToString:arr[2]]) {
			[self.gmPickerArray addObject:data.name01[i]];
		}else if ([data.param02[i] isEqualToString:arr[2]]) {
			[self.gmPickerArray addObject:data.name02[i]];
		}else if ([data.param03[i] isEqualToString:arr[2]]) {
			[self.gmPickerArray addObject:data.name03[i]];
		}
	}
	
	[self.gmNumberArray addObject:arr[2]];
	[self.currencyArray addObject:currencyData];
	
}
- (void)addTvArray:(NSArray *)arr data:(IrgmData *)data
{
	NSDictionary *dict = [NSDictionary dictionary];
	IrgmData *currencyData = [IrgmData mj_objectWithKeyValues:dict];
	currencyData.did = arr.firstObject;
	currencyData.title =  data.title;
	currencyData.types = data.types;
	currencyData.param01 = data.param01;
	currencyData.param02 = data.param02;
	currencyData.param03 = data.param03;
	currencyData.name01 = data.name01;
	currencyData.name02 = data.name02;
	currencyData.name03 = data.name03;
	[self.tvArray addObject:currencyData];
	[self.tvNumberArray addObject:arr[2]];
	// 添加按钮文字 数组
	for (int i = 0; i < 10; i++) {
		if ([data.param01[i] isEqualToString:arr[2]]) {
			[self.tvPickerArray addObject:data.name01[i]];
		}else if ([data.param02[i] isEqualToString:arr[2]]) {
			[self.tvPickerArray addObject:data.name02[i]];
		}else if ([data.param03[i] isEqualToString:arr[2]]) {
			[self.tvPickerArray addObject:data.name03[i]];
		}
	}
	
}

static NSString *const ID = @"cell";
static NSString *const scenceID = @"scenceID";
- (void)awakeFromNib {
    [super awakeFromNib];
	// 初始化
	[self setUpViews];
	//socket连接
	[self connectionSocket];
	// 通知
	[self addNotificationCenterObserver];
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithSceneTabBarView) name:kNotificationSceneTabBarView object:nil];
	//接收到时间Window消失的通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithSceneTimeWindow) name:kNotificationSceneTimeWindow object:nil];
	//接收到创建情景通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateScene:) name:kNotificationCreateScene object:nil];
	//接收到更新情景通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpDataScene:) name:kNotificationUpDataScene object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	
	//监听存储按钮是否可以点击
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithIsYesSaveButtonClick) name:kNotificationSceneIsYesSaveButtonClick object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithIsNoSaveButtonClick) name:kNotificationSceneIsNoSaveButtonClick object:nil];
	
}

//监听存储按钮是否可以点击
- (void)receviedWithIsYesSaveButtonClick
{
	self.isSaveButtonClick = YES;
}
- (void)receviedWithIsNoSaveButtonClick
{
	self.isSaveButtonClick = NO;
}
static BOOL isShowOverMenu = NO;
//监听设备是否在线
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
//接收到更新情景通知
- (void)receviedWithUpDataScene:(NSNotification *)note
{
	isOvertime = YES;
	[SVProgressHUD dismiss];
	[kNotification postNotificationName:kNotificationSceneVCToInfrared object:nil];
}
//接收到创建情景通知
static BOOL isOvertime = NO;
- (void)receviedWithCreateScene:(NSNotification *)note
{
	isOvertime = YES;
	[SVProgressHUD dismiss];
	[kNotification postNotificationName:kNotificationSceneVCToInfrared object:nil];
}
- (void)receviedWithSceneTimeWindow
{
	for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"ScenePickerView"]) {
			[view removeFromSuperview];
		}
	}
}
- (void)receviedWithSceneTabBarView
{
	self.tabBarView.hidden = NO;
	self.backgroundColor = [UIColor whiteColor];
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	DDLogInfo(@"3%@ UIScreenH-%f",window.subviews,UIScreenH);
}
#pragma mark - socket连接
- (void)connectionSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
}
#pragma mark - socket 发送数据
/**
 *  导航栏右边按钮事件 组帧发送数据
 */
- (void)saveClick
{
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	if (self.isSaveButtonClick) {
		
		[SVProgressTool hr_showErrorWithStatus:@"请点击完成或取消按钮之后再点击存储!"];
		return;
	}
	if (self.sceneNameField.text.length > 0) {
		
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"情景名不能为空!"];
		return;
	}
	
	NSString *pictureStr = [NSString stringWithFormat:@"%ld", (long)pictureIndex];
	NSArray *picture = @[pictureStr];
	NSMutableArray *data = [NSMutableArray array];
	
	for (int i = 0; i < self.doArray.count; i++) {//开关
		HRDOData *doData = [HRDOData mj_objectWithKeyValues:self.doArray[i]];
		//第一个字节： 0/1/2/3  ---- 分别表示 第1 2 3  4 开关
		//第二个字节： 0: 关1: 开2: 暂停, 零火/单火类型选择暂停时设置为0（关）3: 无效
		NSString *status = [NSString stringWithFormat:@"%ld%@",[doData.parameter.firstObject integerValue]- 1, self.doSwicherArray[i]];
		//第一次截取
		NSRange range = [self.doTextArray[i] rangeOfString:@"延时"];
		NSString *delay = [self.doTextArray[i] substringFromIndex:range.location + range.length];
		//第二次截取
		range = [delay rangeOfString:@"秒"];
		delay = [delay substringToIndex:range.location];
		NSArray *doArray = @[doData.did, doData.types,status, delay];
		
		[data addObject:doArray];
	}
	
	for (int i = 0; i < self.airArray.count; i++) {//空调
		IracData *iracData = [IracData mj_objectWithKeyValues:self.airArray[i]];
		
		//status存在version里面
		if ([iracData.version integerValue] < 0) {
			continue;
		}
		NSString *status = iracData.version;
		//第一次截取
		NSRange range = [self.airTextArray[i] rangeOfString:@"延时"];
		NSString *delay = [self.airTextArray[i] substringFromIndex:range.location + range.length];
		//第二次截取
		range = [delay rangeOfString:@"秒"];
		delay = [delay substringToIndex:range.location];
		NSArray *doArray = @[iracData.did, iracData.types,status, delay];
		
		[data addObject:doArray];
	}
	
	for (int i = 0; i < self.currencyArray.count; i++) {//通用红外
		IrgmData *irgmData = [IrgmData mj_objectWithKeyValues:self.currencyArray[i]];
		
		
		if ([self.gmNumberArray[i] integerValue] < 0) {
			continue;
		}
		NSString *status = self.gmNumberArray[i];
		
		//第一次截取
		NSRange range = [self.currencyTextArray[i] rangeOfString:@"延时"];
		NSString *delay = [self.currencyTextArray[i] substringFromIndex:range.location + range.length];
		//第二次截取
		range = [delay rangeOfString:@"秒"];
		delay = [delay substringToIndex:range.location];
		NSArray *doArray = @[irgmData.did, irgmData.types,status, delay];
		
		[data addObject:doArray];
	}
	
	for (int i = 0; i < self.tvArray.count; i++) {//电视
		IrgmData *tvData = [IrgmData mj_objectWithKeyValues:self.tvArray[i]];
		
		if ([self.tvNumberArray[i] integerValue] < 0) {
			continue;
		}
		NSString *status = self.tvNumberArray[i];
		
		//第一次截取
		NSRange range = [self.tvTextArray[i] rangeOfString:@"延时"];
		NSString *delay = [self.tvTextArray[i] substringFromIndex:range.location + range.length];
		//第二次截取
		range = [delay rangeOfString:@"秒"];
		delay = [delay substringToIndex:range.location];
		NSArray *doArray = @[tvData.did, tvData.types,status, delay];
		
		[data addObject:doArray];
	}
	
	NSString *str ;
	if (self.sceneData) {//更新情景
		str = [NSString stringWithSceneType:@"update" did:self.sceneData.did title:self.sceneNameField.text picture:picture data:data];
		[SVProgressTool hr_showWithStatus:@"正在更新情景模式..."];
		
	}else//创建情景
	{
		for (HRSceneData *data in self.appDelegate.sceneArray) {
			if ([data.title isEqualToString:self.sceneNameField.text]) {
				[SVProgressTool hr_showErrorWithStatus:@"有相同的情景,请修改情景名称!"];
				return;
			}
		}
		
		[SVProgressTool hr_showWithStatus:@"创建情景模式..."];
		str = [NSString stringWithSceneType:@"create" did:@"None" title:self.sceneNameField.text picture:picture data:data];
		
		DDLogInfo(@"发送创建情景%@", str);
	}
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
	}
}
#pragma mark - 内部方法
- (void)setUpViews
{
	self.isSaveButtonClick = NO;
	//文本编辑
	self.sceneNameField.delegate = self;
	DDLogError(@"%f", CGRectGetMidY(self.middleContainer.frame));
	DDLogError(@"frame%@", NSStringFromCGRect(self.middleContainer.frame));
	self.middleContainerMixY = CGRectGetMidY(self.middleContainer.frame);
	self.updateBtn.backgroundColor = [UIColor colorWithRed:105/255.0 green:181/255.0 blue:1.0 alpha:0.8];
	//设置按钮颜色
	self.doDeviceBtn.selected = YES;
	self.currentButton = self.doDeviceBtn;
	
	self.updateBtn.alpha = 1.0;
	self.iconCollectionView.delegate = self;
	self.iconCollectionView.dataSource = self;
	[self.iconCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SceneCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
	
	//	设置约束
	self.collectionEptViewH.constant = 0;
	self.textViewMinY.constant = 0;
	
	self.sceneNameField.delegate = self;
	
	self.barEptView.backgroundColor = [UIColor colorWithR:0 G:188 B:238 alpha:1.0];
	self.moveView.backgroundColor = [UIColor colorWithR:0 G:188 B:238 alpha:1.0];
	
	[self setUpShadowView:self.shadowUpView shadowOpacity:0.0 offset:8];
	[self setUpShadowView:self.shadowDownView shadowOpacity:0.0 offset:-8];
	
	//tableView
	self.scenceTableView.delegate = self;
	self.scenceTableView.dataSource = self;
	self.scenceTableView.showsVerticalScrollIndicator = YES;
	self.scenceTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.scenceTableView.rowHeight = rowH;
	self.scenceTableView.sectionFooterHeight = 0;
	self.scenceTableView.contentInset = UIEdgeInsetsMake(0, 0, self.scenceTableView.rowHeight + 80, 0);
	self.scenceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	//注册
//	[self.scenceTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SceneCell class]) bundle:nil] forCellReuseIdentifier:scenceID];
	//底部导航条
	UINavigationController *nav = (UINavigationController *)[NSObject activityViewController];
	SceneController *scene = nav.childViewControllers.lastObject;
	
	
	UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenH - 46, UIScreenW, 46)];
	tabBarView.backgroundColor = [UIColor colorWithR:219 G:219 B:219 alpha:1.0];
	[scene.view addSubview:tabBarView];
	self.tabBarView = tabBarView;
	
	// 添加导航条灰线
	UIView *lineBarView = [[UIView alloc] init];
	lineBarView.backgroundColor = [UIColor grayColor];
	[self.tabBarView addSubview:lineBarView];
	self.lineBarView = lineBarView;
	
	//往导航条添加编辑按钮
	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[editButton setBackgroundImage:[UIImage imageNamed:@"ico_edit"] forState:UIControlStateNormal];
	[editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBarView addSubview:editButton];
	self.editButton = editButton;
	
	//往导航条添加添加按钮
	UIButton *addDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[addDeviceButton setBackgroundImage:[UIImage imageNamed:@"ico_add_blue"] forState:UIControlStateNormal];
	[addDeviceButton addTarget:self action:@selector(addDeviceButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBarView addSubview:addDeviceButton];
	self.addDeviceButton = addDeviceButton;
	
	//往导航条添加完成按钮
	UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	completeButton.backgroundColor = [UIColor themeColor];
	[completeButton setTitle:@"完成" forState:UIControlStateNormal];
	completeButton.titleLabel.font = [UIFont systemFontOfSize:22];
	[completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[self.tabBarView addSubview:completeButton];
	self.completeButton = completeButton;
	_headImageViewMinY.constant = 20;
	
	//拿到导航条右边按钮
//	UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	
	for (UIView *view in scene.navigationController.navigationBar.subviews) {
		if ([view isKindOfClass:[UIButton class]] && view.hr_x > UIScreenW * 0.5) {
			DDLogWarn(@"%@", view);
			UIButton *button = (UIButton *)view;
			[button addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
		}
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
//	[self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.size.mas_equalTo(CGSizeMake(self.hr_width, 46));
//		UIWindow *window = [UIApplication sharedApplication].keyWindow;
//		make.left.equalTo(self.tempWindow);
//		make.bottom.equalTo(self.tempWindow);
//	}];
//	self.tabBarView.frame = CGRectMake(0, UIScreenH - 46, UIScreenW, 46);
	
//	self.tabBarView.backgroundColor = [UIColor redColor];
	// 导航条灰线
	[self.lineBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(self.hr_width, 1));
		make.top.equalTo(self.tabBarView);
		make.left.equalTo(self.tabBarView);
	}];
	
	// 编辑按钮
	CGFloat buttonH = 46 - 10;
	[self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(buttonH, buttonH));
		make.top.equalTo(self.tabBarView).offset(5);
		make.left.equalTo(self.tabBarView).offset(self.hr_width * 0.2);
	}];
	// 添加设备按钮
	[self.addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(buttonH, buttonH));
		make.top.equalTo(self.tabBarView).offset(5);
		make.right.equalTo(self.tabBarView).offset(- self.hr_width * 0.2);
	}];
	
	//完成按钮
	[self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.tabBarView).offset(5);
		make.left.equalTo(self.tabBarView).offset(self.hr_width *0.15);
		make.right.equalTo(self.tabBarView).offset(- self.hr_width *0.15);
		make.bottom.equalTo(self.tabBarView).offset(- 5);
	}];
	self.completeButton.layer.cornerRadius = (46 - 10) *0.5;
	self.completeButton.layer.masksToBounds = YES;
	self.completeButton.alpha = 0.0;
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	for (UIView *view in window.subviews) {
		DDLogInfo(@"view1%@",NSStringFromClass([view class]));
	}
	DDLogInfo(@"1%@ UIScreenH-%f",window.subviews,UIScreenH);
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	//记录初始值
	self.scenceNameViewMaxY = CGRectGetMaxY(self.scenceNameView.frame);
	DDLogInfo(@"2%@ UIScreenH-%f",self.tempWindow.subviews,UIScreenH);
}
#pragma mark - textField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.sceneNameField resignFirstResponder];
	return YES;
}
#pragma mark -scenceTableView delegate dataSource代理
static NSInteger section = 0;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//	 NSInteger irac = 0;
//	 NSInteger irgm1 = 0;
//	 NSInteger irgm2 = 0;
//	 NSInteger hrdo = 0;
//	
//		if (self.doArray.count > 0) {
//			hrdo = 1;
//		}
//        if (self.currencyArray.count > 0)
//		{
//			irgm2 = 1;//通用
//		}
//	    if (self.airArray.count > 0)
//		{
//			irac = 1;
//		}
//        if (self.tvArray.count > 0)
//		{
//			irgm1 = 1;
//		}
//	NSInteger total = (irac + irgm1 + irgm2 + hrdo);
//	section = total;
//	return total;
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	NSInteger index = 0;
//	if (section == 0) {
//		if (self.doArray.count > 0) {
//			index = self.doArray.count;
//		}else if (self.currencyArray.count > 0) {
//			index = self.currencyArray.count;
//		}else if (self.airArray.count > 0) {
//			index = self.airArray.count;
//		}else if (self.tvArray.count > 0) {
//			index = self.tvArray.count;
//		}
//	}else if (section == 1) {
//		
//		if (self.doArray.count > 0 && self.currencyArray.count > 0) {//如果section == 0 section 的值是doArray.count>0的情况
//			index = self.currencyArray.count;
//		}else if (self.doArray.count > 0 && self.airArray.count > 0) {
//			index = self.airArray.count;
//		}else if (self.doArray.count > 0 && self.tvArray.count > 0) {
//			index = self.tvArray.count;
//		}else if (self.currencyArray.count > 0 && self.airArray.count > 0) {//如果section == 0 section 的值是currencyArray.count>0的情况
//			index = self.airArray.count;
//		}else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
//			index = self.tvArray.count;
//		}else if (self.airArray.count > 0 && self.tvArray.count > 0) {//如果section == 0 section 的值是airArray.count>0的情况
//			index = self.tvArray.count;
//		}
//		
//	}else if (section == 2) {
//		// section=0 是doArray时的情况
//		if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
//			index = self.airArray.count;
//		}else if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.tvArray.count > 0) {
//			index = self.tvArray.count;
//		}else if (self.doArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
//			index = self.tvArray.count;
//		}
//		// section=0 是currencyArray时的情况
//		else if (self.currencyArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
//			index = self.tvArray.count;
//		}
//	}else if (section == 3) {
//		index = self.tvArray.count;
//	}
//	
//	return index;
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	DDLogInfo(@"section%ldrow%ld", indexPath.section,(long)indexPath.row);
//	SceneCell *cell = [tableView dequeueReusableCellWithIdentifier:scenceID];
//	
//	for (UIGestureRecognizer *gest in cell.contentView.gestureRecognizers ) {//删除手势
//		if ([gest isKindOfClass:[UITapGestureRecognizer class]]) {
//			[cell.contentView removeGestureRecognizer:gest];
//		}
//	}
//	
//	if (indexPath.section == 0) {
//		if (self.doArray.count > 0){
//			//开关
//			[self setDoCell:cell cellForRowAtIndexPath:indexPath];
//			
//			
//		}else if (self.currencyArray.count > 0)
//		{
//			//通用
//			[self setCurrencyTextCell: cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.airArray.count > 0)
//		{
//			//空调
//			[self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.tvArray.count > 0)
//		{
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//		}
//		
//	}else if (indexPath.section == 1)
//	{
//		if (self.doArray.count > 0 && self.currencyArray.count > 0) {
//			//如果section == 0 section 的值为doArray,section == 1为currencyArray 的情况
//			//通用
//			[self setCurrencyTextCell: cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.doArray.count > 0 && self.airArray.count > 0) {
//			//如果section == 0 section 的值为doArray,section == 1为airArray 的情况
//			//空调
//			[self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.doArray.count > 0 && self.tvArray.count > 0) {
//			//如果section == 0 section 的值为doArray,section == 1为tvArray 的情况
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//		}else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
//			//如果section == 0 section 的值为currencyArray,section == 1为airArray 的情况
//			//空调
//			[self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
//			//如果section == 0 section 的值为currencyArray,section == 1为tvArray 的情况
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.airArray.count > 0 && self.tvArray.count > 0) {
//			//如果section == 0 section 的值为airArray,section == 1为tvArray 的情况
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//		
//		}
//		
//	}else if (indexPath.section == 2)
//	{
//		if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
//			//如果section == 0 section 的值为doArray,section == 1为currencyArray,section == 2为airArray 的情况
//			//空调
//			[self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.tvArray.count > 0) {
//			//如果section == 0 section 的值为doArray,section == 1为airArray,section == 2为tvArray 的情
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}else if (self.doArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
//			//如果section == 0 section 的值为doArray,section == 1为airArray,section == 2为tvArray 的情
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}
//		// section=0 是currencyArray时的情况,section == 1为airArray,section == 2为tvArray 的情
//		else if (self.currencyArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
//			//电视
//			[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//			
//		}
//		
//	}else if (indexPath.section == 3)
//	{
//		//如果能来这里证明section 是tvArray
//		//电视
//		[self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
//	}
//	
//	return cell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return sectionHeight;
}
/// 显示每一组的组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *str;
	if (section == 0) {
		if (self.doArray.count > 0) {
			str = [NSString stringWithFormat:@"智能设备: %lu", (unsigned long)self.doArray.count];
		}else if (self.currencyArray.count > 0) {
			str = [NSString stringWithFormat:@"通用红外: %lu", (unsigned long)self.currencyArray.count];
		}else if (self.airArray.count > 0) {
			
			str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
		}else if (self.tvArray.count > 0) {
			
			str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
		}
	}else if (section == 1) {
		
		if (self.doArray.count > 0 && self.currencyArray.count > 0) {//如果section == 0 section 的值是doArray.count>0的情况
			str = [NSString stringWithFormat:@"通用红外: %lu", (unsigned long)self.currencyArray.count];
			
		}else if (self.doArray.count > 0 && self.airArray.count > 0) {
			str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
		}else if (self.doArray.count > 0 && self.tvArray.count > 0) {
			str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
		}else if (self.currencyArray.count > 0 && self.airArray.count > 0) {//如果section == 0 section 的值是currencyArray.count>0的情况
			str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
		}else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
			str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
		}else if (self.airArray.count > 0 && self.tvArray.count > 0) {//如果section == 0 section 的值是airArray.count>0的情况
			str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
		}
		
	}else if (section == 2) {
		// section=0 是doArray时的情况
		if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
			str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
		}else {
			str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
		}
	}else if (section == 3) {
		str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
	}
	
	return str;
}
/// 删除那一行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		if (self.doArray.count > 0) {
			[self.doArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.doArray forRowAtIndexPath:indexPath];
			
		}else if (self.currencyArray.count > 0)
		{
			[self.currencyArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.currencyArray forRowAtIndexPath:indexPath];
			
		}else if (self.airArray.count > 0)
		{
			[self.airArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
			
		}else if (self.tvArray.count > 0)
		{
			[self.tvArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
		}
		
	}else if (indexPath.section == 1)
	{
		if (self.doArray.count > 0 && self.currencyArray.count > 0) {
			
			//如果section == 0 section 的值为doArray,section == 1为currencyArray 的情况
			[self.currencyArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.currencyArray forRowAtIndexPath:indexPath];
			
		}else if (self.doArray.count > 0 && self.airArray.count > 0) {
			//如果section == 0 section 的值为doArray,section == 1为airArray 的情况
			[self.airArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
			
		}else if (self.doArray.count > 0 && self.tvArray.count > 0) {
			//如果section == 0 section 的值为doArray,section == 1为tvArray 的情况
			[self.tvArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
			
		}else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
			//如果section == 0 section 的值为currencyArray,section == 1为airArray 的情况
			[self.airArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
			
		}else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
			//如果section == 0 section 的值为currencyArray,section == 1为tvArray 的情况
			[self.tvArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
			
		}else if (self.airArray.count > 0 && self.tvArray.count > 0) {
			//如果section == 0 section 的值为airArray,section == 1为tvArray 的情况
			[self.tvArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
		}
		
	}else if (indexPath.section == 2)
	{
		if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
			//如果section == 0 section 的值为doArray,section == 1为currencyArray,section == 2为airArray 的情况
			[self.airArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
			
		}else if (self.doArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
			
			//如果section == 0 section 的值为doArray,section == 1为airArray,section == 2为tvArray 的情
			[self.tvArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
		}
		// section=0 是currencyArray时的情况,section == 1为airArray,section == 2为tvArray 的情
		else if (self.currencyArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
			[self.tvArray removeObjectAtIndex:indexPath.row];
			[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
		}
		
	}else if (indexPath.section == 3)
	{
		//如果能来这里证明section 是tvArray
		[self.tvArray removeObjectAtIndex:indexPath.row];
		[self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
	}
	
	
	[self.scenceTableView reloadData];
}
- (void)tableView:(UITableView *)tableView array:(NSArray *)array forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (array.count > 0) {
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}else
	{
		[tableView reloadData];
		//		NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
		//		[tableView reloadSections:set withRowAnimation:UITableViewRowAnimationLeft];
		//		NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
		//		[tableView deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
	}
}
/// 左滑显示删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	ScenePickerView *picker = [ScenePickerView scenePickerView];
	//给picker titlelabel传值
	if (indexPath.section == 0) {
		if (self.doArray.count > 0) {
			[self setDoPicker:picker cellForRowAtIndexPath:indexPath];
		}else if (self.currencyArray.count > 0)
		{
			[self setCurrencyPicker:picker cellForRowAtIndexPath:indexPath];
		}else if (self.airArray.count > 0)
		{
			[self setAirPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else if (self.tvArray.count > 0)
		{
			[self setTvPicker:picker cellForRowAtIndexPath:indexPath];
		}
		
	}else if (indexPath.section == 1)
	{
		if (self.doArray.count > 0 && self.currencyArray.count > 0) {
			[self setCurrencyPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else if (self.doArray.count > 0 && self.airArray.count > 0) {
			[self setAirPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else if (self.doArray.count > 0 && self.tvArray.count > 0) {
			[self setTvPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
			[self setAirPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
			[self setTvPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else if (self.airArray.count > 0 && self.tvArray.count > 0) {
			[self setTvPicker:picker cellForRowAtIndexPath:indexPath];
		}
		
	}else if (indexPath.section == 2)
	{
		if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
			[self setAirPicker:picker cellForRowAtIndexPath:indexPath];
			
		}else {
			[self setTvPicker:picker cellForRowAtIndexPath:indexPath];
		}
		
	}else if (indexPath.section == 3)
	{
		//如果能来这里证明section 是tvArray
		[self setTvPicker:picker cellForRowAtIndexPath:indexPath];
	}
	
	picker.frame = CGRectMake(0, 64, UIScreenW, UIScreenH - 64);
	[[UIApplication sharedApplication].keyWindow addSubview:picker];
	self.picker = picker;
}


#pragma mark - 设置  tabelviewcell
/// 设置开关cell
- (void)setDoCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dict = self.doArray[indexPath.row];
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict];
	
	if ([data.picture.firstObject isEqualToString:@"1"] ||[data.picture.firstObject isEqualToString:@"2"] ||[data.picture.firstObject isEqualToString:@"4"] ||[data.picture.firstObject isEqualToString:@"3"]) {//插座,开关
		cell.switchType = DVSwitchTypeDoDevice;
		NSArray *array = @[@"关",@"翻转",@"开"];
		[cell setUpCellUIWithArray:array];
	}else if ([data.picture.firstObject isEqualToString:@"5"]) {//窗帘
		cell.switchType = DVSwitchTypeWindowDevice;
		NSArray *array = @[@"关",@"停止",@"开"];
		[cell setUpCellUIWithArray:array];
	}
	cell.doData = data;
	
	__weak typeof (self) weakSelf = self;
	[cell sceneCellWithBlock:^(NSInteger index) {
		__strong typeof (self) strongSelf = weakSelf;
		NSString *str = [NSString stringWithFormat:@"%ld", (long)index];
		NSLog(@"row-%ld",indexPath.row);
		strongSelf.doSwicherArray[indexPath.row] = str;
		
		HRDOData *data = [HRDOData mj_objectWithKeyValues:strongSelf.doArray[indexPath.row]];
		NSMutableArray *arr = (NSMutableArray *)data.parameter;
		arr[2] = str;
		data.parameter = arr;
		
		strongSelf.doArray[indexPath.row] = data;
		
	}];
		cell.titleLabel.text = data.parameter[1];
		cell.detailLabel.text = self.doTextArray[indexPath.row];
}
///设置空调cell
- (void)setAirTextCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	cell.switchType = DVSwitchTypeAirDevice;
	NSDictionary *dict = self.airArray[indexPath.row];
	IracData *data = [IracData mj_objectWithKeyValues:dict];
	NSString *str ;
	if ([data.version integerValue] >= 0) {
		
		NSString *status = [self setupStatusWithStatus:data.version];
		str = [NSString stringWithFormat:@"%@", status];
	}else
	{
		str = @"无效按键";
	}
	NSArray *array = @[str];
	[cell setUpCellUIWithArray:array];
	cell.titleLabel.text = data.title;
	cell.detailLabel.text = self.airTextArray[indexPath.row];
}
///设置通用cell
- (void)setCurrencyTextCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof (self) weakSelf = self;
	[cell sceneCellWithPickerBlock:^(NSString *nameKey, NSString *numberKey) {
		if (![nameKey isEqualToString:@""]) {//传过来的值有可能为空
			weakSelf.gmPickerArray[indexPath.row] = nameKey;
			weakSelf.gmNumberArray[indexPath.row] = numberKey;
		}
		[weakSelf.scenceTableView reloadData];
	}];
	cell.switchType = DVSwitchTypeCurrencyDeviceAndTvDevice;
	NSArray *array = @[self.gmPickerArray[indexPath.row]];
	[cell setUpCellUIWithArray:array];
	
	NSDictionary *dict = self.currencyArray[indexPath.row];
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
	cell.gmData  = data;
	cell.titleLabel.text = data.title;
	cell.detailLabel.text = self.currencyTextArray[indexPath.row];
}
///设置TV cell
- (void)setTvTextCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof (self) weakSelf = self;
	[cell sceneCellWithPickerBlock:^(NSString *nameKey, NSString *numberKey) {
		if (![nameKey isEqualToString:@""]) {//传过来的值有可能为空
			weakSelf.tvPickerArray[indexPath.row] = nameKey;
			weakSelf.tvNumberArray[indexPath.row] = numberKey;
		}
		[weakSelf.scenceTableView reloadData];
	}];
	
	cell.switchType = DVSwitchTypeCurrencyDeviceAndTvDevice;
	NSArray *array = @[self.tvPickerArray[indexPath.row]];
	[cell setUpCellUIWithArray:array];
	
	NSDictionary *dict = self.tvArray[indexPath.row];
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
	cell.gmData = data;
	cell.titleLabel.text = data.title;
	cell.detailLabel.text = self.tvTextArray[indexPath.row];
}

- (NSString *)setupStatusWithStatus:(NSString *)status
{
	NSString *str;
	switch ([status intValue]) {
		case 0:
			str = @"关";
			break;
		case 1:
			str = @"开";
			break;
		case 2:
			str = @"自动模式";
			break;
		case 3://无效
			
			break;
		case 4:
			str = @"制冷模式";
			break;
		case 5:
			str = @"除湿模式";
			break;
		case 6:
			str = @"送风模式";
			break;
		case 7:
			str = @"制暖模式";
			break;
		case 8:
			str = @"自动风速";
			break;
		case 9:
			str = @"风速1档";
			break;
		case 10:
			str = @"风速2档";
			break;
		case 11:
			str = @"风速3档";
			break;
		case 12:
			str = @"自动摆风";
			break;
		case 13:
			str = @"手动摆风";
			break;
		case 14://无效
			
			break;
		case 15://无效
			
			break;
		case 16:
			str = @"温度16℃";
			break;
		case 17:
			str = @"温度17℃";
			break;
		case 18:
			str = @"温度18℃";
			break;
		case 19:
			str = @"温度19℃";
			break;
		case 20:
			str = @"温度20℃";
			break;
		case 21:
			str = @"温度21℃";
			break;
		case 22:
			str = @"温度22℃";
			break;
		case 23:
			str = @"温度23℃";
			break;
		case 24:
			str = @"温度24℃";
			break;
		case 25:
			str = @"温度25℃";
			break;
		case 26:
			str = @"温度26℃";
			break;
		case 27:
			str = @"温度27℃";
			break;
		case 28:
			str = @"温度28℃";
			break;
		case 29:
			str = @"温度29℃";
			break;
		case 30:
			str = @"温度30℃";
			break;
		default:
			break;
	}
	return str;
}
/// 设置选中时cell的滑块转态
- (void)setDoTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof (self) weakSelf = self;
	[picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
		__strong typeof (self) strongSelf = weakSelf;
		strongSelf.seconds = seconds;
		strongSelf.everyMinute = everyMinute;
		
		//判断
		
		strongSelf.doTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
	
		
		[strongSelf.scenceTableView reloadData];
	}];
}
- (void)setCurrencyTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof (self) weakSelf = self;
	[picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
		__strong typeof (self) strongSelf = weakSelf;
		strongSelf.seconds = seconds;
		strongSelf.everyMinute = everyMinute;
		
		//判断
		
		strongSelf.currencyTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
		
		
		[strongSelf.scenceTableView reloadData];
	}];
}
- (void)setAirTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof (self) weakSelf = self;
	[picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
		__strong typeof (self) strongSelf = weakSelf;
		strongSelf.seconds = seconds;
		strongSelf.everyMinute = everyMinute;
		
		//判断
		strongSelf.airTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
		
		
		[strongSelf.scenceTableView reloadData];
	}];
}
- (void)setTvTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof (self) weakSelf = self;
	[picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
		__strong typeof (self) strongSelf = weakSelf;
		strongSelf.seconds = seconds;
		strongSelf.everyMinute = everyMinute;
		
		//判断
		strongSelf.tvTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
		
		[strongSelf.scenceTableView reloadData];
	}];
}
//- (void)setTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	__weak typeof (self) weakSelf = self;
//	[picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
//		__strong typeof (self) strongSelf = weakSelf;
//		strongSelf.seconds = seconds;
//		strongSelf.everyMinute = everyMinute;
//		
//		//判断
//		switch (indexPath.section) {
//			case 0:
//			{
//				strongSelf.doTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
//			}
//    
//    break;
//			case 1:
//			{
//				strongSelf.currencyTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
//			}
//    
//    break;
//			case 2:
//			{
//				strongSelf.airTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
//			}
//    
//    break;
//			case 3:
//			{
//				strongSelf.tvTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
//			}
//    
//    break;
//				
//			default:
//    break;
//		}
//		
//		[strongSelf.scenceTableView reloadData];
//	}];
//}
#pragma mark - 设置picker titleLabel
/// 设置开关picker
- (void)setDoPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.doArray[indexPath.row];
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict];
	picker.titleLabel.text = data.parameter[1];
	[self setDoTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}
/// 设置空调picker
- (void)setAirPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.airArray[indexPath.row];
	IracData *data = [IracData mj_objectWithKeyValues:dict];
	picker.titleLabel.text = data.title;
	[self setAirTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}
/// 设置通用picker
- (void)setCurrencyPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.currencyArray[indexPath.row];
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
	picker.titleLabel.text = data.title;
	[self setCurrencyTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}

/// 设置TVpicker
- (void)setTvPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.tvArray[indexPath.row];
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
	picker.titleLabel.text = data.title;
	[self setTvTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	/* 先判断是否是点击了按钮的scrollView滚动,如果是就判断滚动的偏移量是否大于0(大于0就是往下滚动),如果大于0就让中间的view定在固定的高度,如果小于0就让此view跟着上面的所有view一起偏移, 但self.headImageViewMinY.constant > 20时,让headImageViewMinY定在20这个位置
	*/
	DDLogInfo(@"contentOffset1-%f", scrollView.contentOffset.y);
	if (isResetMiddleBar) {
		
		if (scrollView.contentOffset.y > 0) {
			self.headImageViewMinY.constant = - self.scenceNameViewMaxY +20;
			
			
		}else{
			
			
			self.headImageViewMinY.constant =  self.headImageViewMinY.constant - scrollView.contentOffset.y ;
			self.currentButton.selected = NO;
			self.doDeviceBtn.selected = YES;
			self.currentButton = self.doDeviceBtn;
			
			if (self.headImageViewMinY.constant > 20) {
				self.headImageViewMinY.constant = 20;
				//让tableview恢复到正常的滚动
				isResetMiddleBar = NO;
			}
			
		}
		
	}else{
		DDLogWarn(@"contentOffset2-%f", scrollView.contentOffset.y);
		
		DDLogWarn(@"headImageViewMinY-%f", self.headImageViewMinY.constant);
		
		
		if (scrollView.contentOffset.y > 0) {
			
			self.headImageViewMinY.constant =  self.headImageViewMinY.constant - scrollView.contentOffset.y;
		DDLogWarn(@"headImageViewMinY-%f", self.headImageViewMinY.constant);
			if (self.headImageViewMinY.constant < - self.scenceNameViewMaxY +20) {
				self.headImageViewMinY.constant = - self.scenceNameViewMaxY +20 ;
			}
		}else
		{
			self.headImageViewMinY.constant =  self.headImageViewMinY.constant - scrollView.contentOffset.y ;
			if (self.headImageViewMinY.constant > 20) {
				self.headImageViewMinY.constant = 20;
				isResetMiddleBar = NO;
			}
		}
	}
	
}

/// 设置view阴影
- (void)setUpShadowView:(UIView *)view shadowOpacity:(CGFloat)shadowOpacity offset:(CGFloat)offset
{
	view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
	view.layer.shadowColor = [UIColor blackColor].CGColor;
	view.layer.shadowOffset = CGSizeMake(0, offset);
	view.layer.shadowOpacity = shadowOpacity;
}

#pragma mark - UI事件
/// 完成按钮事件
- (void)completeButtonClick
{
	//让tableview退出编辑状态
	[self.scenceTableView setEditing:NO animated:YES];
	//显示view
	[self rightViewIsHidden:NO];
	//设置按钮动画
	[UIView animateWithDuration:1.0 animations:^{
		[self.completeButton setTitle:@"..." forState:UIControlStateNormal];
		self.completeButton.layer.transform = CATransform3DMakeScale(0.0001, 1.0, 0.0001);
	} completion:^(BOOL finished) {
		self.completeButton.alpha = 0.0;
		
	} ];
}
/// 编辑按钮事件
- (void)editButtonClick
{
	[self.scenceTableView setEditing:NO animated:YES];
	
	DDLogInfo(@"%d", self.scenceTableView.isEditing);
	//让tableview进入编辑状态
	[self.scenceTableView setEditing:!self.scenceTableView.isEditing animated:YES];
	//隐藏view
	[self rightViewIsHidden:YES];
	//设置按钮动画
	self.completeButton.alpha = 1.0;
	[self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
	self.completeButton.layer.transform = CATransform3DMakeScale(0.00001, 1.0, 0.0001);
	[UIView animateWithDuration:1.0 animations:^{
	self.completeButton.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0001);
	}];
	
}
/// 显示或隐藏view
- (void)rightViewIsHidden:(BOOL)hidden
{
	for (UIView *view in self.scenceTableView.subviews) {
	if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]) {
		
		for (UIView *cellView in view.subviews) {
			UIView *rightView = [cellView valueForKeyPath:@"rightView"];
			DDLogWarn(@"objc%@",rightView);
			rightView.hidden = hidden;
		}
	}
}
}
/// 添加设备按钮事件
- (void)addDeviceButtonClick
{
	self.tabBarView.hidden = YES;
	SceneModellView *modellView = [SceneModellView shareSceneModellView];
	//block回调
	__weak typeof (self) weakSelf = self;
	[modellView sceneModellViewSendTableViewWithBlock:^(NSArray *doArray, NSArray *currencyArray, NSArray *airArray, NSArray *tvArray) {
		__strong typeof (self) strongSelf = weakSelf;
		//让tableview 回到顶部, moveView回到第一个按钮位置
		[strongSelf setUpDeviceBtn:strongSelf.doDeviceBtn];
		[strongSelf.scenceTableView setContentOffset:CGPointMake(0, 0)];
		strongSelf.headImageViewMinY.constant = 20;
		for (id object in doArray) {
			[strongSelf.doArray addObject:object];
			[strongSelf.sceneArray addObject:object];
			//初始化延时时间数组
			NSString *str = @"延时0.0秒";
			[strongSelf.doTextArray addObject:str];
			HRDOData *data = [HRDOData mj_objectWithKeyValues:object];
			//初始化滑块状态数组
			NSString *swicherStr = data.parameter.lastObject;
			if ([swicherStr isEqualToString:@"255"]) {
			
				swicherStr = @"3";
			}
			[strongSelf.doSwicherArray addObject:swicherStr];
		}
		for (id object in currencyArray) {
			[strongSelf.currencyArray addObject:object];
			[strongSelf.sceneArray addObject:object];
			//初始化延时时间数组
			NSString *str = @"延时0.0秒";
			[strongSelf.currencyTextArray addObject:str];
			//初始化picker文字数组
			NSString *textPicker = @"未选择操作";
			[strongSelf.gmPickerArray addObject:textPicker];
			//初始化按键数字数组
			NSString *number = @"-1";
			[strongSelf.gmNumberArray addObject:number];
		}
		for (id object in airArray) {
			[strongSelf.airArray addObject:object];
			[strongSelf.sceneArray addObject:object];
			
			NSString *str = @"延时0.0秒";
			[strongSelf.airTextArray addObject:str];
		}
		for (id object in tvArray) {
			[strongSelf.tvArray addObject:object];
			[strongSelf.sceneArray addObject:object];
			
			NSString *str = @"延时0.0秒";
			[strongSelf.tvTextArray addObject:str];
			//初始化picker文字数组
			NSString *textPicker = @"未选择操作";
			[strongSelf.tvPickerArray addObject:textPicker];
			//初始化按键数字数组
			NSString *number = @"-1";
			[strongSelf.tvNumberArray addObject:number];
		}
		
		[strongSelf.scenceTableView reloadData];
	}];
	
	
	modellView.frame = self.bounds;
	[self.contentView addSubview:modellView];
	
	//设置背景色
	[UIView animateWithDuration:0.5 animations:^{
		self.backgroundColor = [UIColor colorWithR:178 G:178 B:178 alpha:1.0];
		self.headImageViewMinY.constant = 20 ;
		[self layoutIfNeeded];
	}];

}
/**
 *  中间的条是否恢复到中间
 */
static BOOL isResetMiddleBar = NO;
//tag 10 智能设备 11通用红外 12空调 13电视
- (IBAction)deviceBtnClick:(UIButton *)sender {
	isResetMiddleBar = YES;
	self.currentButton.selected  = NO;
	sender.selected = YES;
	
	self.currentButton = sender;
	if (sender.tag == 10) {//智能设备
		[self setUpDeviceBtn:sender];
		[self.scenceTableView setContentOffset:CGPointMake(0, 0) animated:YES];
		
		
	}else if (sender.tag == 11) {//通用红外
		[self setUpDeviceBtn:sender];
		
		CGFloat rowY = 0.0;
		if (self.currencyArray.count > 0) {
			
			//判断有多少组
			if (section == 1) {
				rowY = 0.0;
			}else if (section >= 2) {//如果有两组
				
				if (self.doArray.count > 0)
				{
					rowY = self.doArray.count * rowH +sectionHeight;
					
				}
			}
			[self.scenceTableView setContentOffset:CGPointMake(0, rowY) animated:YES];
		}else
		{
			
			rowY = [self setupEptTabelView];
			
			[self.scenceTableView setContentOffset:CGPointMake(0, rowY) animated:YES];
		}
		
	}else if (sender.tag == 12) {//tag  空调
		[self setUpDeviceBtn:sender];
		
		CGFloat rowY = 0.0;
		if (self.airArray.count > 0) {
			
			//判断有多少组
			if (section == 1) {
				rowY = 0.0;
			}else if (section == 2) {//如果有两组
				
				if (self.doArray.count > 0)
				{
				   rowY = self.doArray.count * rowH +sectionHeight;
					
				}else if (self.currencyArray.count > 0) {
					rowY = self.currencyArray.count * rowH +sectionHeight;
				}
			}else if (section == 3) {//如果有3组
				
				if (self.doArray.count > 0)
				{
					rowY = self.doArray.count * rowH +sectionHeight;
					
				}
				if (self.currencyArray.count > 0) {
					rowY += self.currencyArray.count * rowH +sectionHeight;
				}
			}else if (section == 4) {//如果有3组
				
				if (self.doArray.count > 0)
				{
					rowY = self.doArray.count * rowH +sectionHeight;
					
				}
				if (self.currencyArray.count > 0) {
					rowY += self.currencyArray.count * rowH +sectionHeight;
				}
			}
			
			[self.scenceTableView setContentOffset:CGPointMake(0, rowY) animated:YES];
		}else
		{
			rowY = [self setupEptTabelView];
			
			[self.scenceTableView setContentOffset:CGPointMake(0, rowY) animated:YES];
		}
	}else if (sender.tag == 13) {//tag  电视
		[self setUpDeviceBtn:sender];
		
		CGFloat rowY = 0.0;
		if (self.tvArray.count > 0) {
			
			//判断有多少组
			if (section == 1) {
				rowY = 0.0;
			}else if (section == 2) {//如果有两组
				
				if (self.doArray.count > 0)
				{
					rowY = self.doArray.count * rowH +sectionHeight;
					
				}else if (self.currencyArray.count > 0) {
					rowY = self.currencyArray.count * rowH +sectionHeight;
				}else if (self.airArray.count > 0) {
					rowY = self.airArray.count * rowH +sectionHeight;
				}
				
			}else if (section == 3) {//如果有3组
				
				if (self.doArray.count > 0)
				{
					rowY = self.doArray.count * rowH +sectionHeight;
					
				}
				if (self.currencyArray.count > 0) {
					rowY += self.currencyArray.count * rowH +sectionHeight;
				}
				if (self.airArray.count > 0) {
					rowY += self.airArray.count * rowH +sectionHeight;
				}
			}else if (section == 4) {//如果有3组
				
				if (self.doArray.count > 0)
				{
					rowY = self.doArray.count * rowH +sectionHeight;
					
				}
				if (self.currencyArray.count > 0) {
					rowY += self.currencyArray.count * rowH +sectionHeight;
				}
				if (self.airArray.count > 0) {
					rowY += self.airArray.count * rowH +sectionHeight;
				}
			}
			
			[self.scenceTableView setContentOffset:CGPointMake(0, rowY) animated:YES];
		}else
		{
			rowY = [self setupEptTabelView];
			
			[self.scenceTableView setContentOffset:CGPointMake(0, rowY) animated:YES];
		}
	}
}
/**
 *  但数组为空时的滚动偏移量
 */
- (CGFloat)setupEptTabelView
{
	CGFloat rowY = 0.0;
	if (self.doArray.count > 0)
	{
		rowY += self.doArray.count * rowH +sectionHeight;
		
	}
	if (self.currencyArray.count > 0) {
		rowY += self.currencyArray.count * rowH +sectionHeight;
	}
	
	if (self.airArray.count > 0) {
		rowY += self.airArray.count * rowH +sectionHeight;
	}
	if (self.tvArray.count > 0) {
		rowY += self.tvArray.count * rowH +sectionHeight;
	}
	return rowY;
}
//设置按钮移动view的center
- (void)setUpDeviceBtn:(UIButton *)btn
{
	CGFloat centerX = btn.hr_centerX;
	[UIView animateWithDuration:0.5 animations:^{
		
		self.headImageViewMinY.constant = - self.scenceNameViewMaxY +20 ;
		
		[self layoutIfNeeded];
	
	}];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		//让选项卡 置顶
		[UIView animateWithDuration:0.5 animations:^{
			
			self.moveView.hr_centerX = centerX;
		} completion:^(BOOL finished) {
			[self.moveView.layer removeAllAnimations];
		}];
	});
}


- (IBAction)updateBtnClick:(UIButton *)sender {
	//退出键盘
	[self endEditing:NO];
	
	[UIView animateWithDuration:1.0 animations:^{
		self.collectionEptViewH.constant = 200;
		self.updateBtn.alpha = 0.0;
		[self setUpShadowView:self.shadowUpView shadowOpacity:1.0 offset:8];
		[self setUpShadowView:self.shadowDownView shadowOpacity:1.0 offset:-4];
		
	} completion:^(BOOL finished) {
		
	}];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.iconArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	SceneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
	
	cell.sceneImage.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
	
	
	return cell;
}
 //记录图片下标
static NSInteger pictureIndex = 1;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	//退出键盘
	[self endEditing:NO];
	//记录图片下标
	pictureIndex = indexPath.row + 1;
	self.iconImageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
	// 不显示Collection
	[self isHiddenWithCollection];
}

/// 不显示CollectionView
- (void)isHiddenWithCollection
{
	[UIView animateWithDuration:1 animations:^{
		self.collectionEptViewH.constant = 0;
		self.textViewMinY.constant = 0;
		self.updateBtn.alpha = 1.0;
		[self setUpShadowView:self.shadowUpView shadowOpacity:0.0 offset:8];
		[self setUpShadowView:self.shadowDownView shadowOpacity:0.0 offset:-8];
		
	} completion:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self isHiddenWithCollection];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[self endEditing: NO];
}

@end
