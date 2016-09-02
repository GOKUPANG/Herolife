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
#import "ChooseBackPicCtl.h"

extern NSInteger showNum;



@interface BackPicSetController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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


/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;







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
    
    
    
    NSLog(@"extern的值是%ld",showNum);
    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    self.backImgView = backgroundImage;
    
    [self.view addSubview:self.backImgView];
    
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];

    
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
    
    
    
    
    ChooseBackPicCtl * CBP = [ChooseBackPicCtl new];
    
    
    __weak BackPicSetController * BPC =self;
    
    CBP.finishBlock = ^(NSInteger showNum){
        
        NSLog(@"传回来的值是 %ld",showNum);
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",showNum];
        
        
        BPC.backImgView.image = [UIImage imageNamed:imgName];
    }
    ;
    
    
    [self.navigationController pushViewController:CBP animated:YES];
    

}


-(void)TakePicWithPhone
{
    NSLog(@"拍照");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *pickVC = [[UIImagePickerController alloc]init];
        
        
        pickVC.delegate =self;
        
        pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self presentViewController:pickVC animated:YES completion:nil];
    
    }
}

-(void)PicFromPhone
{
    NSLog(@"从手机相册选择");
    
    UIImagePickerController * pickVC = [[UIImagePickerController alloc]init];
    
    /** 设置图片来源*/
    
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    pickVC.delegate =self;
    
    [self presentViewController:pickVC animated:YES completion:nil];
    
    

}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"进入系统相册");
    
    UIImage * photo = info[UIImagePickerControllerOriginalImage];
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"image.png"];
    
    NSLog(@"沙盒路径是%@",path);
    
    
    NSError *err;
    [manager removeItemAtPath:path error:&err];
    
    [UIImagePNGRepresentation(photo) writeToFile:path atomically:YES];
    
     self.backImgView.image = photo;
    
    showNum = -1;
    
    [[NSUserDefaults standardUserDefaults ] setInteger:showNum forKey:@"PicNum"];
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)CancelBtn
{
    NSLog(@"取消");
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
