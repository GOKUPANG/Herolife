//
//  EditViewController.m
//  xiaorui
//
//  Created by sswukang on 16/5/4.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "EditViewController.h"
#import "TipsLabel.h"
#import "CityField.h"
#import "testBut.h"
#import "AppDelegate.h"
#import "IracData.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface EditViewController ()<CityFieldDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BrandXiaButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

/** TipsLabel */
@property(nonatomic, strong) TipsLabel *tipsLabel;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
///测试按钮
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UITextField *deviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
///码库型号
@property (weak, nonatomic) IBOutlet CityField *codeModelField;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
///制冷
@property (weak, nonatomic) IBOutlet UIButton *refrigerationButton;
/**  */
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *mid;
@property(nonatomic, copy) NSString *did;
@property(nonatomic, copy) NSString *types;
@property(nonatomic, copy) NSString *uuid;

@property(nonatomic, copy) NSString *deviceTitle;
@property(nonatomic, copy) NSString *deviceDrand;
@property(nonatomic, copy) NSString *deviceModel;
@property(nonatomic, copy) NSString *onSwitch;
@property(nonatomic, copy) NSString *mode;
@property(nonatomic, copy) NSString *temperature;
@property(nonatomic, copy) NSString *windspeed;
@property(nonatomic, copy) NSString *winddirection;
/**  */
@property(nonatomic, copy) NSString *created;
/**  */
@property(nonatomic, copy) NSString *update;
/**  */
@property(nonatomic, copy) NSString *state;

@end

@implementation EditViewController

- (void)setIradata:(IracData *)iradata
{
	_iradata = iradata;
	self.uid = iradata.uid;
	self.uuid = iradata.uuid;
	self.mid = iradata.mid;
	self.did = iradata.did;
	self.types = iradata.types;
	self.deviceTitle = iradata.title;
	self.deviceDrand = iradata.brand;
	self.deviceModel = iradata.model;
	self.onSwitch = iradata.switchOff;
	self.mode = iradata.mode;
	self.temperature = iradata.temperature;
	self.windspeed = iradata.windspeed;
	self.winddirection = iradata.winddirection;
	self.update = iradata.update;
	self.created = iradata.created;
	self.state = iradata.state;
	
	self.deviceTextField.text = iradata.title;
	self.brandTypeTextField.text = [NSString stringWithFormat:@"%@ %@", iradata.brand, iradata.model];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.BrandXiaButton.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 64, UIScreenW, 30)];
	[self.view addSubview:self.tipsLabel];
	
	self.title = @"编辑测试";
    
    self.deviceTextField.textColor = [UIColor colorWithR:160 G:160 B:160 alpha:1.0];
    self.brandTypeTextField.textColor = [UIColor colorWithR:160 G:160 B:160 alpha:1.0];
    self.codeModelField.textColor = [UIColor colorWithR:160 G:160 B:160 alpha:1.0];
    self.determineBtn.titleLabel.textColor = [UIColor colorWithR:161 G:161 B:161 alpha:1.0];
    self.cancleBtn.titleLabel.textColor = [UIColor colorWithR:161 G:161 B:161 alpha:1.0];
   
	_deviceTextField.delegate = self;
	_brandTypeTextField.delegate = self;
	
	/// 建立socket连接 并组帧 发送请求数据
	[self postTokenWithTCPSocket];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackEiter)];
	
	[self.view addGestureRecognizer:tap];
	
	self.deviceTextField.text = self.deviceTitle;
	self.brandTypeTextField.text = [NSString stringWithFormat:@"%@ %@", self.deviceDrand, self.deviceModel];
	
	//监听更新通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateIrac:) name:kNotificationUpdateIrac object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingIrac:) name:kNotificationTestingIrac object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	
	//监听文本框传值
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithAirEditTestKeyboard:) name:kNotificationAirEditTestKeyboard object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
- (void)dealloc
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self setUpBackGroungImage];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (UIScreenW < 375) {
        [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refrigerationButton.mas_bottom).offset(50);
            make.right.equalTo(self.testBtn.mas_left);
            make.left.equalTo(self.refrigerationButton);
            make.height.mas_equalTo(40);
        }];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refrigerationButton.mas_bottom).offset(50);
            make.left.equalTo(self.testBtn.mas_right);
            make.right.equalTo(self.codeModelField);
            make.height.mas_equalTo(40);
        }];
    }
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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}
#pragma mark - 监听通知方法
static BOOL isOvertime1 = NO;
- (void)receviedWithTestingIrac:(NSNotification *)notification
{
	[SVProgressHUD dismiss];
	isOvertime1 = YES;
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"测试成功!"];
	
}
//监听空调的更新帧
static BOOL isOvertime = NO;
- (void)receviedWithUpdateIrac:(NSNotification *)notification
{
	isOvertime = YES;
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"修改成功!" ];
	NSDictionary *dict = notification.userInfo;
	IracData *irac = [IracData mj_objectWithKeyValues:dict[@"msg"]];
	
	self.deviceTextField.text = irac.title;
	self.brandTypeTextField.text = [NSString stringWithFormat:@"%@ %@", irac.brand, irac.model];
	
	if (_block) {
		
		self.block(irac);

	}
	if (irac && irac != nil) {
		if ([_delegate respondsToSelector:@selector(editViewController:iradata:)]) {
			[_delegate editViewController:self iradata:irac];
		}
		
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}
- (void)receviedWithAirEditTestKeyboard:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	self.deviceDrand = dict[@"brand"];
	self.deviceModel = dict[@"model"];
	
}
- (void)tapBackEiter
{
	[self.deviceTextField resignFirstResponder];
	[self.brandTypeTextField resignFirstResponder];
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
static NSInteger timeTeger = 1.0;
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}
#pragma mark - UI点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BrandXiaButton.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }];
}
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




//制冷按钮
- (IBAction)refrigerationButtonClick:(UIButton *)sender {
	[self.deviceTextField resignFirstResponder];
	[self.brandTypeTextField resignFirstResponder];
	
	//	sender.highlighted = NO;
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	DDLogInfo(@"token-------%@",token);
	/// 发送测试开空调 请求帧
	
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	
	//	DDLogWarn(@"-----------brand:%@uuid:%@uid:%@mid:%@:did%@",self.brand, uuid,uid,mid,did);
	NSString *str = [NSString stringWithIRACVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"testing"
											   desc:@"testing desc message"
										srcUserName:user
										dstUserName:user
										 dstDevName:self.uuid
												uid:self.uid
												mid:self.mid
												did:self.did
											   uuid:self.uuid
											  types:self.types
										 newVersion:@"0.0.1"
											  title:self.deviceTextField.text
											  brand:self.deviceDrand
											created:self.created
											 update:self.update
											  state:self.state
											picture:picture
										   regional:regional
											  model:self.deviceModel
										   onSwitch:@"FF"
											   mode:@"01"
										temperature:@"25"
										  windspeed:@"00"
									  winddirection:@"00"];
	
	DDLogWarn(@"-------发送测试空调请求帧-------iracTest%@", str);
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeTeger * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
			[SVProgressHUD dismiss];
		
	});

}

//温度按钮
- (IBAction)tempBtnClick:(UIButton *)sender {
	
	[self.deviceTextField resignFirstResponder];
	[self.brandTypeTextField resignFirstResponder];
	
	//	sender.highlighted = NO;
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	DDLogInfo(@"token-------%@",token);
	/// 发送测试开空调 请求帧
	
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	
	//	DDLogWarn(@"-----------brand:%@uuid:%@uid:%@mid:%@:did%@",self.brand, uuid,uid,mid,did);
	NSString *str = [NSString stringWithIRACVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"testing"
											   desc:@"testing desc message"
										srcUserName:user
										dstUserName:user
										 dstDevName:self.uuid
												uid:self.uid
												mid:self.mid
												did:self.did
											   uuid:self.uuid
											  types:self.types
										 newVersion:@"0.0.1"
											  title:self.deviceTextField.text
											  brand:self.deviceDrand
											created:self.created
											 update:self.update
											  state:self.state
											picture:picture
										   regional:regional
											  model:self.deviceModel
										   onSwitch:@"FF"
											   mode:@"00"
										temperature:@"26"
										  windspeed:@"00"
									  winddirection:@"00"];
	
	DDLogWarn(@"-------发送测试空调请求帧-------iracTest%@", str);
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeTeger * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[SVProgressHUD dismiss];
		
	});

	
}

//确定按钮
- (IBAction)determineBtnClick:(UIButton *)sender {
	[self.deviceTextField resignFirstResponder];
	[self.brandTypeTextField resignFirstResponder];
	
	//如果没有修改就不去 发送请求帧
	if ([self.deviceTextField.text isEqualToString: self.deviceTitle ] && [self.brandTypeTextField.text isEqualToString: [NSString stringWithFormat:@"%@ %@", self.deviceDrand, self.deviceModel]]) {
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			
			[self.navigationController popViewControllerAnimated:YES];
		});
	}
	
	DDLogError(@"uid%@", self.uid);
	
	if (self.deviceTextField.text.length > 0|| self.brandTypeTextField.text.length > 0) {
		

	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	DDLogInfo(@"token-------%@",token);
	/// 发送更新空调 请求帧
	
	NSString *createDate = [NSString loadCurrentDate];
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	
//	DDLogWarn(@"-----------brand:%@uuid:%@uid:%@mid:%@:did%@",self.brand, uuid,uid,mid,did);
	NSString *str = [NSString stringWithIRACVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"update"
											   desc:@"update desc message"
										srcUserName:user
										dstUserName:user
										 dstDevName:self.uuid
												uid:self.uid
												mid:self.mid
												did:self.did
											   uuid:self.uuid
											  types:self.types
										 newVersion:@"0.0.1"
											  title:self.deviceTextField.text
											  brand:self.deviceDrand
											created:createDate
											 update:createDate
											  state:self.state
											picture:picture
										   regional:regional
											  model:self.deviceModel
										   onSwitch:self.onSwitch
											   mode:self.mode
										temperature:self.temperature
										  windspeed:self.windspeed
									  winddirection:self.winddirection];
	
	DDLogWarn(@"-------发送添加更新请求帧-------UPdatestr%@", str);
		[self.appDelegate sendMessageWithString:str];
		[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeTeger * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[SVProgressHUD dismiss];
		
	});
	}else//设备名  或品牌型号为0
	{
		[SVProgressTool hr_showErrorWithStatus:@"设备名或品牌型号不能为空!"];
	}
}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    
	[self.navigationController popViewControllerAnimated:YES];
}

//测试开空调
- (IBAction)testBtnClick:(UIButton *)sender {
	
//	static BOOL isOnSwich = YES;
	[self.deviceTextField resignFirstResponder];
	[self.brandTypeTextField resignFirstResponder];
	
//	sender.highlighted = NO;
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	DDLogInfo(@"token-------%@",token);
	/// 发送测试开空调 请求帧
	
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	
	//	DDLogWarn(@"-----------brand:%@uuid:%@uid:%@mid:%@:did%@",self.brand, uuid,uid,mid,did);
	NSString *str = [NSString stringWithIRACVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"testing"
											   desc:@"testing desc message"
										srcUserName:user
										dstUserName:user
										 dstDevName:self.uuid
												uid:self.uid
												mid:self.mid
												did:self.did
											   uuid:self.uuid
											  types:self.types
										 newVersion:@"0.0.1"
											  title:self.deviceTextField.text
											  brand:self.deviceDrand
											created:self.created
											 update:self.update
											  state:self.state
											picture:picture
										   regional:regional
											  model:self.deviceModel
										   onSwitch:@"FF"
											   mode:@"01"
										temperature:@"25"
										  windspeed:@"00"
									  winddirection:@"00"];
	
	DDLogWarn(@"-------发送测试空调请求帧-------iracTest%@", str);
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeTeger * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
		
	});

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
        [UIView animateWithDuration:0.25 animations:^{
            
            self.BrandXiaButton.layer.transform = CATransform3DMakeRotation(M_PI* 2, 0, 0, 1);
        }];
		[textField initialText];
		
	}
	
	DDLogInfo(@"----------");
	
	if (self.deviceTextField.text.length > 0 && self.brandTypeTextField.text.length > 0) {
		self.testBtn.enabled = YES;
	}
	
}

#pragma mark - CityFieldDelegate
- (void)cityField:(CityField *)cityField brand:(NSString *)brand indexsType:(NSString *)indexsType
{
	DDLogInfo(@"brand%@ indexsType%@", brand, indexsType);
	
	self.deviceDrand = brand;
	self.deviceModel = indexsType;
	
	
}
@end
