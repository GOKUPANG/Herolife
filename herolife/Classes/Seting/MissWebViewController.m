//
//  MissWebViewController.m
//  xiaorui
//
//  Created by sswukang on 16/7/20.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "MissWebViewController.h"

@interface MissWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@end

@implementation MissWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"关于HEROLIFE";
	[navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
	[navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;
	
	
	NSString *urlStr = @"http://www.gzhuarui.cn/?q=about-herolife";
	NSURL *rul = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:rul];
	
	self.webView.delegate = self;
	[self.webView loadRequest:request];
}
- (void)backButtonClick:(UIButton *)btn
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	//导航条
	[self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(20);
		make.height.mas_equalTo(HRNavH);
	}];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.hidden = YES;
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
#pragma mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[SVProgressTool hr_showWithStatus:@"正在加载网页..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
	[SVProgressTool hr_showErrorWithStatus:@"加载失败!"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressTool hr_dismiss];
	[self IsTabBarHidden: NO];
}
#pragma mark - 隐藏底部条 - 海波代码
- (void)IsTabBarHidden:(BOOL)hidden
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = hidden;
		}
	}
}

@end
