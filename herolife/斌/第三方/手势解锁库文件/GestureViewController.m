
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "LoginController.h"
#import "HRTabBarViewController.h"
#import "HRNavigationViewController.h"

@interface GestureViewController ()<CircleViewDelegate>

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;


/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;


/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;



@end

@implementation GestureViewController



#pragma mark - tabbar 设置

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = NO;
        }
    }
	
}

#pragma mark - 导航条 设置
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
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = YES;
        }
    }

    
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - 导航条左边返回方法
-(void)popToLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	for (UIView *view in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			
			view.hidden = YES;
		}
	}
	
	[self.view setBackgroundColor:CircleViewBackgroundColor];
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    
    self.backImgView =  backgroundImage;
    
    [self.view addSubview:backgroundImage];
	
	
	
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
	
	
	//设置背景图片
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
	
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"手势设置";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;

    
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 增加的删除手势密码
- (void)addDeleteButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(didClickBtn:)forControlEvents:UIControlEventTouchUpInside];
	
    NSString *titleString = @"删除手势";
    button.hr_x = UIScreenW *0.5 - 130 *0.5;
    button.hr_y = UIScreenH - 22 - 40;
    
    button.hr_height = 40;
    button.hr_width = 130;
	button.layer.cornerRadius = 40 * 0.5;
	button.layer.masksToBounds = YES;
	
	[button setTitle:titleString forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.tag = buttonTagReset;
	button.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:122 / 255.0];
    [self.view addSubview:button];
    self.resetBtn = button;
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 20 - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    //创建删除按钮
    [self addDeleteButton];
    
    
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    self.title = @"设置手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10 );
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
	self.navView.hidden = YES;
	
	//头像底纹viwe
	UIView *eptView = [[UIView alloc] init];
	eptView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
	eptView.frame = CGRectMake(0, 0, 110, 110);
	eptView.center = CGPointMake(kScreenW/2, kScreenH/5);
	eptView.layer.cornerRadius = eptView.hr_width *0.5;
	eptView.layer.masksToBounds = YES;
	[self.view addSubview:eptView];
	
	
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 100, 100);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
	
	//显示图片
	NSString *iconString;
	//QQ头像
	iconString = [kUserDefault objectForKey:kDefaultsQQIconURL];
	if (iconString.length > 0) {
		
		NSURL *url = [NSURL URLWithString:iconString];
		[imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
	}else
	{
		iconString = [kUserDefault objectForKey:kDefaultsIconURL];
		if (iconString.length > 0) {
			NSURL *url = [NSURL URLWithString:iconString];
			[imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像占位图片.jpg"]];
			
		}else
		{
			imageView.image = [UIImage imageNamed:@"头像占位图片.jpg"];
			
		}
		
	}
	
	imageView.layer.cornerRadius = imageView.hr_width *0.5;
	imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    #pragma mark -斌添加的代码1
    
    /***************添加的代码 ************/
	
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 200, 47);
    label.center = CGPointMake(kScreenW/2, CGRectGetMaxY(imageView.frame) + 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    //从 偏好设置里取用户名
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	//qq用户名称
	NSString *qqUserNmae = [kUserDefault valueForKey:kNSUserDefaultsNickname];
	if (qqUserNmae.length > 0) {
		
		label.text = @"当前用户为QQ用户";
		
	}else
	{
		
		label.text = str;
	}
    [self.view addSubview:label];

    
    
    
    /**************添加的代码*************/

    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 登录其他账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20) title:@"登陆其他账户" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
	
	self.resetBtn.hidden = YES;
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset:
        {
            NSLog(@"点击了重设按钮");
            // 1.隐藏按钮
            [SVProgressHUD showSuccessWithStatus:@"成功删除手势!" ];
			
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
			
             //4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
            [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
            
            //从数据库删除
            NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
            [HRSqlite hrSqliteDeleteUnlockWithUid:uid];
			

        }
            break;
        case buttonTagManager:
        {
            NSLog(@"点击了管理手势密码按钮");
            
            //忘记密码就去登陆界面
            
            [self getLoginHttpRequest];
            
            
            
        }
            break;
        case buttonTagForget:
            NSLog(@"点击了登录其他账户按钮");
            
            
            [self pushToLogout];

            
            break;
        default:
            break;
    }
}

/** 忘记手势密码*/

- (void)getLoginHttpRequest
{
    LoginController * loginVc = [LoginController new];
	//qq用户名称
	NSString *qqUserNmae = [kUserDefault valueForKey:kNSUserDefaultsNickname];
	if (qqUserNmae.length > 0) {
		loginVc.isClear = YES;
		
	}else
	{
		loginVc.isClear = NO;
	}
	HRNavigationViewController *nav = [[HRNavigationViewController alloc] initWithRootViewController:loginVc];
	
	[UIApplication sharedApplication].keyWindow.rootViewController = nav;
    //发送注销请求
    [HRServicesManager logout:nil];
}


/** 登陆其他账号*/
- (void)pushToLogout
{
    
    LoginController * loginVc = [LoginController new];
	loginVc.isClear = YES;
	HRNavigationViewController *nav = [[HRNavigationViewController alloc] initWithRootViewController:loginVc];
	[UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
    //发送注销请求
    [HRServicesManager logout:nil];
}



#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting


- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        //保存数据到数据库
        NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
        
        #pragma mark -修改代码3 重点 返回上一层的东西
        [HRSqlite saveUnlockWithUid:uid lockPassword:gesture];
		
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        NSLog(@"两次手势不匹配！");
		
		//从数据库删除
		NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
		[HRSqlite hrSqliteDeleteUnlockWithUid:uid];
		
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
			//手势正确,就让他跳到首页
			HRTabBarViewController *tabBarVC = [[HRTabBarViewController alloc] init];
			[UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

@end
