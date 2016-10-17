//
//  SettingController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SettingController.h"
#import "SettingCell.h"
#import "AccountManagementController.h"
#import "GestureViewController.h"
#import "BackPicSetController.h"
#import "LoginController.h"
#import "HRNavigationViewController.h"
#import "MissWebViewController.h"

@interface SettingController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 头像 */
@property(nonatomic, weak) UIImageView *iconImage;
/** 头像底纹viwe */
@property(nonatomic, weak) UIView *eptView;
/** <#name#> */
@property(nonatomic, weak) UILabel *userLabel;
/** <#name#> */
@property(nonatomic, weak) UILabel *emailLabel;
/** <#name#> */
@property(nonatomic, weak) UITableView *tableView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;

@end

@implementation SettingController

static NSString *cellID = @"cellID";

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
		
        self.backImgView.image = [UIImage imageNamed:Defalt_BackPic];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImgView.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImgView.image =[UIImage imageNamed:imgName];
    }

	
	
	self.navigationController.navigationBar.hidden = YES;
    NSLog(@"设置页面ViewWillappear");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    NSLog(@"设置页面ViewDidLoad");
    
	[self setupViews];
	//注册
	[self.tableView registerClass:[SettingCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - 内部方法
//初始化
- (void)setupViews
{
    
    
    
    NSLog(@"设置页面setupViews");
    
	
	self.navigationController.navigationBar.hidden = YES;
	
	//背景图片
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundImage.image = [UIImage imageNamed:@"3.jpg"];
    self.backImgView=backgroundImage;
    
	[self.view addSubview:self.backImgView];
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:view];
	
	//导航条
	HRNavigationBar *navView = [[HRNavigationBar alloc] init];
	navView.titleLabel.text = @"设置";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
	self.navView = navView;
	
	//头像底纹viwe
	UIView *eptView = [[UIView alloc] init];
	eptView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
	[self.view addSubview:eptView];
	self.eptView = eptView;
	
	//头像
	UIImageView *iconImage = [[UIImageView alloc] init];
	NSString *iconString;
	//QQ头像
	iconString = [kUserDefault objectForKey:kDefaultsQQIconURL];
	if (iconString.length > 0) {
		
		NSURL *url = [NSURL URLWithString:iconString];
		[iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
	}else
	{
		iconString = [kUserDefault objectForKey:kDefaultsIconURL];
		if (iconString.length > 0) {
			NSURL *url = [NSURL URLWithString:iconString];
			[iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
			
		}else
		{
			iconImage.image = [UIImage imageNamed:@"头像占位图片.jpg"];
			
		}
		
	}
	
	
	self.iconImage.layer.cornerRadius = self.iconImage.hr_height *0.5;
	self.iconImage.layer.borderWidth = HRCommonScreenW * 20;
	self.iconImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
	self.iconImage.layer.masksToBounds = YES;
    
    /** 给头像加一个手势方法*/
    
    iconImage.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconClick)];
    
    [iconImage  addGestureRecognizer:tap];
    
    
    
    
    
	
	[self.view addSubview:iconImage];
	self.iconImage = iconImage;
	
	//用户名
	UILabel *userLabel = [[UILabel alloc] init];
	userLabel.font = [UIFont systemFontOfSize:17];
    
    /** 斌 用户的用户名*/
	NSString *textName = @"";
    NSString *userName =   [kUserDefault valueForKey:kDefaultsUserName];
	textName = userName;
	//qq用户名称
    NSString *qqUserNmae = [kUserDefault valueForKey:kNSUserDefaultsNickname];
	if (qqUserNmae.length > 0) {
		
		textName = qqUserNmae;
		
	}
	
    userLabel.text = textName;
    
	userLabel.textAlignment = NSTextAlignmentCenter;
	userLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:userLabel];
	self.userLabel = userLabel;
	
	
	/** 用户的邮箱*/
	UILabel *emailLabel = [[UILabel alloc] init];
	emailLabel.font = [UIFont systemFontOfSize:11];
	
	NSString *emailName = @"";
	NSString * mailName =   [kUserDefault valueForKey:kDefaultsUserMail];
	emailName = mailName;
	//qq用户名称
	if (qqUserNmae.length > 0) {
		
		emailName = @"当前用户为QQ用户";
		
	}
	

    
	emailLabel.text = emailName;
	emailLabel.textAlignment = NSTextAlignmentCenter;
	emailLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:emailLabel];
	
	self.emailLabel = emailLabel;
	//表格
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
	tableView.delegate        = self;
	tableView.dataSource      = self;
	tableView.bounces = NO;
	tableView.scrollEnabled = NO;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.rowHeight = HRCommonScreenH * 85;
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.sectionFooterHeight = HRCommonScreenH *0;
	tableView.sectionHeaderHeight = HRCommonScreenH *20;
	tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
	
	[self.view addSubview:tableView];
	
	self.tableView = tableView;
}

#pragma mark - 头像点击
-(void)iconClick
{
	
	//qq用户名称
	NSString *qqUserNmae = [kUserDefault valueForKey:kNSUserDefaultsNickname];
	if (qqUserNmae.length > 0) {
		return;
	}
    AccountManagementController *AMC = [AccountManagementController new];
    [self.navigationController pushViewController:AMC animated:YES];

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
	
	[self.eptView mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH *100);
		make.centerX.equalTo(self.view);
		make.height.width.mas_equalTo(HRCommonScreenW * 220);
		
	}];
	
	self.eptView.layer.cornerRadius = HRCommonScreenW *220*0.5;
	self.eptView.layer.masksToBounds = YES;
	//头像
	[self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.navView.mas_bottom).offset(HRCommonScreenH * 110);
		make.centerX.equalTo(self.view);
		make.height.width.mas_equalTo(HRCommonScreenW * 200);
	}];
	
	self.iconImage.layer.cornerRadius = self.iconImage.hr_height *0.5;
	self.iconImage.layer.borderWidth = HRCommonScreenW * 20;
	self.iconImage.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
	self.iconImage.layer.masksToBounds = YES;
	//用户名
	[self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.iconImage.mas_bottom).offset(HRCommonScreenH * 10);
		make.centerX.equalTo(self.iconImage);
	}];
	//邮箱
	
	[self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.userLabel.mas_bottom).offset(HRCommonScreenH * 8);
		make.centerX.equalTo(self.iconImage);
	}];
	//tableview
	
	if (HRUIScreenH < 667) {
		
		[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.emailLabel.mas_bottom).offset(HRCommonScreenH * 25);
			make.left.right.equalTo(self.view);
			make.bottom.equalTo(self.view).offset(HRCommonScreenH * 116 + 49);
		}];
	}else
	{
		[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.emailLabel.mas_bottom).offset(HRCommonScreenH * 70);
			make.left.right.equalTo(self.view);
			make.bottom.equalTo(self.view).offset(HRCommonScreenH * 116 + 49);
		}];
		
	}
}

#pragma mark - tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section== 0) {
        return 2;
        
    }
    
    
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil) {
		cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:50 / 255.0];
	if (indexPath.section == 1 && indexPath.row == 2) {
		cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
	}
	
	switch (indexPath.section) {
  case 0:
		{
			[cell.rightButton setImage:[UIImage imageNamed:@"进入号"] forState:UIControlStateNormal];
			if (indexPath.row == 0) {
                
                
                cell.leftImage.image = [UIImage imageNamed:@"手势"];
                cell.leftLabel.text = @"手势设置";
                
            }else if(indexPath.row == 1) {
				
                
                cell.leftImage.image = [UIImage imageNamed:@"背景图"];
                cell.leftLabel.text = @"背景图设置";
                
                
                
			}else if(indexPath.row == 2) {
				cell.leftImage.image = [UIImage imageNamed:@"背景图"];
				cell.leftLabel.text = @"背景图设置";
			}
		}
			break;
  case 1:
		{
			
			if (indexPath.row == 0) {
				cell.leftImage.image = [UIImage imageNamed:@"升级"];
				cell.leftLabel.text = @"软件版本";
				NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
				[cell.rightButton setTitle:version forState:UIControlStateNormal];
				
			}else if(indexPath.row == 1) {
				cell.leftImage.image = [UIImage imageNamed:@"关于"];
				cell.leftLabel.text = @"关于HEROLIFE";
				[cell.rightButton setImage:[UIImage imageNamed:@"进入号"] forState:UIControlStateNormal];
			}else if(indexPath.row == 2) {
				cell.leftImage.image = [UIImage imageNamed:@"退出"];
				cell.leftLabel.text = @"退出登录";
			}
		}
			break;
			
  default:
			break;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	DDLogInfo(@"%ld", (long)indexPath.row);
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row==0)
            {
				GestureViewController * GVC = [GestureViewController new];
				GVC.type = GestureViewControllerTypeSetting;
                [self.navigationController pushViewController:GVC animated:YES];

            }
            
            else if (indexPath.row == 1)
            {
                
                
                BackPicSetController *BPC = [BackPicSetController new];
                [self.navigationController pushViewController:BPC animated:YES];
                
            }
            
            
            else if(indexPath.row == 2)
            {
               
                
            }
            
            
            
        }
            
            break;
            
            
	 case 1:
		{
			if (indexPath.row == 1) {//关于
				
				MissWebViewController *web = [[MissWebViewController alloc] init];
				self.navigationController.navigationBar.hidden = NO;
				//隐藏底部条
				for (UIView *view  in self.tabBarController.view.subviews) {
					if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
						view.hidden = YES;					}
				}
				[self.navigationController pushViewController:web animated:YES];
				
				
			}else if (indexPath.row == 2) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出当前登陆？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
				[alert show];
			}
        }
			
            break;
            
            
        default:
            break;
    }

    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HRCommonScreenH *20)];
	bottomView.backgroundColor = [UIColor clearColor];
	
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.hr_width, HRCommonScreenH *10)];
	topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];;
	
	[bottomView addSubview:topView];
	return bottomView;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		//隐藏slideMenu
		[self logout];
	}
}
-(void)logout {
	
	//弹出登陆界面
	
    
    
    LoginController *loginVC = [[LoginController alloc] init];
	NSString *QQName = [kUserDefault objectForKey:@"kNSUserDefaultsNickname"];
	if (QQName.length > 0) {
		loginVC.isClear = YES;
	}else
	{
		loginVC.isClear = NO;
	}
	
    HRNavigationViewController *nav = [[HRNavigationViewController alloc] initWithRootViewController:loginVC];
    
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
//	[self.navigationController pushViewController:nav animated:YES];
	
	
	//发送注销请求kDefaultsQQIconURL
	[HRServicesManager logout:nil];
	[self IsTabBarHidden:YES];
	[kUserDefault setObject:@"" forKey:kNSUserDefaultsNickname];
	[kUserDefault setObject:@"" forKey:kDefaultsQQIconURL];
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
