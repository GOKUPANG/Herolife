//
//  PopEditDoView.m
//  xiaorui
//
//  Created by sswukang on 16/5/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "PopEditDoView.h"
#import "HRDOData.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
@interface PopEditDoView ()
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

@end
@implementation PopEditDoView

- (void)setDoData:(HRDOData *)doData
{
	_doData = doData;
	self.deviceName.text = doData.parameter[1];
	DDLogWarn(@"%@", self.doData.uuid);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
	self.determineBtn.layer.cornerRadius = self.determineBtn.hr_height *0.5;
	self.cancle.layer.cornerRadius = self.cancle.hr_height *0.5;
	self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5];
	/// 建立socket连接 并组帧 发送请求数据
	[self postTokenWithTCPSocket];
	
	//通知
	[self addNotificationCenterObserver];
	//手势
	[self addTapGesture];
	
	
}
- (void)addTapGesture
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	[self addGestureRecognizer:tap];
}
- (void)tapClick
{
	[self.deviceName resignFirstResponder];
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的更新帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateDo:) name:kNotificationUpdateDo object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
#pragma mark -  通知处理方法
//监听通用的更新帧
//监听空调的更新帧
static BOOL isOvertime = NO;
- (void)receviedWithUpdateDo:(NSNotification *)notification
{
	isOvertime = YES;
	
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"修改成功!"];
	
		[self hiddenSelf];
}
#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}

#pragma mark - UI点击
//确定
- (IBAction)determineBtnClick:(UIButton *)sender {
	[self.deviceName resignFirstResponder];
	[self sendDataToSocketWithOpArray];
	
}
//取消
- (IBAction)cancleBtnClick:(UIButton *)sender {
	[self.deviceName resignFirstResponder];
	[self hiddenSelf];
	
}
- (void)hiddenSelf
{
	[SVProgressHUD dismiss];
	self.superview.hidden = YES;
}
#pragma mark - 传参组帧
- (void)sendDataToSocketWithOpArray
{
	NSString *deviceName = [self.deviceName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	if (deviceName.length > 0) {
		
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
		NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
		NSString *xiaoRuiUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
		NSArray *parameter = @[self.doData.parameter.firstObject, @"None", self.deviceName.text, self.doData.parameter[2]];
		NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"update" desc:@"update desc message" srcUserName:user dstUserName:user dstDevName:xiaoRuiUUID uid:self.doData.uid mid:self.doData.mid did:self.doData.did uuid:self.doData.uuid types:@"hrdo" newVersion:@"0.0.1" title:self.deviceName.text brand:self.doData.brand created:[NSString loadCurrentDate] update:[NSString loadCurrentDate] state:@"1" picture:self.doData.picture regional:self.doData.regional parameter:parameter];
		
		[self.appDelegate sendMessageWithString:str];
		[SVProgressTool hr_showWithStatus:@"正在更新设备名..."];
		// 启动定时器
		[_timer invalidate];
		isOvertime = NO;
		isShowOverMenu = NO;
		_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	}else{
		[SVProgressTool hr_showErrorWithStatus:@"设备名不能为空!"];
	}
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


@end
