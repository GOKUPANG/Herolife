//
//  EnterPSWController.m
//  herolife
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 huarui. All rights reserved.
//


/** 屏幕高度*/
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

#import "NewConnectWifiController.h"
#import "UIView+SDAutoLayout.h"
#import "WiFiListController.h"

#import "WaitController.h"
#import "WIFIListModel.h"
#import "UDPModel.h"
#import "HRPushMode.h"
#import "NextController.h"

#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "WaitController.h"
#import "HRTabBarViewController.h"

@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>

@end

@implementation EspTouchDelegateImpl

-(void) dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
}

-(void) showAlertWithResult: (ESPTouchResult *) result
{
    //这里得到wifi UUID  1
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@ is connected to the wifi" , result.bssid];
    WaitController *waitVC = [[WaitController alloc] init];
    waitVC.bssidUUID = result.bssid;
//    
//    HRTabBarViewController *tabVC = (HRTabBarViewController *)[NSObject activityViewController];
//    DDLogWarn(@"nav---%@", NSStringFromClass([tabVC class]));
//    for (UIViewController *VC in tabVC.childViewControllers) {
//        UINavigationController *lastNav = (UINavigationController *)VC;
//        for (UIViewController *VC in lastNav.childViewControllers) {
//            if (NSStringFromClass([VC class]) isEqualToString:<#(nonnull NSString *)#>) {
//                
//            }
//        }
//    }
    
//    [VC.navigationController pushViewController:waitVC animated:YES];
//    NSTimeInterval dismissSeconds = 3.5;
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    [alertView show];
//    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:dismissSeconds];
}

-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithResult:result];
    });
}

@end

@interface NewConnectWifiController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>


@property(nonatomic,strong)UIView * lineView2;
/** <#name#> */
@property(nonatomic, weak) UIView *lineView3;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@property(nonatomic,strong)UITableView * tableView;
/** wifi名称 */
@property(nonatomic, weak)  UILabel * WIFILabel;
/**  */
@property(nonatomic, weak)  UITextField *WIFITextField;
/** 选中wifi时 传过来的值 */
@property(nonatomic, copy) NSString *name;
/** 选中wifi时 传过来的下标 */
@property(nonatomic, assign) NSInteger index;

@property(nonatomic, strong) HRUDPSocketTool  *udpSocket;


/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
/** 停留时间 */
@property(nonatomic, assign) int leftTime;
/** 停留时间 */
@property(nonatomic, assign) int wiftTime;

/** 定时器 */
@property (nonatomic, weak) NSTimer *wiftTimer;
/** WiFi cell的 最右边的图片 */
@property(nonatomic, weak) UIImageView *WIFIImageView;
/** <#name#> */
@property(nonatomic, weak) UISwitch *rightSwitch;

//demo属性
@property (strong, nonatomic) NSString *bssid;
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

// the state of the confirm/cancel button
@property (nonatomic, assign) BOOL _isConfirmState;

// without the condition, if the user tap confirm/cancel quickly enough,
// the bug will arise. the reason is follows:
// 0. task is starting created, but not finished
// 1. the task is cancel for the task hasn't been created, it do nothing
// 2. task is created
// 3. Oops, the task should be cancelled, but it is running
@property (nonatomic, strong) NSCondition *_condition;

@property (nonatomic, strong) UIButton *_doneButton;
@property (nonatomic, strong) EspTouchDelegateImpl *_esptouchDelegate;
@end


@implementation NewConnectWifiController

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
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",(long)PicNum];
        
        self.backImgView.image =[UIImage imageNamed:imgName];
    }
    
    
    
    NSLog(@"设置页面ViewWillappear");
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self makeUI];
    
    
    [self MakeStartAddView];
    
    
    //haibo 全屏放回
    [self goBack];
    
    //haibo 隐藏底部条
    [self IsTabBarHidden:YES];
    
    //初始化demo属性
    [self setUpDemoViewAttribute];
    [self addWifiTimer];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

//海波代码
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
-(void)makeUI
{
    //海波代码----------------------start-------------------------------------
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
    navView.titleLabel.text = @"输入密码";
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    self.navView = navView;
    //海波代码----------------------end-------------------------------------
    UIView  * lineView1 = [[UIView alloc]init];
    
    [self.view addSubview:lineView1];
    
    lineView1.sd_layout
    .topSpaceToView(self.view,64+90)
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(1);
    
    lineView1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    
    
    
    //第二条线
    _lineView2 = [[UIView alloc]init];
    
    [self.view addSubview:_lineView2];
    
    _lineView2.sd_layout
    .topSpaceToView(lineView1,50)
    .leftEqualToView(lineView1)
    .rightEqualToView(lineView1)
    .heightIs(1);
    _lineView2.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.7];
    
    
    //第三条线
    UIView *lineView3 = [[UIView alloc]init];
    
    [self.view addSubview:lineView3];
    
    lineView3.sd_layout
    .topSpaceToView(_lineView2,50)
    .leftEqualToView(_lineView2)
    .rightEqualToView(_lineView2)
    .heightIs(1);
    lineView3.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.7];
    
    self.lineView3 = lineView3;
    /** 第一行白线上面添加一个View*/
    
    UIView * WIFIView = [[UIView alloc]init];
    [self.view addSubview:WIFIView];
    
    
    WIFIView.sd_layout
    .bottomEqualToView(lineView1)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(46.0);
    
    
    
    /** WIFILabel */
    
    UILabel * WIFILabel = [[UILabel alloc]init];
    [WIFIView addSubview:WIFILabel];
    
    WIFILabel.sd_layout
    .bottomSpaceToView(WIFIView,10)
    .leftSpaceToView(WIFIView,25)
    .widthIs(200)
    .heightIs (20);
    WIFILabel.text = [kUserDefault objectForKey:kUserDefaultSsidString];
    WIFILabel.textAlignment= NSTextAlignmentLeft;
    
    WIFILabel.textColor = [UIColor whiteColor];
    self.WIFILabel = WIFILabel;
    
    /** WiFi cell的 最右边的图片*/
    
    UIImageView *WIFIImageView  = [[UIImageView alloc]init];
    
    [WIFIView addSubview:WIFIImageView];
    
    WIFIImageView.sd_layout
    .bottomSpaceToView(WIFIView,8)
    .rightSpaceToView(WIFIView,25)
    .widthIs(13)
    .heightIs(18);
    
    /** WiFi密码输入框*/
    
    UITextField *WIFITextField = [[UITextField alloc]init];
    
    [self.view addSubview:WIFITextField];
    
    
    WIFITextField.sd_layout
    .bottomSpaceToView(_lineView2,10)
    .leftSpaceToView(self.view,25)
    .widthIs(HRUIScreenW - 70)
    .heightIs(22);
    WIFITextField.textColor = [UIColor whiteColor];
    
    WIFITextField.returnKeyType = UIReturnKeyDone;
    
    WIFITextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    WIFITextField.placeholder = @"请输入密码";
    [WIFITextField setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    WIFITextField.clearButtonMode =    UITextFieldViewModeAlways;
#ifdef DEBUG
    WIFITextField.text = @"HRKJ39026922";
#endif
    
    
    self.WIFITextField = WIFITextField;
    
    /***********************新添加wifi方式的界面           ***************/
    //是否显示wifi滑块
    UILabel *sliderLabel = [[UILabel alloc] init];
    [self.view addSubview:sliderLabel];
    
    sliderLabel.text = @"wifi名是否已隐藏";
    sliderLabel.textColor = [UIColor whiteColor];
    sliderLabel.sd_layout
    .bottomSpaceToView(lineView3,10)
    .leftSpaceToView(self.view,25)
    .widthIs(150)
    .heightIs(30);
    
    UISwitch *rightSwitch = [[UISwitch alloc] init];
    [self.view addSubview:rightSwitch];
    
    rightSwitch.sd_layout
    .bottomSpaceToView(lineView3,10)
    .rightSpaceToView(self.view,25);
    self.rightSwitch = rightSwitch;
    
    
    
    /** WIFI密码输入框最右边的图片 */
    
    //    UIImageView *EyeimageView = [[UIImageView alloc]init];
    //    [self.view addSubview:EyeimageView];
    
    
    UIButton * eyeBtn = [[UIButton alloc]init];
    
    [self.view addSubview:eyeBtn];
    
    
    
    eyeBtn.sd_layout
    .bottomSpaceToView(_lineView2,10)
    .rightSpaceToView(self.view,25)
    .widthIs(18)
    .heightIs(13);
    
    // EyeimageView.image = [UIImage imageNamed:@"睁眼"];
    
    
    [eyeBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateNormal];
    
    [eyeBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateSelected];
    
    eyeBtn.selected = NO ;
    
    
    [eyeBtn addTarget:self action:@selector(openEye:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)openEye:(UIButton *)btn
{
    if (btn.selected == YES) {
        
        [btn setSelected:NO];
        self.WIFITextField.secureTextEntry = YES;
        
    }
    
    else{
        
        [btn setSelected:YES];
        
        self.WIFITextField.secureTextEntry = NO;
        
    }
}



#pragma mark - 添加wiftTime定时器
- (void)addWifiTimer
{
    self.wiftTime = 1200;
    self.wiftTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateWifiTimeLabel) userInfo:nil repeats:YES];
    
}
static NSString *wift;
- (void)updateWifiTimeLabel
{
    
    self.wiftTime--;
    wift = [NSString stringWithGetWifiName];
    self.WIFILabel.text = wift;
//    DDLogWarn(@"---------------------当前wifi%@", wift);
    if (self.wiftTime == 0) {
        
        [self.wiftTimer invalidate];
        self.wiftTimer = nil;
        
    }

}

#pragma mark - UI事件  -haibo
- (void)leftButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 开始添加按钮的设置
-(void)MakeStartAddView
{
    
    UIView * StartView = [[UIView alloc]init];
    [self.view addSubview:StartView];
    
    StartView.sd_layout
    .topSpaceToView(_lineView3,50)
    .leftSpaceToView(self.view ,15)
    .rightSpaceToView(self.view,15)
    .heightIs(40);
    
    
    UILabel * StartLabel  = [[UILabel alloc]init];
    
    [StartView addSubview:StartLabel];
    
    //    StartLabel.sd_layout
    //    .topSpaceToView(StartView,10)
    //    .bottomSpaceToView(StartView,10)
    //    .leftSpaceToView(StartView,137.5/375.0 *SCREEN_W)
    //    .rightSpaceToView(StartView,137.5/375.0 *SCREEN_W);
    
    StartLabel.sd_layout
    .topEqualToView(StartView)
    .bottomEqualToView(StartView)
    .leftEqualToView(StartView)
    .rightEqualToView(StartView);
    
    
    
    
    
    
    StartLabel.text = @"开始添加";
    
    StartLabel.textColor = [UIColor whiteColor];
    
    StartLabel.textAlignment = NSTextAlignmentCenter;
    
    
    StartView. backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    //给StartView添加边框效果
    
    StartView.layer.borderWidth = 1;
    StartView.layer.borderColor =[UIColor colorWithWhite:1.0 alpha:0.7].CGColor;
    
    
    
    //给 starView添加一个手势
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StartViewClick)];
    
    [StartView addGestureRecognizer:tap];
    
}


#pragma mark -点击开始添加实现的方法
-(void)StartViewClick
{
    
    NSLog(@"点击了开始添加");
    if (self.WIFILabel.text.length < 0.5 || self.WIFITextField.text.length < 0.5) {
        [SVProgressTool hr_showErrorWithStatus:@"wifi名或密码不能为空!"];
    }else
    {
        [self tapConfirmForResults];
    }
}

#pragma mark - demo相关
/************************************demo start****************************************/

#pragma mark -  the follow three methods are used to make soft-keyboard disappear when user finishing editing

// when textField begin editing, soft-keyboard apeear, do the callback
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.WIFITextField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.WIFITextField resignFirstResponder];
}
- (void)setUpDemoViewAttribute
{
    
    self._isConfirmState = NO;
    self.bssid = [kUserDefault objectForKey:kUserDefaultBssidString];
    self._condition = [[NSCondition alloc]init];
    self._esptouchDelegate = [[EspTouchDelegateImpl alloc]init];
    self.WIFITextField.delegate = self;
}
- (void) tapConfirmForResults
{
    [SVProgressTool hr_showWithStatus:@"正在添加..."];
//    NSString *wifi = [NSString stringWithGetWifiName];
    if ([self.WIFILabel.text isEqualToString:@"HUARUIKEJI_5G"]) {
        [SVProgressTool hr_showErrorWithLongTimeStatus:@"当前HUARUIKEJI_5G网络不支持该wifi盒子,请更换wifi后重试!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    if ([self.WIFILabel.text isEqualToString:@"互联网智能门锁"]) {
        [SVProgressTool hr_showErrorWithStatus:@"当前网络不支持该wifi盒子,请更换wifi后重试!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    NSLog(@"ESPViewController do confirm action...");
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"ESPViewController do the execute work...");
        // execute the task
        NSArray *esptouchResultArray = [self executeForResults];
        // show the result to the user in UI Main Thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
            // check whether the task is cancelled and no results received
            if (!firstResult.isCancelled)
            {
                NSMutableString *mutableStr = [[NSMutableString alloc]init];
                NSUInteger count = 0;
                // max results to be displayed, if it is more than maxDisplayCount,
                // just show the count of redundant ones
                const int maxDisplayCount = 5;
                if ([firstResult isSuc])
                {
                    
                    [SVProgressTool hr_dismiss];
                    ESPTouchResult *resultInArray;
                    for (int i = 0; i < [esptouchResultArray count]; ++i)
                    {
                        resultInArray = [esptouchResultArray objectAtIndex:i];
                        [mutableStr appendString:[resultInArray description]];
                        [mutableStr appendString:@"\n"];
                        count++;
                        if (count >= maxDisplayCount)
                        {
                            break;
                        }
                    }
                    
                    if (count < [esptouchResultArray count])
                    {
                        [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                    }
                    
                    
                    WaitController *waitVC = [[WaitController alloc] init];
                    waitVC.bssidUUID = resultInArray.bssid;
                    
                    [self.navigationController pushViewController:waitVC animated:YES];
                    //这里得到wifi UUID 2
//                    [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:mutableStr delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                }
                
                else
                {
                    //无任密码错误,还是超时都会走这个方法
//                    [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                    
                    [SVProgressTool hr_showErrorWithLongTimeStatus:@"请求失败,该错误可能是输入的密码错误或是请求超时!"];
                    DDLogWarn(@"----请求失败,该错误可能是输入的密码错误或是请求超时!");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
            
        });
    });
}
#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [self._condition lock];
    NSString *apSsid = self.WIFILabel.text;
    NSString *apPwd = self.WIFITextField.text;
    NSString *apBssid = self.bssid;
    BOOL isSsidHidden = [self.rightSwitch isOn];
    int taskCount = 1;
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
    // set delegate
    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self._condition unlock];
    NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}


/************************************demo end****************************************/
#pragma mark - tableView的UI设置

-(void)makeTableViewUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, self.view.bounds.size.width, 46.0 * 2) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    _tableView.rowHeight = 46.0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view addSubview:_tableView];
    
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.text = @"输入密码";
        cell.textLabel.textColor = [UIColor whiteColor];
        
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (void)dealloc
{
    
}

#pragma mark  - 海波代码
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [self IsTabBarHidden:YES];
    [SVProgressTool hr_dismiss];
    [self.wiftTimer invalidate];
    self.wiftTimer = nil;
    [SVProgressTool hr_dismiss];
    
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
#pragma mark - 全屏放回 - 海波代码
- (void)goBack
{
    // 获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

@end
