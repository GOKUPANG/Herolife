//
//  AddNewDeviceViewController.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/20.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "AddNewDeviceViewController.h"
#import "SearchDeviceView.h"
#import "XiaoRuiNewQRcode.h"
#import "ManualCreateXiaoRui.h"
#import "NextController.h"
#import "CreateXiaoRuiController.h"

@interface AddNewDeviceViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) SearchDeviceView *searchView;
/** 记录当前的数据 */
@property(nonatomic, copy) NSString *currentData;

@end

@implementation AddNewDeviceViewController

- (void)loadView
{
    self.view = [XiaoRuiNewQRcode shareXiaoRuiNewQRcode];
}
- (void)viewDidLoad {
	[super viewDidLoad];
    
	self.navigationController.navigationBar.hidden = YES;
	self.title = NSLocalizedString(@"addDevice_title", @"addDevice_title");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCreateXiaoRui:) name:kNotificationQRCodeCreateXiaoRui object:nil];
	[kNotification addObserver:self selector:@selector(receiveManualCreateXiaoRui) name:kNotificationQRCodeManualCreateXiaoRui object:nil];
}
//手动创建小睿
//收到通知之后重新设置当前view
- (void)receiveManualCreateXiaoRui
{
	ManualCreateXiaoRui *manua = [ManualCreateXiaoRui shareManualCreateXiaoRui];
	self.view = manua;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	for (UIView *view in self.view.subviews) {
		
		if ([NSStringFromClass([view class]) isEqualToString:@"HRQrButton"]) {
			UIButton *btn = (UIButton *)view;
			DDLogInfo(@"2222%@", NSStringFromCGRect(btn.frame));
			if (btn.origin.x < UIScreenW * 0.5) {
				btn.selected = YES;
			}else
			{
				
				btn.selected = NO;
			}
		}
	}
	
	
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	[self IsTabBarHidden:NO];
    
    for (UIView *view in self.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UIView"]) {
            
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        }
        if ([NSStringFromClass([view class]) isEqualToString:@"UIImageView"]) {
            UIImageView *imageView = (UIImageView *)view;
            NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
            
            if (!PicNum) {
                
                imageView.image = [UIImage imageNamed:@"1.jpg"];
            }
            
            
            else if (PicNum == -1)
            {
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
                path = [path stringByAppendingPathComponent:@"image.png"];
                
                imageView.image =[UIImage imageWithContentsOfFile:path];
            }
            
            else{
                
                NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
                
                imageView.image =[UIImage imageNamed:imgName];
            }
            
        }
    }

	
}
// 扫描创建小睿
//收到通知之后重新设置当前view
- (void)receiveCreateXiaoRui:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	NSString *qrData = dict[@"result"];
	
	NSString *data = qrData;

	//过滤
	if ([data containsString:@"HRSC"]) {

		[kUserDefault setObject:data forKey:kUserDefaultQrData];
		[kUserDefault synchronize];
		NextController *next = [[NextController alloc] init];
		next.qrData = data;
		[self.navigationController pushViewController:next animated:YES];



	}else
	{
        
        CreateXiaoRuiController *createVC = [[CreateXiaoRuiController alloc] init];
        createVC.qrUUID = data;
        [self.navigationController pushViewController:createVC animated:YES];
//		[self showError];
        
	}
	
}
- (void)showError
{
	[SVProgressTool hr_showErrorWithStatus:@"扫描到错误的二维码,请对准本门锁二维码进行扫描!"];
	
}
- (void)dealloc
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 隐藏底部条
- (void)IsTabBarHidden:(BOOL)hidden
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = hidden;
		}
	}
}

@end
