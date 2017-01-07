//
//  CurrencyCtrlController.m
//  xiaorui
//
//  Created by sswukang on 16/6/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CurrencyCtrlController.h"
#import "CurrencyCtrlView.h"
#import <SVProgressHUD.h>
#import "IrgmData.h"
#import <MJExtension.h>

@interface CurrencyCtrlController ()
@property (nonatomic, strong) CurrencyCtrlView *currencyCtrlView;
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;

@end

@implementation CurrencyCtrlController

- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:backgroundImage];
    self.backgroundImage = backgroundImage;
    
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
	
	self.currencyCtrlView = [[CurrencyCtrlView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
	self.currencyCtrlView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.currencyCtrlView];
	self.currencyCtrlView.irgmData = self.irgmData;
	
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = @"通用";
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        self.backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backgroundImage.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backgroundImage.image =[UIImage imageNamed:imgName];
    }
    
    
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
