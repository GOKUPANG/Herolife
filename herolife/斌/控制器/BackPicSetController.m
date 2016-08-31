//
//  BackPicSetController.m
//  herolife
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 huarui. All rights reserved.
//

#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
#define HRCommonScreenH (HRUIScreenH / 667 /2)
#define HRCommonScreenW (HRUIScreenW / 375 /2)


#import "BackPicSetController.h"
#import "UIView+SDAutoLayout.h"

@interface BackPicSetController ()

/** 选择背景图片按钮*/
@property(nonatomic,strong)UIButton *  ChooseBP;

/** 拍照按钮*/
@property(nonatomic,strong)UIButton * TakePic;


/** 线条*/

@property(nonatomic,strong)UIView * lineView;


/** 从手机相册选取*/

@property(nonatomic,strong)UIButton * FromPP;


/** 取消按钮*/

@property(nonatomic,strong)UIButton * Cancel;


/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;





@end

@implementation BackPicSetController

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
    navView.titleLabel.text = @"背景图设置";
  //  [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:navView];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navView = navView;

    
    
    
    [self makeUI];
    

}


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)makeUI
{
    _ChooseBP = [[UIButton alloc]init];
    _TakePic = [[UIButton alloc]init];
    _FromPP=[[UIButton alloc]init];
    _Cancel = [[UIButton alloc]init];
    _lineView=[[UIView alloc]init];
    
    [self.view addSubview:_ChooseBP];
    [self.view addSubview:_TakePic];
    [self.view addSubview:_FromPP];
    [self.view addSubview:_Cancel];
    [self.view addSubview:_lineView];
    
    
    _ChooseBP.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
    _TakePic.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
     _FromPP.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
     _Cancel.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
    _lineView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.7];
    
    
    [_ChooseBP setTitle:@"选择背景图" forState:UIControlStateNormal];

    
    [_TakePic setTitle:@"拍照" forState:UIControlStateNormal];
    
    [_FromPP setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    
    [_Cancel setTitle:@"取消" forState:UIControlStateNormal];

    /** 选择背景图*/
    _ChooseBP.sd_layout
    .topSpaceToView(self.view,200 * HRCommonScreenH)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(100 * HRCommonScreenH);
    
   /** 拍照*/
    
   _TakePic.sd_layout
    
    .topSpaceToView(_ChooseBP,30 * HRCommonScreenH)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(100 * HRCommonScreenH);
    
    
    /** 线条*/
    _lineView.sd_layout
    .topSpaceToView(_TakePic,0)
    .leftEqualToView(self.view )
    .rightEqualToView(self.view)
    .heightIs(0.7);
    
    
    /** 从手机相册选择*/
    
    _FromPP.sd_layout
    .topEqualToView(_lineView)
    .rightEqualToView(self.view)
    .leftEqualToView(self.view)
    .heightIs(100 * HRCommonScreenH);
    
    
    /** 取消 */
    
    _Cancel.sd_layout
    .topSpaceToView(_FromPP,30 * HRCommonScreenH)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(100 * HRCommonScreenH);
    
    
    #pragma mark -添加按钮点击事件

    
    [_ChooseBP addTarget:self action:@selector(ChooseBPIC) forControlEvents:UIControlEventTouchUpInside];
    [_TakePic addTarget:self action:@selector(TakePicWithPhone) forControlEvents:UIControlEventTouchUpInside];
    [_FromPP addTarget:self action:@selector(PicFromPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [_Cancel addTarget:self action:@selector(CancelBtn) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - 按钮点击事件实现方法
-(void)ChooseBPIC
{
    NSLog(@"选择背景图");
}


-(void)TakePicWithPhone
{
    NSLog(@"拍照");
    
}

-(void)PicFromPhone
{
    NSLog(@"从手机相册选择");
}

-(void)CancelBtn
{
    NSLog(@"取消");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
