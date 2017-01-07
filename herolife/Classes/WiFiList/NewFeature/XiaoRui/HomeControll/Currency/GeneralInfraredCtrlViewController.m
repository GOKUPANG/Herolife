//
//  GeneralInfraredCtrlViewController.m
//  xiaorui
//
//  Created by sswukang on 15/12/23.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "GeneralInfraredCtrlViewController.h"
#import "GeneralInfraredCtrl.h"
#import <SVProgressHUD.h>
#import "IrgmData.h"
#import <MJExtension.h>

@interface GeneralInfraredCtrlViewController ()

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;


@property (nonatomic, strong) GeneralInfraredCtrl *ctrlView;

@end

@implementation GeneralInfraredCtrlViewController




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


-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImgView.image = [UIImage imageNamed:Defalt_BackPic];
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






- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
}
- (void)viewDidLoad {
	[super viewDidLoad];
    
    
    
    [self makeNavBarAndOthers];

	//self.view.backgroundColor = [UIColor whiteColor];
	self.title = self.irgmData.title;
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
	scrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:scrollView];
	self.ctrlView = [GeneralInfraredCtrl new];
    self.ctrlView.backgroundColor = [UIColor clearColor];
    
    
    
	self.ctrlView.irgmData = self.irgmData;
	[self.view addSubview:scrollView];
	[scrollView addSubview:self.ctrlView];
	[self.ctrlView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(scrollView);
		make.width.equalTo(scrollView);
		if (IS_3_5_INCH_SCREEN) {
			make.height.equalTo(scrollView);
		} else {
			make.height.equalTo(scrollView).offset(-NAV_BAR_HEIGHT+64);
		}
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUpdateIrgmWithTitle:) name:kNotificationUpdateIrgmWithTitle object:nil];
    
    
    
    
    
    
    
    
    
    
}

-(void)makeNavBarAndOthers
{
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    self.backImgView = backgroundImage;
    
    [self.view addSubview:self.backImgView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"电视";
    
     
    
    
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;

}


- (void)backButtonClick:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addUpdateIrgmWithTitle:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
	self.irgmData = data;
	self.title = data.title;
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
