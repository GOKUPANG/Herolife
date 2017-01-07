//
//  AddIraViewController.m
//  xiaorui
//
//  Created by sswukang on 16/4/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AddIraViewController.h"
#import "CityField.h"
#import "IracData.h"
#import <SVProgressHUD.h>
#import "HRTotalData.h"
#import "AppDelegate.h"
#import "TipsLabel.h"
#import "DeviceListModel.h"
@interface AddIraViewController ()<UITextFieldDelegate, CityFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** TipsLabel */
@property(nonatomic, strong) TipsLabel *tipsLabel;
@property(nonatomic, weak) UILabel *tipsView;

/** brand */
@property(nonatomic, copy) NSString *brand;
/** model */
@property(nonatomic, copy) NSString *model;



/** 是否创建 成功 */
@property(nonatomic, assign) BOOL isCreate;

@property (weak, nonatomic) IBOutlet UITextField *brandField;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameField;


@end

@implementation AddIraViewController


- (void)viewDidLoad {
	
    [super viewDidLoad];
	
    self.brandField.textColor = [UIColor colorWithR:160 G:160 B:160 alpha:1.0];
    
    self.deviceNameField.textColor = [UIColor colorWithR:160 G:160 B:160 alpha:1.0];
	self.title = @"添加空调";
	self.addBtn.titleLabel.textColor = [UIColor colorWithR:161 G:161 B:161 alpha:1.0];
    self.cancelBtn.titleLabel.textColor = [UIColor colorWithR:161 G:161 B:161 alpha:1.0];
	_brandField.delegate = self;
	_deviceNameField.delegate = self;
	/// 建立socket连接 并组帧 发送请求数据
	[self postTokenWithTCPSocket];

	//添加提示框
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 64, UIScreenW, 30)];
	[self.view addSubview:self.tipsLabel];
	
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackEiter)];
	
	[self.view addGestureRecognizer:tap];
	
	//监听更新通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateIrac:) name:kNotificationCreateIrac object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.deviceNameField becomeFirstResponder];
    
    [self setUpBackGroungImage];
}
- (void)setUpBackGroungImage
{
    
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

static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}
#pragma mark - 通知  方法
static BOOL isOvertime = NO;
- (void)receviedWithCreateIrac:(NSNotification *)not
{
	isOvertime = YES;
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"添加设备成功!"];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)tapBackEiter
{
	[self.deviceNameField resignFirstResponder];
	[self.brandField resignFirstResponder];
}

#pragma mark - UI事件 发送socket数据
- (IBAction)addBtnClick:(UIButton *)sender {
	
	[self.deviceNameField resignFirstResponder];
	[self.brandField resignFirstResponder];
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送创建空调 请求帧
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUid];
	NSString *uuid = self.iradata.uuid;
	NSString *mid = self.iradata.did;
	
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	
	NSString *str = [NSString stringWithIRACVersion:@"0.0.1" status:@"200" token:token type:@"create" desc:@"push desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:@"None" uuid:uuid types:@"irac" newVersion:@"0.0.1" title:self.deviceNameField.text brand:self.brand created:@"None" update:@"None" state:@"1" picture:picture regional:regional model:self.model onSwitch:@"None" mode:@"None" temperature:@"None" windspeed:@"None" winddirection:@"None"];
	
		DDLogWarn(@"-------发送添加空调请求帧-------iracstr%@", str);
		[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在添加设备..."];

	// 启动定时器
	isOvertime = NO;
	isShowOverMenu = NO;
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backButtonClick:(UIButton *)sender {
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


- (void)dealloc
{
	DDLogError(@"dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - <UITextFieldDelegate>
// 是否允许用户在文本框上输入文字
// 作用:拦截用户的输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([textField isKindOfClass:[CityField class]]) {
		
		return NO;
	}
	return YES;
}

// 开始编辑的时候调用
- (void)textFieldDidBeginEditing:(id)textField
{
	if ([textField isKindOfClass:[CityField class]]) {
		
		[textField initialText];
		
	}
	
	DDLogInfo(@"----------");
	
	if (self.deviceNameField.text.length > 0 && self.brandField.text.length > 0) {
			self.addBtn.enabled = YES;
		}
	
}

#pragma mark - CityFieldDelegate
- (void)cityField:(CityField *)cityField brand:(NSString *)brand indexsType:(NSString *)indexsType
{
	DDLogInfo(@"brand%@ indexsType%@", brand, indexsType);
	
	self.brand = brand;
	self.model = indexsType;
}



@end
