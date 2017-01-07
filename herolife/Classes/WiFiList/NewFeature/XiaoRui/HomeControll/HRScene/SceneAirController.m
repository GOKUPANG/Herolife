//
//  SceneAirController.m
//  xiaorui
//
//  Created by sswukang on 16/7/12.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneAirController.h"
#import "SceneAirView.h"
#import "IracData.h"

#import <SVProgressHUD.h>

@interface SceneAirController ()

@property (strong, nonatomic) SceneAirView* sceneairView;
/** NSString */
@property(nonatomic, copy) NSString *status;

@end

@implementation SceneAirController

- (void)setData:(IracData *)data
{
	_data = data;
	self.title = data.title;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.status = @"-1";
	self.view.backgroundColor = [UIColor whiteColor];
	self.sceneairView = [[SceneAirView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAV_BAR_HEIGHT)];
	//导航栏按钮
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem hr_itemWithImage:@"" highImage:@"" target:self action:@selector(backClick) title:@"取消"];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem hr_itemWithImage:@"" highImage:@"" target:self action:@selector(completeClick) title:@"完成"];
	[kNotification addObserver:self selector:@selector(receiveNotificationSceneAirData:) name:kNotificationSceneAirData object:nil];
	[self.view addSubview:self.sceneairView];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
   
	[kNotification postNotificationName:kNotificationSceneAirDismiss object:nil];
	[SVProgressHUD dismiss];
}
#pragma mark - 通知
- (void)receiveNotificationSceneAirData:(NSNotification *)note
{
	NSDictionary *dict = note.userInfo;
	self.status = dict[@"status"];
	DDLogInfo(@"note%@", note.userInfo);
}
#pragma mark - UI事件

- (void)completeClick
{
	[kNotification postNotificationName:kNotificationSceneAirDismiss object:nil];
	if (self.block) {
        
		self.block(self.status);
	}
	
	[kNotification postNotificationName:kNotificationSceneLine5Center object:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
	[kNotification removeObserver:self];
}

- (void)sceneAirControllerWithBlock:(sceneAirControllerBlock)block
{
	self.block = block;
}

@end
