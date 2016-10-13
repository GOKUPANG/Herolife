//
//  OpenLockController.m
//  herolife
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "OpenLockController.h"
#import "UIView+SDAutoLayout.h"
#import "NSString+DoorLock.h"
#import "DeviceListModel.h"



/** 高度比例*/
#define Percent_H 75.0/667.0
/** 宽度比例*/
#define Percent_W 125.0/375.0
/** 视图的宽度*/
#define VIEW_W [UIScreen mainScreen].bounds.size.width * 125.0/375.0
/** 视图的高度*/
#define VIEW_H  [UIScreen mainScreen].bounds.size.height  * 75.0/667.0
/** 总的个数*/
#define SIZE 12
/** 单行个数*/
#define NUM 3
/** 行距*/
#define MARGIN_Y 0
/** 状态栏高度[方便整体调整]*/
#define START_H  [UIScreen mainScreen].bounds.size.height - (Percent_H *SCREEN_H  + VIEW_H *4)

/** 屏幕高度*/
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width


@interface OpenLockController ()


/** 输入框*/
@property(nonatomic,strong)UITextField * MimaTF;

/** 锁 */
@property(nonatomic,strong)UIButton * DoorLockBtn;


/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;


/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;


@property(nonatomic, weak) AppDelegate *appDelegate;

/** 获得的动态秘钥*/
@property(nonatomic,copy)NSString * dynamicKey ;

/** 开锁 定时器*/

@property(nonatomic,strong) NSTimer * timer;







@end

@implementation OpenLockController


#pragma mark - tabbar 设置
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
        
        
        
        self.backImgView.image = [UIImage imageNamed:@"1.jpg"];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"1.jpg"];
    self.backImgView = backgroundImage;
    
    
    [self.view addSubview:backgroundImage];
    
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:view];
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"智能开锁";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:navView];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navView = navView;
    
    
    [self makeUI];
    
    [self makeView];
    
    
    /***************** 与服务器建立socket连接*******************/
    
    [self postTokenWithTCPSocket];
    
    /********************   添加通知 ****************************/
    
    [self addNotificationCenterObserver];
    
}

static BOOL isOvertime = NO;

- (void)backButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
	
}
#pragma mark - 添加通知

-(void)addNotificationCenterObserver
{
    
    
    
    //监听开关锁的控制帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDoorOpenOrNot:) name:@"kDoorOpenOrNot" object:nil];
    //监听门锁是否在线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDoorOnlineOrNot:) name:@"kDoorOnlineOrNot" object:nil];
    
    //监听门锁wifi盒子不在线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithBoxNotOnline) name:kNotificationNotOnline object:nil];
    
}


#pragma mark -WiFi盒子不在线

-(void)receviedWithBoxNotOnline
{
    //[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线"];
    
   isOvertime  = YES;
    
    NSLog(@"------------------收到目标设备不在线-----------------设置不超时");

    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - 门锁是否在线通知实现方法
-(void)receviedWithDoorOnlineOrNot:(NSNotification *)notification


{
    
    
    
    NSLog(@"------------------收到门锁在线与否的帧-----------------设置不超时");
    
    
    
    
    
  //  isOvertime = YES ;
    
    NSDictionary *dict = notification.userInfo;
    
    int stateFloat  =  [dict[@"msg"][@"state"] intValue];
    NSLog(@"收到的dict是%@",dict);
    
    switch (stateFloat) {
        case 0:
        {
            [SVProgressTool hr_showErrorWithStatus:@"离线!"];
            
            
        }
            break;
            
        case 1:{
            
            //门锁状态正常   继续发送帧请求开锁
            
            
            NSString * dynamicKey = dict[@"msg"][@"key"];
            
            _dynamicKey = dict[@"msg"][@"key"] ;
            
            
         //   NSString * jiamiStr = [NSString hr_stringWithBase64String:_MimaTF.text];
            
     NSString * jiamiStr =       [NSString hr_openLock_base64String:_MimaTF.text dynamicStr:_dynamicKey];
            
            
            
            NSLog(@"动态秘钥是%@",dynamicKey);
            
            
            
          
            
            NSLog(@"门锁状态正常  继续发送帧请求开锁");
            
            NSString *token = [kUserDefault objectForKey:PushToken];
            
            NSString *srcUserName  =  [kUserDefault objectForKey:kDefaultsUserName];
            
            NSString *UUID = [kUserDefault objectForKey:kUserDefaultUUID];
            
            DeviceListModel *model = self.listModel;
            
            
            
            NSString * uid = model.uid;
            
            
            NSString * did  =  model.did;
            
            NSString *DoorUUID = model.uuid;
            
            
            
            
            
           if (self.AuthorUserName.length > 0   )
           {  //把获得的dynamicKey放到auth这个字段中去
               NSString * RequestStr = [NSString stringWithHROpenLockVersion:@"0.01" status:@"200" token:token type:@"control1" desc:@"none" srcUserName:srcUserName srcDevName:UUID dstUserName:self.AuthorUserName dstDevName:DoorUUID msgTypes:@"hrsc" uid:uid did:did uuid:DoorUUID state:@"none" online:@"none" control:@"2" number:@"none" key:@"none" auth:jiamiStr];
               
               
               
               
               
               
               [self.appDelegate sendMessageWithString:RequestStr];

               
           }
            
           else{
               
               //把获得的dynamicKey放到auth这个字段中去
               NSString * RequestStr = [NSString stringWithHROpenLockVersion:@"0.01" status:@"200" token:token type:@"control1" desc:@"none" srcUserName:srcUserName srcDevName:UUID dstUserName:srcUserName dstDevName:DoorUUID msgTypes:@"hrsc" uid:uid did:did uuid:DoorUUID state:@"none" online:@"none" control:@"2" number:@"none" key:@"none" auth:jiamiStr];
               
               
               
               
               
               
               [self.appDelegate sendMessageWithString:RequestStr];
               
           }
            
//            //把获得的dynamicKey放到auth这个字段中去
//             NSString * RequestStr = [NSString stringWithHROpenLockVersion:@"0.01" status:@"200" token:token type:@"control1" desc:@"none" srcUserName:srcUserName srcDevName:UUID dstUserName:srcUserName dstDevName:DoorUUID msgTypes:@"hrsc" uid:uid did:did uuid:DoorUUID state:@"none" online:@"none" control:@"2" number:@"none" key:@"none" auth:jiamiStr];
//            
//            
//        
//            
//          
//            
//            [self.appDelegate sendMessageWithString:RequestStr];
            
            
        }
            break;
            
        case 2:{
            [SVProgressTool hr_showErrorWithStatus:@"忙碌!"];
            
            
        }
            
            break;
            
        case 3:{
            
            [SVProgressTool hr_showErrorWithStatus:@"禁止!"];
            
            
        }
            break;
            
        case 4:{
            
            [SVProgressTool hr_showErrorWithStatus:@"欠费!"];
            
            
        }
            
            break;
            
        case 5:
        {
            [SVProgressTool hr_showErrorWithStatus:@"关闭远程!"];
            
            
        }
            break;
            
        case 6:
        {
            [SVProgressTool hr_showErrorWithStatus:@"未配对门锁!"];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - 开锁是否成功通知实现方法
-(void)receviedWithDoorOpenOrNot:(NSNotification *)notification
{
    
    
    NSLog(@"------------------收到门锁第二个帧-----------------设置不超时");

    
    
    isOvertime = YES;
    

    NSDictionary *dict = notification.userInfo;
    
    int controlNum = [dict[@"msg"][@"control"] intValue];
    
    /*  3:操作成功 4:密码错误 5:密钥错误 6:非法用户 7:授权失效 8:操作失败  **/
    
    switch (controlNum) {
        case 3:
        {
            [SVProgressTool hr_showSuccessWithStatus:@"开锁成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        }
            break;
            
        case 4:
        {
            [SVProgressTool hr_showErrorWithStatus:@"密码错误!"];
            
        }
            break;
        case 5:
        {
            [SVProgressTool hr_showErrorWithStatus:@"秘钥错误!"];
            
        }
            break;
            
        case 6:
        {
            [SVProgressTool hr_showErrorWithStatus:@"非法用户"];
            
        }
            break;
            
        case 7:
        {
            [SVProgressTool hr_showErrorWithStatus:@"授权失效!"];
            
        }
            break;
            
        case 8:
        {
            [SVProgressTool hr_showErrorWithStatus:@"操作失败!"];
            
        }
            break;
            
            
            
        default:
            break;
    }
    
    
}

#pragma mark - 确定按钮 开锁 事件
-(void)UnlockDoor
{
    
    NSLog(@"获得的密码是%@",_MimaTF.text);
    
     
    
    
    if (_MimaTF.text.length>12||_MimaTF.text.length<6) {
        NSLog(@"请输入6到12位的开锁密码");
       
        
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入6到12位的开锁密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
               
        
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
         return;
        
        
        
    }
    
    
    
    
    
    

    
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushToken"];
    
    NSString *srcUserName  =  [kUserDefault objectForKey:kDefaultsUserName];
    
    NSString *UUID = [kUserDefault objectForKey:kUserDefaultUUID];
    
    DeviceListModel *model = self.listModel;
    
    
    
    NSString * uid = model.uid;
    
    
    NSString * did  =  model.did;
    
    
    NSString *DoorUUID  = model.uuid;
    
    
    if (self.AuthorUserName.length > 0   ) {
        NSLog(@"---------------------我是别人授权给我的----------------------------");
        
        
        
        NSLog(@"-------授权给我的这个锁的主人的名字是%@---------",self.AuthorUserName);
        
        
        
        NSString * RequestStr = [NSString stringWithHROpenLockVersion:@"0.01" status:@"200" token:token type:@"control1" desc:@"none" srcUserName:srcUserName srcDevName:UUID dstUserName:self.AuthorUserName dstDevName:DoorUUID msgTypes:@"hrsc" uid:uid did:did uuid:DoorUUID state:@"none" online:@"none" control:@"0" number:@"none" key:@"none" auth:@"none"];
        
        [self.appDelegate sendMessageWithString:RequestStr];
        
           NSLog(@"请求帧wjjtest是%@",RequestStr);

        
        
    }
    
    else{
        NSLog(@"-------------------我不是别人授权的我是我自己-----------------------");
        
        
        NSString * RequestStr = [NSString stringWithHROpenLockVersion:@"0.01" status:@"200" token:token type:@"control1" desc:@"none" srcUserName:srcUserName srcDevName:UUID dstUserName:srcUserName dstDevName:DoorUUID msgTypes:@"hrsc" uid:uid did:did uuid:DoorUUID state:@"none" online:@"none" control:@"0" number:@"none" key:@"none" auth:@"none"];
        
        
        [self.appDelegate sendMessageWithString:RequestStr];
        
        
    }

    
    
    
    
    
//    NSString * RequestStr = [NSString stringWithHROpenLockVersion:@"0.01" status:@"200" token:token type:@"control1" desc:@"none" srcUserName:srcUserName srcDevName:UUID dstUserName:srcUserName dstDevName:DoorUUID msgTypes:@"hrsc" uid:uid did:did uuid:DoorUUID state:@"none" online:@"none" control:@"0" number:@"none" key:@"none" auth:@"none"];
//    
//    NSLog(@"请求的字符串是%@",RequestStr);
//    
//    
//    
//    
//    [self.appDelegate sendMessageWithString:RequestStr];
    
     [SVProgressTool hr_showWithStatus:@"正在开锁"];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
    
    
    
    
    /** 密码正确 改变门锁图标为开锁状态*/
    
    _DoorLockBtn.selected = YES;
    
    
}


#pragma mark - 定时器事件
-(void)startTimer
{
    
    if (!isOvertime) {
        
        
        [SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
        
        
        [_timer invalidate];
        
        
    }
    
    
    
   
}


#pragma mark - 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate connectToHost];
    self.appDelegate = appDelegate;
    
}
#pragma mark - 导航条左边返回方法
-(void)popToLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -基本控件搭建
-(void)makeUI
{
    
    /** 背景键盘图片*/
    UIImageView *imageView1  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"键盘"]];
    
    [self.view addSubview:imageView1];
    
    imageView1.sd_layout
    .bottomSpaceToView(self.view,75.0/667.0 * self.view.bounds.size.height)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(300.0/667.0 *self.view.bounds.size.height);
    
    
    /** 键盘上面的输入框 */
    
    UIView * mimaView = [[UIView alloc]init];
    
    [self.view addSubview:mimaView];
    
    mimaView.sd_layout
    .bottomSpaceToView(imageView1,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(40.0/667 * SCREEN_H);
    
   // mimaView . backgroundColor = [UIColor greenColor];
    
    mimaView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    
    
    
    _MimaTF = [[UITextField alloc]initWithFrame:CGRectMake(10.0/667 * SCREEN_H, 0, SCREEN_W-80, 40.0/667.0 * SCREEN_H)];
    
    _MimaTF.placeholder = @"请输入6到12位的开锁密码";
    #pragma mark -修改输入框提示语的颜色 KVO
    
  [_MimaTF setValue:[UIColor colorWithWhite:1.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    _MimaTF.secureTextEntry = YES;
    _MimaTF.enabled = NO;
    _MimaTF.font= [UIFont systemFontOfSize:17.0/667.0 * SCREEN_H];
    _MimaTF.textColor = [UIColor whiteColor];
    
    [mimaView addSubview:_MimaTF];
    
    
    /** 输入框右边的锁*/
    
    _DoorLockBtn = [[UIButton alloc]init];
    
    [self.view addSubview:_DoorLockBtn];
    
    _DoorLockBtn.sd_layout
    .rightSpaceToView(self.view,10.0/375 * SCREEN_W)
    .bottomSpaceToView(imageView1,7.0/667 *SCREEN_H)
    .widthIs(20.0/375.0 *SCREEN_W)
    .heightIs(26.0/667.0 *SCREEN_H);
    
    [_DoorLockBtn setImage:[UIImage imageNamed:@"关锁"] forState:UIControlStateNormal];
    
    [_DoorLockBtn setImage:[UIImage imageNamed:@"智能开锁"] forState:UIControlStateSelected];
    
    /** 一开始默认是关锁图标*/
    _DoorLockBtn.selected = NO;
    
    
    
    /** 键盘下面的View*/
    
    UIView * footView  = [[UIView alloc]init];
    
    [self.view addSubview:footView];
    
    footView.sd_layout
    .topSpaceToView(imageView1,0 )
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    footView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    
  /** 添加确定按钮
     按钮 rgb  198,240,255
   */
    
    UIButton * ConfirmBtn = [[UIButton alloc]init];
    [self.view addSubview:ConfirmBtn];
    
    
    ConfirmBtn.backgroundColor =[UIColor colorWithRed:198.0/255.0 green:240.0/255.0 blue:255.0/255.0 alpha:0.3];
    ConfirmBtn.sd_layout
    .topSpaceToView(imageView1,17.5/667.0 * SCREEN_H)
    .bottomSpaceToView(self.view,17.5/667.0 * SCREEN_H)
    .leftSpaceToView(self.view,142.5/375.0 *SCREEN_W)
    .rightSpaceToView(self.view,142.5/375.0 *SCREEN_W);
    
    ConfirmBtn.layer.cornerRadius = 20.0/667.0 *SCREEN_H;
    ConfirmBtn.clipsToBounds=YES;
    
    [ConfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    
  /** 点击确定按钮 事件*/
    [ConfirmBtn addTarget:self action:@selector(UnlockDoor) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /** 回退图片 X */
    
   UIImageView *BackSpaceImg = [[UIImageView alloc]init];
    
    [self.view addSubview:BackSpaceImg];
    
    BackSpaceImg.sd_layout
    .topSpaceToView(imageView1,27.5/667.0 * SCREEN_H)
    .bottomSpaceToView(self.view,27.0/667.5 * SCREEN_H)
    .rightSpaceToView(self.view,43.0/375.0 *SCREEN_W)
    .widthIs(30.0/375.0 * SCREEN_W);
    
    BackSpaceImg.image = [UIImage imageNamed:@"后退"];
    
    
    
    /** 回退按钮*/
    
    UIButton *backBtn = [[UIButton alloc]init];
    
    [self.view addSubview:backBtn];
    
    backBtn.sd_layout
    .topEqualToView(imageView1)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view)
    .widthIs(125.0/375.0 * SCREEN_W);
    /** 回退删除功能 点击事件*/

    [backBtn addTarget:self action:@selector(BackSpace) forControlEvents:UIControlEventTouchUpInside];
    
   
    /** 为按钮添加长按手势*/
    
    UILongPressGestureRecognizer * LPGR = [[ UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPress)];
    
    [backBtn addGestureRecognizer:LPGR];
    
    
}

#pragma mark - 长按删除全部

-(void)LongPress
{
    _MimaTF.text = @"";
    
}



#pragma mark -删除回退按钮 事件

-(void)BackSpace
{
    
    NSString * oldTfStr = _MimaTF.text;
    if (oldTfStr.length!= 0) {
        
        NSString * mimaTX = [oldTfStr substringToIndex:_MimaTF.text.length-1];
        
        _MimaTF.text = mimaTX;

        
    }
    
    
}



#pragma mark -创建九宫格
/** 九宫格*/
- (void)makeView{
    /** x的间距*/
    CGFloat margin_x =  0 ;
    
    /** y的间距*/
    CGFloat margin_y = MARGIN_Y;
    
    /** 图片数组*/
    //    NSArray *iamgeNameArr = @[@""];
    /** 名字*/
    
    
    for (int i=0; i<SIZE; i++) {
        // x的公式：公有部分(视图间距) + (视图宽度 + 视图间距) * 一行中第几个
        // 一行中第几个
        int row = i % NUM;
        CGFloat view_x = margin_x + (VIEW_W + margin_x) * row;
        
        // 第几行
        // y的公式：公有部分 + （视图高度 + 视图间距） * 第几行
        int low = i / NUM;
        CGFloat view_y = (START_H + margin_y) + (VIEW_H + margin_y) * low;
        
        
       UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(view_x, view_y, VIEW_W, VIEW_H)];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(OnNumberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        [self.view addSubview:btn];
        
    }
}


#pragma mark -点击键盘实现的方法

-(void)OnNumberBtnClick:(UIButton *)btn
{
    NSInteger tag = btn.tag + 1;
    
    NSString * oldtext =_MimaTF.text;
    
    if (tag ==11) {
        
         _MimaTF.text =  [oldtext stringByAppendingString:[NSString stringWithFormat:@"%ld",tag-11 ]];
        
    }
    
    else if (tag ==10)
    {
        _MimaTF.text=[oldtext stringByAppendingString:@"*"];
        
    }
    
    else if (tag ==12 ){
        
        _MimaTF.text=[oldtext stringByAppendingString:@"#"];

    }
    
    else{
        
         _MimaTF.text =  [oldtext stringByAppendingString:[NSString stringWithFormat:@"%ld",tag ]];
    }
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
