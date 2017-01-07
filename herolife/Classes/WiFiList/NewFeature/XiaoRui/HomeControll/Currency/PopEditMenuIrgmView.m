//
//  PopEditMenuIrgmView.m
//  xiaorui
//
//  Created by sswukang on 16/5/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "PopEditMenuIrgmView.h"
#import "IrgmData.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface PopEditMenuIrgmView ()
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet UITextField *keyName;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

@end
@implementation PopEditMenuIrgmView

- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
}
- (void)setTagBtn:(NSInteger)tagBtn
{
	_tagBtn = tagBtn;
	self.deviceName.text = self.irgmData.title;
	NSInteger value = tagBtn;
	NSString *keyName;
	if (value >= 20) {
		NSInteger index = value - 20;
		keyName = self.irgmData.name03[index];
	}else if (value >= 10) {
		NSInteger index = value - 10;
		keyName = self.irgmData.name02[index];
	}else if (value >= 0) {
		NSInteger index = value;
		keyName = self.irgmData.name01[index];
	}
	self.keyName.text = keyName;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
	self.determineBtn.layer.cornerRadius = self.determineBtn.hr_height *0.5;
	self.cancle.layer.cornerRadius = self.cancle.hr_height *0.5;
	self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5];
    self.deviceName.layer.cornerRadius = 5;
    self.deviceName.layer.masksToBounds = YES;
    self.deviceName.layer.borderColor = [UIColor blackColor].CGColor;
    self.deviceName.layer.borderWidth = 1;
    self.keyName.layer.cornerRadius = 5;
    self.keyName.layer.masksToBounds = YES;
    self.keyName.layer.borderWidth = 1;
    self.keyName.layer.borderColor = [UIColor blackColor].CGColor;
	/// 建立socket连接 并组帧 发送请求数据
	[self postTokenWithTCPSocket];
	
	//通知
	[self addNotificationCenterObserver];
	//手势
	[self addTapGesture];
	
	
}

- (void)drawRect:(CGRect)rect
{
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
	//监听空调的测试帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateIrgm:) name:kNotificationUpdateIrgm object:nil];
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
static BOOL isOvertime = NO;
- (void)receviedWithUpdateIrgm:(NSNotification *)notification
{
	isOvertime = YES;
	NSDictionary *dic = notification.userInfo;
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateIrgmWithTitle object:nil userInfo:dic];
	
	IrgmData *data = [IrgmData mj_objectWithKeyValues:dic[@"msg"]];
	self.irgmData = data;
	[self setNeedsDisplay];
	[self setNeedsLayout];
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"修改成功!" ];
	[self hiddenSelf];
	if (self.keyNameBlock != nil) {
		
		self.keyNameBlock(data);
	}
	
}

#pragma mark - block
- (void)getKeyNameWithBlock:(KeyNameBlock)keyNameBlock
{
	self.keyNameBlock = keyNameBlock;
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
	[self.keyName resignFirstResponder];
	
	DDLogWarn(@"%ld", (long)self.tagBtn);
	NSInteger value = self.tagBtn;
	NSMutableArray *muArr;
	if (value >= 20) {
		NSUInteger index = value - 20;
		int i = 3;
		muArr = [NSMutableArray arrayWithArray:self.irgmData.name03];
		[muArr replaceObjectAtIndex:index withObject:self.keyName.text];
		[self sendDataToSocketWithOpArray:muArr index:i value:value lastIndex: index];
	}else if (value >= 10) {
		NSUInteger index = value - 10;
		int i = 2;
		muArr = [NSMutableArray arrayWithArray:self.irgmData.name02];
		[muArr replaceObjectAtIndex:index withObject:self.keyName.text];
		[self sendDataToSocketWithOpArray:muArr index:i value:value lastIndex: index];
	}else if (value >= 0) {
		NSUInteger index = value;
		int i = 1;
		muArr = [NSMutableArray arrayWithArray:self.irgmData.name01];
		[muArr replaceObjectAtIndex:index withObject:self.keyName.text];
		[self sendDataToSocketWithOpArray:muArr index:i value:value lastIndex: index];
	}
	
}
//取消
- (IBAction)cancleBtnClick:(UIButton *)sender {
	[self.deviceName resignFirstResponder];
	[self.keyName resignFirstResponder];
	[self hiddenSelf];

}
- (void)hiddenSelf
{
	[SVProgressHUD dismiss];
	self.superview.hidden = YES;
}
#pragma mark - 传参组帧
- (void)sendDataToSocketWithOpArray:(NSArray *)arr index:(int)index value:(NSInteger)value lastIndex:(NSInteger)lastIndex
{
	//改变名称  对应 name改变
	if (self.deviceName.text.length > 0) {
	
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
		NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
		NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
		NSString *str;
		NSString *number = [NSString stringWithFormat:@"%ld", (long)value];
		NSArray *op = [NSArray array];
		if (index == 1) {
			NSString *address = self.irgmData.param01[lastIndex];
			op = @[number,self.keyName.text,address];
		str = [NSString stringWithIRGMVersion:@"0.0.1"
													 status:@"200"
													  token:token
													   type:@"update"
													   desc:@"update desc message"
												srcUserName:user
												dstUserName:user
												 dstDevName:uuid
														uid:self.irgmData.uid
														mid:self.irgmData.mid
														did:self.irgmData.did
													   uuid:self.irgmData.uuid
													  types:self.irgmData.types
												 newVersion:self.irgmData.version
													  title:self.deviceName.text
													  brand:self.irgmData.brand
													created:self.irgmData.created
													 update:self.irgmData.update
													  state:self.irgmData.state
													picture:self.irgmData.picture
												   regional:self.irgmData.regional
														 op:op
													 name01:arr
													 name02:self.irgmData.name02
													 name03:self.irgmData.name03
													param01:self.irgmData.param01
													param02:self.irgmData.param02
													param03:self.irgmData.param03];
		}else if (index == 2) {
			NSString *address = self.irgmData.param02[lastIndex];
			op = @[number,self.keyName.text,address];
			str = [NSString stringWithIRGMVersion:@"0.0.1"
										   status:@"200"
											token:token
											 type:@"update"
											 desc:@"update desc message"
									  srcUserName:user
									  dstUserName:user
									   dstDevName:uuid
											  uid:self.irgmData.uid
											  mid:self.irgmData.mid
											  did:self.irgmData.did
											 uuid:self.irgmData.uuid
											types:self.irgmData.types
									   newVersion:self.irgmData.version
											title:self.deviceName.text
											brand:self.irgmData.brand
										  created:self.irgmData.created
										   update:self.irgmData.update
											state:self.irgmData.state
										  picture:self.irgmData.picture
										 regional:self.irgmData.regional
											   op:op
										   name01:self.irgmData.name01
										   name02:arr
										   name03:self.irgmData.name03
										  param01:self.irgmData.param01
										  param02:self.irgmData.param02
										  param03:self.irgmData.param03];
		}else if (index == 3) {
			NSString *address = self.irgmData.param03[lastIndex];
			op = @[number,self.keyName.text,address];
			str = [NSString stringWithIRGMVersion:@"0.0.1"
										   status:@"200"
											token:token
											 type:@"update"
											 desc:@"update desc message"
									  srcUserName:user
									  dstUserName:user
									   dstDevName:uuid
											  uid:self.irgmData.uid
											  mid:self.irgmData.mid
											  did:self.irgmData.did
											 uuid:self.irgmData.uuid
											types:self.irgmData.types
									   newVersion:self.irgmData.version
											title:self.deviceName.text
											brand:self.irgmData.brand
										  created:self.irgmData.created
										   update:self.irgmData.update
											state:self.irgmData.state
										  picture:self.irgmData.picture
										 regional:self.irgmData.regional
											   op:op
										   name01:self.irgmData.name01
										   name02:self.irgmData.name02
										   name03:arr
										  param01:self.irgmData.param01
										  param02:self.irgmData.param02
										  param03:self.irgmData.param03];
		}
	
	[self.appDelegate sendMessageWithString:str];
		[SVProgressTool hr_showWithStatus:@"正在更新设备名..."];
		// 启动定时器
		[_timer invalidate];
		isOvertime = NO;
		isShowOverMenu = NO;
		_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
	}else{
		[SVProgressTool hr_showErrorWithStatus:@"设备ID或设备名不能为空!"];
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
