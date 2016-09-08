//
//  PushSettingController.m
//  herolife
//
//  Created by PongBan on 16/9/7.
//  Copyright © 2016年 huarui. All rights reserved.
//
#define HRMyScreenH (HRUIScreenH / 667.0)
#define HRMyScreenW (HRUIScreenW / 375.0 )


#import "PushSettingController.h"

@interface PushSettingController ()

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;

@end

@implementation PushSettingController


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
        
        
        
        self.backImgView.image = [UIImage imageNamed:@"Snip20160825_3"];
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


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    self.backImgView = backgroundImage;
    
    
    [self.view addSubview:self.backImgView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"应用";
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;
    

    
    [self makeBaseUI];
    
   
}


#pragma mark - 界面设置
-(void)makeBaseUI
{
   /****************************** 头像下面的线 ******************************/
    
    UIView * lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    
    [self.view addSubview:lineView1];
    
    lineView1.sd_layout
    .topSpaceToView(self.view,64+95*HRMyScreenH )
    .leftSpaceToView(self.view,5)
    .rightSpaceToView(self.view,5)
    .heightIs(1);
    
    /****************************** 头像 ******************************/
    
    UIImageView *headImgView = [[UIImageView alloc]init];
    [self.view addSubview:headImgView];
    
    headImgView.sd_layout
    .bottomSpaceToView(lineView1,5)
    .leftSpaceToView(self.view,15)
    .widthIs(70 *HRMyScreenH)
    .heightIs(70 *HRMyScreenH);
    
    headImgView.layer.cornerRadius = 35 *HRMyScreenH;
    headImgView.layer.masksToBounds = YES;
    headImgView.image = [UIImage imageNamed:@"1.jpg"];
    
    /****************************** 头像名字Label ******************************/
    
    

    UILabel * headLabel = [[UILabel alloc]init];
    [self.view addSubview:headLabel];

    headLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
  //  NSArray *fontArray = [UIFont familyNames];
    
   // NSArray *famliyArray = [UIFont fontNamesForFamilyName:@"PingFang SC"];
    
  //  NSLog(@"%@",Array);
    
    
    headLabel.textColor = [UIColor whiteColor];
    
    headLabel.text =@"HEROLIFE";
    
    
    headLabel.sd_layout
    .bottomSpaceToView(lineView1,30 * HRMyScreenH)
    .leftSpaceToView(headImgView,10)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
/****************************** 第二条线基本推送下面的线 ******************************/
    
    
    UIView * lineView2 =[[UIView alloc]init];
    lineView2.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    [self.view addSubview:lineView2];
    
    lineView2.sd_layout
    .topSpaceToView(lineView1,43.5 * HRMyScreenH)
    .leftEqualToView(lineView1)
    .rightEqualToView(lineView1)
    .heightIs(1);
    
    #pragma mark - 基本推送label
    
    //基本推送label
    
    UILabel *pushLabel = [[UILabel alloc]init];
    pushLabel .textColor = [UIColor whiteColor];
    pushLabel.text = @"基本推送";
    pushLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * HRMyScreenH];
    [self.view addSubview:pushLabel];
    
    pushLabel.sd_layout
    .bottomSpaceToView(lineView2,10*HRMyScreenH)
    .leftSpaceToView(self.view,15)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    /****************************** 第三条线推送1 ******************************/
    
    UIView *lineView3 = [[UIView alloc]init];
    [self.view addSubview:lineView3];
    lineView3.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView3.sd_layout
    .topSpaceToView(lineView2,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView2)
    .heightIs(1);
    
    
   
    
    
    
    
     /****************************** 第四条线推送2 ******************************/
    
    UIView *lineView4 = [[UIView alloc]init];
    [self.view addSubview:lineView4];
    lineView4.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView4.sd_layout
    .topSpaceToView(lineView3,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView3)
    .heightIs(1);


    /****************************** 第5条线推送3 ******************************/
    
    UIView *lineView5 = [[UIView alloc]init];
    [self.view addSubview:lineView5];
    lineView5.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView5.sd_layout
    .topSpaceToView(lineView4,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView4)
    .heightIs(1);
    
    
    /****************************** 第6条线推送4 ******************************/
    
    UIView *lineView6 = [[UIView alloc]init];
    [self.view addSubview:lineView6];
    lineView6.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView6.sd_layout
    .topSpaceToView(lineView5,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView5)
    .heightIs(1);
    


    /****************************** 第7条线短信推送 ******************************/
    
    UIView *lineView7 = [[UIView alloc]init];
    [self.view addSubview:lineView7];
    lineView7.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView7.sd_layout
    .topSpaceToView(lineView6,68.0 * HRMyScreenH)
    .leftSpaceToView(self.view,5)
    .rightEqualToView(lineView6)
    .heightIs(1);
    
    
    /****************************** 第8条线短信推送1 ******************************/
    
    UIView *lineView8 = [[UIView alloc]init];
    [self.view addSubview:lineView8];
    lineView8.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView8.sd_layout
    .topSpaceToView(lineView7,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView7)
    .heightIs(1);

    /****************************** 第9条线短信推送2 ******************************/
    
    UIView *lineView9 = [[UIView alloc]init];
    [self.view addSubview:lineView9];
    lineView9.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.7];
    
    lineView9.sd_layout
    .topSpaceToView(lineView8,45.0 * HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW)
    .rightEqualToView(lineView8)
    .heightIs(1);


    
    /****************************** 推送开关 ******************************/

    
#pragma mark -基本推送
    
    UISwitch * SW1 = [[UISwitch alloc]init];
    [self.view addSubview:SW1];
    
    SW1.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView3,5)
    .heightIs(0)
    .widthIs(0);
    
    
    UISwitch * SW2 = [[UISwitch alloc]init];
    [self.view addSubview:SW2];
    
    SW2.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView4,5)
    .heightIs(0)
    .widthIs(0);
    
    
    UISwitch * SW3 = [[UISwitch alloc]init];
    [self.view addSubview:SW3];
    
    SW3.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView5,5)
    .heightIs(0)
    .widthIs(0);
    
    
    UISwitch * SW4 = [[UISwitch alloc]init];
    [self.view addSubview:SW4 ];
    
    SW4 .sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView6,5)
    .heightIs(0)
    .widthIs(0);
    
    
    #pragma mark - 短信推送
    
    
    UISwitch * MSW1 = [[UISwitch alloc]init];
    [self.view addSubview:MSW1];
    
    MSW1.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView8,5)
    .heightIs(0)
    .widthIs(0);
    
    
    
    UISwitch * MSW2 = [[UISwitch alloc]init];
    [self.view addSubview:MSW2];
    
    MSW2.sd_layout
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(lineView9,5)
    .heightIs(0)
    .widthIs(0);
    
    
    /******************************  短信推送Label ******************************/
    
    UILabel *MessLabel = [[UILabel alloc]init];
    UILabel *MessLabel1 = [[UILabel alloc]init];
     UILabel *MessLabel2 = [[UILabel alloc]init];
    [self.view addSubview:MessLabel];
    [self.view addSubview:MessLabel1];
     [self.view addSubview:MessLabel2];
    
    
   
    MessLabel .textColor = [UIColor whiteColor];
    MessLabel.text = @"短信推送";
    MessLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * HRMyScreenH];
   

    
    MessLabel.sd_layout
    .bottomSpaceToView(lineView7,10*HRMyScreenH)
    .leftSpaceToView(self.view,15)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
    
    MessLabel1 .textColor = [UIColor whiteColor];
    MessLabel1.text = @"劫持提醒";
    MessLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
    
    MessLabel1.sd_layout
    .bottomSpaceToView(lineView8,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
   
    MessLabel2 .textColor = [UIColor whiteColor];
    MessLabel2.text = @"防撬报警";
    MessLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
   
    
    MessLabel2.sd_layout
    .bottomSpaceToView(lineView9,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    
    /****************************** 基本推送Label *********************************/
    
    UILabel *PushLabel1 = [[UILabel alloc]init];
    UILabel *PushLabel2 = [[UILabel alloc]init];
    UILabel *PushLabel3 = [[UILabel alloc]init];
    UILabel *PushLabel4 = [[UILabel alloc]init];
    [self.view addSubview:PushLabel1];
    [self.view addSubview:PushLabel2];
    [self.view addSubview:PushLabel3];
    [self.view addSubview:PushLabel4];
    
    
    //Label的基本设置
    
    PushLabel1 .textColor = [UIColor whiteColor];
    PushLabel1.text = @"门锁操作信息推送";
    PushLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
    PushLabel2 .textColor = [UIColor whiteColor];
    PushLabel2.text = @"低电量提醒推送";
    PushLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];

    PushLabel3 .textColor = [UIColor whiteColor];
    PushLabel3.text = @"长时间未开关提醒推送";
    PushLabel3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];

    PushLabel4 .textColor = [UIColor whiteColor];
    PushLabel4.text = @"闯入风险提醒推送";
    PushLabel4.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17 * HRMyScreenH];
    
    
    
    /****************************** 基本推送Label的布局 *********************************/

    
    PushLabel1.sd_layout
    .bottomSpaceToView(lineView3,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);
    
    PushLabel2.sd_layout
    .bottomSpaceToView(lineView4,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);

    
    PushLabel3.sd_layout
    .bottomSpaceToView(lineView5,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);

    PushLabel4.sd_layout
    .bottomSpaceToView(lineView6,10*HRMyScreenH)
    .leftSpaceToView(self.view,42.5 *HRMyScreenW+5)
    .heightIs(20)
    .rightEqualToView(self.view);

    /****************************** 保存按钮的创建 *********************************/

    UIButton * SaveBtn = [[UIButton alloc]init];
    [self.view addSubview:SaveBtn];
    
    SaveBtn.sd_layout
    .bottomSpaceToView(self.view , 30.0 * HRMyScreenH)
    .rightSpaceToView(self.view,122.0 *HRMyScreenW)
    .widthIs(130.0 *HRMyScreenW)
    .heightIs(40.0 *HRMyScreenH);
    
    
    SaveBtn.layer.cornerRadius = 20.0 * HRMyScreenH;
    SaveBtn.layer.masksToBounds = YES;
    
    UIBlurEffect *blurEffect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //可以看见的毛玻璃
    
    UIVisualEffectView *VisualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    //将这个view覆盖整个图片
    
    VisualEffectView.frame = SaveBtn.frame;
    
    
    //添加到图片上去
    
    
    [SaveBtn addSubview:VisualEffectView];
    
  //z  SaveBtn.backgroundColor  =  [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    
    [SaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    [SaveBtn addTarget:self action:@selector(SaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testtttt)];
    [VisualEffectView addGestureRecognizer:tap];
    
    
}
#pragma mark - 毛玻璃点击
-(void)testtttt
{
    NSLog(@"测试");
    
}

#pragma mark -保存按钮点击方法
-(void)SaveBtnClick
{
    NSLog(@"点击了保存");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
