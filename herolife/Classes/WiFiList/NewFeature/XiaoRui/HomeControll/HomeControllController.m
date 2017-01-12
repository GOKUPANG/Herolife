//
//  HomeControllController.m
//  herolife
//
//  Created by sswukang on 2016/12/14.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HomeControllController.h"
#import "InfraredDeviceCell.h"
#import "DeviceListModel.h"
#import "AppDelegate.h"
#import "HRRefreshHeader.h"
#import "TipsLabel.h"
#import "IracData.h"
#import "IrgmData.h"
#import "HRDOData.h"
#import "HRSceneData.h"
#import "AddIraViewController.h"
#import "EditViewController.h"
#import "AirCtrlViewController.h"
#import "GeneralInfraredCtrlViewController.h"
#import "CurrencyCtrlController.h"
#import "WindowCurtainsController.h"
#import "SwitchViewController.h"
#import "SceneController.h"
#import "AddCurrencyView.h"
#import "CurrencyController.h"
#import "PopEditDoView.h"
#import "IrgmStudyController.h"

@interface HomeControllController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate, YXCustomAlertViewDelegate>
///背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowCollectionView;

/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** mid */
@property(nonatomic, copy) NSString *mid;
/** uid */
@property(nonatomic, copy) NSString *uid;
/** did */
@property(nonatomic, copy) NSString *did;
/** uuid */
@property(nonatomic, copy) NSString *uuid;
/** TipsLabel */
@property(nonatomic, strong) TipsLabel *tipsLabel;
/** tableview */
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *popView;
/** ept */
@property(nonatomic, strong) UIView *eptView;
/** iracView */
@property(nonatomic, weak) UIView *iracView;
/** PopEditDoView */
//@property(nonatomic, strong) AddCurrencyView *currencyView;
/** eptCurrencyView */
@property(nonatomic, strong) UIView *eptCurrencyView;
/**  */
@property(nonatomic, strong) NSMutableArray *iracArray;
/**  */
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressIrac;
/**  */
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGS;
/**  */
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressDO;
/** 情景图标名称 */
@property(nonatomic, strong) NSArray *iconArray;
/** PopEditDoView */
@property(nonatomic, strong) AddCurrencyView *currencyView;
/** PopEditDoView */
@property(nonatomic, strong) PopEditDoView *doView;
/** 弹框中的输入框 */
@property(nonatomic, weak) UITextField *nameField;
/** <#name#> */
@property(nonatomic, weak) YXCustomAlertView *deviceAlertView;
@end

@implementation HomeControllController
- (NSArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = @[
                       @"在家",
                       @"浪漫",
                       @"会议",
                       @"就餐",
                       @"睡觉",
                       @"空调开",
                       @"空调关",
                       @"离家",
                       @"起床",
                       @"工作",
                       @"放松",
                       @"音乐",
                       @"唱K",
                       @"阅读",
                       @"在家",
                       @"窗帘开",
                       @"窗帘关",
                       @"窗帘暂停",
                       @"运动"
                       ];
    }
    return _iconArray;
}
- (NSMutableArray *)iracArray
{
    if (_iracArray == nil) {
        _iracArray = [NSMutableArray array];
    }
    return _iracArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotification removeObserver:self];

    //保存数据
    [kUserDefault setObject:self.deviceModel.uid forKey:kdefaultsIracUid];
    [kUserDefault setObject:self.deviceModel.uuid forKey:kdefaultsIracUuid];
    [kUserDefault setObject:self.deviceModel.did forKey:kdefaultsIracMid];
    [kUserDefault synchronize];
    
    
    self.mid = self.deviceModel.did;
    //建立连接
    [self postTokenWithTCPSocket];
    //HTTP请求设备
    [self getHTTPRequest];
    
    //隐藏底部条
    [self IsTabBarHidden:YES];
    [self setUpViews];
    // 集成刷新控件
    [self setupRefresh];
    
    [self addNotificationCenterObserver];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self IsTabBarHidden:YES];
    [self setUpBackGroungImage];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getHomeHTTPRequest];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressTool hr_dismiss];
    [kNotification removeObserver:self];
    
}

- (void)dealloc
{
    [kNotification removeObserver:self];
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
    //刷新设备
    [kNotification addObserver:self selector:@selector(getHomeHTTPRequest) name:kNotificationRefreshXiaoRuiDevice object:nil];
    
    //监听空调的创建帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateIrac:) name:kNotificationCreateIrac object:nil];
    //监听空调的删除帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDeleteIrac:) name:kNotificationDeleteIrac object:nil];
    //监听空调的更新帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateIrac:) name:kNotificationUpdateIrac object:nil];
    //监听空调的测试帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingIrac:) name:kNotificationTestingIrac object:nil];
    //监听空调的控制帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlIrac:) name:kNotificationControlIrac object:nil];
    
    //监听通用的创建帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateIrac:) name:kNotificationCreateIrgm object:nil];
    //监听通用的删除帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDeleteIrac:) name:kNotificationDeleteIrgm object:nil];
    //监听通用的更新帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateIrac:) name:kNotificationUpdateIrgm object:nil];
    //监听通用的测试帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingIrgm:) name:kNotificationTestingIrgm object:nil];
    //监听通用的控制帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlIrac:) name:kNotificationControlIrgm object:nil];
    
    //监听开关的创建帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateIrac:) name:kNotificationCreateDo object:nil];
    //监听开关的删除帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDeleteIrac:) name:kNotificationDeleteDo object:nil];
    //监听开关的更新帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateIrac:) name:kNotificationUpdateDo object:nil];
    //监听开关的测试帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingIrac:) name:kNotificationTestingDo object:nil];
    //监听通用的控制帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlDo:) name:kNotificationControlDo object:nil];
    
    //监听情景的创建帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateIrac:) name:kNotificationCreateScene object:nil];
    //监听情景的更新帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpdateIrac:) name:kNotificationUpDataScene object:nil];
    //监听情景的删除帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDeleteIrac:) name:kNotificationDeleteScene object:nil];
    //监听情景的控制帧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlScene:) name:kNotificationControlScene object:nil];
    
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
// -------------------空调 start------------------------------------

//监听空调的创建帧
- (void)receviedWithCreateIrac:(NSNotification *)notification
{
    [SVProgressTool hr_dismiss];
    isOvertime = YES;
    [self dismissDeviceAlertView];
    
    [self getHomeHTTPRequest];
   
}
//监听空调的删除帧
static BOOL isOvertimeDelete = NO;
- (void)receviedWithDeleteIrac:(NSNotification *)notification
{
    isOvertimeDelete = YES;
    [SVProgressTool hr_showSuccessWithStatus:@"删除成功!"];
    [self dismissDeviceAlertView];
    
    [self getHomeHTTPRequest];

    
}
//监听空调的更新帧
- (void)receviedWithUpdateIrac:(NSNotification *)notification
{
    [self getHomeHTTPRequest];
    [SVProgressTool hr_dismiss];
    isOvertime = YES;
    
    [self dismissDeviceAlertView];

}

//监听空调的测试帧
- (void)receviedWithTestingIrac:(NSNotification *)notification
{
}
//
- (void)receviedWithTestingIrgm:(NSNotification *)notification
{
    [self getHomeHTTPRequest];
}
//监听空调的控制帧

- (void)receviedWithControlIrac:(NSNotification *)notification
{
    [SVProgressTool hr_dismiss];
    isOvertime = YES;
    [self getHomeHTTPRequest];
}
//监听开关的控制帧
static BOOL isOvertime = NO;

- (void)receviedWithControlDo:(NSNotification *)notification
{
    isOvertime = YES;
    [SVProgressHUD dismiss];
    [self getHomeHTTPRequest];
}

- (void)receviedWithControlScene:(NSNotification *)notification
{
    isOvertime = YES;
    [SVProgressTool hr_showSuccessWithStatus:@"执行情景模式成功!"];
    [self getHomeHTTPRequest];
}

- (void)dismissDeviceAlertView
{
    [UIView animateWithDuration:0.8 animations:^{
        
        
        CGRect AlertViewFrame = self.deviceAlertView.frame;
        
        AlertViewFrame.origin.y = HRUIScreenH ;
        
        
        _deviceAlertView.frame = AlertViewFrame;
        
        _deviceAlertView.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        
        [_deviceAlertView dissMiss];
        
    }];
}

#pragma mark - 内部方法
// 集成刷新控件
- (void)setupRefresh
{
    // header - 下拉刷新
    self.collectionView.mj_header = [HRRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHomeHTTPRequest)];
    // 进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setUpViews
{
    
    CGSize size = CGSizeMake((UIScreenW - 40) / 3.f, (UIScreenW - 40) / 3.f + 10);
    self.flowCollectionView.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    self.flowCollectionView.itemSize = size;
    self.flowCollectionView.minimumLineSpacing = 10;
    self.flowCollectionView.minimumInteritemSpacing = 5;
    
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    UINib *cellNib = [UINib nibWithNibName:@"InfraredDeviceCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
    
    
}
- (void)setUpBackGroungImage
{
    
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

#pragma mark - UI事件
///返回
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
///添加按钮事件
- (IBAction)addButtonClick:(UIButton *)btn {
    NSArray *titleArray = @[@"添加空调类型",@"添加电视类型",@"添加红外通用",@"添加智能设备",@"添加情景模式"];
    NSArray *iconArray = @[@"添加空调类型",@"添加电视类型",@"添加红外通用",@"添加智能设备",@"添加情景模式"];
    [FTPopOverMenu showForSender:btn
                        withMenu:titleArray
                  imageNameArray:iconArray
                       doneBlock:^(NSInteger selectedIndex) {
                           if (selectedIndex == 0) {//添加空调类型
                               
                               AddIraViewController *VC = [[AddIraViewController alloc] init];
                               VC.iradata = self.deviceModel;
                               [self.navigationController pushViewController:VC animated:YES];
                               
                           }else if (selectedIndex == 1)//添加电视类型

                           {
                               [self addDeviceAlertViewWithTag:1 title:@"添加电视设备"];
                               
                           }else if (selectedIndex == 2)//添加红外通用
                           {
                               //添加弹框
                               [self addDeviceAlertViewWithTag:2 title:@"添加通用设备"];
                               
                           }else if (selectedIndex == 3)//添加智能设备
                               
                           {
                               SwitchViewController *switchVC = [[SwitchViewController alloc] init];
                               [self.navigationController pushViewController:switchVC animated:YES];
                               
                           }else if (selectedIndex == 4)//添加情景模式
                               
                           {
                               
                               SceneController *sceneVC = [[SceneController alloc] init];
                               [self.navigationController pushViewController:sceneVC animated:YES];
                           }
                           
                       } dismissBlock:^{
                           
                       }];
    
    

}

//添加通用 窗口
- (void)addCurrencyView
{
    //添加弹框
    self.currencyView = [[AddCurrencyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.currencyView];
    
    self.currencyView.backgroundColor  = [UIColor clearColor];
    self.currencyView.hidden = NO;
    
    //添加手势
    [self addTapGesture];
}
#pragma mark - 添加点击手势  点击退出键盘
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.eptView addGestureRecognizer:tap];
}
- (void)tapClick
{
    [self.view endEditing:YES];
}

#pragma mark - HTTP请求
- (void)getHTTPRequest
{
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_enter(serviceGroup);
        [self getHttpWithIRAC: serviceGroup];
        dispatch_group_wait(serviceGroup, DISPATCH_TIME_FOREVER);
        
        dispatch_group_enter(serviceGroup);
        [self getHttpWithIRGM: serviceGroup];
        
        dispatch_group_wait(serviceGroup, DISPATCH_TIME_FOREVER);
        
        
        dispatch_group_enter(serviceGroup);
        [self getHttpWithIRDO: serviceGroup];
        dispatch_group_wait(serviceGroup, DISPATCH_TIME_FOREVER);
        
        dispatch_group_notify(serviceGroup, dispatch_get_global_queue(0, 0), ^{
            
            [self getHttpWithScene];
        });
        
    });
    
    
    
    

    
}

//获取情景信息 HTTP请求
- (void)getHttpWithScene
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIHRScene_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        
        
        DDLogDebug(@"HRScene---responseObject--------------------4");
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        DDLogDebug(@"HRScene---responseObject%@", responseObject);
        
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
            
            // 要给保存 缓存的单例  清空  数据   如果不清空就可能保存上次的  内容
            [self.appDelegate  addHTTPDoArray:nil];
            return;
        }
        //把模型数组添加到对应的空数组中
        NSMutableArray *mutableArr = [NSMutableArray array];
        NSArray *responseArray = (NSArray*)responseObject;
        for (NSDictionary *dict in responseArray) {
            HRSceneData *sceneData = [HRSceneData mj_objectWithKeyValues:dict];
            HRSceneData *data = [HRSceneData hrsceneDataWithDict:dict];
            sceneData.data = data.data;
            [mutableArr addObject: sceneData];
        }
        [self.appDelegate  addHTTPSceneArray:mutableArr];
        
        
        [kNotification postNotificationName:kNotificationRefreshXiaoRuiDevice object:nil];
    }];
    
}

//获取开关信息 HTTP请求
- (void)getHttpWithIRDO:(dispatch_group_t)serviceGroup
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIHRDO_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        dispatch_group_leave(serviceGroup);
        DDLogDebug(@"HRDO---responseObject--------------------3");
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        DDLogDebug(@"HRDO---responseObject%@", responseObject);
        
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
            
            // 要给保存 缓存的单例  清空  数据   如果不清空就可能保存上次的  内容
            
            [self.appDelegate  addHTTPDoArray:nil];
            return;
        }
        //把模型数组添加到对应的空数组中
        NSMutableArray *mutableArr = [NSMutableArray array];
        NSArray *responseArray = (NSArray*)responseObject;
        for (NSDictionary *dict in responseArray) {
            HRDOData *iracData = [HRDOData mj_objectWithKeyValues:dict];
            [mutableArr addObject: iracData];
        }
        [self.appDelegate  addHTTPDoArray:mutableArr];
    }];
    
    
}
//获取红外空调信息 HTTP请求
- (void)getHttpWithIRAC:(dispatch_group_t)serviceGroup
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIRAC_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        
        dispatch_group_leave(serviceGroup);
        DDLogDebug(@"IRAC---responseObject--------------------1");
        
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        DDLogDebug(@"IRAC---responseObject%@", responseObject);
        
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
            
            // 要给保存 缓存的单例  清空  数据   如果不清空就可能保存上次的  内容
            
            [self.appDelegate addHTTPIracArray:nil];
            return;
        }
        [IracData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"switchOff" : @"switch"
                     };
        }];
        
        //把模型数组添加到对应的空数组中
        NSMutableArray *mutableArr = [NSMutableArray array];
        NSArray *responseArray = (NSArray*)responseObject;
        for (NSDictionary *dict in responseArray) {
            IracData *iracData = [IracData mj_objectWithKeyValues:dict];
            [mutableArr addObject: iracData];
        }
        [self.appDelegate  addHTTPIracArray:mutableArr];
    }];
    
    
}

//获取通用设备信息 HTTP请求
- (void)getHttpWithIRGM:(dispatch_group_t)serviceGroup
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIRGM_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        dispatch_group_leave(serviceGroup);
        DDLogDebug(@"IRGM---responseObject--------------------2");
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        DDLogDebug(@"IRGM---responseObject%@", responseObject);
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
            
            // 要给保存 缓存的单例  清空  数据   如果不清空就可能保存上次的  内容
            
            [self.appDelegate  addHTTPIrgmArray:nil];
            return;
        }
        //把模型数组添加到对应的空数组中
        //		NSMutableArray *mutableArr = [NSMutableArray array];
        NSArray *responseArray = (NSArray*)responseObject;
        //把模型数组添加到对应的空数组中
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSDictionary *dict in responseArray) {
            IrgmData *iracData = [IrgmData mj_objectWithKeyValues:dict];
            [mutableArr addObject: iracData];
        }
        [self.appDelegate  addHTTPIrgmArray:mutableArr];
        DDLogError(@"p6---%@",self.appDelegate.irgmArray);
        
    }];
    
}

#pragma mark - 从单例中取数据
- (void)getHomeHTTPRequest
{
    
    AppDelegate *app = self.appDelegate;
    [self.iracArray removeAllObjects];
    
    //添加空调
    //先判断是否是本身小睿的数据信息
    NSMutableArray *iracArr = [NSMutableArray array];
    NSString *mid = self.mid;
    for (IracData *data in app.iracArray) {
        if ([data.mid isEqualToString:mid]) {
            [iracArr addObject:data];
            [self.iracArray addObject:data];
        }
    }
    
    //添加通用
    //先判断是否是本身小睿的数据信息
    NSMutableArray *irgmArray = [NSMutableArray array];
    for (IrgmData *data in app.irgmArray) {
        if ([data.mid isEqualToString:mid]) {
            [irgmArray addObject:data];
        }
    }
    
    for (IrgmData *data in irgmArray) {
        [self.iracArray addObject:data];
    }
    //添加开关
    //先判断是否是本身小睿的数据信息
    NSMutableArray *doArray = [NSMutableArray array];
    for (HRDOData *data in app.doArray) {
        if ([data.mid isEqualToString:mid]) {
            [doArray addObject:data];
        }
    }
    for (HRDOData *data in doArray) {
        //拆开 开关  每一路添加
        [self addDoDataArrayWithFirstObject:data];
    }
    //添加情景
    NSMutableArray *sceneArray = [NSMutableArray array];
    for (HRSceneData *data in app.sceneArray) {
        if ([data.mid isEqualToString:mid]) {
            [sceneArray addObject:data];
        }
    }
    DDLogInfo(@"sceneArray%@", app.sceneArray);
    for (HRSceneData *data in sceneArray) {
        [self.iracArray addObject:data];
    }
    
    DDLogInfo(@"infer ---iracArray-%@", self.iracArray);
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    
    
}

//拆开 开关  每一路添加
- (void)addDoDataArrayWithFirstObject:(HRDOData *)data
{
    NSDictionary *dictData = (NSDictionary *)data;
    DDLogWarn(@"-----dict%@", dictData);
    HRDOData *doData = [HRDOData mj_objectWithKeyValues:dictData];
    if ([doData.parameter.firstObject isEqualToString:@"1"]) {
        
        DDLogError(@"1%@", data.parameter.firstObject);
        //添加第一路
        NSArray *dataArr = doData.parameter;
        NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
        doData.parameter = parameterArr1;
        
        [self.iracArray addObject:doData];
    }else if ([doData.parameter.firstObject isEqualToString:@"2"])
    {
        
        DDLogError(@"2%@", data.parameter.firstObject);
        //添加第一路
        HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *data1Arr = newData.parameter;
        NSArray *parameter1Arr1 = @[@"1", data1Arr[2], data1Arr[3]];
        newData.parameter = parameter1Arr1;
        [self.iracArray addObject:newData];
        DDLogInfo(@"dataArr23%@ %@", data1Arr[2],data1Arr[3]);
        //添加第二路
        HRDOData *newData2 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr2 = [newData2 valueForKeyPath:@"parameter"];
        NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
        DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
        //把前面值的覆盖了
        [newData2 setValue:parameterArr2 forKeyPath:@"parameter"];
        [self.iracArray addObject:newData2];
    }else if ([data.parameter.firstObject isEqualToString:@"3"])
    {
        DDLogError(@"3%@", data.parameter.firstObject);
        //添加第一路
        HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
        HRDOData *temData = [HRDOData mj_objectWithKeyValues:dictData];
        
        NSArray *parameterArr1 = @[@"1", newData.parameter[2], newData.parameter[3]];
        temData.parameter = parameterArr1;
        [self.iracArray addObject:temData];
        
        //添加第二路
        HRDOData *temData2 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *parameterArr2 = @[@"2", newData.parameter[4], newData.parameter[5]];
        //把前面值的覆盖了
        temData2.parameter = parameterArr2;
        [self.iracArray addObject:temData2];
        
        //添加第三路
        HRDOData *temData3 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *parameterArr3 = @[@"3", newData.parameter[6], newData.parameter[7]];
        //把前面值的覆盖了
        temData3.parameter = parameterArr3;
        [self.iracArray addObject:temData3];
        
    }else if ([data.parameter.firstObject isEqualToString:@"4"])
    {
        //添加第一路
        HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr = newData.parameter;
        NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
        newData.parameter = parameterArr1;
        [self.iracArray addObject:newData];
        
        //添加第二路
        HRDOData *doData2 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr2 = [doData2 valueForKeyPath:@"parameter"];
        NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
        DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
        //把前面值的覆盖了
        [doData2 setValue:parameterArr2 forKeyPath:@"parameter"];
        [self.iracArray addObject:doData2];
        
        //添加第三路
        HRDOData *doData3 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr3 = [doData3 valueForKeyPath:@"parameter"];
        NSArray *parameterArr3 = @[@"3", dataArr3[6], dataArr3[7]];
        //把前面值的覆盖了
        [doData3 setValue:parameterArr3 forKeyPath:@"parameter"];
        [self.iracArray addObject:doData3];
        
        //添加第四路
        HRDOData *doData4 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr4 = [doData4 valueForKeyPath:@"parameter"];
        NSArray *parameterArr4 = @[@"4", dataArr4[8], dataArr4[9]];
        //把前面值的覆盖了
        [doData4 setValue:parameterArr4 forKeyPath:@"parameter"];
        [self.iracArray addObject:doData4];
    }
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //	appDelegate.recevedDelegate = self;
    [appDelegate connectToHost];
    self.appDelegate = appDelegate;
    
}

#pragma mark - UICollectionViewDelegate  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.iracArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    InfraredDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UIGestureRecognizer *gest in cell.contentView.gestureRecognizers ) {//删除手势
        if ([gest isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [cell.contentView removeGestureRecognizer:gest];
        }
    }
    
    DDLogInfo(@"%ld", (long)indexPath.row);
    if (self.iracArray.count > 0) {
        
        id data = self.iracArray[indexPath.row];
        
        if ([[data valueForKeyPath:@"types"] isEqualToString:@"irac"]) {//空调
            IracData *dataAir = [IracData mj_objectWithKeyValues:data];
            HRInfraredDevice *device = [[HRInfraredDevice alloc] init];
            device.deviceType = HRInfraredDeviceTypeAir;
            device.name = dataAir.title;
            cell.device = device;
            [cell updateUI];
            //添加长按手势
            UILongPressGestureRecognizer  *longPressIrac = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressIracActiong:)];
            
            [cell.contentView addGestureRecognizer:longPressIrac];
            
        }else if ([[data valueForKeyPath:@"types"] isEqualToString:@"irgm"])//红外类型
        {
            IrgmData *dataGeneral = [IrgmData mj_objectWithKeyValues:data];
            if ([dataGeneral.picture.lastObject isEqualToString:@"1"]) {
                cell.titleLabel.text = dataGeneral.title;
                cell.imageView.image = [UIImage imageNamed:@"电视关"];
            }else if ([dataGeneral.picture.lastObject isEqualToString:@"2"])
            {
                cell.titleLabel.text = dataGeneral.title;
                cell.imageView.image = [UIImage imageNamed:@"小睿通用关"];
            }
            //添加长按手势
            UILongPressGestureRecognizer  *longPressGS = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressActiong:)];
            [cell.contentView addGestureRecognizer:longPressGS];
            
        }else if ([[data valueForKeyPath:@"types"] isEqualToString:@"hrdo"])//开关类型
        {
            HRDOData *doData = [HRDOData mj_objectWithKeyValues:data];
            //添加长按手势
            UILongPressGestureRecognizer  *longPressDO = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDoActiong:)];
            [cell.contentView addGestureRecognizer:longPressDO];
            
            NSString * pictureStr = doData.picture.firstObject;
            if ([pictureStr isEqualToString:@"1"] || [pictureStr isEqualToString:@"2"] || [pictureStr isEqualToString:@"4"]) {//智能开关
                
                if ([doData.parameter[2] isEqualToString:@"0"]) {
                    
                    cell.imageView.image = [UIImage imageNamed:@"灯泡关"];
                    
                }else if ([doData.parameter[2] isEqualToString:@"1"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"灯泡开"];
                }
                
            }else if ([pictureStr isEqualToString:@"3"]) {//智能插座
                
                if ([doData.parameter[2] isEqualToString:@"0"]) {
                    
                    cell.imageView.image = [UIImage imageNamed:@"插座关"];
                    
                }else if ([doData.parameter[2] isEqualToString:@"1"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"插座开"];
                }
            }else if ([pictureStr isEqualToString:@"5"]) {//窗帘控制器
                cell.imageView.image = [UIImage imageNamed:@"窗帘"];
            }
            cell.titleLabel.text = doData.parameter[1];
            
        }else if ([[data valueForKeyPath:@"types"] isEqualToString:@"scene"])//情景类型
        {
            HRSceneData *sceneData = [HRSceneData mj_objectWithKeyValues:data];
            int index = [sceneData.picture.firstObject intValue] ;
            cell.titleLabel.text = sceneData.title;
            if (index == 0) {
                cell.imageView.image = [UIImage imageNamed:self.iconArray[index]];
            }else
            {
                cell.imageView.image = [UIImage imageNamed:self.iconArray[index -1]];
            }
            //添加长按手势
            UILongPressGestureRecognizer  *longPressScene = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSceneActiong:)];
            [cell.contentView addGestureRecognizer:longPressScene];
            
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *types = [(NSDictionary *)self.iracArray[indexPath.row] valueForKeyPath:@"types"];
    if ([types isEqualToString:@"irac"]) {
        IracData *data = [IracData mj_objectWithKeyValues:(NSDictionary *)self.iracArray[indexPath.row]];
        
        AirCtrlViewController *vc = [[AirCtrlViewController alloc] init];
        vc.iracData = data;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([types isEqualToString:@"irgm"]) {
        IrgmData *data = [IrgmData mj_objectWithKeyValues:(NSDictionary *)self.iracArray[indexPath.row]];
        
        if ([data.picture.lastObject isEqualToString:@"1"]) {
            GeneralInfraredCtrlViewController *vc = [[GeneralInfraredCtrlViewController alloc] init];
            vc.irgmData = data;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([data.picture.lastObject isEqualToString:@"2"]) {
            CurrencyCtrlController *vc = [[CurrencyCtrlController alloc] init];
            vc.irgmData = data;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([types isEqualToString:@"hrdo"]) {
        HRDOData *data = [HRDOData mj_objectWithKeyValues:(NSDictionary *)self.iracArray[indexPath.row]];
        NSString * pictureStr = data.picture.firstObject;
        if ([pictureStr isEqualToString:@"1"] || [pictureStr isEqualToString:@"2"] || [pictureStr isEqualToString:@"4"]) {
            
            if ([data.parameter[2] isEqualToString:@"0"]) {//灯泡关
                [self controlDoBulbWithData:data status:@"1"];
                
                
            }else if ([data.parameter[2] isEqualToString:@"1"])//灯泡开
            {
                [self controlDoBulbWithData:data status:@"0"];
            }
            
        }else if ([pictureStr isEqualToString:@"3"]) {//插座 关
            
            if ([data.parameter[2] isEqualToString:@"0"]) {
                
                [self controlDoBulbWithData:data status:@"1"];
            }else if ([data.parameter[2] isEqualToString:@"1"])//插座 开
            {
                [self controlDoBulbWithData:data status:@"0"];
            }
        }else if ([pictureStr isEqualToString:@"5"]) {// 窗帘
            
            WindowCurtainsController *windowVC = [[WindowCurtainsController alloc] init];
            windowVC.doData = data;
            [self.navigationController pushViewController:windowVC animated:YES];
            
        }
        
    }else if ([types isEqualToString:@"scene"])
    {
        HRSceneData *rowDict = [HRSceneData mj_objectWithKeyValues:(NSDictionary *)self.iracArray[indexPath.row]];
        NSArray *data = [NSArray array];
        /// 发送控制情景 请求帧
        NSString *str = [NSString stringWithSceneType:@"control" did:rowDict.did title:rowDict.title picture:rowDict.picture data:data];
        
        [self.appDelegate sendMessageWithString:str];
        [SVProgressTool hr_showWithStatus:@"正在控制设备..."];
        // 设置超时
        isOvertime = NO;
        isShowOverMenu = NO;
        // 启动定时器
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
    }
    
    
    
}

#pragma mark - 开关控制
- (void)controlDoBulbWithData:(HRDOData *)data status:(NSString *)status
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    
    /// 发送开关 控制请求帧
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
    NSString *channelNumber = data.parameter.firstObject;
    NSString *op = @"None";
    
    NSArray *parameter = @[channelNumber, op, data.parameter[1], status];
    
    NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"control" desc:@"control desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:data.uid mid:data.mid did:data.did uuid:data.uuid types:@"hrdo" newVersion:data.version title:data.title brand:data.brand created:data.created update:data.update state:data.state picture:data.picture regional:data.regional parameter:parameter];
    
    DDLogWarn(@"-------发送开关 控制请求帧-------dostr%@", str);
    [self.appDelegate sendMessageWithString:str];
    [SVProgressTool hr_showWithStatus:@"正在控制设备..."];
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
static NSInteger gesturerRow = -1;
#pragma mark - 长按手势
// 情景长按手势
- (void)longPressSceneActiong:(UILongPressGestureRecognizer *)gesture
{
    CGPoint pointTouch = [gesture locationInView:self.collectionView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        
        
        if (indexPath == nil) {
            gesturerRow = -1;
        }else{
            gesturerRow = indexPath.row;
            
        }
        HRSceneData *data = [HRSceneData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:data.title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改设备信息", @"删除设备", nil];
        
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        sheet.tag = 1003;
        [sheet showInView:self.view];
    }
    
}
// 开关长按手势
- (void)longPressDoActiong:(UILongPressGestureRecognizer *)gesture
{
    CGPoint pointTouch = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        
        if (indexPath == nil) {
            gesturerRow = -1;
        }else{
            gesturerRow = indexPath.row;
            
        }
        HRDOData *data = [HRDOData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:data.title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改设备信息", @"删除设备", nil];
        
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        sheet.tag = 1002;
        [sheet showInView:self.view];
    }
}

// 红外空调长按手势
- (void)longPressIracActiong:(UILongPressGestureRecognizer *)gesture
{
    CGPoint pointTouch = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        
        if (indexPath == nil) {
            gesturerRow = -1;
        }else{
            gesturerRow = indexPath.row;
            
        }
        
        IracData *data = [IracData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:data.title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改设备信息", @"删除设备", nil];
        
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        sheet.tag = 1000;
        [sheet showInView:self.view];
    }
}
//通用
- (void)longPressActiong:(UILongPressGestureRecognizer *)gesture
{
    CGPoint pointTouch = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        
        if (indexPath == nil) {
            DDLogInfo(@"indexPath为空");
            gesturerRow = -1;
        }else{
            gesturerRow = indexPath.row;
            DDLogInfo(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
            
        }
        
        IrgmData *data = [IrgmData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:data.title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改设备信息", @"删除设备", nil];
        sheet.tag = 1001;
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [sheet showInView:self.view];
    }
    
}


#pragma mark - sheet 代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {//空调
        
        if (buttonIndex == 0) {
            //跳转到编辑 控制器
            EditViewController *editVC = [[EditViewController alloc] init];
            IracData *rowDict = [IracData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
            editVC.iradata = rowDict;
            [self.navigationController pushViewController:editVC animated:YES];
            
        }else if (buttonIndex == 1) {
            
            
            [self deleteDeviceAlertViewWithTag:4 title:@"删除设备"];
            
        }else if(buttonIndex == 2) {
            
        }
    }else if (actionSheet.tag == 1001)//通用
    {
        IrgmData *rowDict = [IrgmData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
        if (buttonIndex == 0) {
//            //红外学习
            if ([rowDict.picture.lastObject isEqualToString:@"1"]) {
                // 通用红外学习
                IrgmStudyController *studyVC = [[IrgmStudyController alloc] init];
                studyVC.irgmData = rowDict;
                [self.navigationController pushViewController:studyVC animated:YES];
            
            }else if ([rowDict.picture.lastObject isEqualToString:@"2"])
            {
                CurrencyController *currencyVC = [[CurrencyController alloc] init];
                currencyVC.irgmData = rowDict;
                [self.navigationController pushViewController:currencyVC animated:YES];
                
            }
        }else if (buttonIndex == 1) {
            
            [self deleteDeviceAlertViewWithTag:5 title:@"删除设备"];
            
        }else if(buttonIndex == 2) {
            
        }
    }else if (actionSheet.tag == 1002)//开关
    {
        if (buttonIndex == 0) {
            
            [self addDeviceAlertViewWithTag:3 title:@"修改设备信息"];
            
        }else if (buttonIndex == 1) {
            
            [self deleteDeviceAlertViewWithTag:6 title:@"删除设备"];
            
        }else if(buttonIndex == 2) {
            
        }
    }
    else if (actionSheet.tag == 1003)//情景
    {
        HRSceneData *rowDict = [HRSceneData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
        
        if (buttonIndex == 0) {
            //编辑 view
            SceneController *sceneVC = [[SceneController alloc] init];
            sceneVC.sceneData = rowDict;
            [self.navigationController pushViewController:sceneVC animated:YES];
            
        }else if (buttonIndex == 1) {
            [self deleteDeviceAlertViewWithTag:7 title:@"删除设备"];
            
        }else if(buttonIndex == 2) {
            
        }
    }
    
}

- (void)startTimerDelete
{
    if (!isOvertimeDelete && !
        isShowOverMenu) {
        [SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
    }
}



#pragma mark -添加 YXCustomAlertView 弹窗 相关  第三方demo方法

-(void)deleteDeviceAlertViewWithTag:(NSInteger)tag title:(NSString *)title
{
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = title;
    alertV.tag = tag;
    
    
    self.deviceAlertView = alertV;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.deviceAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.deviceAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
}

-(void)addDeviceAlertViewWithTag:(NSInteger)tag title:(NSString *)title
{
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = title;
    alertV.tag = tag;
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:nameLabel];
    nameLabel.text = @"设备名";
    nameLabel.textColor = [UIColor blackColor];
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
    nameField.layer.borderColor = [[UIColor blackColor] CGColor];
    nameField.secureTextEntry = NO;
    UIView *leftpPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.leftView = leftpPwdView;
    
    
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.layer.borderWidth = 1;
    nameField.layer.cornerRadius = 4;
    
    nameField.placeholder = @"请输入您的设备名";
    
    
    
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    nameField.textColor = [UIColor blackColor];
    
    
    
    
    self.nameField = nameField;
    
    
    [alertV addSubview:self.nameField];
    
    
    
    self.deviceAlertView = alertV;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.deviceAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.deviceAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
}

- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            CGRect AlertViewFrame = customAlertView.frame;
            
            AlertViewFrame.origin.y = 0;
            
            customAlertView.alpha = 0;
            
            
            
            customAlertView.frame = AlertViewFrame;
            
        } completion:^(BOOL finished) {
            
            
            [customAlertView dissMiss];
            
            
        }];
    }else{
        
        
        
        
        if (customAlertView.tag == 1) {//TV
            
            if (self.nameField.text.length == 0 ) {
                [customAlertView.layer shake];
                
                [SVProgressTool hr_showErrorWithStatus:@"设备名为空,请输入设备名!"];
                return;
                
            }
            [self sendDataToSocketWithPicture:@"1"];
        }else if (customAlertView.tag == 2)//通用
        {
            
            if (self.nameField.text.length == 0 ) {
                [customAlertView.layer shake];
                
                [SVProgressTool hr_showErrorWithStatus:@"设备名为空,请输入设备名!"];
                return;
                
            }
            [self sendDataToSocketWithPicture:@"2"];
            
        }else if (customAlertView.tag == 3)//通用
        {
            
            if (self.nameField.text.length == 0 ) {
                [customAlertView.layer shake];
                
                [SVProgressTool hr_showErrorWithStatus:@"设备名为空,请输入设备名!"];
                return;
                
            }
            HRDOData *rowDict = [HRDOData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
            [self sendSocketWithData:rowDict];
            
        }else if (customAlertView.tag == 4)//删除  空调
        {
            [self sendSocketWithDeleteIrac];
            
        }else if (customAlertView.tag == 5)//删除  通用和TV
        {
            [self sendSocketWithDeleteCurrentyAndTV];
            
        }else if (customAlertView.tag == 6)//删除  开关
        {
            [self sendSocketWithDeleteDo];
            
        }else if (customAlertView.tag == 7)//删除  情景
        {
            [self sendSocketWithDeleteScene];
            
        }
    }
}
#pragma mark - 删除 设备 socket帧
//情景
- (void)sendSocketWithDeleteScene
{
    
    HRSceneData *rowDict = [HRSceneData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
    NSArray *data = [NSArray array];
    /// 发送删除开关 请求帧
    NSString *str = [NSString stringWithSceneType:@"delete" did:rowDict.did title:rowDict.title picture:rowDict.picture data:data];
    
    [self.appDelegate sendMessageWithString:str];
    [SVProgressTool hr_showWithStatus:@"正在删除设备..."];
    // 设置超时
    isOvertimeDelete = NO;
    isShowOverMenu = NO;
    // 启动定时器
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimerDelete) userInfo:nil repeats:NO];
}
//开关
- (void)sendSocketWithDeleteDo
{
    
    HRDOData *rowDict = [HRDOData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
    
    /// 发送删除开关 请求帧
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
    NSArray *regional = [NSArray array];
    NSArray *parameter;
    NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"delete" desc:@"delete desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:rowDict.uid mid:rowDict.mid did:rowDict.did uuid:rowDict.uuid types:@"hrdo" newVersion:@"0.0.1" title:rowDict.title brand:rowDict.brand created:[NSString loadCurrentDate] update:[NSString loadCurrentDate] state:@"1" picture:rowDict.picture.firstObject regional:regional parameter:parameter];
    
    [self.appDelegate sendMessageWithString:str];
    [SVProgressTool hr_showWithStatus:@"正在删除设备..."];
    // 设置超时
    isOvertimeDelete = NO;
    isShowOverMenu = NO;
    // 启动定时器
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimerDelete) userInfo:nil repeats:NO];
}
//通用 TV
- (void)sendSocketWithDeleteCurrentyAndTV
{
    
    IrgmData *rowDict = [IrgmData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    
    /// 发送创建空调 请求帧
    NSString *str = [NSString stringWithIRGMVersion:@"0.0.1"
                                             status:@"200"
                                              token:token
                                               type:@"delete"
                                               desc:@"delete desc message"
                                        srcUserName:user
                                        dstUserName:user
                                         dstDevName:rowDict.uuid
                                                uid:rowDict.uid
                                                mid:rowDict.mid
                                                did:rowDict.did
                                               uuid:rowDict.uuid
                                              types:rowDict.types
                                         newVersion:rowDict.version
                                              title:rowDict.title
                                              brand:rowDict.brand
                                            created:rowDict.created
                                             update:rowDict.update
                                              state:rowDict.state
                                            picture:rowDict.picture
                                           regional:rowDict.regional
                                                 op:rowDict.op
                                             name01:rowDict.name01
                                             name02:rowDict.name02
                                             name03:rowDict.name03
                                            param01:rowDict.param01
                                            param02:rowDict.param02
                                            param03:rowDict.param03];
    
    [self.appDelegate sendMessageWithString:str];
    // 设置超时
    [SVProgressTool hr_showWithStatus:@"正在删除设备..."];
    // 设置超时
    isOvertimeDelete = NO;
    isShowOverMenu = NO;
    // 启动定时器
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimerDelete) userInfo:nil repeats:NO];
    
}
//空调
- (void)sendSocketWithDeleteIrac
{
    
    IracData *rowDict = [IracData mj_objectWithKeyValues:self.iracArray[gesturerRow]];
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    
    /// 发送创建空调 请求帧
    NSString *uid = rowDict.uid;
    NSString *uuid = rowDict.uuid;
    NSString *mid = rowDict.mid;
    //根据该ID删除设备
    NSString *did = rowDict.did;
    
    NSArray *picture = [NSArray array];
    NSArray *regional = [NSArray array];
    
    
    NSString *str = [NSString stringWithIRACVersion:@"0.0.1" status:@"200" token:token type:@"delete" desc:@"delete desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:did uuid:uuid types:@"irac" newVersion:@"0.0.1" title:rowDict.title brand:rowDict.brand created:rowDict.created update:rowDict.update state:@"1" picture:picture regional:regional model:rowDict.model onSwitch:rowDict.switchOff mode:rowDict.mode temperature:rowDict.temperature windspeed:rowDict.windspeed winddirection:rowDict.winddirection];
    
    [self.appDelegate sendMessageWithString:str];
    [SVProgressTool hr_showWithStatus:@"正在删除设备..."];
    // 设置超时
    isOvertimeDelete = NO;
    isShowOverMenu = NO;
    // 启动定时器
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimerDelete) userInfo:nil repeats:NO];
}
#pragma mark - 创建 TV 通用设备 和修改开关设备名称 socket 帧
- (void)sendSocketWithData:(HRDOData *)doData
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    NSString *xiaoRuiUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
    NSArray *parameter = @[doData.parameter.firstObject, @"None", self.nameField.text, doData.parameter[2]];
    NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"update" desc:@"update desc message" srcUserName:user dstUserName:user dstDevName:xiaoRuiUUID uid:doData.uid mid:doData.mid did:doData.did uuid:doData.uuid types:@"hrdo" newVersion:@"0.0.1" title:self.nameField.text brand:doData.brand created:[NSString loadCurrentDate] update:[NSString loadCurrentDate] state:@"1" picture:doData.picture regional:doData.regional parameter:parameter];
    
    [self.appDelegate sendMessageWithString:str];
    DDLogInfo(@"发送 更新开关  数据%@", str);
    [SVProgressTool hr_showWithStatus:@"正在更新设备名..."];
    // 启动定时器
    [_timer invalidate];
    isOvertime = NO;
    isShowOverMenu = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}

- (void)sendDataToSocketWithPicture:(NSString *)pic
{
    [SVProgressTool hr_showWithStatus:@"正在添加设备..."];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    
    /// 发送创建TV 请求帧
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUid];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracMid];
    
    NSMutableArray *picture = [NSMutableArray array];
    [picture addObject:pic];
    NSArray *regional = [NSArray array];
    NSArray *op = [NSArray array];
    NSArray *name01 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
    NSArray *name02 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
    NSArray *name03 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
    NSArray *param01 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
    NSArray *param02 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
    NSArray *param03 = @[@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None",@"None"];
    
    NSString *str = [NSString stringWithIRGMVersion:@"0.0.1" status:@"200" token:token type:@"create" desc:@"create desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:@"None" uuid:uuid types:@"irgm" newVersion:@"0.0.1" title:self.nameField.text brand:@"brand" created:@"None" update:@"None" state:@"1" picture:picture regional:regional op:op name01:name01 name02:name02 name03:name03 param01:param01 param02:param02 param03:param03];
    DDLogWarn(@"-------发送添加通用 请求帧-------iracstr%@", str);
    
    [self.appDelegate sendMessageWithString:str];
    // 启动定时器
    [_timer invalidate];
    isOvertime = NO;
    isShowOverMenu = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
   
    
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
