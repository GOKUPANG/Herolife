//
//  DoTableViewCell.m
//  xiaorui
//
//  Created by sswukang on 16/5/16.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "DoTableViewCell.h"
#import "HRDOData.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
@interface DoTableViewCell ()

/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation DoTableViewCell
- (void)setIndexPathRow:(NSInteger)indexPathRow
{
	_indexPathRow = indexPathRow;
}
- (void)setDoData:(HRDOData *)doData
{
	_doData = doData;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deviceNameTextField.layer.cornerRadius = 5;
    self.deviceNameTextField.layer.masksToBounds = YES;
    self.deviceNameTextField.layer.borderWidth = 1;
    self.deviceNameTextField.layer.borderColor = [UIColor blackColor].CGColor;
	//通知
	[self addNotificationCenterObserver];
	// 建立连接
	[self postTokenWithTCPSocket];
	
	
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(self.imageBtn.mas_width);
    }];
    [self.deviceNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageBtn.mas_right).offset(10);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-10);
    }];
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	DDLogWarn(@"------------dealloc-----------");
	
	
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的测试帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingDo:) name:kNotificationTestingDo object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
//监听空调的测试帧

static BOOL isOvertime = NO;
- (void)receviedWithTestingDo:(NSNotification *)notification
{
	isOvertime = YES;
	NSDictionary *dict = notification.userInfo;
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict[@"msg"]];
	if ([data.state isEqualToString:@"4"]) {
		[SVProgressHUD showSuccessWithStatus:@"测试控制成功,请查看设备是否响应..." ];
	}else if ([data.state isEqualToString:@"5"]) {
		[SVProgressTool hr_showErrorWithStatus:@"测试控制失败!"];
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

- (IBAction)imageBtnClick:(UIButton *)sender {
	
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送测试开关 请求帧
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUid];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracMid];
	NSArray *regional = [NSArray array];
	NSString *channelNumber = self.doData.parameter.firstObject;
	NSString *op = @"None";

	//去空格
	NSString *textField = [self.deviceNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	if (textField.length > 0) {
		
			NSString *channelName = [NSString stringWithFormat:@"%lu", sender.tag];
			NSString *channelStatus = @"1";
		    NSString *brand = [kUserDefault objectForKey:kdefaultsIracBrand];
			NSArray *parameter = @[channelNumber, op, channelName, channelStatus];
		
			NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"testing" desc:@"testing desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:@"None" uuid:self.doData.uuid types:@"hrdo" newVersion:@"0.0.1" title:self.deviceNameTextField.text brand:brand created:@"None" update:@"None" state:@"3" picture:self.doData.picture.firstObject regional:regional parameter:parameter];
		
			DDLogWarn(@"-------发送测试开关 请求帧-------dostr%@", str);
		[self.appDelegate sendMessageWithString:str];
		// 启动定时器
		[_timer invalidate];
		isOvertime = NO;
		isShowOverMenu = NO;
		
		_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"设备名称不能为空!"];
		
		}
}

- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}
@end
