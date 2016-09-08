//
//  EnterPSWController.m
//  herolife
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 huarui. All rights reserved.
//


/** 屏幕高度*/
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

#import "EnterPSWController.h"
#import "UIView+SDAutoLayout.h"
#import "WiFiListController.h"

#import "WaitController.h"

@interface EnterPSWController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UIView * lineView2;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation EnterPSWController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入密码";
    
    
    UIImageView *BakView = [[UIImageView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
    
    BakView.image = [UIImage imageNamed:@"2"];
    
    [self.view addSubview:BakView];
    

    
    
  //  [self makeTableViewUI];
    
    [self makeUI];
    
    
    [self MakeStartAddView];
    
	
	//haibo 全屏放回
	[self goBack];
	
	//haibo 隐藏底部条
	[self IsTabBarHidden:YES];
	
}
//海波代码
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
-(void)makeUI
{
	//海波代码----------------------start-------------------------------------
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
	[self.view addSubview:backgroundImage];
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"输入密码";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:navView];
	self.navView = navView;
	//海波代码----------------------end-------------------------------------
    UIView  * lineView1 = [[UIView alloc]init];
    
    [self.view addSubview:lineView1];
    
    lineView1.sd_layout
    .topSpaceToView(self.view,64+90)
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(1);
    
    lineView1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    
    
    
    //第二条线
    _lineView2 = [[UIView alloc]init];
    
    [self.view addSubview:_lineView2];
	
    _lineView2.sd_layout
    .topSpaceToView(lineView1,50)
    .leftEqualToView(lineView1)
    .rightEqualToView(lineView1)
    .heightIs(1);
    _lineView2.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.7];
    
    
    
    /** 第一行白线上面添加一个View*/
    
    UIView * WIFIView = [[UIView alloc]init];
    [self.view addSubview:WIFIView];
    
    WIFIView.sd_layout
    .bottomEqualToView(lineView1)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(46.0);
    
    
    
    /** 给这个第一行的View 添加一个手势事件 用于选择WiFi */
    
    UITapGestureRecognizer * WIFITap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WIFIClick)];
    
    [WIFIView addGestureRecognizer:WIFITap];
    
    
/** WIFILabel */
    
    UILabel * WIFILabel = [[UILabel alloc]init];
    [WIFIView addSubview:WIFILabel];
    
    WIFILabel.sd_layout
    .bottomSpaceToView(WIFIView,10)
    .leftSpaceToView(WIFIView,25)
    .widthIs(200)
    .heightIs (20);
    
    WIFILabel.textAlignment= NSTextAlignmentLeft;
    
    WIFILabel.text = @"HUARUIKEJI";
    
    
    
    WIFILabel.textColor = [UIColor whiteColor];
    
    
    /** WiFi cell的 最右边的图片*/
    
    UIImageView *WIFIImageView  = [[UIImageView alloc]init];
    
    [WIFIView addSubview:WIFIImageView];
    
    WIFIImageView.sd_layout
    .bottomSpaceToView(WIFIView,8)
    .rightSpaceToView(WIFIView,25)
    .widthIs(13)
    .heightIs(18);
    
    WIFIImageView.image = [UIImage imageNamed:@"进入"];
    
    /** WiFi密码输入框*/
    
    UITextField *WIFITextField = [[UITextField alloc]init];
    
    [self.view addSubview:WIFITextField];
    
    WIFITextField.sd_layout
    .bottomSpaceToView(_lineView2,10)
    .leftSpaceToView(self.view,25)
    .widthIs(250)
    .heightIs(22);
    
    WIFITextField.textColor = [UIColor whiteColor];
    
    WIFITextField.returnKeyType = UIReturnKeyDone;
    
    WIFITextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    WIFITextField.placeholder = @"请输入密码";
    [WIFITextField setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    WIFITextField.clearButtonMode =    UITextFieldViewModeAlways;
    

    
    
    /** WIFI密码输入框最右边的图片 */
    
    
    UIImageView *EyeimageView = [[UIImageView alloc]init];
    [self.view addSubview:EyeimageView];
    
    
    EyeimageView.sd_layout
    .bottomSpaceToView(_lineView2,10)
    .rightSpaceToView(self.view,25)
    .widthIs(18)
    .heightIs(13);
    
    EyeimageView.image = [UIImage imageNamed:@"睁眼"];
    
    
    
    
    

    
}
#pragma mark - UI事件  -haibo
- (void)leftButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -点击WiFiView 实现的方法
-(void)WIFIClick
{
    
    NSLog(@"点击了WIFI");
	WiFiListController *WiFiVC = [[WiFiListController alloc] init];
	[self.navigationController pushViewController:WiFiVC animated:YES];
    
    
}

#pragma mark - 开始添加按钮的设置
-(void)MakeStartAddView
{
    
  
    
    
    UIView * StartView = [[UIView alloc]init];
    [self.view addSubview:StartView];
    
    StartView.sd_layout
    .topSpaceToView(_lineView2,50)
    .leftSpaceToView(self.view ,15)
    .rightSpaceToView(self.view,15)
    .heightIs(40);
    
    
    UILabel * StartLabel  = [[UILabel alloc]init];
    
    [StartView addSubview:StartLabel];
    
//    StartLabel.sd_layout
//    .topSpaceToView(StartView,10)
//    .bottomSpaceToView(StartView,10)
//    .leftSpaceToView(StartView,137.5/375.0 *SCREEN_W)
//    .rightSpaceToView(StartView,137.5/375.0 *SCREEN_W);
    
    StartLabel.sd_layout
    .topEqualToView(StartView)
    .bottomEqualToView(StartView)
    .leftEqualToView(StartView)
    .rightEqualToView(StartView);
    
    

    
    
    
    StartLabel.text = @"开始添加";
    
    StartLabel.textColor = [UIColor whiteColor];
    
    StartLabel.textAlignment = NSTextAlignmentCenter;
    
    
    StartView. backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    //给StartView添加边框效果
    
    StartView.layer.borderWidth = 1;
    StartView.layer.borderColor =[UIColor colorWithWhite:1.0 alpha:0.7].CGColor;
    
    
    
    //给 starView添加一个手势
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StartViewClick)];
    
    [StartView addGestureRecognizer:tap];
    
}


#pragma mark -点击开始添加实现的方法

-(void)StartViewClick
{
    NSLog(@"点击了开始添加");
	WaitController *waitVC = [[WaitController alloc] init];
	[self.navigationController pushViewController:waitVC animated:YES];
}

#pragma mark - tableView的UI设置

-(void)makeTableViewUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, self.view.bounds.size.width, 46.0 * 2) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
                  
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    _tableView.rowHeight = 46.0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self.view addSubview:_tableView];
    
    
  
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:@"cellID"];

    if (cell == nil) {
    cell                     = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text      = @"输入密码";
    cell.textLabel.textColor = [UIColor whiteColor];


    }

    cell.backgroundColor     = [UIColor clearColor];

    return cell;
    
}
#pragma mark  - 海波代码
- (void)viewWillDisappear:(BOOL)animated
{
	[self IsTabBarHidden:YES];
}
#pragma mark - 隐藏底部条 - 海波代码
- (void)IsTabBarHidden:(BOOL)hidden
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = hidden;
		}
	}
}
#pragma mark - 全屏放回 - 海波代码
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

@end
