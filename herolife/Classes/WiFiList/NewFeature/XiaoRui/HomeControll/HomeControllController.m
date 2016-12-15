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

@interface HomeControllController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>
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
/** PopEditDoView */
//@property(nonatomic, strong) PopEditDoView *doView;
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
@end

@implementation HomeControllController
- (NSArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = @[
                       @"ico_scene_athome_clicked",
                       @"ico_scene_romance_clicked",
                       @"ico_scene_meeting_clicked",
                       @"ico_scene_repast_clicked",
                       @"ico_scene_sleeping_clicked",
                       @"ico_scene_air_open",
                       @"ico_scene_air_close",
                       @"ico_scene_leavehome_clicked",
                       @"ico_scene_gettingup_clicked",
                       @"ico_scene_working_clicked",
                       @"ico_scene_relaxation_clicked",
                       @"ico_scene_media_clicked",
                       @"ico_scene_recreation_clicked",
                       @"ico_scene_reading_clicked",
                       @"ico_scene_athome_clicked",
                       @"ico_scene_curtainopen_clicked",
                       @"ico_scene_curtainclose_clicked",
                       @"ico_scene_curtainstop_clicked",
                       @"ico_scene_sports_clicked"
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
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setUpBackGroungImage];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self IsTabBarHidden:NO];
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
    
    //    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0);
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
                           
                           
                       } dismissBlock:^{
                           
                       }];
    
    

}

#pragma mark - HTTP请求
- (void)getHTTPRequest
{
    [self getHttpWithIRAC];
    
    
    [self getHttpWithIRGM];
    
    
    
    [self getHttpWithIRDO];
    
    
    
    [self getHttpWithScene];
    
}

//获取情景信息 HTTP请求
- (void)getHttpWithScene
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIHRScene_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
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

    }];
    
}

//获取开关信息 HTTP请求
- (void)getHttpWithIRDO
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIHRDO_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
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
- (void)getHttpWithIRAC
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIRAC_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
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
- (void)getHttpWithIRGM
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *mid = self.mid;
    parameters[@"mid"] = mid;
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiIRGM_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
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

-(void)showAlert:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"添加空调类型", @"添加通用类型", @"添加开关类型", nil];
    [alert show];
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
