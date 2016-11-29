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
#import "PushSettingController.h"
#import "DeviceListModel.h"
#import "DoorLockModel.h"
#import "HRRefreshHeader.h"
#import "HRRefreshFooter.h"

@interface DoorLockRecordConroller ()<UITableViewDelegate,UITableViewDataSource>

//tableView

@property(nonatomic,strong)UITableView * tableView;

/** 推送View*/

@property(nonatomic,strong)UIView * pushView;

/** 推送Label*/

@property(nonatomic,strong)UILabel * pushLabel;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;
/** 保存记录查询数据 */
@property(nonatomic, strong) NSMutableArray *queryArray;
/** 表头 view */
@property(nonatomic, weak) UIView *headerView;



@end

@implementation DoorLockRecordConroller
/**
 *  刷新次数
 */
static int indexCount = 0;
- (NSMutableArray *)queryArray
{
	if (!_queryArray) {
		_queryArray = [NSMutableArray array];
	}
	return _queryArray;
}



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
    
    
    if (self.AuthorUserName.length >0) {
        
        self.pushView.userInteractionEnabled = NO ;
        UIImageView * img = [self.view viewWithTag:100];
        
        img.hidden = YES;
    }
    
    else
    {
        self.pushView.userInteractionEnabled = YES ;
        UIImageView * img = [self.view viewWithTag:100];
        
        img.hidden = NO;
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
	
	[self.queryArray removeAllObjects];
	indexCount = 0;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    
    self.backImgView = backgroundImage;
    
    [self.view addSubview:self.backImgView];
    
    
    UIView *view                 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor         = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"门锁记录";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:navView];
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navView = navView;
    
    [self setNavbar];
    [self setPushUI];
    [self makeTableViewUI];
	
    // Do any additional setup after loading the view.
	
	//集成刷新
	[self setupRefresh];
}

#pragma mark - 内部方法
// 集成刷新控件
- (void)setupRefresh
{
    // header - 上拉刷新
    self.tableView.mj_header = [HRRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHttpRequsetWithHeader)];
    [self.tableView.mj_header beginRefreshing];
    // footer - 下拉刷新
    self.tableView.mj_footer = [HRRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(getHttpRequsetWithFooter)];
}

#pragma mark - 获取设备信息  发送HTTP请求
- (void)getHttpRequsetWithFooter
{
	/// 从偏好设置里加载数据
	NSString *uuid = self.listModel.uuid;
    
    
    
    if (indexCount < 0) {
        indexCount = 1;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@&sy=(unlock|batlow|ltnolock|errlimt|illunlock|holding)&page=%d",HRAPI_RecordeLock_URL,uuid,indexCount];
	url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"请求记录的网址%@",url);
    
    
    HRWeakSelf
    [HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        //DDLogWarn(@"记录查询HTTP请求%@", responseObject);
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            //			[weakSelf.queryArray removeAllObjects];
            DDLogDebug(@"下拉刷新responseObject不是NSArray");
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"下拉刷新responseObject count == 0");
        }
        
        NSArray *responseArr = (NSArray*)responseObject;
        
        [weakSelf.queryArray removeAllObjects];
        
        for (NSDictionary *dict in responseArr) {
            DoorLockModel *lockModel = [DoorLockModel mj_objectWithKeyValues:dict];
            if ([lockModel.uuid isEqualToString:uuid]) {
                // NSLog(@"符合的情况");
                [weakSelf.queryArray addObject:lockModel];
                
            }
        }
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView reloadData];
        indexCount++;
    }];
    
    NSLog(@"下拉刷新查询数组的长度%lu",(unsigned long)weakSelf.queryArray.count);

    
}

- (void)getHttpRequsetWithHeader
{
    /// 从偏好设置里加载数据
    NSString *uuid = self.listModel.uuid;
    
    if (indexCount < 0) {
        indexCount = 0;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@&sy=(unlock|batlow|ltnolock|errlimt|illunlock|holding)&page=%d",HRAPI_RecordeLock_URL,uuid,indexCount];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"请求记录的网址%@",url);
    
    
    HRWeakSelf
    [HRHTTPTool hr_getHttpWithURL:url parameters:nil responseDict:^(id responseObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        //DDLogWarn(@"记录查询HTTP请求%@", responseObject);
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            //			[weakSelf.queryArray removeAllObjects];
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
        }
        
        NSArray *responseArr = (NSArray*)responseObject;
        
        
        //  NSLog(@"记录查询请求回来的数据%@",responseArr);
        
        
        
        
        [weakSelf.queryArray removeAllObjects];
        
        for (NSDictionary *dict in responseArr) {
            DoorLockModel *lockModel = [DoorLockModel mj_objectWithKeyValues:dict];
            if ([lockModel.uuid isEqualToString:uuid]) {
                // NSLog(@"符合的情况");
                [weakSelf.queryArray addObject:lockModel];
                
            }
        }
        
        [self.tableView reloadData];
        indexCount--;
    }];
    
    NSLog(@"查询数组的长度%lu",(unsigned long)weakSelf.queryArray.count);
    
}


#pragma mark -点击第一行跳转到推送设置界面

-(void)ViewClick
{
   // NSLog(@"授权列表的名字%@",self.AuthorUserName);
    
    
    if (self.AuthorUserName.length > 0) {
        
        [SVProgressTool hr_showErrorWithStatus:@"授权用户无法设置推送"];
       
        
        
        return;
        
    }
    
    if (self.listModel == nil ) {
        
      
        [SVProgressTool hr_showErrorWithStatus:@"尚未添加门锁"];

        return;
        
    }
    
    PushSettingController * PSC = [PushSettingController new];
    PSC.listModel = self.listModel;
    
    [self.navigationController pushViewController:PSC animated:YES];
    
    
}


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //self.pushView.backgroundColor = [UIColor redColor];
    
    /********************** 给这个View加一个手势***************************/

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewClick)];
    
    [_pushView addGestureRecognizer:tap];
    
    
    
    //推送view下面的白线
    
    UIView *lineView = [[UIView alloc]init];
    
    [self.view addSubview:lineView];
    
    lineView.sd_layout
    .topSpaceToView(self.pushView,0)
    .leftSpaceToView(self.view,15.0/375.0 *self.view.bounds.size.width)
    .rightSpaceToView(self.view,(15.0/375.0 *self.view.bounds.size.width))
    .heightIs(1.0);
    
    lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
   // UISwitch * sw = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width-(20.0/375.0 *self.view.bounds.size.width)-51, 64+(14.0/667.0 *self.view.bounds.size.height), 0, 0)];
    
   // [self.view addSubview:sw];
    
    /******************进入符号**********************/
    
    UIImageView *infoImg = [[UIImageView alloc]init];
    [self.view addSubview:infoImg];
    infoImg.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView,10)
    .heightIs(18)
    .widthIs(9);
    infoImg.image = [UIImage imageNamed:@"进入"];
    
    infoImg.tag = 100;
    
    
    
    
    //推送label
    
    _pushLabel = [[UILabel alloc]init];
    
    [self.view addSubview:_pushLabel];
    
    
    
    _pushLabel.sd_layout
    .bottomSpaceToView(lineView,5.0)
    .leftEqualToView(lineView)
    .widthIs(70)
    .heightIs(30);
    _pushLabel.text = @"推送设置";
    _pushLabel.font = [UIFont systemFontOfSize:17];
   // _pushLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];

    
    
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
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+(75.0/667.0)*self.view.bounds.size.height, UIScreenW, 50)];
	headerView.backgroundColor = [UIColor clearColor];
	self.headerView = headerView;
	[self.view addSubview:headerView];
	
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+(75.0/667.0)*self.view.bounds.size.height + 50, self.view.bounds.size.width, 500) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
	
//    _tableView.tableHeaderView = headerView;
	
	[self setUpHeardView];
    _tableView.rowHeight = 50 ;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    //隐藏滚动条
//    _tableView.showsVerticalScrollIndicator =NO;
    //超过边界不允许滚动
//    _tableView.bounces = NO;
	
    [self.view addSubview:_tableView];
    
    
    _tableView.separatorInset= UIEdgeInsetsMake(0, 10, 0, 10);
 
    
    
    UIView *footView = [UIView new];
    
    _tableView.tableFooterView = footView;
    
    //解决tableView头部多出得高度
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

#pragma mark - tableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.queryArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   DoorRecordCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[DoorRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.lockModel = self.queryArray[indexPath.row];
    if ([cell.lockModel.unread isEqualToString:@"read"]) {

        NSLog(@"已读");
        
        cell.selectImageView.hidden = YES;
        
    }
    else{
        NSLog(@"未读");

        cell.selectImageView.hidden = NO;
        
    }
    
    return cell;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoorLockModel *model = self.queryArray[indexPath.row];
    
    
    NSString * did = model.did ;
    
    NSLog(@"did是%@",did);
    
    
    //加个post请求 修改unread字段
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager hrManager ];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HRAPI_RecoderSelectState_URL, did];
    
    NSLog(@"更新的网址是%@",url);
    
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"更新unread成功");
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"更新unread失败%@",error);
        
        
    }];
    
    
    model.unread = @"read";
    
    [self.queryArray replaceObjectAtIndex:indexPath.row withObject:model];
    
    [tableView reloadData];
    
    
    
    
    
    
    
    
    NSString *title = model.title;
    NSRange range = [title rangeOfString:@"|"];
    
    NSString *time = [title substringToIndex:range.location];
    NSString *user = model.person.firstObject;
    
    
    range = [title rangeOfString:@"|" options:NSBackwardsSearch];
    NSString *message = [title substringFromIndex:range.location + 1];
    
    
    NSString  *finalString = [NSString stringWithFormat:@"用户名:%@\n操作:%@\n时间:%@\n", user, message, time];
    
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:finalString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

    
}

-(void)setUpHeardView
{
	
//	self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
	UILabel *timeLabel = [[UILabel alloc]init];
	
	UILabel *userNameLabel = [[UILabel alloc]init];
	
	UILabel *recordLabel = [[UILabel alloc]init];
	
	[self.headerView addSubview:timeLabel];
	[self.headerView addSubview:userNameLabel];
	[self.headerView addSubview:recordLabel];
	
	//布局
	
	/**
	 时间      90
	 用户名    150
	 开锁记录  100
	 */
	
 
	//用户名
 timeLabel.sd_layout
	.leftSpaceToView(self.headerView,15.0/375.0 *self.headerView.frame.size.width)
	.widthIs(110.0/375.0 * self.headerView.frame.size.width)
	.bottomSpaceToView(self.headerView,10.0)
	.heightIs(20.0);
	timeLabel.text = @"用户名";
	timeLabel.font = [UIFont systemFontOfSize:17];
   
	timeLabel.textColor = [UIColor whiteColor];
	// _timeLabel.backgroundColor = [UIColor greenColor];
	
	
	// 时间
	recordLabel.sd_layout
	.rightSpaceToView(self.headerView,15.0)
	.bottomEqualToView(timeLabel)
	.heightIs(20.0)
	.widthIs(120.0/375.0 * self.headerView.frame.size.width + 40);
	
	// NSLog(@"%f",120.0/375.0 *self.contentView.frame.size.width);
	
	
	recordLabel.text = @"时间";
	recordLabel.font = [UIFont systemFontOfSize:17];
    
    
	recordLabel.textColor = [UIColor whiteColor];
	
	recordLabel.textAlignment = NSTextAlignmentCenter;
	
	//  _recordLabel.backgroundColor = [UIColor greenColor];
	
	//操作
	userNameLabel.sd_layout
	.topEqualToView(timeLabel)
	.bottomEqualToView(timeLabel)
	.leftSpaceToView(timeLabel,0)
	.rightSpaceToView(recordLabel,0);
	
	userNameLabel.text = @"操作";
	userNameLabel.font = [UIFont systemFontOfSize:17];
    
   // userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];

	userNameLabel.textColor = [UIColor whiteColor];
	
	userNameLabel.textAlignment = NSTextAlignmentCenter;
	
		
	
	
}


@end
