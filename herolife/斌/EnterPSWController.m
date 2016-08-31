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

@interface EnterPSWController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UIView * lineView2;


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
    
    
}

#pragma mark - 创建前面两行的View

-(void)makeUI
{
    //先 创建 第一条线
    
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

#pragma mark -点击WiFiView 实现的方法
-(void)WIFIClick
{
    
    NSLog(@"点击了WIFI");
    
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.text = @"输入密码";
        cell.textLabel.textColor = [UIColor whiteColor];
        
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
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
