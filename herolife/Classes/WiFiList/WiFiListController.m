//
//  WiFiListController.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "WiFiListController.h"

#import "WiFiListCell.h"
#import "WIFIListModel.h"
#import "UDPModel.h"
#import "HRPushMode.h"
#import "HRRefreshHeader.h"

@interface WiFiListController ()<UITableViewDelegate, UITableViewDataSource>
/**  */
@property(nonatomic, weak) HRNavigationBar *navView;
/** WiFi列表 tabelview */
@property(nonatomic, weak) UITableView *tableView;
/** 记录当前的cell */
@property(nonatomic, weak) WiFiListCell *currentCell;
/** 存放wifi名称 */
@property(nonatomic, strong) NSArray *wifiArray;
/** <#name#> */
@property(nonatomic, weak) UIButton *refreshButton;
/** 存放型号 数组 */
@property(nonatomic, strong) NSArray *rssilist;
@end

static NSString *cellID = @"cellID";
@implementation WiFiListController
- (NSArray *)wifiArray
{
	if (!_wifiArray) {
		_wifiArray = [NSArray array];
	}
	return _wifiArray;
}
- (NSArray *)rssilist
{
	if (!_rssilist) {
		_rssilist = [NSArray array];
	}
	return _rssilist;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化
	[self setupViews];
	
	[self goBack];
	
	//注册
	[self.tableView registerClass:[WiFiListCell class] forCellReuseIdentifier:cellID];
	[self setupRefresh];
	
}
#pragma mark - 内部方法
// 集成刷新控件
- (void)setupRefresh
{
	// header - 下拉刷新
	self.tableView.mj_header = [HRRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHomeHTTPRequest)];
	// 进入刷新状态
	[self.tableView.mj_header beginRefreshing];
}
- (void)getHomeHTTPRequest
{
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
	self.wifiArray = app.wifiNameArray;
	self.rssilist = app.rssilistArray;
	
	[self.tableView reloadData];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[self.tableView.mj_header endRefreshing];
	});
}
- (void)dealloc
{
	[kNotification removeObserver:self];
}
- (void)setupViews
{
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
	[self.view addSubview:backgroundImage];
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	self.navigationController.navigationBar.hidden = YES;
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"WiFi列表";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	navView.rightLabel.text = @"刷新";
	
	[navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
	[self.view addSubview:navView];
	self.navView = navView;
	
	
	UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	refreshButton.backgroundColor = [UIColor clearColor];
	[refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:refreshButton];
	self.refreshButton = refreshButton;
	
	//WiFi列表 tabelview
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
	tableView.delegate        = self;
	tableView.dataSource      = self;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.rowHeight = HRCommonScreenH * 84;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:tableView];
	self.tableView = tableView;
	
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	//导航条
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	[self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.navView);
		make.bottom.top.equalTo(self.navView);
		
		make.width.mas_equalTo(HRNavH);
	}];
	
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.navView.mas_bottom).offset(0);
		make.left.equalTo(self.view).offset(HRCommonScreenW *30);
		make.right.equalTo(self.view).offset(- HRCommonScreenW *30);
		make.bottom.equalTo(self.view);
	}];
}
#pragma mark - UI事件
//刷新
- (void)refreshButtonClick:(UIButton *)btn
{
	[self.tableView.mj_header beginRefreshing];
	[self getHomeHTTPRequest];
}
- (void)backButtonClick:(UIButton *)btn
{
	
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.wifiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	WiFiListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil) {
		cell = [[WiFiListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	cell.leftLabel.text = self.wifiArray[indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.rssilistString = self.rssilist[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.currentCell.leftImage.image = [UIImage imageNamed:@""];;
	WiFiListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	self.currentCell = cell;
	cell.leftImage.image = [UIImage imageNamed:@"选择"];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSString *name = self.wifiArray[indexPath.row];
		if (self.wifiBlock) {
			self.wifiBlock(name, indexPath.row);
		}
		[self.navigationController popViewControllerAnimated:YES];
	});
}
#pragma mark - 全屏放回
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
#pragma mark - block
- (void)selectWifiBlockWithBlock:(selectWifiBlock)block
{
	self.wifiBlock = block;
}

@end
