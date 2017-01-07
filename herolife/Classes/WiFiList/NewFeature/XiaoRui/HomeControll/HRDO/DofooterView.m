//
//  DofooterView.m
//  xiaorui
//
//  Created by sswukang on 16/5/16.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "DofooterView.h"
#import "DoTableViewCell.h"
#import "TipsLabel.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "HRDOData.h"
#import "TipsLabel.h"
#import "HRDOData.h"
#import "HomeControllController.h"
#import "SwitchViewController.h"

@interface DofooterView ()<UITableViewDelegate, UITableViewDataSource>
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *registerDevice;
@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (weak, nonatomic) IBOutlet UITableView *editTableView;
/** firstObject Text*/
@property(nonatomic, copy) NSString *firstObjectText;
/** secondObjectText */
@property(nonatomic, copy) NSString *secondObjectText;
/** threeObjectText */
@property(nonatomic, copy) NSString *threeObjectText;
/** fourObjectText */
@property(nonatomic, copy) NSString *fourObjectText;

/** 记录没进入编辑状态时 文本的初始firstObjectInitial*/
@property(nonatomic, copy) NSString *firstObjectInitial;
/** 记录没进入编辑状态时 文本的初始secondObjectInitial */
@property(nonatomic, copy) NSString *secondObjectInitial;
/**记录没进入编辑状态时 文本的初始 threeObjectInitial */
@property(nonatomic, copy) NSString *threeObjectInitial;
/** 记录没进入编辑状态时 文本的初始fourObjectInitial */
@property(nonatomic, copy) NSString *fourObjectInitial;

/** TipsLabel */
@property(nonatomic, strong) TipsLabel *tipsLabel;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
///表格的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabelViewH;

@end

@implementation DofooterView

- (void)setDoData:(HRDOData *)doData
{
	_doData = doData;
    NSInteger index = [self.doData.parameter.firstObject integerValue];
    switch (index) {
        case 1:
        {
            self.tabelViewH.constant = 40;
        }
            break;
        case 2:
        {
            self.tabelViewH.constant = 80;
        }
            break;
        case 3:
        {
            self.tabelViewH.constant = 120;
        }
            break;
        case 4:
        {
            self.tabelViewH.constant = 160;
        }
            break;
            
        default:
            break;
    }
	[self.editTableView reloadData];
}
- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setUpView];
	//通知
	[self addNotificationCenterObserver];
	// 建立连接
	[self postTokenWithTCPSocket];
	
	//添加提示框
//	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, self.hr_width, 30)];
//	[self.superview addSubview:self.tipsLabel];
	
	
}
- (void)layoutSubviews
{
	[super layoutSubviews];
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	DDLogWarn(@"------------dealloc-----------");
	
	
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的创建帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateDo:) name:kNotificationCreateDo object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}

static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	self.registerDevice.enabled = YES;
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}

//监听空调的创建帧
static BOOL isOvertime = NO;
- (void)receviedWithCreateDo:(NSNotification *)notification
{
	self.registerDevice.enabled = YES;
	isOvertime = YES;
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:@"创建设备成功!" ];
    [kNotification postNotificationName:kNotificationDofooterViewPop object:nil];
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}
static NSString *const doCellID = @"doCellID";
- (void)setUpView
{
	self.hidden = NO;
	self.registerDevice.layer.cornerRadius = self.registerDevice.hr_height * 0.5;
	self.registerDevice.layer.masksToBounds = YES;
	self.cancle.layer.cornerRadius = self.cancle.hr_height * 0.5;
	self.cancle.layer.masksToBounds = YES;
	
	self.editTableView.delegate = self;
	self.editTableView.dataSource = self;
	self.editTableView.bounces = NO;
	self.editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.editTableView.showsHorizontalScrollIndicator = NO;
	
	//自动布局
//	self.editTableView.rowHeight = UITableViewAutomaticDimension;
//	self.editTableView.estimatedRowHeight = 160;
	//注册
	
	UINib *cellNib = [UINib nibWithNibName:@"DoTableViewCell" bundle:nil];
	[self.editTableView registerNib:cellNib forCellReuseIdentifier:doCellID];
	//手势
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	[self addGestureRecognizer:tap];
}
#pragma mark -  UI事件
- (void)tapClick
{
	[self endEditing:YES];
}
- (IBAction)registerDevice:(UIButton *)sender {
	
	[SVProgressTool hr_showWithStatus:@"正在创建设备..."];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSString *firstObjectText;
		NSString *secondObjectText;
		NSString *threeObjectText;
		NSString *fourObjectText;
		
		///判断文本有没有被编辑,如果没有 文本 监听的值就为空
		if (!self.firstObjectText ) {//如果没有值  就去取 默认的初始值
			firstObjectText = self.firstObjectInitial;
			DDLogError(@"如果没有编辑--%@", self.firstObjectText);
		}else
		{
			firstObjectText = self.firstObjectText;
		}
		if (!self.secondObjectText ) {
		    secondObjectText = self.secondObjectInitial;
			DDLogError(@"如果没有编辑--%@", self.secondObjectText);
		}else
		{
			secondObjectText = self.secondObjectText;
		}
		if (!self.threeObjectText ) {
			threeObjectText = self.threeObjectInitial;
			DDLogError(@"如果没有编辑--%@", self.threeObjectText);
		}else
		{
			threeObjectText = self.threeObjectText;
		}
		if (!self.fourObjectText ) {
			fourObjectText = self.fourObjectInitial;
			DDLogError(@"如果没有编辑--%@", self.fourObjectText);
		}else
		{
			fourObjectText = self.fourObjectInitial;
		}
		//----------------------到这里参数一定有值------------------------------------
		/// 发送创建开关 请求帧
		DDLogWarn(@"--1--%@--", self.firstObjectText);
		DDLogWarn(@"---2-%@--", self.secondObjectText );
		DDLogWarn(@"--3--%@--", self.threeObjectText );
		DDLogWarn(@"---4-%@--", self.fourObjectText );
		NSString *channelNumber = self.doData.parameter.firstObject;
		NSString *op = @"None";
		
		//去空格
		NSString *newFirstObjectText = [firstObjectText stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *newSecondObjectText = [secondObjectText stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *newThreeObjectText = [threeObjectText stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSString *newFourObjectText = [fourObjectText stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		//中文转码
//		firstObjectText = [firstObjectText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//		secondObjectText = [secondObjectText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//		threeObjectText = [threeObjectText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//		fourObjectText = [fourObjectText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
		if (!self.secondObjectInitial && !self.threeObjectInitial && !self.fourObjectInitial) {//只有一路
			if (newFirstObjectText.length > 0) {
				
				NSString *channelName = firstObjectText;
				NSString *channelStatus = @"0";
				NSArray *parameter = @[channelNumber, op, channelName, channelStatus];
				
				[self createDoWithTitle:firstObjectText parameter:parameter];
				
			}else
			{
				[SVProgressTool hr_showErrorWithStatus:@"设备名称不能为空!"];
			}
		}else if (!self.threeObjectInitial && !self.fourObjectInitial)//只有两路
		{
			
			if (newFirstObjectText.length > 0 && newSecondObjectText.length > 0) {
				
				NSString *channelName = firstObjectText;
				NSString *channelName2 = secondObjectText;
				NSString *channelStatus = @"0";
				NSArray *parameter = @[channelNumber, op, channelName, channelStatus, channelName2, channelStatus, @"None", @"None", @"None", @"None"];
				
				[self createDoWithTitle:firstObjectText parameter:parameter];
				
			}else
			{
				[SVProgressTool hr_showErrorWithStatus:@"设备名称不能为空!"];
			}
		}else if (!self.fourObjectInitial)//只有三路
		{
			if (newFirstObjectText.length > 0 && newSecondObjectText.length > 0 && newThreeObjectText.length > 0) {
				
				NSString *channelName = firstObjectText;
				NSString *channelName2 = secondObjectText;
				NSString *channelName3 = threeObjectText;
				NSString *channelStatus = @"0";
				NSArray *parameter = @[channelNumber, op, channelName, channelStatus, channelName2, channelStatus, channelName3, channelStatus, @"None", @"None"];
				
				[self createDoWithTitle:firstObjectText parameter:parameter];
			}else
			{
				[SVProgressTool hr_showErrorWithStatus:@"设备名称不能为空!"];
			}
		}else//只有四路
		{
			if (newFirstObjectText.length > 0 && newSecondObjectText.length > 0 && newThreeObjectText.length > 0 && newFourObjectText.length > 0) {
				
				NSString *channelName = firstObjectText;
				NSString *channelName2 = secondObjectText;
				NSString *channelName3 = threeObjectText;
				NSString *channelName4 = fourObjectText;
				NSString *channelStatus = @"0";
				NSArray *parameter = @[channelNumber, op, channelName, channelStatus, channelName2, channelStatus, channelName3, channelStatus, channelName4, channelStatus];
				
				[self createDoWithTitle:firstObjectText parameter:parameter];
			}else
			{
				[SVProgressTool hr_showErrorWithStatus:@"设备名称不能为空!"];
			}
		}
	});
	
	[self endEditing:YES];
	
}
#pragma mark - 创建开关
- (void)createDoWithTitle:(NSString *)title parameter:(NSArray *)parameter
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送创建开关 请求帧
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUid];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracMid];
	NSString *brand = @"brand";
	NSArray *regional = [NSArray array];
	
	NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"create" desc:@"create desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:@"None" uuid:self.doData.uuid types:@"hrdo" newVersion:@"0.0.1" title:title brand:brand created:@"None" update:@"None" state:@"1" picture:self.doData.picture regional:regional parameter:parameter];
	DDLogWarn(@"-------发送添加开关 请求帧-------dostr%@", str);
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在添加设备..."];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}
- (IBAction)cancleBtnClick:(UIButton *)sender {
	[SVProgressHUD dismiss];
	[self endEditing:YES];
	self.hidden = YES;
	self.superview.hidden = YES;
}
#pragma mark - tableview  delegate  Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	DDLogWarn(@"numberOfRowsInSection-%lu",[self.doData.parameter.firstObject integerValue]);
	return [self.doData.parameter.firstObject integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doCellID];
	
	cell.doData = self.doData;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//绑定tag
	cell.imageBtn.tag = indexPath.row + 1;
	//按钮图片
	NSString * pictureStr = self.doData.picture.firstObject;
	if ([pictureStr isEqualToString:@"1"] || [pictureStr isEqualToString:@"2"] || [pictureStr isEqualToString:@"4"]) {
        
//        [cell.imageBtn setImage:[UIImage imageNamed:@"注册设备灯泡关"] forState:UIControlStateNormal];
        
        [cell.imageBtn setBackgroundImage:[UIImage imageNamed:@"注册设备灯泡关"] forState:UIControlStateNormal];
		
		switch (indexPath.row) {
			case 0:
				cell.deviceNameTextField.text = @"第一路开关";
				self.firstObjectInitial = @"第一路开关";
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingFirstObject:) name:UITextFieldTextDidEndEditingNotification object:cell.deviceNameTextField];
				
				break;
			case 1:
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingSecondObject:) name:UITextFieldTextDidEndEditingNotification object:cell.deviceNameTextField];
				self.secondObjectInitial = @"第二路开关";
				cell.deviceNameTextField.text = @"第二路开关";
				break;
			case 2:
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingThreeObject:) name:UITextFieldTextDidEndEditingNotification object:cell.deviceNameTextField];
				self.threeObjectInitial = @"第三路开关";
				cell.deviceNameTextField.text = @"第三路开关";
				break;
			case 3:
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingFourObject:) name:UITextFieldTextDidEndEditingNotification object:cell.deviceNameTextField];
				self.fourObjectInitial = @"第四路开关";
				cell.deviceNameTextField.text = @"第四路开关";
				break;
				
			default:
				break;
		}
		
	}else if ([pictureStr isEqualToString:@"3"]) {
        
//        [cell.imageBtn setImage:[UIImage imageNamed:@"注册设备插座关"] forState:UIControlStateNormal];
        
        [cell.imageBtn setBackgroundImage:[UIImage imageNamed:@"注册设备插座关"] forState:UIControlStateNormal];
		cell.deviceNameTextField.text = @"智能插座";
		self.firstObjectInitial = @"智能插座";
	}else if ([pictureStr isEqualToString:@"5"]) {
		[cell.imageBtn setBackgroundImage:[UIImage imageNamed:@"注册设备形状-29"] forState:UIControlStateNormal];
		
		self.firstObjectInitial = @"智能窗帘控制器";
		cell.deviceNameTextField.text = @"智能窗帘控制器";
	}
	
	
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	DDLogWarn(@"%lu", indexPath.row);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40	;
}
//处理属性改变事件
- (void)endEditingFirstObject:(NSNotification*)note
{
	if (note) {
		 UITextField *textField = note.object;
		self.firstObjectText = textField.text;
	}
}
- (void)endEditingSecondObject:(NSNotification*)note
{
	if (note) {
		UITextField *textField = note.object;
		self.secondObjectText = textField.text;
	}
}
- (void)endEditingThreeObject:(NSNotification*)note
{
	if (note) {
		UITextField *textField = note.object;
		self.threeObjectText = textField.text;
	}
}
- (void)endEditingFourObject:(NSNotification*)note
{
	if (note) {
		UITextField *textField = note.object;
		self.fourObjectText = textField.text;
	}
}



@end
