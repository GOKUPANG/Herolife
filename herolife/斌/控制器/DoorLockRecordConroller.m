//
//  DoorLockRecordConroller.m
//  herolife
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//  门锁记录

#import "DoorLockRecordConroller.h"
#import "UIView+SDAutoLayout.h"
#import "DoorRecordCell.h"

@interface DoorLockRecordConroller ()<UITableViewDelegate,UITableViewDataSource>

//tableView

@property(nonatomic,strong)UITableView * tableView;

/** 推送View*/

@property(nonatomic,strong)UIView * pushView;

/** 推送Label*/

@property(nonatomic,strong)UILabel * pushLabel;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;





@end

@implementation DoorLockRecordConroller


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //	self.tabBarController.view.hidden = YES;
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = YES;
        }
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
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    [self.view addSubview:backgroundImage];
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"智能开锁";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:navView];
    self.navView = navView;
    
    [self setNavbar];
    [self setPushUI];
    [self makeTableViewUI];
    

    // Do any additional setup after loading the view.
}

#pragma mark -推送开关
-(void)setPushUI
{
    
    self.pushView = [[UIView alloc]init];
    
    [self.view addSubview:self.pushView];
    
    self.pushView.sd_layout
    .topSpaceToView(self.view,64)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(60.0/667.0 * self.view.size.height);
    
   // self.pushView.backgroundColor = [UIColor redColor];
    
    //推送view下面的白线
    
    UIView *lineView = [[UIView alloc]init];
    
    [self.view addSubview:lineView];
    
    lineView.sd_layout
    .topSpaceToView(self.pushView,0)
    .leftSpaceToView(self.view,15.0/375.0 *self.view.bounds.size.width)
    .rightSpaceToView(self.view,(15.0/375.0 *self.view.bounds.size.width))
    .heightIs(1.0);
    
    lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    UISwitch * sw = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width-(20.0/375.0 *self.view.bounds.size.width)-51, 64+(14.0/667.0 *self.view.bounds.size.height), 0, 0)];
    
    [self.view addSubview:sw];
    
    //推送label
    
    _pushLabel = [[UILabel alloc]init];
    
    [self.view addSubview:_pushLabel];
    
    _pushLabel.sd_layout
    .bottomSpaceToView(lineView,15.0/667.0 *self.view.bounds.size.height)
    .leftEqualToView(lineView)
    .widthIs(70)
    .heightIs(30);
    _pushLabel.text = @"推送";
    _pushLabel.font = [UIFont systemFontOfSize:17];
    
    
    _pushLabel.textColor = [UIColor whiteColor];
    
    

    
    
    
    
    
    
}

#pragma mark -导航栏相关设置


-(void)setNavbar
{
  #pragma mark -状态栏白色
    
    
    self.title = @"门锁记录";
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    //背景颜色 图片
    
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"2"]];
    

}

#pragma mark -tableView UI 设置
-(void)makeTableViewUI
{
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+(75.0/667.0)*self.view.bounds.size.height, self.view.bounds.size.width, 500) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.tableHeaderView = [UIView new];
    
    _tableView.rowHeight = 50 ;
    
    //隐藏滚动条
    _tableView.showsVerticalScrollIndicator =NO;
    //超过边界不允许滚动
    _tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
    
    
    _tableView.separatorInset= UIEdgeInsetsMake(0, 10, 0, 10);
 
    
    
    UIView *footView = [UIView new];
    
    _tableView.tableFooterView = footView;
    
    //解决tableView头部多出得高度
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

#pragma mark - tableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   DoorRecordCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[DoorRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.backgroundColor = [UIColor clearColor];
    //cell.alpha = 0.2;
    
    
    if (indexPath.row == 1) {
        cell.recordLabel.text =@"指纹开锁";
        cell.userNameLabel.text = @"jack";
        cell.timeLabel.text = @"2016.12.12";
        
        
    }
    
    else{
    cell.timeLabel.text = @"2016.08.16";
    cell.recordLabel.text = @"低电量提醒";
    cell.userNameLabel.text = @"Eleanor" ;
        
    }
    
    
   // cell.textLabel.text = @"222";
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    return cell;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
