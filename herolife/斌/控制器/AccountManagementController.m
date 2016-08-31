//
//  AccountManagementController.m
//  herolife
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AccountManagementController.h"
#import "UIView+SDAutoLayout.h"
#import "JCAlertView.h"
#import "DoorLockRecordConroller.h"

@interface AccountManagementController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

//导航栏
@property(nonatomic,strong)UIView * alphaView;


@property(nonatomic,strong)UITableView *tableView;
/** 头像View*/
@property(nonatomic,strong)UIView * headImgView;

/** 用户名*/
@property(nonatomic,strong)UIView * userNameView;

/** 原密码*/
@property(nonatomic,strong)UIView * oldPswView ;

/** 新密码*/
@property(nonatomic,strong) UIView * NewPswView;


/** 确认密码*/
@property(nonatomic,strong)UIView * comfirmPswView ;


/** 确认修改*/
@property(nonatomic,strong)UIView * comfirmFixView ;

/** 有三个输入框*/

/** 原密码输入框*/
@property(nonatomic,strong)UITextField * OldPswTF;

/** 新密码输入框*/
@property(nonatomic,strong)UITextField * NewPswTF;

/** 确认密码输入框*/

@property(nonatomic,strong)UITextField * confirmTF;


@property(nonatomic,assign )BOOL isCanClick;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;





@end

@implementation AccountManagementController

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
    
    
    [self setUI];
    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    [self.view addSubview:backgroundImage];
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"用户管理";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    self.navView = navView;

     
 
    
    [self makeMyUI];
    
    
    
}

#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -跳转到下一个界面  

-(void)nextPage
{
    DoorLockRecordConroller * Dlr =[DoorLockRecordConroller new];
    [self.navigationController pushViewController:Dlr animated:YES];
    
}

#pragma mark -判断确认按钮是否能点击

-(void)textFieldDidChange
{
    if (_OldPswTF.text.length > 0&& _NewPswTF.text.length>0 &&_confirmTF.text.length > 0) {
        _comfirmFixView.alpha = 0.7;
        _comfirmFixView.userInteractionEnabled = YES;
        
    }
    
    else
    { _comfirmFixView.alpha = 0.2 ;
        _comfirmFixView.userInteractionEnabled = NO;
        
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_OldPswTF.text.length > 0&& _NewPswTF.text.length>0 &&_confirmTF.text.length > 0) {
         _comfirmFixView.alpha = 0.7;
    }
}

#pragma mark - 确认修改方法

-(void)changePsw
{
    NSLog(@"已经修改了密码，么么哒");
    
}

#pragma mark - 键盘点击return 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"点击了return");
    
    //判断三个输入框是否都有东西
    //判断新密码和确认密码是否一样
    if (_OldPswTF.text.length > 0&& _NewPswTF.text.length>0 &&_confirmTF.text.length > 0) {
        
        [self.view endEditing:YES];
        _comfirmFixView.alpha = 0.7;
        [_OldPswTF resignFirstResponder];
        [_NewPswTF resignFirstResponder];
        [_confirmTF resignFirstResponder];
        
        //执行确认登陆按钮的方法 以后添加
        [self changePsw];
        

        
        
        return YES;
        
            }
    
    
    return NO;
    
    
   // [self.view endEditing:YES];
    
}


#pragma mark -键盘弹出视图上升

//键盘出现时，让视图上升

- (void)textFieldDidBeginEditing:(UITextField *)textField

{

    
    //获得当前视图中心
    
    CGPoint p=self.view.center;
    
    //让视图中心在y坐标上升更150
    
    p.y-=150;
    
    [self.view setCenter:p];
    
    _alphaView.hidden =YES;
    
   // self.navigationController.navigationBar.hidden =YES;
    
    
    self.navView.hidden = YES;
    
    
    
    self.title = @"";
    
    if (_OldPswTF.text.length > 0 && _NewPswTF.text.length > 0 &&_confirmTF.text.length >0) {
        //_isCanClick = YES;
        _comfirmFixView.alpha = 0.7;
        _comfirmFixView.userInteractionEnabled = YES;
        
    }
    
    
    else{
        
        _comfirmFixView.alpha = 0.2;
        _comfirmFixView.userInteractionEnabled = NO;
        
    }

    
    //设置动画名字
#if 0
    [UIView beginAnimations:@"Animation"context:nil];
    
    //设置动画的间隔时间
    
    [UIView setAnimationDuration:0.20];
    
    //在当前正在运行的状态下开始下一段动画
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    //设置视图移动的偏移量
    
    //self.view.frame =CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y -150,self.view.frame.size.width,self.view.frame.size.height);
    //获得当前视图中心
    
    CGPoint p=self.view.center;
    
    //让视图中心在y坐标上升更150
    
    p.y-=150;
    
    [self.view setCenter:p];
    
    _alphaView.hidden =YES;
    
    self.title = @"";
    
    //设置动画结束
    
    [UIView commitAnimations];
    
#endif
    
}

//键盘消失时，试图恢复原样

- (void)textFieldDidEndEditing:(UITextField *)textField

{
//#if 0
   
    
    CGPoint p=self.view.center;
    
    p.y+=150;
    
    [self.view setCenter:p];
   // _alphaView.hidden = NO;
  //  self.navigationController.navigationBar.hidden = NO;
    
    self.navView.hidden= NO;
    
    
    self.title = @"账号管理";
    
//#endif
   // 设置动画的名字
#if 0
    
        [UIView beginAnimations:@"Animation"context:nil];
    
    //设置动画的间隔时间
    
    [UIView setAnimationDuration:0.4];
    
    //使用当前正在运行的状态开始下一段动画
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    //设置视图移动的位移
    
    //self.view.frame =CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y +150,self.view.frame.size.width,self.view.frame.size.height);
    
    CGPoint p=self.view.center;
    
    p.y+=150;
    
    [self.view setCenter:p];
    
    _alphaView.hidden = NO;
    self.title = @"账号管理";
    
    //设置动画结束
    
    [UIView commitAnimations];
    
#endif
}
#pragma mark -取消键盘第一响应

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [self.view endEditing:YES];
    [_OldPswTF resignFirstResponder];
    [_NewPswTF resignFirstResponder];
    [_confirmTF resignFirstResponder];
    
    

}
#pragma mark -更换头像
-(void)test
{
    
    [JCAlertView showMultipleButtonsWithTitle:@"更换头像" Message:@"" Click:^(NSInteger index) {
        NSLog(@"click%zi", index);
    } Buttons:@{@(JCAlertViewButtonTypeDefault):@"拍照"},@{@(JCAlertViewButtonTypeCancel):@"从手机相册获取"},@{@(JCAlertViewButtonTypeWarn):@"取消"}, nil];
    
    
}
-(void)makeMyUI
{
    
#pragma mark -头像相关设置
    //用sd自动布局来创建几个类似tableViewcell的View
    //头像
    _headImgView = [[UIView alloc]init];
      [self.view addSubview:_headImgView];
    
    _headImgView.sd_layout
    .topSpaceToView(self.navigationController.navigationBar,20)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(70);
    
    _headImgView.backgroundColor = [UIColor whiteColor];
    _headImgView.alpha = 0.2;
    
    _headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(test)];
    
    [_headImgView addGestureRecognizer:tap];
    
    
    
    
    
    
    
    //头像图片
    
    //加一条线条
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    
    lineView.sd_layout
    .topSpaceToView(_headImgView,0)
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .heightIs(1);
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.7;
    
    //头像label
    UILabel *headLabel = [[UILabel alloc]init];
    [self.view addSubview:headLabel];
    
    headLabel.sd_layout
    .bottomSpaceToView(lineView,20)
    .leftSpaceToView(self.view,15)
    .widthIs(60)
    .heightIs(20);
    
    headLabel.font = [UIFont systemFontOfSize:17];
    headLabel.text = @"头像";
    headLabel.textColor = [UIColor whiteColor];
    
    //headLabel.text = @"头像";
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String"];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,5)];
//    headLabel.attributedText = str;

    #pragma mark -用户名相关设置
    //用户名
    
    _userNameView = [[UIView alloc]init];
    
    [self.view addSubview:_userNameView];
    
    
    _userNameView.sd_layout
    .topEqualToView(lineView)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    
    _userNameView.backgroundColor = [UIColor whiteColor];
    _userNameView.alpha = 0.2;
    
    //用户名label
    
    UILabel *userNameLabel = [[UILabel alloc]init];
    [self.view addSubview:userNameLabel];
    
    userNameLabel.sd_layout
    .topSpaceToView(lineView,20)
    .leftSpaceToView(self.view,15)
    .widthIs(60)
    .heightIs(20);
   
   userNameLabel.font = [UIFont systemFontOfSize:17];
   userNameLabel.text = @"用户名";
   userNameLabel.textColor = [UIColor whiteColor];

    
    
    
    //第二条白线
    
    UIView * lineView1 = [[UIView alloc]init];
    [self.view addSubview:lineView1];
    
    lineView1.sd_layout
    .topSpaceToView(_userNameView,0)
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(1);
    lineView1.backgroundColor = [UIColor whiteColor];
    lineView1.alpha = 0.7;

    #pragma mark -原密码相关设置
    //原密码
    
    _oldPswView = [[UIView alloc]init];
    [self.view addSubview:_oldPswView];
    
    _oldPswView.sd_layout
    .topEqualToView(lineView1)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    
    _oldPswView.backgroundColor = [UIColor whiteColor];
    _oldPswView.alpha = 0.2 ;
    
    //原密码label
    UILabel *oldPswLabel = [[UILabel alloc]init];
    [self.view addSubview:oldPswLabel];
    
    oldPswLabel.sd_layout
    .topSpaceToView(lineView1,20)
    .leftSpaceToView(self.view,15)
    .widthIs(60)
    .heightIs(20);
    
    oldPswLabel.font = [UIFont systemFontOfSize:17];
    oldPswLabel.text = @"原密码";
    oldPswLabel.textColor = [UIColor whiteColor];
    
   
    
    
    
    
    
    
    
    
    //原密码与新密码之间的线
    
    UIView *lineView2 = [[ UIView alloc]init];
    [self.view addSubview:lineView2];
    
    lineView2.sd_layout
    .topSpaceToView(_oldPswView,0)
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(1);
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.alpha = 0.7;
    
    
    //原密码输入框
    
    _OldPswTF = [[UITextField alloc]init];
    _OldPswTF.textColor =[UIColor whiteColor];
    _OldPswTF.secureTextEntry = YES;
//    _OldPswTF.clearsOnBeginEditing  = YES;
    _OldPswTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _OldPswTF.delegate = self;
    
    //输入框添加方法
    
    [_OldPswTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    
    
    [self.view addSubview:_OldPswTF];
    
    
    _OldPswTF.sd_layout
    .bottomSpaceToView(lineView2,10)
    .leftSpaceToView(self.view,70)
    .rightSpaceToView(self.view,15)
    .heightIs(18);
    

 #pragma mark -新密码相关设置
    
    //新密码
    _NewPswView = [[UIView alloc]init];
    [self.view addSubview:_NewPswView];
    
    _NewPswView.sd_layout
    .topEqualToView(lineView2)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    
    _NewPswView.backgroundColor = [UIColor whiteColor];
    _NewPswView.alpha = 0.2 ;
    
    
    UILabel *NewPswLabel = [[UILabel alloc]init];
    [self.view addSubview:NewPswLabel];
    
    NewPswLabel.sd_layout
    .topSpaceToView(lineView2,20)
    .leftSpaceToView(self.view,15)
    .widthIs(60)
    .heightIs(20);
    
    NewPswLabel.font = [UIFont systemFontOfSize:17];
    NewPswLabel.text = @"新密码";
    NewPswLabel.textColor = [UIColor whiteColor];

    
    //新密码与确认密码之间的线
    
    UIView *lineView3 = [[ UIView alloc]init];
    [self.view addSubview:lineView3];
    
    lineView3.sd_layout
    .topSpaceToView(_NewPswView,0)
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(1);
    lineView3.backgroundColor = [UIColor whiteColor];
    lineView3.alpha = 0.7;
    
    //新密码输入框
    
    
    _NewPswTF = [[UITextField alloc]init];
    _NewPswTF.textColor =[UIColor whiteColor];
    _NewPswTF.secureTextEntry = YES;
   // _NewPswTF.clearsOnBeginEditing  = YES;
    _NewPswTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _NewPswTF.delegate=self;
    
    [_NewPswTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    

    [self.view addSubview:_NewPswTF];
    
    
    _NewPswTF.sd_layout
    .bottomSpaceToView(lineView3,10)
    .leftSpaceToView(self.view,70)
    .rightSpaceToView(self.view,15)
    .heightIs(18);

    
 #pragma mark -确认密码相关设置
    //确认密码
    
    _comfirmPswView = [[UIView alloc]init];
    [self.view addSubview:_comfirmPswView];
    
    _comfirmPswView.sd_layout
    .topEqualToView(lineView3)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    
    _comfirmPswView.backgroundColor = [UIColor whiteColor];
    
    _comfirmPswView.alpha = 0.2 ;
    
    
    UILabel *comfirmPswLabel = [[UILabel alloc]init];
    [self.view addSubview:comfirmPswLabel];
    
    comfirmPswLabel.sd_layout
    .topSpaceToView(lineView3,20)
    .leftSpaceToView(self.view,15)
    .widthIs(70)
    .heightIs(20);
    
    comfirmPswLabel.font = [UIFont systemFontOfSize:17];
    comfirmPswLabel.text = @"确认密码";
    comfirmPswLabel.textColor = [UIColor whiteColor];
    
    
    //确认密码下面的线
    
    UIView * lineView4 = [[UIView alloc]init];
    [self.view addSubview:lineView4];
    
    lineView4.sd_layout
    .topSpaceToView(_comfirmPswView,0)
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(1);
    lineView4.backgroundColor = [UIColor whiteColor];
    lineView4.alpha = 0.7;
    
    
    //确认密码输入框
    
    
    _confirmTF = [[UITextField alloc]init];
    _confirmTF.textColor =[UIColor whiteColor];
    _confirmTF.secureTextEntry = YES;
   // _confirmTF.clearsOnBeginEditing  = YES;
    _confirmTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmTF.delegate=self;
    [_confirmTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    

    
    [self.view addSubview:_confirmTF];
    
    
    _confirmTF.sd_layout
    .bottomSpaceToView(lineView4,10)
    .leftSpaceToView(comfirmPswLabel,5)
    .rightSpaceToView(self.view,15)
    .heightIs(18);

    
    
    

     //底部空白View
    UIView *footView = [[UIView alloc]init];
    [self.view addSubview:footView];
    
    footView.sd_layout
    .topEqualToView(lineView4)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(25);
    footView.backgroundColor = [UIColor whiteColor];
    footView.alpha = 0.2 ;
    
    
  #pragma mark -确认修改
    //确认修改
    
    _comfirmFixView = [[UIView alloc]init];
    [self.view addSubview:_comfirmFixView];
    
    _comfirmFixView.sd_layout
    .topSpaceToView(footView,20)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    
    _comfirmFixView.backgroundColor = [UIColor whiteColor];
    
    _comfirmFixView.alpha = 0.2 ;
    
    //确认修改label
    
    UILabel *comfirmFixLabel = [[UILabel alloc]init];
    [self.view addSubview:comfirmFixLabel];
    
    comfirmFixLabel.sd_layout
    .topSpaceToView(footView,35)
    .leftSpaceToView(self.view,(self.view.size.width-70)/2)
    .widthIs(70)
    .heightIs(20);
    
    comfirmFixLabel.font = [UIFont systemFontOfSize:17];
    comfirmFixLabel.text = @"确认修改";
    comfirmFixLabel.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * confirmTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePsw)];
    
    [_comfirmFixView addGestureRecognizer:confirmTap];
    
    _comfirmFixView.userInteractionEnabled = NO;
    

    
    
    
}

#pragma mark -设置导航栏UI
-(void)setUI
{
    

   //导航栏字体设置
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:20],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"授权管理";
#if 0
       [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
   // [self.navigationController.navigationBar setShadowImage:[UIImage new ]];
    
        self.navigationController.navigationBar.shadowImage = [UIImage new];
       self.navigationController.navigationBar.translucent = YES;
    
    for(UIView *aView in self.navigationController.navigationBar.subviews) {
        for(UIView *bView in aView.subviews) {
            if([bView isKindOfClass:[UIImageView class]] &&
               bView.bounds.size.width == self.navigationController.navigationBar.frame.size.width &&
               bView.bounds.size.height < 2) {
                bView.hidden = YES;
            }
        }
    }
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    
    CGRect frame = self.navigationController.navigationBar.frame;
   _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _alphaView.backgroundColor = [UIColor whiteColor   ];
    _alphaView.userInteractionEnabled = NO;
    [self.navigationController.navigationBar insertSubview: _alphaView atIndex:0];
    _alphaView.alpha = 0.2;
    
#endif
}
#pragma mark - tableView UI 设置
-(void)makeTableViewUI
{
    _tableView = [[ UITableView alloc]initWithFrame:CGRectMake(0, 84, self.view.size.width, 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor yellowColor];
    
    _tableView.tableHeaderView = [UIView new];
    
    _tableView.rowHeight = 70 ;
    
    
    
    
    [self.view addSubview:_tableView];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.alpha = 0.2;
    
    
   cell.textLabel.text = @"222";
    
    return cell;
    
    
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return  UIStatusBarStyleLightContent;
//}

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
