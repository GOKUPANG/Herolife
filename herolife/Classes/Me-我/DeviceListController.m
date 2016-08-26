//
//  DeviceListController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "DeviceListController.h"
// Components
#import "YRCoverFlowLayout.h"

// Model
#import "PhotoModel.h"

// Cells
#import "CustomCollectionViewCollectionViewCell.h"
#import "DeviceListCell.h"

#define HRNavigationBarFrame self.navigationController.navigationBar.bounds
@interface DeviceListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
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
@end

@implementation DeviceListController
static NSString *cellID = @"cellID";
- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化
	[self setupViews];
	//注册
	[self.tableView registerClass:[DeviceListCell class] forCellReuseIdentifier:cellID];
}
#pragma mark - 内部方法
//初始化
- (void)setupViews
{
	
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
	[self.view addSubview:backgroundImage];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"设备列表";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;
	self.view.backgroundColor = [UIColor grayColor];
	
	//cover flow
//	YRCoverFlowLayout *layout = [[YRCoverFlowLayout alloc] init];
//	layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//	layout.minimumLineSpacing = 20;
//	layout.minimumInteritemSpacing = 30;
//	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
//	collectionView.dataSource = self;
//	collectionView.delegate = self;
//	
//	[self.view addSubview:collectionView];
//	self.collectionView = collectionView;
	
	//站位的view
	UIView *eptView = [[UIView alloc] init];
	eptView.backgroundColor = [UIColor redColor];
	[self.view addSubview:eptView];
	self.eptView = eptView;
	
	//下拉列表按钮
	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:listButton];
	self.listButton = listButton;
	
	UIImageView *listImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"标签"]];
	CGRect rect = listImageView.frame;
	rect.origin = CGPointMake(HRUIScreenW *10, 0);
	listImageView.frame = rect;
	[listButton addSubview:listImageView];
	self.listImageView = listImageView;
	
	UILabel *listLabel = [[UILabel alloc] init];
	listLabel.text = @"HEROLIFE";
	listLabel.textColor = [UIColor whiteColor];
	listLabel.font = [UIFont systemFontOfSize:17];
	listLabel.hr_centerX = listButton.hr_centerX;
	listLabel.hr_centerY = listButton.hr_centerY;
	[listButton addSubview:listLabel];
	self.listLabel = listLabel;
	
	UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉符号"]];
	rightImageView.frame = rect;
	[listButton addSubview:rightImageView];
	self.rightImageView = rightImageView;
	//半透明框
//	UIImageView *alphaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"半透明框"]];
//	[self.view addSubview:alphaImageView];
//	self.alphaImageView = alphaImageView;
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
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	//导航条
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
	//站位的view
	[self.eptView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(HRCommonScreenW * 30);
		make.right.equalTo(self.view).offset(- HRCommonScreenW * 30);
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH *63);
		make.height.mas_equalTo(HRCommonScreenH * 272);
	}];
	
	//列表按钮
	[self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.eptView.mas_bottom).offset(HRCommonScreenH *20);
		make.centerX.equalTo(self.view);
		make.width.mas_equalTo(HRCommonScreenW * 271);
		make.height.mas_equalTo(HRCommonScreenH * 50);
	}];
	
	//列表按钮里左边的图片
	[self.listImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.listButton).offset(HRCommonScreenW * 10);
		make.centerY.equalTo(self.listButton);
	}];
	//列表按钮里的文本
	[self.listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.listButton);
	}];
	//列表按钮里的右边图片
	[self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.listButton).offset(- HRCommonScreenW *10);
		make.centerY.equalTo(self.listButton);
	}];
	
	[self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.listButton.mas_bottom).offset(HRCommonScreenH *170);
		make.left.equalTo(self.view).offset(HRCommonScreenW * 10);
		make.right.equalTo(self.view).offset(- HRCommonScreenW * 10);
		make.height.mas_equalTo(HRCommonScreenH * 446);
	}];
	
	
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.top.equalTo(self.alphaView);
	}];
	
}

#pragma mark - UI事件
- (void)listButtonClick:(UIButton *)btn
{
	
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
			cell.leftImage.image = [UIImage imageNamed:@"开锁首页"];
			cell.leftLabel.text = @"手机开锁";
			cell.rightLabel.text = @"最后一次操作的时间";
			cell.minLabel.text = @"剩余电量95%";
		}
			break;
  case 1:
		{
			
			cell.leftImage.image = [UIImage imageNamed:@"记录"];
			cell.leftLabel.text = @"记录查询";
			cell.rightLabel.text = @"最后一次记录";
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
}


#pragma mark - UICollectionViewDelegate/Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CustomCollectionViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCellIdentifier
																							 forIndexPath:indexPath];
	
//	cell.photoModel = _photoModelsDatasource[indexPath.row];
	
	//	cell.layer.borderWidth = 2;
	//	cell.layer.borderColor = [UIColor redColor].CGColor;
	cell.layer.cornerRadius = 10;
	cell.layer.masksToBounds = YES;
	//
	//	CAShapeLayer *leftLayer = [[CAShapeLayer alloc] init];
	//	CGRect rect = cell.frame;
	//	rect.origin.x = cell.frame.origin.x - 30;
	//	rect.origin.y = cell.frame.origin.y - 30;
	//	rect.size.width = cell.frame.size.width + 30;
	//	rect.size.height = cell.frame.size.height + 30;
	//	leftLayer.frame = rect;
	//	leftLayer.cornerRadius = 10;
	//	leftLayer.borderColor = [UIColor redColor].CGColor;
	//	leftLayer.borderWidth = 2;
	//	[cell.layer addSublayer:leftLayer];
	
	CAShapeLayer *border = [CAShapeLayer layer];
	
	border.strokeColor = [UIColor redColor].CGColor;
	
	border.fillColor = nil;
	
	CGRect rect = cell.frame;
	rect.origin.x = cell.frame.origin.x - 30;
	rect.origin.y = cell.frame.origin.y - 30;
	rect.size.width = cell.frame.size.width + 30;
	rect.size.height = cell.frame.size.height + 30;
	
	border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
	
	border.frame = rect;
	
	border.lineWidth = 1.f;
	
	border.lineCap = @"square";
	
	border.lineDashPattern = @[@8, @4];
	border.cornerRadius = 10;
	border.masksToBounds = YES;
	[cell.layer addSublayer:border];
	
	
	return cell;
}

@end
