//
//  IrgmStudyController.m
//  xiaorui
//
//  Created by sswukang on 16/5/11.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "IrgmStudyController.h"
#import "IrgmData.h"
#import "IrgmStudyView.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>

@interface IrgmStudyController ()
@property (nonatomic, strong) IrgmStudyView *irgmStudyView;

/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;


/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;


@end

@implementation IrgmStudyController



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
	self.title = @"电视学习";
    
    [self makeNavBarAndOthers];

	self.irgmStudyView = [[IrgmStudyView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    
	self.irgmStudyView.irgmData = self.irgmData;
    self.irgmStudyView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.irgmStudyView];
    
	
	[self postTokenWithTCPSocket];
	
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
    navView.titleLabel.text = @"通用学习";
    
    
    
    
    
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



#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}
//返回的时候要发送一次学习结束帧
- (void)backBtnClick
{
	
	NSString *UUID = [kUserDefault objectForKey:kUserDefaultUUID];
	if ([self.irgmData.op.lastObject isEqualToString:UUID]) {
		NSArray *op = @[@"None",@"None",@"None", UUID];
		[self sendDataToSocketWithArray:op state:@"9"];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 传参组帧
- (void)sendDataToSocketWithArray:(NSArray *)array state:(NSString *)state
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	NSArray *name01 = [NSArray array];
	NSArray *name02 = [NSArray array];
	NSArray *name03 = [NSArray array];
	NSArray *param01 = [NSArray array];
	NSArray *param02 = [NSArray array];
	NSArray *param03 = [NSArray array];
	NSString *str = [NSString stringWithIRGMVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"testing"
											   desc:@"testing desc message"
										srcUserName:user
										dstUserName:user
										 dstDevName:self.irgmData.uuid
												uid:self.irgmData.uid
												mid:self.irgmData.mid
												did:self.irgmData.did
											   uuid:self.irgmData.uuid
											  types:self.irgmData.types
										 newVersion:self.irgmData.version
											  title:self.irgmData.title
											  brand:self.irgmData.brand
											created:self.irgmData.created
											 update:self.irgmData.update
											  state:state
											picture:picture
										   regional:regional
												 op:array
											 name01:name01
											 name02:name02
											 name03:name03
											param01:param01
											param02:param02
											param03:param03];
	
	[self.appDelegate sendMessageWithString:str];
	DDLogInfo(@"leftBack-退出学习%@", str);
	
}

@end
