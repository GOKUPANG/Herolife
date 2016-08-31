//
//  OpenLockController.m
//  herolife
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "OpenLockController.h"
#import "UIView+SDAutoLayout.h"

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
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    [self.view addSubview:backgroundImage];
    
    
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
    
    _MimaTF.placeholder = @"请输入密码";
    #pragma mark -修改输入框提示语的颜色 KVO
    
    [_MimaTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
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


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - 确定按钮 开锁 事件 
-(void)UnlockDoor
{
    
    NSLog(@"获得的密码是%@",_MimaTF.text);
    
    
    
    NSLog(@"正在开锁");
    
    /** 密码正确 改变门锁图标为开锁状态*/
    
    _DoorLockBtn.selected = YES;
    
    
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
        
        
        
         _MimaTF.text =  [oldtext stringByAppendingString:[NSString stringWithFormat:@"%d",tag-11 ]];
        
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
