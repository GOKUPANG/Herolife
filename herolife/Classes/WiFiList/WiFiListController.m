//
//  WiFiListController.m
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "WiFiListController.h"

#import "WiFiListCell.h"

@interface WiFiListController ()<UITableViewDelegate, UITableViewDataSource>
/**  */
@property(nonatomic, weak) HRNavigationBar *navView;
/** WiFi列表 tabelview */
@property(nonatomic, weak) UITableView *tableView;
/** 记录当前的cell */
@property(nonatomic, weak) WiFiListCell *currentCell;
@end

static NSString *cellID = @"cellID";
@implementation WiFiListController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化
	[self setupViews];
	
	
	
	//注册
	[self.tableView registerClass:[WiFiListCell class] forCellReuseIdentifier:cellID];
}

- (void)setupViews
{
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
	[self.view addSubview:backgroundImage];
	
	self.navigationController.navigationBar.hidden = YES;
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"WiFi列表";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	navView.rightLabel.text = @"刷新";
	[navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
	[self.view addSubview:navView];
	self.navView = navView;
	
	//WiFi列表 tabelview
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
	tableView.delegate        = self;
	tableView.dataSource      = self;
	tableView.bounces = NO;
//	tableView.scrollEnabled = NO;
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
	
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH * 127);
		make.left.equalTo(self.view).offset(HRCommonScreenW *30);
		make.right.equalTo(self.view).offset(- HRCommonScreenW *30);
		make.bottom.equalTo(self.view);
	}];
}
#pragma mark - UI事件
- (void)backButtonClick:(UIButton *)btn
{
	
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	WiFiListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil) {
		cell = [[WiFiListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.currentCell.leftImage.image = [UIImage imageNamed:@""];;
	WiFiListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	self.currentCell = cell;
	cell.leftImage.image = [UIImage imageNamed:@"选择"];
}


@end
