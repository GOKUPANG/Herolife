//
//  AddCurrencyView.m
//  xiaorui
//
//  Created by sswukang on 16/6/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AddCurrencyView.h"
#import "IrgmData.h"
#import <SVProgressHUD.h>
#import "HRTotalData.h"
#import "AppDelegate.h"
#import "NSString+Util.h"
#import "HRDOData.h"
@interface AddCurrencyView ()<UITextFieldDelegate>
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/**  */
@property(nonatomic, weak) UIView *eptView;
/** titleLabel */
@property(nonatomic, weak) UILabel *titleLabel;
/** deviceLabel */
@property(nonatomic, weak) UILabel *deviceLabel;
/** deviceTextField */
@property(nonatomic, weak) UITextField *deviceTextField;
/** determineBtn */
@property(nonatomic, weak) UIButton *determineBtn;
/** determineBtn */
@property(nonatomic, weak) UIButton *cancelBtn;


/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

@end
@implementation AddCurrencyView

- (void)setData:(IrgmData *)data
{
	_data = data;
}
- (void)setDoData:(HRDOData *)doData
{
	_doData = doData;
	self.deviceTextField.text = doData.parameter[1];
	DDLogWarn(@"%@", self.doData.uuid);
}
- (void)setTextLabel:(NSString *)textLabel
{
	_textLabel = textLabel;
	self.titleLabel.text = textLabel;
}

- (void)setTitleButton:(NSString *)titleButton
{
	_titleButton = titleButton;
	[self.determineBtn setTitle:titleButton forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		//初始化
		[self setUp];
		/// 建立socket连接 并组帧 发送请求数据
		[self postTokenWithTCPSocket];
		//通知
		[self addNotificationCenterObserver];
		//手势
		[self addTapGesture];
	}
	return self;
}
//初始化
- (void)setUp{
	
	UIView *view = [[UIView alloc]init];
	self.backgroundColor  = [UIColor colorWithR:127 G:127 B:127 alpha:0.6];
	view.backgroundColor = [UIColor whiteColor];
	self.eptView = view;
	
	[self addSubview:view];
	
	///往空view里添加控件
	// 标题
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.9];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.font = [UIFont systemFontOfSize:18];
	[self.eptView addSubview:titleLabel];
	self.titleLabel = titleLabel;
	
	// 设备名
	UILabel *deviceLabel = [[UILabel alloc] init];
	deviceLabel.text = @"设备名";
	deviceLabel.textColor = [UIColor blackColor];
	deviceLabel.textAlignment = NSTextAlignmentCenter;
	deviceLabel.font = [UIFont systemFontOfSize:17];
	[self.eptView addSubview:deviceLabel];
	self.deviceLabel = deviceLabel;
	
	//文本框
	UITextField *deviceTextField = [[UITextField alloc] init];
	deviceTextField.placeholder = @"请输入设备名";
	deviceTextField.delegate = self;
	deviceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	deviceTextField.borderStyle = UITextBorderStyleRoundedRect;
	[self.eptView addSubview:deviceTextField];
	self.deviceTextField = deviceTextField;
	
	//确定按钮
	UIButton *determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	determineBtn.backgroundColor = [UIColor themeColor];
	[determineBtn setTintColor:[UIColor whiteColor]];
	determineBtn.titleLabel.font = [UIFont systemFontOfSize:16];
	[determineBtn addTarget:self action:@selector(determineBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.eptView addSubview:determineBtn];
	self.determineBtn = determineBtn;
	
	//取消按钮
	UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	cancelBtn.backgroundColor = [UIColor themeColor];
	[cancelBtn setTintColor:[UIColor whiteColor]];
	cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
	[cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.eptView addSubview:cancelBtn];
	self.cancelBtn = cancelBtn;
}

#pragma mark - UI点击
- (void)determineBtnClick
{
	
	[self.deviceTextField resignFirstResponder];
	if (self.deviceType == HRCurrencyDeviceTypeTV) {
		
		[self sendDataToSocketWithPicture:@"1"];
	} else if (self.deviceType == HRCurrencyDeviceTypeCurrency) {//通用
		
		[self sendDataToSocketWithPicture:@"2"];
	}else if (self.deviceType == HRCurrencyDeviceTypeDo) {
		
		[self sendDataToSocketWithOpArray];
	}
}
#pragma mark - 组帧
- (void)sendDataToSocketWithOpArray
{
	NSString *deviceName = [self.deviceTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	if (deviceName.length > 0) {
		
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
		NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
		NSString *xiaoRuiUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
		NSArray *parameter = @[self.doData.parameter.firstObject, @"None", self.deviceTextField.text, self.doData.parameter[2]];
		NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"update" desc:@"update desc message" srcUserName:user dstUserName:user dstDevName:xiaoRuiUUID uid:self.doData.uid mid:self.doData.mid did:self.doData.did uuid:self.doData.uuid types:@"hrdo" newVersion:@"0.0.1" title:self.deviceTextField.text brand:self.doData.brand created:[NSString loadCurrentDate] update:[NSString loadCurrentDate] state:@"1" picture:self.doData.picture regional:self.doData.regional parameter:parameter];
		
		[self.appDelegate sendMessageWithString:str];
		DDLogInfo(@"发送 更新开关  数据%@", str);
		[SVProgressTool hr_showWithStatus:@"正在更新设备名..."];
		// 启动定时器
		[_timer invalidate];
		isOvertime = NO;
		isShowOverMenu = NO;
		_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	}else{
		[SVProgressTool hr_showErrorWithStatus:@"设备名为空,请输入设备名!"];
	}
}

//TV
- (void)sendDataToSocketWithPicture:(NSString *)pic
{
	if (self.deviceTextField.text.length > 0) {
		[SVProgressTool hr_showWithStatus:@"正在添加设备..."];
		
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
		NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
		
		DDLogInfo(@"token-------%@",token);
		/// 发送创建TV 请求帧
		NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUid];
		NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
		NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracMid];
		
		NSMutableArray *picture = [NSMutableArray array];
		[picture addObject:pic];
		NSArray *regional = [NSArray array];
		NSArray *op = [NSArray array];
		NSArray *name01 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
		NSArray *name02 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
		NSArray *name03 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
		NSArray *param01 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
		NSArray *param02 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
		NSArray *param03 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
		
		NSString *str = [NSString stringWithIRGMVersion:@"0.0.1" status:@"200" token:token type:@"create" desc:@"create desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:@"None" uuid:uuid types:@"irgm" newVersion:@"0.0.1" title:self.deviceTextField.text brand:@"brand" created:@"None" update:@"None" state:@"1" picture:picture regional:regional op:op name01:name01 name02:name02 name03:name03 param01:param01 param02:param02 param03:param03];
		DDLogWarn(@"-------发送添加通用 请求帧-------iracstr%@", str);
		
		[self.appDelegate sendMessageWithString:str];
		// 启动定时器
		[_timer invalidate];
		isOvertime = NO;
		isShowOverMenu = NO;
		_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"设备名为空,请输入设备名!"];
	}

}

- (void)cancelBtnClick
{
	[self.deviceTextField resignFirstResponder];
	[self hiddenSelf];
}
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.eptView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.centerY.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(self.hr_width*0.7, self.hr_height*0.25));
		
	}];
	self.eptView.layer.cornerRadius = 10;
	
	// 每一行的高度
	CGFloat totalH = (self.hr_height*0.25 - 60) / 3;
	// 标题
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
	CGSize size = [self.titleLabel.text sizeWithAttributes:dict];
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(self.eptView.mas_top).offset(10);
		make.width.mas_equalTo(150);
		make.height.mas_equalTo(totalH);
	}];
	//设备名
	NSMutableDictionary *dictDevice = [NSMutableDictionary dictionary];
	dictDevice[NSFontAttributeName] = [UIFont systemFontOfSize:17];
	CGSize sizeDevice = [self.deviceLabel.text sizeWithAttributes:dictDevice];
	[self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.eptView.mas_left).offset(10);
		make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
		make.width.mas_equalTo(sizeDevice.width + 10);
		make.height.mas_equalTo(totalH);
	}];
	//文本
	[self.deviceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.deviceLabel.mas_right).offset(10);
//		make.top.bottom.equalTo(self.deviceLabel);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self.deviceLabel);
		make.right.equalTo(self.eptView.mas_right).offset(-10);
	}];
    self.deviceTextField.layer.cornerRadius = 5;
    self.deviceTextField.layer.borderWidth = 1;
    self.deviceTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.deviceTextField.layer.masksToBounds = YES;
    
	//添加
	[self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.deviceLabel);
		make.top.equalTo(self.deviceLabel.mas_bottom).offset(30);
		make.width.mas_equalTo((self.hr_width*0.7 -20 -30)/2);
		make.height.mas_equalTo(totalH);
	}];
	self.determineBtn.layer.cornerRadius = totalH *0.5;
	self.determineBtn.layer.masksToBounds = YES;
	//取消
	[self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.deviceTextField);
		make.top.bottom.equalTo(self.determineBtn);
		make.width.mas_equalTo((self.hr_width*0.7 -20 -30)/2);
	}];
	self.cancelBtn.layer.cornerRadius = totalH *0.5;
	self.determineBtn.layer.masksToBounds = YES;
}

- (void)addTapGesture
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	[self addGestureRecognizer:tap];
}
- (void)tapClick
{
	[self.deviceTextField resignFirstResponder];
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的更新帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateIrgm:) name:kNotificationCreateIrgm object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	
	//监听键盘的通知
	[kNotification addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
	[kNotification addObserver:self selector:@selector(showKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
	//监听空调的更新帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateDo:) name:kNotificationUpdateDo object:nil];
}
// 开关更新帧
- (void)receviedWithUpdateDo:(NSNotification *)notification
{
	isOvertime = YES;
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"修改成功!"];
	
	[self hiddenSelf];
}

static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
//监听通用的更新帧
static BOOL isOvertime = NO;
- (void)receviedWithCreateIrgm:(NSNotification *)notification
{
	isOvertime = YES;
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"创建成功!"];
	[self hiddenSelf];
}
#pragma mark -  通知处理方法
//监听键盘的通知
- (void)showKeyboard:(NSNotification *)note
{
	[UIView animateWithDuration:0.25 animations:^{
		CGRect rect = self.eptView.frame;
		rect.origin.y = UIScreenH *0.2;
		self.eptView.frame = rect;
		
	}];
}
- (void)showKeyboardHide:(NSNotification *)note
{
	[UIView animateWithDuration:0.25 animations:^{
		CGRect rect = self.eptView.frame;
		rect.origin.y = CGRectGetMidY(self.eptView.frame);
		self.eptView.frame = rect;
		
	}];
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
}

- (void)hiddenSelf
{
	[SVProgressHUD dismiss];
	UIView *view1 = self.superview;
	for (UIView *view in view1.subviews) {
		
		if ([view isKindOfClass:[UIButton class]]) {
			DDLogInfo(@"UIButton-%@",view);
			UIButton *btn = (UIButton *)view;
			btn.hidden = NO;
		}
	}
	__weak typeof (self) weakSelf = self;
	[UIView animateWithDuration:0.25 animations:^{
		weakSelf.backgroundColor = [UIColor clearColor];
	}completion:^(BOOL finished) {
		[weakSelf removeFromSuperview];
	}];
}

- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}
-(void)dealloc
{
	DDLogWarn(@"dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	
	return YES;
}

@end

