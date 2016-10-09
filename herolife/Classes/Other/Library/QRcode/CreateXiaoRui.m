
//
//  CreateXiaoRui.m
//  xiaorui
//
//  Created by sswukang on 16/7/19.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CreateXiaoRui.h"

#import "AddNewDeviceViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "HRTotalData.h"

@interface CreateXiaoRui ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *createDeviceButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineViewY;
/** AFHTTPSessionManager */
@property(nonatomic, strong) AFHTTPSessionManager *manager;
/**  */
@property(nonatomic, assign) CGFloat initialLineY;

@property (weak, nonatomic) IBOutlet UITextField *deviceNameFiled;
/** uid */
@property(nonatomic, copy) NSString *uid;
@end

@implementation CreateXiaoRui
+ (instancetype)shareCreateXiaoRui
{
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setupViews];
	//通知
	[self addNotificationCenterObserver];
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	[kNotification addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
	[kNotification addObserver:self selector:@selector(keyboardShowHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardShow:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	CGSize kbSize = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	[UIView animateWithDuration:0.5 animations:^{
		self.LineViewY.constant = self.initialLineY + kbSize.height;
		[self layoutIfNeeded];
	}];
	
}
- (void)keyboardShowHidden:(NSNotification *)note
{
	[UIView animateWithDuration:0.5 animations:^{
		self.LineViewY.constant = self.initialLineY ;
		[self layoutIfNeeded];
	}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (self.uuid.length > 0 > 0 && self.deviceNameFiled.text.length > 0) {
		[self getHttpRequset];
		
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"设备ID或设备名不能为空!"];
	}
	[self endEditing:NO];
	return YES;
}
#pragma mark - 内部方法
- (void)setupViews
{
	self.backgroundButton.backgroundColor = [UIColor themeColor];
	self.createDeviceButton.backgroundColor = [UIColor themeColor];
	self.initialLineY = self.LineViewY.constant;
	self.deviceNameFiled.delegate = self;
	NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
	DDLogError(@"uid%@", uid);
	self.uid = uid;
}
#pragma mark - UI事件
- (IBAction)backgroundButton:(UIButton *)sender {
	[self.deviceNameFiled resignFirstResponder];
	QRTools *qrTools = [[QRTools alloc] init];
	[qrTools intoQRCodeVC];
}
- (IBAction)createDevice:(UIButton *)sender {
	if (self.uuid.length > 0 && self.deviceNameFiled.text.length > 0) {
		[self getHttpRequset];
		
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"设备ID或设备名不能为空!"];
	}
	
}
#pragma mark - HTTP
// 更新小睿
- (void)httpWithUpdataXiaoRuiWithData:(HRTotalData *)data
{
	//组帧
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"type"] = @"xiaorui";
	parameters[@"title"] = self.deviceNameFiled.text;
	[self.manager PUT:[NSString stringWithFormat:@"%@/%@", HRAPI_XiaoRuiNode_URL, data.mid] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdataXiaoRui object:nil];
		[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
		[SVProgressHUD showSuccessWithStatus:@"更新小睿成功!"];
		UINavigationController *nav = (UINavigationController *)[NSObject activityViewController];
		[nav popViewControllerAnimated:YES];
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		DDLogDebug(@"%@", error);
		
		[ErrorCodeManager showError:error];
		
	}];
}

//创建小睿
- (void)httpWithCreateXiaoRui
{
	NSString *muString = [NSString hr_stringWithBase64];
	DDLogInfo(@"muString--%@", muString);
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"field_uuid[und][0][value]"] = self.uuid;
	parameters[@"type"] = @"xiaorui";
	parameters[@"field_version[und][0][value]"] = @"0.0.1";
	parameters[@"title"] = self.deviceNameFiled.text;
	parameters[@"language"] = @"und";
	parameters[@"field_brand[und][0][value]"] = @"xiaorui brand";
	parameters[@"field_status[und][0][value]"] = @"1";
	parameters[@"field_status[und][0][value]"] = @"0";
	parameters[@"field_licence[und][0][value]"] = muString;
	
	int x = arc4random() % 8;
	int y = arc4random() % 255 +1;
	parameters[@"field_addr[und][0][value]"] = [NSString stringWithFormat:@"%d",x];
	parameters[@"field_addr[und][1][value]"] = [NSString stringWithFormat:@"%d",y];
	
//	[self.manager POST:HRAPI_XiaoRuiNode_URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		
//		//		kNotificationPost(@"")
//		NSDictionary *dict = (NSDictionary *)responseObject;
//		DDLogInfo(@"创建小睿%@",dict);
//		
//		///创建小睿成功之后要增加创建小睿红外和单火地址表
//		//创建红外地址表- irdev
//		[CreateXRHttpTools postHttpCreateIrdevWithMid:dict[@"nid"] title:self.deviceNameFiled.text responseDict:^(NSDictionary *dict) {
//			DDLogInfo(@"创建irdev%@",dict);
//			//创建单火地址表- singleswitch
//			[CreateXRHttpTools postHttpCreateSingleswitchWithMid:dict[@"nid"] title:self.deviceNameFiled.text  responseDict:^(NSDictionary *dict) {
//				
//				[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateXiaoRui object:nil];
//				[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//				[SVProgressHUD showSuccessWithStatus:@"添加小睿成功..."];
//				UINavigationController *nav = (UINavigationController *)[NSObject activityViewController];
//				[nav popViewControllerAnimated:YES];
//				
//			} result:^(NSError *error) {
//				
//				[ErrorCodeManager showError:error];
//				
//			}];
//			
//		} result:^(NSError *error) {
//			
//			
//			[ErrorCodeManager showError:error];
//			
//		}];
//		
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		DDLogDebug(@"%@", error);
//		DDLogDebug(@"%ld", (long)error.code);
//		
//		
//		[ErrorCodeManager showError:error];
//	}];
}
/// 发送HTTP搜索
- (void)getHttpRequset
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	self.manager = manager;
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"uuid"] = self.uuid;
	[SVProgressTool hr_showWithStatus:@"正在添加小睿..."];
//	[manager GET:HRAPI_XiaoRuiInFo_URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		
//		//如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
//		if (![responseObject isKindOfClass:[NSArray class]]) {
//			DDLogDebug(@"responseObject不是NSArray");
//			
//			return;
//		}
//		//去除服务器发过来的数据里没有值的情况
//		if (((NSArray*)responseObject).count < 1 ) {
//			DDLogDebug(@"responseObject count == 0");
//			//如果为空就去创建小睿
//			[self httpWithCreateXiaoRui];
//			return;
//		}
//		
//		NSArray *responseArr = (NSArray*)responseObject;
//		for (NSDictionary *dict in responseArr) {
//			DDLogError(@"dictuid--%@self.uid--%@",[dict valueForKeyPath:@"uid"],self.uid );
//			HRTotalData *data = [HRTotalData mj_objectWithKeyValues:dict];
//			if ([data.uid isEqualToString:self.uid]) {//如果用户ID是自己 就更新
//				[self httpWithUpdataXiaoRuiWithData:data];
//			}else
//			{
//				[SVProgressTool hr_showErrorWithStatus:@"该小睿在其他帐号上已经激活,请在其他帐号上删除该小睿,再重试!"];
//			}
//			
//		}
//		
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		DDLogDebug(@"%@", error);
//		
//		[ErrorCodeManager showError:error];
//	}];
}


@end
