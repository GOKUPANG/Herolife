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

@interface SettingController ()<UITableViewDelegate, UITableViewDataSource>
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
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImgView.image = [UIImage imageNamed:@"Snip20160825_3"];
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
	backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
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
	iconImage.image = [UIImage imageNamed:@"Default-568h@3x-1"];
	self.iconImage.layer.cornerRadius = self.iconImage.hr_height *0.5;
	self.iconImage.layer.borderWidth = HRCommonScreenW * 20;
	self.iconImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
	self.iconImage.layer.masksToBounds = YES;
	
	[self.view addSubview:iconImage];
	self.iconImage = iconImage;
	
	//用户名
	UILabel *userLabel = [[UILabel alloc] init];
	userLabel.font = [UIFont systemFontOfSize:17];
	userLabel.text = @"用户名: Eleanor";
	userLabel.textAlignment = NSTextAlignmentCenter;
	userLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:userLabel];
	self.userLabel = userLabel;
	
	
	//邮箱
	UILabel *emailLabel = [[UILabel alloc] init];
	emailLabel.font = [UIFont systemFontOfSize:11];
	emailLabel.text = @"邮 箱: Eleanor_If@163.com";
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
				cell.leftImage.image = [UIImage imageNamed:@"子账号"];
				cell.leftLabel.text = @"子帐号管理";
			}else if(indexPath.row == 1) {
				cell.leftImage.image = [UIImage imageNamed:@"手势"];
				cell.leftLabel.text = @"手势设置";
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
				cell.leftLabel.text = @"软件升级";
				[cell.rightButton setTitle:@"V2.1.1" forState:UIControlStateNormal];
				
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
                AccountManagementController *AMC = [AccountManagementController new];
                [self.navigationController pushViewController:AMC animated:YES];
                
            }
            
            else if (indexPath.row == 1)
            {
                GestureViewController * GVC = [GestureViewController new];
                [self.navigationController pushViewController:GVC animated:YES];
                
            }
            
            
            else if(indexPath.row == 2)
            {
                BackPicSetController *BPC = [BackPicSetController new];
                [self.navigationController pushViewController:BPC animated:YES];
                
            }
            
            
            
        }
            
            break;
            
            
            case 1:
        {
            if (indexPath.row == 0) {
                
//        Class Psc  =   NSClassFromString(@"PushSettingController") ;
//                
//                
//                UIViewController *psc  = [[Psc alloc]init];
//                
//                [self.navigationController pushViewController:psc animated:YES];
                
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

@end
