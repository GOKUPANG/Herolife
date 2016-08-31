//
//  ManualController.m
//  herolife
//
//  Created by sswukang on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

/** 屏幕高度*/
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width


#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
#define HRCommonScreenH (HRUIScreenH / 667 /2)
#define HRCommonScreenW (HRUIScreenW / 375 /2)


#import "ManualController.h"
#import "NextController.h"
#import "AddDeivcecell.h"
@interface ManualController ()<UITableViewDelegate,UITableViewDataSource>
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 二维码按钮 */
@property(nonatomic, weak) UIButton *qrButton;
/** 二维码Label */
@property(nonatomic, weak) UILabel *qrLabel;
/** 手动添加按钮 */
@property(nonatomic, weak) UIButton *manualButton;
/** 手动添加label */
@property(nonatomic, weak) UILabel *manualLabel;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ManualController

- (void)viewDidLoad {
	[super viewDidLoad];
	//初始化
	[self setupViews];
	[self goBack];
	
	//隐藏底部条
	[self IsTabBarHidden:YES];
}

#pragma mark - 内部方法
//初始化
- (void)setupViews
{
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"icon_bg.jpg"];
	[self.view addSubview:backgroundImage];
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"智能门锁";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;

	//求字体长度
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
	//二维码按钮
	UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[qrButton setBackgroundImage:[UIImage imageNamed:@"发光圆"] forState:UIControlStateNormal];
	[qrButton setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
	[qrButton addTarget:self action:@selector(qrcodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:qrButton];
	self.qrButton = qrButton;
	
	//求字体长度
	//二维码Label
	UILabel *qrLabel = [[UILabel alloc] init];
	qrLabel.backgroundColor = [UIColor clearColor];
	qrLabel.textColor = [UIColor whiteColor];
	qrLabel.textAlignment = NSTextAlignmentCenter;
	qrLabel.font = [UIFont systemFontOfSize:14];
	qrLabel.text = @"扫描二维码";
	[self.view addSubview:qrLabel];
	self.qrLabel = qrLabel;
	
	//手动添加按钮
	UIButton *manualButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[manualButton setBackgroundImage:[UIImage imageNamed:@"发光圆"] forState:UIControlStateNormal];
	[manualButton setImage:[UIImage imageNamed:@"手指"] forState:UIControlStateNormal];
	[manualButton addTarget:self action:@selector(manualButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:manualButton];
	self.manualButton = manualButton;
	
	//手动添加label
	UILabel *manualLabel = [[UILabel alloc] init];
	manualLabel.backgroundColor = [UIColor clearColor];
	manualLabel.textColor = [UIColor whiteColor];
	manualLabel.textAlignment = NSTextAlignmentCenter;
	manualLabel.font = [UIFont systemFontOfSize:14];
	manualLabel.text = @"手动添加";
	[self.view addSubview:manualLabel];
	
	self.manualLabel = manualLabel;
	
	
	[self setTableViewUI];
	
}

-(void)setTableViewUI
{
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84.0, SCREEN_W, SCREEN_H-84.0 -200) style:UITableViewStylePlain];
	_tableView.delegate =self;
	_tableView.dataSource = self;
	
	_tableView.rowHeight = 120 * HRCommonScreenH;
	
	_tableView.backgroundColor = [UIColor clearColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.tableView.bounces = NO;
	
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	
	UIView *footView = [UIView new];
	
	_tableView.tableFooterView = footView   ;
	
	// _tableView.separatorInset =UIEdgeInsetsMake(0, 100, 0, 0);
	
	
	
	[self.view addSubview:_tableView];
	
	
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	[self.qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view).offset(- HRCommonScreenW * 134);
		make.bottom.equalTo(self.view).offset(- HRCommonScreenH * 64 - 49);
		
	}];
	[self.qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.qrLabel);
		make.bottom.equalTo(self.qrLabel.mas_top).offset(- HRCommonScreenH * 10);
		
	}];
	[self.manualLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.qrLabel);
		make.centerX.equalTo(self.view).offset(HRCommonScreenW * 134);
	}];
	[self.manualButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.manualLabel);
		make.bottom.equalTo(self.manualLabel.mas_top).offset(- HRCommonScreenH * 10);
		
	}];
	
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	
}
#pragma mark - UI事件
- (void)qrcodeButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)manualButtonClick:(UIButton *)btn
{
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self IsTabBarHidden:NO];
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
#pragma mark - 全屏放回
- (void)backButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
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

#pragma mark - tableView 代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
	
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	
	
	AddDeivcecell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
	
	if (cell == nil) {
		cell = [[AddDeivcecell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
		
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	cell.DeviceNameLabel.text = @"智能设备";
	
	// cell.textLabel.textColor = [UIColor whiteColor];
	
	
	cell.phoneImage.image = [UIImage imageNamed:@"门锁"];
	
	
	//设置分割线的偏移
	
 //   cell.separatorInset =UIEdgeInsetsMake(0, -50, 0, 0);
	
	//设置右边的小箭头
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	//设置选中cell的背景颜色
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
	
	
	return cell;
	
	
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"选中了第%ld行",(long)indexPath.row);
	NextController *nextVC = [[NextController alloc] init];
	[self.navigationController pushViewController:nextVC animated:YES];
}

@end
