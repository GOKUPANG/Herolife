//
//  SceneModellView.m
//  xiaorui
//
//  Created by sswukang on 16/7/5.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneModellView.h"
#import "AppDelegate.h"
#import "HRDOData.h"
#import "IracData.h"
#import "IrgmData.h"
#import "HRSceneData.h"
#import <MJExtension.h>
#import "SceneAirController.h"
#import "SceneController.h"


@interface SceneModellView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *line5View;
@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** UITableView */
@property(nonatomic, weak) UITableView *doTableView ;
@property(nonatomic, weak) UITableView *currencyTableView ;
@property(nonatomic, weak) UITableView *airTableView;
@property(nonatomic, weak) UITableView *tvTableView ;
/** UIButton */
@property(nonatomic, weak) UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIButton *airButton;
@property (weak, nonatomic) IBOutlet UIButton *tvButton;
/** UIView */
@property(nonatomic, weak) UIView *bottomView;
/** 底部导航条顶部灰心 */
@property(nonatomic, weak) UIView *lineBarView;
/** 底部导航条中间灰心 */
@property(nonatomic, weak) UIView *middleLineBarView;
@property(nonatomic, weak) UIButton *cancelButton;
@property(nonatomic, weak) UIButton *completeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fistViewH;
@property (weak, nonatomic) IBOutlet UIView *fistView;
/** UITableView */
@property(nonatomic, weak) UITableView *currentTableView;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *doArray;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *currencyArray;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *airArray;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *tvArray;

/** -------------------------------保存打钩数据 -----------------------------------------*/
/** 保存打钩开关数据 */
@property(nonatomic, strong) NSMutableArray *doSaveArray;
/** 保存打钩通用数据 */
@property(nonatomic, strong) NSMutableArray *currencySaveArray;
/** 保存打钩空调数据 */
@property(nonatomic, strong) NSMutableArray *airSaveArray;
/** 保存打钩电视数据 */
@property(nonatomic, strong) NSMutableArray *tvSaveArray;
/** cell上自定义UILabel */
@property(nonatomic, weak) UILabel *currencyLabel;
/** cell上自定义UILabel */
@property(nonatomic, weak) UILabel *airLabel;
/** cell上自定义UILabel */
@property(nonatomic, weak) UILabel *tvLabel;
/* */
@property(nonatomic, assign) CGFloat airButtonX;
/** <#是否连接#> */
@property(nonatomic, assign) BOOL isCenter;

@end

@implementation SceneModellView
#pragma mark - 懒加载
- (NSMutableArray *)doArray
{
	if (!_doArray) {
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

//保存打钩数据
- (NSMutableArray *)doSaveArray
{
	if (!_doSaveArray) {
		_doSaveArray = [NSMutableArray array];
		
	}
	return _doSaveArray;
}
- (NSMutableArray *)currencySaveArray
{
	if (!_currencySaveArray) {
		_currencySaveArray = [NSMutableArray array];
	}
	return _currencySaveArray;
}
- (NSMutableArray *)airSaveArray
{
	if (!_airSaveArray) {
		_airSaveArray = [NSMutableArray array];
	}
	return _airSaveArray;
}

- (NSMutableArray *)tvSaveArray
{
	if (!_tvSaveArray) {
		_tvSaveArray = [NSMutableArray array];
	}
	return _tvSaveArray;
}

- (UIView *)bottomView
{
	if (!_bottomView) {
		UIView *bottomView = [[UIView alloc] init];
		bottomView.backgroundColor = [UIColor colorWithR:219 G:219 B:219 alpha:1.0];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[window addSubview:bottomView];
		_bottomView = bottomView;
	}
	return _bottomView;
}
#pragma mark - 头
+ (SceneModellView *)shareSceneModellView
{
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
	[super awakeFromNib];
	//初始化UI
	[self setupViews];
	//拿到单例数据
	[self getHomeHTTPRequest];
	//通知
	[kNotification addObserver:self selector:@selector(bottomViewHidden) name:kNotificationSceneAirDismiss object:nil];
	[kNotification addObserver:self selector:@selector(SceneLine5CenterToAirButtonCenter) name:kNotificationSceneLine5Center object:nil];
	[kNotification postNotificationName:kNotificationSceneIsYesSaveButtonClick object:nil];
	isSelectAll = NO;
	
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	[self deviceBtnClick:self.doButton];
}
- (void)layoutSubviews
{
	[super layoutSubviews];
	
//    [self setNeedsDisplay];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
	[self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(UIScreenW, 46));
		make.left.equalTo(self);
		make.bottom.equalTo(self);
	}];
	// 导航条顶部灰线
	[self.lineBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(self.hr_width, 1));
		make.top.equalTo(self.bottomView);
		make.left.equalTo(self.bottomView);
	}];
	// 导航条中间灰线
	[self.middleLineBarView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(1, 46));
		make.top.equalTo(self.bottomView);
		make.centerX.equalTo(self.bottomView);
	}];
	// 编辑按钮
	CGFloat buttonH = 46 - 10;
	[self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(buttonH, buttonH));
		make.top.equalTo(self.bottomView).offset(5);
		make.left.equalTo(self.bottomView).offset(self.hr_width * 0.2);
	}];
	// 添加设备按钮
	[self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(buttonH, buttonH));
		make.top.equalTo(self.bottomView).offset(5);
		make.right.equalTo(self.bottomView).offset(- self.hr_width * 0.2);
	}];
	
}

- (void)setupViews
{
	self.isCenter = NO;
	self.airButtonX = self.airButton.hr_x;
	self.backgroundColor = [UIColor clearColor];
	//设置两根线的颜色
	self.line1View.backgroundColor = [UIColor themeColor];
	self.line5View.backgroundColor = [UIColor themeColor];
	
	//scrollView
	self.scrollView.pagingEnabled = YES;
	CGRect sRect = self.scrollView.frame;
	sRect.size.width = UIScreenW;
	self.scrollView.frame = sRect;
	self.scrollView.delegate = self;
	self.scrollView.tag = 10;
	
	CGSize size = self.scrollView.contentSize;
	size.width = UIScreenW *4;
	self.scrollView.contentSize = size;
	
	//开关tableView
	UITableView *doTableView = [self addTableViewWithFrame:self.scrollView.frame tag:0];
	self.doTableView = doTableView;
	DDLogInfo(@"frame%@",NSStringFromCGRect(self.scrollView.frame));
	//通用tableView
	CGRect currencyRect = self.scrollView.frame;
	currencyRect.origin.x = self.scrollView.hr_width;
	UITableView *currencyTableView = [self addTableViewWithFrame:currencyRect tag:1];
	self.currencyTableView = currencyTableView;
	//空调tableView
	currencyRect.origin.x = self.scrollView.hr_width *2;
	UITableView *airTableView = [self addTableViewWithFrame:currencyRect tag:2];
	self.airTableView = airTableView;
	//电视tableView
	currencyRect.origin.x = self.scrollView.hr_width *3;
	UITableView *tvTableView = [self addTableViewWithFrame:currencyRect tag:3];
	self.tvTableView = tvTableView;
	
	//按钮默认选中第一个
	self.doButton.selected = YES;
	self.currentButton = self.doButton;
	
	// 添加导航条顶部灰线
	UIView *lineBarView = [[UIView alloc] init];
	lineBarView.backgroundColor = [UIColor grayColor];
	[self.bottomView addSubview:lineBarView];
	self.lineBarView = lineBarView;
	// 添加导航条中间灰线
	UIView *middleLineBarView = [[UIView alloc] init];
	middleLineBarView.backgroundColor = [UIColor grayColor];
	[self.bottomView addSubview:middleLineBarView];
	self.middleLineBarView = middleLineBarView;
	//底部按钮
	self.cancelButton = [self setupButtonWithTitle:@"取消" sel:@selector(cancelButtonClick)];
	self.completeButton = [self setupButtonWithTitle:@"完成" sel:@selector(completeButtonClick)];
	//动画弹出
	self.currentTableView = self.doTableView;
	
}

#pragma mark - 通知
- (void)SceneLine5CenterToAirButtonCenter
{
	self.isCenter = YES;
	
	
}

/**
 *  收到通知之后让bottomView显示
 */
- (void)bottomViewHidden
{
    [self setNeedsLayout];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		self.bottomView.hidden = NO;
        NSLog(@"self.bottomView.frame%@", NSStringFromCGRect(self.bottomView.frame));
	});
    
}
- (void)dealloc
{
	[kNotification removeObserver:self];
}
#pragma mark - HTTP数据
- (void)getHomeHTTPRequest
{
	
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[self.doArray removeAllObjects];
	[self.airArray removeAllObjects];
	[self.currencyArray removeAllObjects];
	[self.tvArray removeAllObjects];
	
	//添加空调
	NSMutableArray *iracArr = app.iracArray;
	for (IracData *data in iracArr) {
		
		data.version = @"-1";
		[self.airArray addObject:data];
	}
	//添加通用
	NSMutableArray *irgmArray = app.irgmArray;
	
	for (IrgmData *data in irgmArray) {
		if ([data.picture.firstObject isEqualToString:@"1"]) {//电视
			[self.tvArray addObject:data];
		}else if ([data.picture.firstObject isEqualToString:@"2"])//通用
		{
			[self.currencyArray addObject:data];
		}
	}
	//添加开关
	NSMutableArray *doArray = app.doArray;
	for (HRDOData *data in doArray) {
		//拆开 开关  每一路添加
		[self addDoDataArrayWithFirstObject:data];
	}
	
	[self.tvTableView reloadData];
	[self.doTableView reloadData];
	[self.airTableView reloadData];
	[self.currencyTableView reloadData];
	
	
}

//拆开 开关  每一路添加
- (void)addDoDataArrayWithFirstObject:(HRDOData *)data
{
	NSDictionary *dictData = (NSDictionary *)data;
	DDLogWarn(@"-----dict%@", dictData);
	HRDOData *doData = [HRDOData mj_objectWithKeyValues:dictData];
	if ([doData.parameter.firstObject isEqualToString:@"1"]) {
		
		DDLogError(@"1%@", data.parameter.firstObject);
		//添加第一路
		NSArray *dataArr = doData.parameter;
		NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
		doData.parameter = parameterArr1;
		[self.doArray addObject:doData];
		
	}else if ([doData.parameter.firstObject isEqualToString:@"2"])
	{
		DDLogError(@"2%@", data.parameter.firstObject);
		//添加第一路
		HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *data1Arr = newData.parameter;
		NSArray *parameter1Arr1 = @[@"1", data1Arr[2], data1Arr[3]];
		newData.parameter = parameter1Arr1;
		[self.doArray addObject:newData];
		DDLogInfo(@"dataArr23%@ %@", data1Arr[2],data1Arr[3]);
		//添加第二路
		HRDOData *newData2 = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr2 = [newData2 valueForKeyPath:@"parameter"];
		NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
		DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
		//把前面值的覆盖了
		[newData2 setValue:parameterArr2 forKeyPath:@"parameter"];
		[self.doArray addObject:newData2];
	}else if ([data.parameter.firstObject isEqualToString:@"3"])
	{
		DDLogError(@"3%@", data.parameter.firstObject);
		//添加第一路
		HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr = newData.parameter;
		NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
		newData.parameter = parameterArr1;
		[self.doArray addObject:newData];
		
		//添加第二路
		HRDOData *doData2 = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr2 = [doData2 valueForKeyPath:@"parameter"];
		NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
		DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
		//把前面值的覆盖了
		[doData2 setValue:parameterArr2 forKeyPath:@"parameter"];
		[self.doArray addObject:doData2];
		
		//添加第三路
		HRDOData *doData3 = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr3 = [doData3 valueForKeyPath:@"parameter"];
		NSArray *parameterArr3 = @[@"3", dataArr3[6], dataArr3[7]];
		//把前面值的覆盖了
		[doData3 setValue:parameterArr3 forKeyPath:@"parameter"];
		[self.doArray addObject:doData3];
		
	}else if ([data.parameter.firstObject isEqualToString:@"4"])
	{
		//添加第一路
		HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr = newData.parameter;
		NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
		newData.parameter = parameterArr1;
		[self.doArray addObject:newData];
		
		//添加第二路
		HRDOData *doData2 = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr2 = [doData2 valueForKeyPath:@"parameter"];
		NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
		DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
		//把前面值的覆盖了
		[doData2 setValue:parameterArr2 forKeyPath:@"parameter"];
		[self.doArray addObject:doData2];
		
		//添加第三路
		HRDOData *doData3 = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr3 = [doData3 valueForKeyPath:@"parameter"];
		NSArray *parameterArr3 = @[@"3", dataArr3[6], dataArr3[7]];
		//把前面值的覆盖了
		[doData3 setValue:parameterArr3 forKeyPath:@"parameter"];
		[self.doArray addObject:doData3];
		
		//添加第四路
		HRDOData *doData4 = [HRDOData mj_objectWithKeyValues:dictData];
		NSArray *dataArr4 = [doData4 valueForKeyPath:@"parameter"];
		NSArray *parameterArr4 = @[@"4", dataArr4[8], dataArr4[9]];
		//把前面值的覆盖了
		[doData4 setValue:parameterArr4 forKeyPath:@"parameter"];
		[self.doArray addObject:doData4];
	}
}

- (UIButton *)setupButtonWithTitle:(NSString *)title sel:(SEL)sel
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
	[button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];

	[self.bottomView addSubview:button];
	return button;
}

/**
 *  创建tableview
 *
 *  @param frame frame
 *  @param tag   tag
 *
 *  @return tableview
 */
- (UITableView *)addTableViewWithFrame:(CGRect)frame tag:(NSInteger)tag
{
	UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
	tableView.backgroundColor = [UIColor whiteColor];
	tableView.tag = tag;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
	[self.scrollView addSubview:tableView];
	return tableView;
}
#pragma mark - UI事件
static BOOL isSelectAll  = NO;
- (IBAction)allSelectButtonClick:(UIButton *)sender {
	
	if ([self.currentTableView isEqual:self.doTableView]) {//开关
		isSelectAll  = YES;
		[self.doTableView reloadData];
		//先删除,再添加全部
		[self.doSaveArray removeAllObjects];
		NSMutableArray *mb = [NSMutableArray array];
		for (id objec in self.doArray) {
			[mb addObject:objec];
		}
		self.doSaveArray = mb;
		
		
	}else if ([self.currentTableView isEqual:self.currencyTableView]) {//通用
		isSelectAll  = YES;
		//先删除,再添加全部
		[self.currencyTableView reloadData];
		[self.currencySaveArray removeAllObjects];
		NSMutableArray *mb = [NSMutableArray array];
		for (id objec in self.currencyArray) {
			[mb addObject:objec];
		}
		self.currencySaveArray = mb;
		
		
	}else if ([self.currentTableView isEqual:self.airTableView]) {//空调
		isSelectAll  = YES;
		//先删除,再添加全部
		[self.airSaveArray removeAllObjects];
		for (IracData *data in self.airArray) {
			data.version = @"-1";
			[self.airSaveArray addObject:data];
		}
		[self.airTableView reloadData];
		
	}else if ([self.currentTableView isEqual:self.tvTableView]) {//电视
		isSelectAll  = YES;
		//先删除,再添加全部
		[self.tvTableView reloadData];
		[self.tvSaveArray removeAllObjects];
		
		for (id objec in self.tvArray) {
			[self.tvSaveArray addObject:objec];
		}
	}
	
}

- (void)cancelButtonClick//取消
{
	[self setupBackAnimatetion];
	isSelectAll = NO;
	[kNotification postNotificationName:kNotificationSceneIsNoSaveButtonClick object:nil];
	NSLog(@"%s", __func__);
}
- (void)completeButtonClick
{
	[self setupBackAnimatetion];
	isSelectAll = NO;
	if (self.tableViewBlock) {
		self.tableViewBlock(self.doSaveArray,self.currencySaveArray,self.airSaveArray,self.tvSaveArray);
	}
	
	[kNotification postNotificationName:kNotificationSceneIsNoSaveButtonClick object:nil];
	
}

- (void)sceneModellViewSendTableViewWithBlock:(blockSceneTabelView)block
{
	self.tableViewBlock = block;
}
/**
 *  设置退出View的动画
 */
- (void)setupBackAnimatetion
{
	[UIView animateWithDuration:0.5 animations:^{
		self.fistViewH.constant = - UIScreenH *0.8;
		[self layoutIfNeeded];
	}completion:^(BOOL finished) {
		self.hidden = YES;
		self.bottomView.hidden = YES;
		self.bottomView.alpha = 0.0;
		[self superTabBarViewIsHidden];
	}];
}
- (void)superTabBarViewIsHidden
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSceneTabBarView object:nil];
}
//tag 10 空调 11电视 12通用红外 13智能设备
- (IBAction)deviceBtnClick:(UIButton *)sender {
	
	DDLogWarn(@"%ld",(long)sender.tag);
	self.currentButton.selected  = NO;
	sender.selected = YES;
	self.currentButton = sender;
	DDLogInfo(@"sender.tag-%ld",(long)sender.tag);
	if (sender.tag == 20) {
		[self setUpDeviceBtn:sender];
	}else if (sender.tag == 21) {
		[self setUpDeviceBtn:sender];
	}else if (sender.tag == 22) {
		[self setUpDeviceBtn:sender];
	}else if (sender.tag == 23) {
		[self setUpDeviceBtn:sender];
	}
}
- (void)setUpDeviceBtn:(UIButton *)btn
{
	
	CGFloat centerX = btn.hr_centerX;
	//让选项卡 置顶
	[UIView animateWithDuration:0.5 animations:^{
		
		self.line5View.hr_centerX = centerX;
	} completion:^(BOOL finished) {
		[self.line5View.layer removeAllAnimations];
	}];
	self.currentButton = btn;
	
	NSInteger index = btn.tag - 20;
	CGPoint offset = self.scrollView.contentOffset;
	offset.x = index * self.scrollView.hr_width;
	
	//记录当前的tableview
	if (offset.x == self.doTableView.hr_x) {
		self.currentTableView = self.doTableView;
	}else if (offset.x == self.currencyTableView.hr_x)
	{
		self.currentTableView = self.currencyTableView;
	}else if (offset.x == self.airTableView.hr_x)
	{
		self.currentTableView = self.airTableView;
	}else if (offset.x == self.tvTableView.hr_x)
	{
		self.currentTableView = self.tvTableView;
	}
	[self.scrollView setContentOffset:offset animated:YES];

}


#pragma mark - tabelViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (tableView.tag) {
  case 0:
			return self.doArray.count;
			break;
  case 1:
			return self.currencyArray.count;
			break;
  case 2:
			return self.airArray.count;
			break;
  case 3:
			return self.tvArray.count;
			break;
			
  default:
			return 0;
			break;
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *ID = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
	}
	switch (tableView.tag) {
  case 0://开关
		{
			HRDOData *data = [HRDOData mj_objectWithKeyValues:self.doArray[indexPath.row]];
			if ([data.picture.lastObject isEqualToString:@"1"] || [data.picture.lastObject isEqualToString:@"2"] || [data.picture.lastObject isEqualToString:@"4"]) {//开关
				if ([data.parameter.lastObject isEqualToString:@"0"]) {
					cell.imageView.image = [UIImage imageNamed:@"ic_off"];
				}else if ([data.parameter.lastObject isEqualToString:@"1"]) {
					cell.imageView.image = [UIImage imageNamed:@"ic_on"];
				}
			}else if ([data.picture.lastObject isEqualToString:@"3"] ) {//插座
				cell.imageView.image = [UIImage imageNamed:@"ic_plug_on"];
			}else if ([data.picture.lastObject isEqualToString:@"5"]) {// 窗帘
				cell.imageView.image = [UIImage imageNamed:@"ic_can"];
			}
			cell.textLabel.text = data.parameter[1];
			
			if (isSelectAll) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			
		}
			break;
  case 1://红外
		{
			IrgmData *data = [IrgmData mj_objectWithKeyValues:self.currencyArray[indexPath.row]];
			cell.imageView.image = [UIImage imageNamed:@"ico_infraredDevice_general_3"];
			cell.textLabel.text = data.title;
			UILabel *label = [self getLabelWithCell:cell];
			[label removeFromSuperview];
			[self setupLabelCell:cell labelText:@""];
			if (isSelectAll) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
			break;
  case 2://空调
		{
			UILabel *label = [self getLabelWithCell:cell];
			[label removeFromSuperview];
			
			IracData *data = [IracData mj_objectWithKeyValues:self.airArray[indexPath.row]];
			cell.imageView.image = [UIImage imageNamed:@"ico_infraredDevice_air"];
			cell.textLabel.text = data.title;
			
			[self setupLabelCell:cell labelText:@""];
			if (isSelectAll) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				UILabel *label = [self getLabelWithCell:cell];
				label.text = @"无效按键";
			}
		}
			break;
  case 3:// 电视
		{
			IrgmData *data = [IrgmData mj_objectWithKeyValues:self.tvArray[indexPath.row]];
			cell.imageView.image = [UIImage imageNamed:@"ic_television"];
			cell.textLabel.text = data.title;
			UILabel *label = [self getLabelWithCell:cell];
			[label removeFromSuperview];
			[self setupLabelCell:cell labelText:@""];
			if (isSelectAll) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
			break;
			
  default:
			
			break;
	}
	return cell;
}
- (void)setupLabelCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
	UILabel *label = [[UILabel alloc] init];
	label.text = labelText;
	label.textColor = [UIColor grayColor];
	[cell.contentView addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(cell.contentView).offset(-10);
		make.top.bottom.equalTo(cell.contentView);
		make.width.mas_equalTo(UIScreenW * 0.4);
	}];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[self setupAccessoryTypeWithTableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)setupAccessoryTypeWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	switch (tableView.tag) {
  case 0:
		{
			if (cell.accessoryType == UITableViewCellAccessoryNone) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				HRDOData *data = self.doArray[indexPath.row];
				[self.doSaveArray addObject:data];
				DDLogInfo(@"doSaveArray1-%@", self.doSaveArray);
				
			}else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				HRDOData *data = self.doArray[indexPath.row];
				
				//把保存数据的数组都取出来,放到一个新数组里
				NSMutableArray *mb = [NSMutableArray array];
				for (HRDOData *saveData in self.doSaveArray) {
					if ([saveData.did isEqualToString:data.did] && [saveData.parameter[1] isEqualToString:data.parameter[1]]) {
						continue;
					}
					[mb addObject:saveData];
				}
				self.doSaveArray = mb;
				DDLogInfo(@"doSaveArray2-%@", self.doSaveArray);
			}
		}
			break;
  case 1:
		{
			if (cell.accessoryType == UITableViewCellAccessoryNone) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				IrgmData *data = self.currencyArray[indexPath.row];
				[self.currencySaveArray addObject:data];
				DDLogInfo(@"doSaveArray1-%@", self.doSaveArray);
				
			}else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				IrgmData *data = self.currencyArray[indexPath.row];
				//把保存数据的数组都取出来,放到一个新数组里
				NSMutableArray *mb = [NSMutableArray array];
				for (IrgmData *saveData in self.currencySaveArray) {
					if ([saveData.did isEqualToString:data.did]) {
						continue;
					}
					[mb addObject:saveData];
				}
				self.currencySaveArray = mb;

			}
		}
			
			break;
  case 2:
		{
			if (cell.accessoryType == UITableViewCellAccessoryNone) {
				IracData *data = self.airArray[indexPath.row];
				SceneAirController *sceneAir = [[SceneAirController alloc] init];
					__weak typeof (self) weakSelf = self;
				[sceneAir sceneAirControllerWithBlock:^(NSString *str) {
					__strong typeof (self) stongSelf = weakSelf;
					
//					CGRect rect = stongSelf.line5View.frame;
//					rect.origin.x = stongSelf.airButtonX;
//					DDLogWarn(@"airButton%f", stongSelf.airButton.hr_x);
//					stongSelf.line5View.frame = rect;
					DDLogWarn(@"line5View%@", NSStringFromCGRect(stongSelf.line5View.frame));
					
					if ([str integerValue] >= 0) {
						cell.accessoryType = UITableViewCellAccessoryCheckmark;
						// 把version 字段用来存放 空调界面修改好的数据
						data.version = str;
						[stongSelf.airSaveArray addObject:data];
						
						//拿到UILabel
						UILabel *label = [stongSelf getLabelWithCell:cell];
						NSString *status = [stongSelf setupStatusWithStatus:str];
						label.text = [NSString stringWithFormat:@"%@", status];
					}else
					{
						cell.accessoryType = UITableViewCellAccessoryNone;
						//拿到UILabel
						UILabel *label = [stongSelf getLabelWithCell:cell];
						label.text = @"";
					}
				}];
				
				sceneAir.data = data;
				UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sceneAir];
				UINavigationController *actNav = (UINavigationController *)[NSObject activityViewController];
				UIViewController *vc = actNav.childViewControllers.lastObject;
				//让底部条Window隐藏
                self.bottomView.hidden = YES;
//                self.bottomView.alpha = 0.0;
                
//                [self.bottomView removeFromSuperview];
//                [self.lineBarView removeFromSuperview];
//                [self.middleLineBarView removeFromSuperview];
//                [self.cancelButton removeFromSuperview];
//                [self.completeButton removeFromSuperview];
                
				[vc presentViewController:nav animated:YES completion:nil];
				

			}else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
			{
				CGRect rect = self.line5View.frame;
				rect.origin.x = self.airButton.hr_x;
				DDLogWarn(@"airButton%f", self.airButton.hr_x);
				self.line5View.frame = rect;
				DDLogWarn(@"line5View%f", self.line5View.hr_x);
				
				//修改label的值
				UILabel *label = [self getLabelWithCell:cell];
				DDLogInfo(@"text%@",label.text);
				label.text = @"";
				cell.accessoryType = UITableViewCellAccessoryNone;
				IracData *data = self.airArray[indexPath.row];
				//把保存数据的数组都取出来,放到一个新数组里
				NSMutableArray *mb = [NSMutableArray array];
				for (IracData *saveData in self.airSaveArray) {
					if ([saveData.did isEqualToString:data.did]) {
						continue;
					}
					
					[mb addObject:saveData];
				}
				self.airSaveArray = mb;
			}
//			isSelectAll = NO;
//			[self.airTableView reloadData];
		}
			break;
  case 3:
		{
			if (cell.accessoryType == UITableViewCellAccessoryNone) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				IrgmData *data = self.tvArray[indexPath.row];
				[self.tvSaveArray addObject:data];
				
			}else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				IrgmData *data = self.tvArray[indexPath.row];
				//把保存数据的数组都取出来,放到一个新数组里
				NSMutableArray *mb = [NSMutableArray array];
				for (IrgmData *saveData in self.tvSaveArray) {
					if ([saveData.did isEqualToString:data.did]) {
						continue;
					}
					[mb addObject:saveData];
				}
				self.tvSaveArray = mb;
			}
		}
			break;
			
  default:
			break;
	}
}
/**
 *  遍历contentView那到自定义的label
 *
 *  @return 返回label
 */
- (UILabel *)getLabelWithCell:(UITableViewCell *)cell
{
	UILabel *label;
	for (UIView *view in cell.contentView.subviews) {
		if ([view isKindOfClass:[UILabel class]] && view.hr_x > UIScreenW *0.2) {
			label = (UILabel *)view;
		}
	}
	return label;
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
#pragma mark - scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (scrollView.tag == 10) {
		
		NSInteger index = scrollView.contentOffset.x / scrollView.hr_width;
		DDLogInfo(@"index%ld",(long)index);
		DDLogWarn(@"contentOffset%f",scrollView.contentOffset.x);
		
		switch (index) {
			case 0:
				[self deviceBtnClick:self.doButton];
				break;
			case 1:
				[self deviceBtnClick:self.currencyButton];
				break;
			case 2:
				[self deviceBtnClick:self.airButton];
				break;
			case 3:
				[self deviceBtnClick:self.tvButton];
				break;
				
			default:
				break;
		}
		
	}
}


@end
