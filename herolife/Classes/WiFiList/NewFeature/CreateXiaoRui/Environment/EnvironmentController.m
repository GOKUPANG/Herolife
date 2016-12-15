//
//  EnvironmentController.m
//  herolife
//
//  Created by sswukang on 2016/12/8.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "EnvironmentController.h"
#import "UUChart.h"
#import "DeviceListModel.h"
#import "HRTotalData.h"

@interface EnvironmentController ()<UUChartDataSource>
///背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet HRNoHighLightedButton *PMButton;
/** 记录当前的按钮 */
@property(nonatomic, weak) UIButton *currentButton;
/** 图表对象 */
@property(nonatomic, strong) UUChart *chartView;
@property(nonatomic, strong) UUChart *currentChartView;
@property (weak, nonatomic) IBOutlet UIImageView *circularImageView;
/**数据等级  */
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
/**数值  */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
/**单位  */
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;


/** 保存PM数组 */
@property(nonatomic, strong) NSMutableArray *pmArr;
/** 保存voc数组 */
@property(nonatomic, strong) NSMutableArray *vocArr;
/** 保存温度数组 */
@property(nonatomic, strong) NSMutableArray *tempArr;
/** 保存湿度数组 */
@property(nonatomic, strong) NSMutableArray *humidArr;

/** 保存时间的数组 */
@property(nonatomic, strong) NSMutableArray *updataArr;
/** 总数据数组 */
@property(nonatomic, strong) NSMutableArray *totalArr;
/** mid */
@property(nonatomic, copy) NSString *mid;
@end

@implementation EnvironmentController

- (NSMutableArray *)tempArr
{
    if (_tempArr == nil) {
        _tempArr = [NSMutableArray array];
    }
    return _tempArr;
}

- (NSMutableArray *)humidArr
{
    if (_humidArr == nil) {
        _humidArr = [NSMutableArray array];
    }
    return _humidArr;
}

- (NSMutableArray *)vocArr
{
    if (!_vocArr) {
        _vocArr = [NSMutableArray array];
    }
    return _vocArr;
}
- (NSMutableArray *)totalArr
{
    if (!_totalArr) {
        _totalArr = [NSMutableArray array];
    }
    return _totalArr;
}
- (NSMutableArray *)pmArr
{
    if (!_pmArr) {
        _pmArr = [NSMutableArray array];
    }
    return _pmArr;
}
- (NSMutableArray *)updataArr
{
    if (!_updataArr) {
        _updataArr = [NSMutableArray array];
    }
    return _updataArr;
}

- (void)setDeviceModel:(DeviceListModel *)deviceModel
{
    _deviceModel = deviceModel;
    self.mid = deviceModel.did;
    DDLogInfo(@"%@", self.mid);
}

/// 加载表格
- (void)addChart
{
    UUChart *chart = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(-10, CGRectGetMaxY(_circularImageView.frame) + 57.5, UIScreenW, UIScreenH - (CGRectGetMaxY(_circularImageView.frame) + 57.5) - 70 - 49.5 + 20)
                                                    withSource:self
                                                     withStyle:UUChartLineStyle];
    chart.backgroundColor = [UIColor clearColor];
    [chart showInView:self.view];
    self.chartView = chart;
    self.currentChartView = self.chartView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认点击PM按钮
    [self buttonClick:_PMButton];
    //隐藏底部条
    [self IsTabBarHidden:YES];
    
    
    //添加线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_chartView.frame) - 15, self.view.frame.size.width - 10, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self setUpBackGroungImage];
}
- (void)setUpBackGroungImage
{
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImgView.image = [UIImage imageNamed:@"1.jpg"];
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
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self IsTabBarHidden:NO];
}
#pragma mark - UI事件
//tag = 1是第1按钮 2是第2按钮 3是第3按钮 4是第4按钮
- (IBAction)buttonClick:(UIButton *)sender {
    self.currentButton.selected = NO;
    sender.selected = YES;
    self.currentButton = sender;
    if (sender.tag == 1) {//pm
        self.companyLabel.text = @"ug/m³";
        [self.currentChartView removeFromSuperview];
        [self addChart];
    }else if (sender.tag == 2)//voc
    {
        self.companyLabel.text = @"";
        [self.currentChartView removeFromSuperview];
        [self addChart];
    }else if (sender.tag == 3)//湿度
    {
        self.companyLabel.text = @"%";
        self.levelLabel.text = @"";
        [self.currentChartView removeFromSuperview];
        [self addChart];
    }else if (sender.tag == 4)//温度
    {
        self.companyLabel.text = @"℃";
        self.levelLabel.text = @"";
        [self.currentChartView removeFromSuperview];
        [self addChart];
        
    }
    
    DDLogWarn(@"%ld", (long)sender.tag);
}
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)refreshButtonClick:(UIButton *)sender {
    
    //HTTP请求
    if (self.currentButton.tag == 1) {
        [self getHttpPMRequste];
    }else if (self.currentButton.tag == 2) {
        [self getHttpVOCRequste];
    }else{
        [self getHttpHumTempRequste];
    }
    
}

#pragma mark - HTTP网络加载数据 -- 温湿度
///网络加载数据
- (void)getHttpHumTempRequste
{
    
    
    __weak typeof (self) weakSelf = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mid"] = self.mid;
    [HRHTTPTool hr_getHttpWithURL:HRAPI_TempHumid_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        [weakSelf.totalArr removeAllObjects];
        [weakSelf.tempArr removeAllObjects];
        [weakSelf.humidArr removeAllObjects];
        [weakSelf.updataArr removeAllObjects];
        NSArray *responseArr = (NSArray*)responseObject;
        
        /**
         * 创建温度、湿度、时间 空数组
         */
        //把模型数组添加到对应的空数组中
        for ( NSDictionary *dic in responseArr) {
            
            HRTotalData *totalData = [HRTotalData totalDataWithDict: dic];
            
            [weakSelf.totalArr addObject: totalData];
            
            [weakSelf.tempArr addObject: totalData.parameter.firstObject];
            
            [weakSelf.humidArr addObject: totalData.parameter.lastObject];
            
            //时间字符串截取
            NSString *update = [totalData.update substringWithRange:NSMakeRange(11, 5)];
            [weakSelf.updataArr addObject:update];
            
            [kUserDefault setObject:totalData.types forKey:kdefaultsHumitureType];
            [kUserDefault synchronize];
        }
        //服务器给 的数据 顺序不对  要反过来
        weakSelf.totalArr = (NSMutableArray *)[[weakSelf.totalArr reverseObjectEnumerator] allObjects];
        weakSelf.tempArr = (NSMutableArray *)[[weakSelf.tempArr reverseObjectEnumerator] allObjects];
        weakSelf.humidArr = (NSMutableArray *)[[weakSelf.humidArr reverseObjectEnumerator] allObjects];
        weakSelf.updataArr = (NSMutableArray *)[[weakSelf.updataArr reverseObjectEnumerator] allObjects];
        
        [weakSelf.view setNeedsDisplay];
        
        
        /// 在网络请求到数据之后再创建一个表格
        
        [weakSelf.currentChartView removeFromSuperview];
        [weakSelf addChart];
        
        ///	数据存储在FMDB第三方框架中
        //		[SqliteTools addTempHumidWithArray:weakSelf.tempHumidArr];
        [HRSqlite addTempHumidWithArray:weakSelf.totalArr];
        
    }];
    
}

#pragma mark - HTTP网络加载数据 -- VOC
///网络加载数据
- (void)getHttpVOCRequste
{
    __weak typeof (self) weakSelf = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mid"] = self.mid;
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiVOC_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        
        [weakSelf.totalArr removeAllObjects];
        [weakSelf.vocArr removeAllObjects];
        [weakSelf.updataArr removeAllObjects];
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        
        NSArray *responseArr = (NSArray*)responseObject;
        
        //把模型数组添加到对应的空数组中
        for ( NSDictionary *dic in responseArr) {
            
            HRTotalData *totalData = [HRTotalData totalDataWithDict: dic];
            
            [weakSelf.totalArr addObject: totalData];
            
            [weakSelf.vocArr addObject: totalData.parameter.firstObject];
            
            //时间字符串截取
            NSString *update = [totalData.update substringWithRange:NSMakeRange(11, 5)];
            [weakSelf.updataArr addObject:update];
            
            [kUserDefault setObject:totalData.types forKey:kdefaultsVocType];
            [kUserDefault synchronize];
        }
        
        //服务器给 的数据 顺序不对  要反过来
        weakSelf.totalArr = (NSMutableArray *)[[weakSelf.totalArr reverseObjectEnumerator] allObjects];
        weakSelf.vocArr = (NSMutableArray *)[[weakSelf.vocArr reverseObjectEnumerator] allObjects];
        weakSelf.updataArr = (NSMutableArray *)[[weakSelf.updataArr reverseObjectEnumerator] allObjects];
        
        [weakSelf.view setNeedsDisplay];
        
        /// 判断vocStateView text的文字是什么
        [weakSelf getVocStateViewWithVocArrLastObject:[self.vocArr.lastObject intValue]];
        
        
        self.numberLabel.text = self.vocArr.lastObject;
        [weakSelf.currentChartView removeFromSuperview];
        [weakSelf addChart];
        
        ///	数据存储在FMDB第三方框架中
        [HRSqlite addTempHumidWithArray:weakSelf.totalArr];

    }];
    
}
/// 判断vocStateView text的文字是什么
- (void)getVocStateViewWithVocArrLastObject:(int)lastObject
{
    if (lastObject == 0) {
        self.levelLabel.text = @"优";
    }else if (lastObject == 1) {
        self.levelLabel.text = @"良";
    }else if (lastObject == 2) {
        self.levelLabel.text = @"中";
    }else if (lastObject == 3) {
        self.levelLabel.text = @"差";
    }
}
#pragma mark - HTTP网络加载数据 --PM
///网络加载数据
- (void)getHttpPMRequste
{
    __weak typeof (self) weakSelf = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mid"] = self.mid;
    DDLogWarn(@"PM2.5--mid:%@", self.mid);
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiPm2_5_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            return;
        }
        
        [weakSelf.totalArr removeAllObjects];
        [weakSelf.pmArr removeAllObjects];
        [weakSelf.updataArr removeAllObjects];
        NSArray *responseArr = (NSArray*)responseObject;
        
        //把模型数组添加到对应的空数组中
        for (NSDictionary *dic in responseArr) {
            
            HRTotalData *totalData = [HRTotalData totalDataWithDict: dic];
            
            [weakSelf.totalArr addObject: totalData];
            
            [weakSelf.pmArr addObject: totalData.parameter.firstObject];
            
            //时间字符串截取
            NSString *update = [totalData.update substringWithRange:NSMakeRange(11, 5)];
            [weakSelf.updataArr addObject:update];
            [kUserDefault setObject:totalData.types forKey:kdefaultsPm2_5Type];
            [kUserDefault synchronize];
            
        }
        
        //服务器给 的数据 顺序不对  要反过来
        weakSelf.totalArr = (NSMutableArray *)[[weakSelf.totalArr reverseObjectEnumerator] allObjects];
        weakSelf.pmArr = (NSMutableArray *)[[weakSelf.pmArr reverseObjectEnumerator] allObjects];
        weakSelf.updataArr = (NSMutableArray *)[[weakSelf.updataArr reverseObjectEnumerator] allObjects];
        
        [weakSelf.view setNeedsDisplay];
        
        DDLogDebug(@"%@", weakSelf.pmArr.lastObject);
        weakSelf.numberLabel.text = weakSelf.pmArr.lastObject;
        [weakSelf.currentChartView removeFromSuperview];
        [weakSelf addChart];
        ///	数据存储在FMDB第三方框架中
        [HRSqlite addTempHumidWithArray:weakSelf.totalArr];
        
    }];
    
}
#pragma mark - 从数据库中取数据

/// 从数据库中取温湿度数据
- (void)getDataWithHumTempSqlite
{
    [self.tempArr removeAllObjects];
    [self.humidArr removeAllObjects];
    [self.updataArr removeAllObjects];
    [self.totalArr removeAllObjects];
    
    NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
    NSString *mid = [kUserDefault objectForKey:kdefaultsIracMid];
    NSString *type = [kUserDefault objectForKey:kdefaultsHumitureType];
    [self.totalArr addObjectsFromArray:[HRSqlite tempHumidBackWithUid:uid mid:mid type:type]];
    
    if (self.totalArr.count > 0) {
        for (HRTotalData *model in self.totalArr) {
            [self.tempArr addObject:model.parameter.firstObject];
            [self.humidArr addObject:model.parameter.lastObject];
            NSString *update = [model.update substringWithRange:NSMakeRange(11, 5)];
            [self.updataArr addObject:update];
        }
        
    }
    
    if (self.tempArr.count < 1) {//如果数据库中没有值,就去请求数据
        [self getHttpHumTempRequste];
    }
}

/// 从数据库中取VOC数据
- (void)getDataWithVOCSqlite
{
    [self.vocArr removeAllObjects];
    [self.updataArr removeAllObjects];
    [self.totalArr removeAllObjects];
    
    NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
    NSString *mid = self.mid;
    NSString *type = [kUserDefault objectForKey:kdefaultsVocType];
    [self.totalArr addObjectsFromArray:[HRSqlite tempHumidBackWithUid:uid mid:mid type:type]];
    
    if (self.totalArr.count > 0) {
        for (HRTotalData *model in self.totalArr) {
            [self.vocArr addObject:model.parameter.firstObject];
            NSString *update = [model.update substringWithRange:NSMakeRange(11, 5)];
            [self.updataArr addObject:update];
        }
        self.numberLabel.text = self.vocArr.lastObject;
        /// 判断vocStateView text的文字是什么
        [self getVocStateViewWithVocArrLastObject:[self.vocArr.lastObject intValue]];
        
    }
    
    if (self.vocArr.count < 1) {//如果数据库中没有值,就去请求数据
        [self getHttpVOCRequste];
    }
}

/// 从数据库中取PM数据
- (void)getDataWithPMSqlite
{
    [self.pmArr removeAllObjects];
    [self.updataArr removeAllObjects];
    [self.totalArr removeAllObjects];
    
    NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
    NSString *mid = self.mid;
    NSString *type = [kUserDefault objectForKey:kdefaultsPm2_5Type];
    [self.totalArr addObjectsFromArray:[HRSqlite tempHumidBackWithUid:uid mid:mid type:type]];
    
    if (self.totalArr.count > 0) {
        for (HRTotalData *model in self.totalArr) {
            [self.pmArr addObject:model.parameter.firstObject];
            NSString *update = [model.update substringWithRange:NSMakeRange(11, 5)];
            [self.updataArr addObject:update];
        }
        self.numberLabel.text = self.pmArr.lastObject;
        
    }
    if (self.pmArr.count < 1) {//如果数据库中没有值,就去请求数据
        [self getHttpPMRequste];
    }
}
#pragma mark - UUChart 代理
/// 显示x坐标的集合点
-(NSArray *)UUChart_xLableArray:(UUChart *)chart {
    
    DDLogDebug(@"--------------------x1--------------");
    return self.updataArr;
}
/// 显示y坐标的集合点
-(NSArray *)UUChart_yValueArray:(UUChart *)chart {
    DDLogDebug(@"--------------------y2--------------");
    
    NSMutableArray *mu = [NSMutableArray array];
    if (self.currentButton.tag == 1) {//pm
        
        mu = self.pmArr;
        
    }else if (self.currentButton.tag == 2)//voc
    {
        mu = self.vocArr;
    }else if (self.currentButton.tag == 3)//湿度
    {
        mu = self.humidArr;
        
    }else//温度
    {
        mu = self.tempArr;
    }
    
    return @[mu];
}
/// 显示颜色的集合 --刚进来这个界面,先走这个方法
-(NSArray *)UUChart_ColorArray:(UUChart *)chart {
    DDLogDebug(@"--------------------Color3--------------");
    
    static UIColor *color ;
    
    if (self.currentButton.tag == 1) {//pm
        
        color = [self uuchartColorWithPM];
        
    }else if (self.currentButton.tag == 2)//voc
    {
        
        color = [self uuchartColorWithVOC];
        
    }else if (self.currentButton.tag == 3)//湿度
    {
        color = [self uuchartColorWithHum];

    }else if (self.currentButton.tag == 4)//温度
    {
        
        color = [self uuchartColorWithTemp];
    }
    
    return @[color];
}

//温度颜色
- (UIColor *)uuchartColorWithTemp
{
    
    UIColor *color  = [UIColor colorWithHex:0xFE9600];
    if (self.tempArr.count > 0) {
        
    }else{
        /// 从数据库中取数据
        [self getDataWithHumTempSqlite];
        
    }
    
    self.numberLabel.text = self.tempArr.lastObject;
    return color;
    
}

//湿度颜色
- (UIColor *)uuchartColorWithHum
{
    
    UIColor *color  = [UIColor colorWithHex:0x6F67E0];
    if (self.tempArr.count > 0) {
        
    }else{
        /// 从数据库中取数据
        [self getDataWithHumTempSqlite];
        
    }
    
    self.numberLabel.text = self.humidArr.lastObject;
    return color;
    
}

- (UIColor *)uuchartColorWithVOC
{
    
    UIColor *color ;
    if (self.vocArr.count > 0) {
        /// 传一个数组的最后一个元素 判断 比较  返回一个颜色
        color = [self getChartColorWithVocArrayLastObject:[self.vocArr.lastObject intValue] * 51];
        
    }else{
        /// 从数据库中取数据
        [self getDataWithVOCSqlite];
        
        /// 传一个数组的最后一个元素 判断 比较  返回一个颜色
        color = [self getChartColorWithVocArrayLastObject:[self.vocArr.lastObject intValue] * 51];
    }
    self.numberLabel.text = self.vocArr.lastObject;
    return color;

}
/// 传一个数组的最后一个元素 判断 比较  返回一个颜色
- (UIColor *)getChartColorWithVocArrayLastObject:(int)lastObject
{
    UIColor *color;
    if (lastObject > 150) {
        color = [UIColor colorWithString:@"#d67c2d"];
        self.levelLabel.text = @"差";
    }else if (lastObject > 100) {
        color = [UIColor colorWithString:@"#eb5858"];
        self.levelLabel.text = @"中";
    }else if (lastObject > 50) {
        color = [UIColor colorWithString:@"#c2c20b"];
        self.levelLabel.text = @"良";
    }else if (lastObject >= 0) {
        color = [UIColor colorWithString:@"#48c435"];
        self.levelLabel.text = @"优";
    }
    self.levelLabel.textColor = color;
    return color;
}

- (UIColor *)uuchartColorWithPM
{
    UIColor *color ;
    if (self.pmArr.count > 0) {
        
        
        int index = [self.pmArr.lastObject intValue];
        /// 传一个数组的最后一个元素 判断 比较  返回一个颜色
        color = [self getChartColorWithPMArrayLastObject:index];
        
    }else{
        
        [self getDataWithPMSqlite];
        
        /// 传一个数组的最后一个元素 判断 比较  返回一个颜色
        color = [self getChartColorWithPMArrayLastObject:[self.pmArr.lastObject intValue]];
    }
    self.numberLabel.text = self.pmArr.lastObject;
    return color;
}
/// 传一个数组的最后一个元素 判断 比较  返回一个颜色
- (UIColor *)getChartColorWithPMArrayLastObject:(int)lastObject
{
    UIColor *color;
    if (lastObject > 300) {
        color = [UIColor colorWithString:@"#800080"];
        self.levelLabel.text = @"严重污染";
    }else if (lastObject > 200) {
        color = [UIColor colorWithString:@"#ba0d0d"];
        self.levelLabel.text = @"重度污染";
    }else if (lastObject > 150) {
        color = [UIColor colorWithString:@"#d67c2d"];
        self.levelLabel.text = @"中度污染";
    }else if (lastObject > 100) {
        color = [UIColor colorWithString:@"#eb5858"];
        self.levelLabel.text = @"轻度污染";
    }else if (lastObject > 50) {
        color = [UIColor colorWithString:@"#c2c20b"];
        self.levelLabel.text = @"良";
    }else if (lastObject >= 0) {
        color = [UIColor colorWithString:@"#48c435"];
        self.levelLabel.text = @"优";
    }
    self.levelLabel.textColor = color;
    return color;
}

-(BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    
    return NO;
}
/// 显示Y坐标轴的范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(500, 0);
}
/// 显示y的最大值最小两个值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
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
