//
//  AirCtrlViewController.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/24.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "AirCtrlViewController.h"
#import "AirCtrlView.h"
#import "IracData.h"

@interface AirCtrlViewController ()

@property (strong, nonatomic) AirCtrlView* airCtrlView;
/** 背景图片 */
@property(nonatomic, weak) UIImageView *backImageView;

@end

@implementation AirCtrlViewController
- (void)setIracData:(IracData *)iracData
{
	_iracData = iracData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加背景图片
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backImageView.image = [UIImage imageNamed: @"1.jpg"];
    [self.view addSubview: backImageView];
    self.backImageView = backImageView;
    
    //添加蒙版
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:backView];
    
    
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = self.iracData.title;
	self.airCtrlView = [[AirCtrlView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAV_BAR_HEIGHT)];
	
	self.airCtrlView.iracData = _iracData;
	[self.view addSubview:self.airCtrlView];
    
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = self.iracData.title;
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:navView];
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpBackGroungImage];
}
- (void)setUpBackGroungImage
{
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImageView.image = [UIImage imageNamed:@"1.jpg"];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImageView.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImageView.image =[UIImage imageNamed:imgName];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}
#pragma mark - UI事件
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
