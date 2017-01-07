//
//  CurrencyController.m
//  xiaorui
//
//  Created by sswukang on 16/6/8.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CurrencyController.h"
#import <SVProgressHUD.h>
#import "IrgmData.h"
#import <MJExtension.h>
#import "CurrencyNewView.h"
#import "AppDelegate.h"

@interface CurrencyController ()
//@property (nonatomic, strong) CurrencyView *currencyView;

@property (nonatomic, strong) CurrencyNewView *currencyView;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;

@end

@implementation CurrencyController

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
    
	
	self.currencyView = [[CurrencyNewView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
	self.currencyView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.currencyView];
	self.currencyView.irgmData = self.irgmData;
	
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = self.irgmData.title;
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    
	[self postTokenWithTCPSocket];
	
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
