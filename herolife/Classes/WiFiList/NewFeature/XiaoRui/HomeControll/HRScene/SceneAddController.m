//
//  SceneAddController.m
//  herolife
//
//  Created by sswukang on 2016/12/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneAddController.h"

#import "AppDelegate.h"
#import "HRDOData.h"
#import "IracData.h"
#import "IrgmData.h"
#import "HRSceneData.h"
#import "SceneAddCell.h"

@interface SceneAddController ()<UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;
/** <#name#> */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 全选按钮 */
@property(nonatomic, weak) UIButton *allSelectButton;
/** 反选按钮 */
@property(nonatomic, weak) UIButton *reverseSelectButton;
/** 中间的条 */
@property(nonatomic, weak) UIView *middleBar;
/** <#name#> */
@property(nonatomic, weak) UIButton *fistButton;
/** <#name#> */
@property(nonatomic, weak) UIButton *secondButton;
/** <#name#> */
@property(nonatomic, weak) UIButton *threeButton;
/** <#name#> */
@property(nonatomic, weak) UIButton *fourButton;
/** 下划线 */
@property(nonatomic, weak) UIView *underLine;
/** 记录当前选中的按钮 */
@property(nonatomic, weak) UIButton *currentButton;
/** <#name#> */
@property(nonatomic, weak) UIView *tabBarView;
/** <#name#> */
@property(nonatomic, weak) UIView *lineBarView;
/** <#name#> */
@property(nonatomic, weak) UIButton *cancelButton;
/** <#name#> */
@property(nonatomic, weak) UIButton *completeButton;
/** <#name#> */
@property(nonatomic, weak) UIScrollView *scrollView;

/** UITableView */
@property(nonatomic, weak) UITableView *doTableView ;
@property(nonatomic, weak) UITableView *currencyTableView ;
@property(nonatomic, weak) UITableView *airTableView;
@property(nonatomic, weak) UITableView *tvTableView ;
/** UITableView */
@property(nonatomic, weak) UITableView *currentTableView;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *doArray;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *currencyArray;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *airArray;
/** NSMutableArray */
@property(nonatomic, strong) NSMutableArray *tvArray;

/** -------------------------------保存打钩数据 -------------------*/
/** 保存打钩开关数据 */
@property(nonatomic, strong) NSMutableArray *doSaveArray;
/** 保存打钩通用数据 */
@property(nonatomic, strong) NSMutableArray *currencySaveArray;
/** 保存打钩空调数据 */
@property(nonatomic, strong) NSMutableArray *airSaveArray;
/** 保存打钩电视数据 */
@property(nonatomic, strong) NSMutableArray *tvSaveArray;
/** cell上自定义UILabel */
@property(nonatomic, weak) UILabel *currencyLabel;
/** cell上自定义UILabel */
@property(nonatomic, weak) UILabel *airLabel;
/** cell上自定义UILabel */
@property(nonatomic, weak) UILabel *tvLabel;
/* */
@property(nonatomic, assign) CGFloat airButtonX;
/** <#是否连接#> */
@property(nonatomic, assign) BOOL isCenter;

@end

@implementation SceneAddController

static NSString *cellID = @"cell";
#pragma mark - 懒加载
- (NSMutableArray *)doArray
{
    if (!_doArray) {
        _doArray = [NSMutableArray array];
    }
    return _doArray;
}
- (NSMutableArray *)currencyArray
{
    if (_currencyArray == nil) {
        _currencyArray = [NSMutableArray array];
    }
    return _currencyArray;
}

- (NSMutableArray *)airArray
{
    if (_airArray == nil) {
        _airArray = [NSMutableArray array];
    }
    return _airArray;
}
- (NSMutableArray *)tvArray
{
    if (_tvArray == nil) {
        _tvArray = [NSMutableArray array];
    }
    return _tvArray;
}

//保存打钩数据
- (NSMutableArray *)doSaveArray
{
    if (!_doSaveArray) {
        _doSaveArray = [NSMutableArray array];
        
    }
    return _doSaveArray;
}
- (NSMutableArray *)currencySaveArray
{
    if (!_currencySaveArray) {
        _currencySaveArray = [NSMutableArray array];
    }
    return _currencySaveArray;
}
- (NSMutableArray *)airSaveArray
{
    if (!_airSaveArray) {
        _airSaveArray = [NSMutableArray array];
    }
    return _airSaveArray;
}

- (NSMutableArray *)tvSaveArray
{
    if (!_tvSaveArray) {
        _tvSaveArray = [NSMutableArray array];
    }
    return _tvSaveArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    //拿到单例数据
    [self getHomeHTTPRequest];
    isSelectAll = NO;
    isReverseSelectAll = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isSelectAll = NO;
    isReverseSelectAll = NO;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.reverseSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.centerY.equalTo(self.navView);
        make.height.equalTo(self.navView);
        make.width.equalTo(self.reverseSelectButton.mas_height);
    }];
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.reverseSelectButton.mas_left);
        make.centerY.equalTo(self.navView);
        make.height.equalTo(self.reverseSelectButton);
        make.width.equalTo(self.allSelectButton.mas_height);
    }];
    
    //按钮
    [self.fistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleBar);
        make.top.bottom.equalTo(self.middleBar);
        make.width.mas_equalTo(UIScreenW / 4);
    }];
    
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.middleBar);
        make.left.equalTo(self.fistButton.mas_right);
        make.width.equalTo(self.fistButton);
    }];
    
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.middleBar);
        make.left.equalTo(self.secondButton.mas_right);
        make.width.equalTo(self.fistButton);
    }];
    
    [self.fourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.middleBar);
        make.left.equalTo(self.threeButton.mas_right);
        make.width.equalTo(self.fistButton);
    }];
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fistButton);
        make.centerX.equalTo(self.fistButton);
        make.height.mas_equalTo(1);
        make.width.equalTo(self.fistButton);
    }];
    
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.middleBar.mas_bottom);
//        make.bottom.equalTo(self.view).offset(- 49);
//        make.right.left.equalTo(self.view);
//    }];
//    
//    CGSize size = self.scrollView.contentSize;
//    size.width = UIScreenW *4;
//    self.scrollView.contentSize = size;
//    
//    [self.doTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.scrollView);
//        make.left.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView);
//    }];
//    
//    [self.currencyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.doTableView);
//        make.bottom.equalTo(self.doTableView);
//        make.left.equalTo(self.doTableView.mas_right);
//        make.width.equalTo(self.doTableView);
//    }];
//    
//    [self.airTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.doTableView);
//        make.bottom.equalTo(self.doTableView);
//        make.left.equalTo(self.currencyTableView.mas_right);
//        make.width.equalTo(self.doTableView);
//    }];
//    
//    [self.tvTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.doTableView);
//        make.bottom.equalTo(self.doTableView);
//        make.left.equalTo(self.airTableView.mas_right);
//        make.width.equalTo(self.doTableView);
//    }];
//    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.tabBarView);
        make.left.equalTo(self.tabBarView);
        make.width.mas_equalTo(UIScreenW / 2);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.tabBarView);
        make.right.equalTo(self.tabBarView);
        make.width.equalTo(self.cancelButton);
    }];
    [self.lineBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView);
        make.left.right.equalTo(self.tabBarView);
        make.height.mas_equalTo(1);
    }];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DDLogWarn(@"NSStringFromCGRectdoTableView---%@scrollView%@", NSStringFromCGRect(self.doTableView.frame), NSStringFromCGRect(self.scrollView.frame));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DDLogWarn(@"NSStringFromCGRectdoTableView---%@scrollView%@", NSStringFromCGRect(self.doTableView.frame), NSStringFromCGRect(self.scrollView.frame));
    });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        self.backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backgroundImage.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backgroundImage.image =[UIImage imageNamed:imgName];
    }
    
    
}
- (void)setUpViews
{
    self.navigationController.navigationBar.hidden = YES;
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:backgroundImage];
    self.backgroundImage = backgroundImage;
    
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = @"添加设备";
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [self.view addSubview:navView];
    self.navView = navView;
    //全选按钮
    UIButton *allSelectButton = [self setUpNavBarButtonWithTag:1 title:@"全选"] ;
    self.allSelectButton = allSelectButton;
    //反选按钮
    UIButton *reverseSelectButton = [self setUpNavBarButtonWithTag:2 title:@"反选"];
    self.reverseSelectButton = reverseSelectButton;
    
    //中间的条
    UIView *middleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UIScreenW, 44)];
    middleBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:middleBar];
    self.middleBar = middleBar;
    
    UIButton *fistButton = [self addButtonWithTag:1 title:@"智能设备"];
    UIButton *secondButton = [self addButtonWithTag:2 title:@"通用红外"];
    UIButton *threeButton = [self addButtonWithTag:3 title:@"空调"];
    UIButton *fourButton = [self addButtonWithTag:4 title:@"电视"];
    self.fistButton = fistButton;
    self.secondButton = secondButton;
    self.threeButton = threeButton;
    self.fourButton = fourButton;
    
    //
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 44, UIScreenW, UIScreenH - 49 - 64 - 44)];
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    self.scrollView.delegate = self;
    self.scrollView.tag = 10;
    
    CGSize size = self.scrollView.contentSize;
    size.width = UIScreenW *4;
    self.scrollView.contentSize = size;
    
    
    //开关tableView
    UITableView *doTableView = [self addTableViewWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH - 49 - 64 - 44) tag:0];
    self.doTableView = doTableView;
    DDLogInfo(@"---frame%@",NSStringFromCGRect(self.scrollView.frame));
    //通用tableView
    CGRect currencyRect = self.scrollView.frame;
    currencyRect.origin.x = self.scrollView.hr_width;
    currencyRect.origin.y = 0;
    UITableView *currencyTableView = [self addTableViewWithFrame:currencyRect tag:1];
    self.currencyTableView = currencyTableView;
    //空调tableView
    currencyRect.origin.x = self.scrollView.hr_width *2;
    UITableView *airTableView = [self addTableViewWithFrame:currencyRect tag:2];
    
    self.airTableView = airTableView;
    //电视tableView
    currencyRect.origin.x = self.scrollView.hr_width *3;
    UITableView *tvTableView = [self addTableViewWithFrame:currencyRect tag:3];
    self.tvTableView = tvTableView;
    
    // 下划线
    UIView *underLine = [[UIView alloc] init];
    underLine.backgroundColor = [UIColor orangeColor];
    [middleBar addSubview:underLine];
    self.underLine = underLine;
    [self buttonClick:self.fistButton];
    
    //底部条
    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenH - 49, UIScreenW, 49)];
    tabBarView.backgroundColor = self.middleBar.backgroundColor;
    [self.view addSubview:tabBarView];
    self.tabBarView = tabBarView;
    
    // 添加导航条灰线
    UIView *lineBarView = [[UIView alloc] init];
    lineBarView.backgroundColor = [UIColor blackColor];
    [self.tabBarView addSubview:lineBarView];
    self.lineBarView = lineBarView;
    
    //往导航条取消按钮
    UIButton *cancelButton = [self setUpNavBarButtonWithTag:3 title:@"取消"];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.cancelButton = cancelButton;
    
    //往导航条完成按钮
    UIButton *completeButton = [self setUpNavBarButtonWithTag:4 title:@"完成"];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.completeButton = completeButton;
    
    self.currentTableView = self.doTableView;
    self.isCenter = NO;
    //注册
    [self.tvTableView registerNib:[UINib nibWithNibName:@"SceneAddCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.doTableView registerNib:[UINib nibWithNibName:@"SceneAddCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.currencyTableView registerNib:[UINib nibWithNibName:@"SceneAddCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.airTableView registerNib:[UINib nibWithNibName:@"SceneAddCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}
- (UIButton *)setUpNavBarButtonWithTag:(NSInteger)tag title:(NSString *)title
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(allSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]  forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = [UIColor clearColor];
    if (tag == 1 || tag == 2) {
        
        [self.navView addSubview:button];
    }else
    {
        [self.tabBarView addSubview:button];
    }
    return button;
}

- (UIButton *)addButtonWithTag:(NSInteger)tag title:(NSString *)title
{
    
    HRCommonButton *button = [HRCommonButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = tag;
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleBar addSubview:button];
    return button;
}

/**
 *  创建tableview
 *
 *  @param frame frame
 *  @param tag   tag
 *
 *  @return tableview
 */
- (UITableView *)addTableViewWithFrame:(CGRect)frame tag:(NSInteger)tag
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tag = tag;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(37, 0, 0, 0);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:tableView];
    return tableView;
}
- (void)dealloc
{
    [kNotification removeObserver:self];
}
#pragma mark - UI事件
- (void)buttonClick:(UIButton *)button
{
    self.currentButton.selected = NO;
    button.selected = !button.selected;
    self.currentButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underLine.hr_centerX = button.centerX;
    }];
    
    [self setUpDeviceBtn:button];
}

- (void)setUpDeviceBtn:(UIButton *)btn
{
    
    
    NSInteger index = btn.tag - 1;
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index * self.scrollView.hr_width;
    
    //记录当前的tableview
    if (offset.x == self.doTableView.hr_x) {
        self.currentTableView = self.doTableView;
    }else if (offset.x == self.currencyTableView.hr_x)
    {
        self.currentTableView = self.currencyTableView;
    }else if (offset.x == self.airTableView.hr_x)
    {
        self.currentTableView = self.airTableView;
    }else if (offset.x == self.tvTableView.hr_x)
    {
        self.currentTableView = self.tvTableView;
    }
    [self.scrollView setContentOffset:offset animated:YES];
    
}

static BOOL isSelectAll  = NO;
static BOOL isReverseSelectAll  = NO;
- (void)allSelectButtonClick:(UIButton *)button
{
    if (button.tag == 1) {//全选
        [self selectAllData];
    }else if (button.tag == 2) {//反选
        [self reverseAllData];
    }else if (button.tag == 3) {//取消
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [kNotification postNotificationName:kNotificationSceneIsNoSaveButtonClick object:nil];
        
    }else if (button.tag == 4) {//完成
        isSelectAll = NO;
        if (self.tableViewBlock) {
            self.tableViewBlock(self.doSaveArray,self.currencySaveArray,self.airSaveArray,self.tvSaveArray);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
///自定义代理
- (void)sceneModellViewSendTableViewWithBlock:(blockSceneTabelView)block
{
    self.tableViewBlock = block;
}
- (void)reverseAllData
{
    isReverseSelectAll = YES;
    isSelectAll  = NO;
    
    if ([self.currentTableView isEqual:self.doTableView]) {//开关
        [self.doTableView reloadData];
        //先删除,再添加全部
        [self.doSaveArray removeAllObjects];
        
        
    }else if ([self.currentTableView isEqual:self.currencyTableView]) {//通用
        //先删除,再添加全部
        [self.currencyTableView reloadData];
        [self.currencySaveArray removeAllObjects];
        
        
    }else if ([self.currentTableView isEqual:self.airTableView]) {//空调
        //先删除,再添加全部
        [self.airTableView reloadData];
        [self.airSaveArray removeAllObjects];
        
    }else if ([self.currentTableView isEqual:self.tvTableView]) {//电视
        //先删除,再添加全部
        [self.tvTableView reloadData];
        [self.tvSaveArray removeAllObjects];
        
    }

}
- (void)selectAllData
{
    
    isSelectAll  = YES;
    isReverseSelectAll  = NO;
    if ([self.currentTableView isEqual:self.doTableView]) {//开关
        [self.doTableView reloadData];
        //先删除,再添加全部
        [self.doSaveArray removeAllObjects];
        NSMutableArray *mb = [NSMutableArray array];
        for (id objec in self.doArray) {
            [mb addObject:objec];
        }
        self.doSaveArray = mb;
        
        
    }else if ([self.currentTableView isEqual:self.currencyTableView]) {//通用
        //先删除,再添加全部
        [self.currencyTableView reloadData];
        [self.currencySaveArray removeAllObjects];
        NSMutableArray *mb = [NSMutableArray array];
        for (id objec in self.currencyArray) {
            [mb addObject:objec];
        }
        self.currencySaveArray = mb;
        
        
    }else if ([self.currentTableView isEqual:self.airTableView]) {//空调
        //先删除,再添加全部
        [self.airSaveArray removeAllObjects];
        for (IracData *data in self.airArray) {
            data.version = @"-1";
            [self.airSaveArray addObject:data];
        }
        [self.airTableView reloadData];
        
    }else if ([self.currentTableView isEqual:self.tvTableView]) {//电视
        //先删除,再添加全部
        [self.tvTableView reloadData];
        [self.tvSaveArray removeAllObjects];
        
        for (id objec in self.tvArray) {
            [self.tvSaveArray addObject:objec];
        }
    }
    
}

#pragma mark - HTTP数据
- (void)getHomeHTTPRequest
{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.doArray removeAllObjects];
    [self.airArray removeAllObjects];
    [self.currencyArray removeAllObjects];
    [self.tvArray removeAllObjects];
    
    //添加空调
    NSMutableArray *iracArr = app.iracArray;
    for (IracData *data in iracArr) {
        
        data.version = @"-1";
        [self.airArray addObject:data];
    }
    //添加通用
    NSMutableArray *irgmArray = app.irgmArray;
    
    for (IrgmData *data in irgmArray) {
        if ([data.picture.firstObject isEqualToString:@"1"]) {//电视
            [self.tvArray addObject:data];
        }else if ([data.picture.firstObject isEqualToString:@"2"])//通用
        {
            [self.currencyArray addObject:data];
        }
    }
    //添加开关
    NSMutableArray *doArray = app.doArray;
    for (HRDOData *data in doArray) {
        //拆开 开关  每一路添加
        [self addDoDataArrayWithFirstObject:data];
    }
    
    [self.tvTableView reloadData];
    [self.doTableView reloadData];
    [self.airTableView reloadData];
    [self.currencyTableView reloadData];
    
    
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
        [self.doArray addObject:doData];
        
    }else if ([doData.parameter.firstObject isEqualToString:@"2"])
    {
        DDLogError(@"2%@", data.parameter.firstObject);
        //添加第一路
        HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *data1Arr = newData.parameter;
        NSArray *parameter1Arr1 = @[@"1", data1Arr[2], data1Arr[3]];
        newData.parameter = parameter1Arr1;
        [self.doArray addObject:newData];
        DDLogInfo(@"dataArr23%@ %@", data1Arr[2],data1Arr[3]);
        //添加第二路
        HRDOData *newData2 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr2 = [newData2 valueForKeyPath:@"parameter"];
        NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
        DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
        //把前面值的覆盖了
        [newData2 setValue:parameterArr2 forKeyPath:@"parameter"];
        [self.doArray addObject:newData2];
    }else if ([data.parameter.firstObject isEqualToString:@"3"])
    {
        DDLogError(@"3%@", data.parameter.firstObject);
        //添加第一路
        HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr = newData.parameter;
        NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
        newData.parameter = parameterArr1;
        [self.doArray addObject:newData];
        
        //添加第二路
        HRDOData *doData2 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr2 = [doData2 valueForKeyPath:@"parameter"];
        NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
        DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
        //把前面值的覆盖了
        [doData2 setValue:parameterArr2 forKeyPath:@"parameter"];
        [self.doArray addObject:doData2];
        
        //添加第三路
        HRDOData *doData3 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr3 = [doData3 valueForKeyPath:@"parameter"];
        NSArray *parameterArr3 = @[@"3", dataArr3[6], dataArr3[7]];
        //把前面值的覆盖了
        [doData3 setValue:parameterArr3 forKeyPath:@"parameter"];
        [self.doArray addObject:doData3];
        
    }else if ([data.parameter.firstObject isEqualToString:@"4"])
    {
        //添加第一路
        HRDOData *newData = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr = newData.parameter;
        NSArray *parameterArr1 = @[@"1", dataArr[2], dataArr[3]];
        newData.parameter = parameterArr1;
        [self.doArray addObject:newData];
        
        //添加第二路
        HRDOData *doData2 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr2 = [doData2 valueForKeyPath:@"parameter"];
        NSArray *parameterArr2 = @[@"2", dataArr2[4], dataArr2[5]];
        DDLogInfo(@"dataArr45%@ %@", dataArr2[4],dataArr2[5]);
        //把前面值的覆盖了
        [doData2 setValue:parameterArr2 forKeyPath:@"parameter"];
        [self.doArray addObject:doData2];
        
        //添加第三路
        HRDOData *doData3 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr3 = [doData3 valueForKeyPath:@"parameter"];
        NSArray *parameterArr3 = @[@"3", dataArr3[6], dataArr3[7]];
        //把前面值的覆盖了
        [doData3 setValue:parameterArr3 forKeyPath:@"parameter"];
        [self.doArray addObject:doData3];
        
        //添加第四路
        HRDOData *doData4 = [HRDOData mj_objectWithKeyValues:dictData];
        NSArray *dataArr4 = [doData4 valueForKeyPath:@"parameter"];
        NSArray *parameterArr4 = @[@"4", dataArr4[8], dataArr4[9]];
        //把前面值的覆盖了
        [doData4 setValue:parameterArr4 forKeyPath:@"parameter"];
        [self.doArray addObject:doData4];
    }
}


#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 0:
            return self.doArray.count;
            break;
        case 1:
            return self.currencyArray.count;
            break;
        case 2:
            return self.airArray.count;
            break;
        case 3:
            return self.tvArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SceneAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (tableView.tag) {
        case 0://开关
        {
            HRDOData *data = [HRDOData mj_objectWithKeyValues:self.doArray[indexPath.row]];
            if ([data.picture.lastObject isEqualToString:@"1"] || [data.picture.lastObject isEqualToString:@"2"] || [data.picture.lastObject isEqualToString:@"4"]) {//开关
//                if ([data.parameter.lastObject isEqualToString:@"0"]) {
//                    cell.imageView.image = [UIImage imageNamed:@"灯泡关"];
//                }else if ([data.parameter.lastObject isEqualToString:@"1"]) {
//                    cell.imageView.image = [UIImage imageNamed:@"灯泡开"];
//                }
                
                cell.leftImagView.image = [UIImage imageNamed:@"灯泡关"];
                
            }else if ([data.picture.lastObject isEqualToString:@"3"] ) {//插座
                
                cell.leftImagView.image = [UIImage imageNamed:@"插座关"];
//                if ([data.parameter.lastObject isEqualToString:@"0"]) {
//                    cell.imageView.image = [UIImage imageNamed:@"插座关"];
//                }else if ([data.parameter.lastObject isEqualToString:@"1"]) {
//                    cell.imageView.image = [UIImage imageNamed:@"插座开"];
//                }
            }else if ([data.picture.lastObject isEqualToString:@"5"]) {// 窗帘
                cell.leftImagView.image = [UIImage imageNamed:@"窗帘"];
            }
            cell.leftLabel.text = data.parameter[1];
            
            if (isSelectAll) {
                cell.selectButton.hidden = NO;
                
            }
            if (isReverseSelectAll) {
                cell.selectButton.hidden = YES;
            }
            
        }
            break;
        case 1://红外
        {
            IrgmData *data = [IrgmData mj_objectWithKeyValues:self.currencyArray[indexPath.row]];
            cell.leftImagView.image = [UIImage imageNamed:@"小睿通用关"];
            cell.leftLabel.text = data.title;
            if (isSelectAll) {
                cell.selectButton.hidden = NO;
            }
            if (isReverseSelectAll) {
                cell.selectButton.hidden = YES;
            }
        }
            break;
        case 2://空调
        {
            IracData *data = [IracData mj_objectWithKeyValues:self.airArray[indexPath.row]];
            cell.leftImagView.image = [UIImage imageNamed:@"空调"];
            cell.leftLabel.text = data.title;
            
            if (isSelectAll) {
                cell.selectButton.hidden = NO;
            }
            if (isReverseSelectAll) {
                cell.selectButton.hidden = YES;
            }
        }
            break;
        case 3:// 电视
        {
            IrgmData *data = [IrgmData mj_objectWithKeyValues:self.tvArray[indexPath.row]];
            cell.leftImagView.image = [UIImage imageNamed:@"电视关"];
            cell.leftLabel.text = data.title;
            cell.selectButton.hidden = YES;
            if (isSelectAll) {
                cell.selectButton.hidden = NO;
            }
            if (isReverseSelectAll) {
                cell.selectButton.hidden = YES;
            }
        }
            break;
            
        default:
            
            break;
    }
    return cell;
}
- (void)setupLabelCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    label.textColor = [UIColor grayColor];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-10);
        make.top.bottom.equalTo(cell.contentView);
        make.width.mas_equalTo(UIScreenW * 0.4);
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self setupAccessoryTypeWithTableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)setupAccessoryTypeWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SceneAddCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (tableView.tag) {
        case 0:
        {
            if (cell.selectButton.isHidden) {
                cell.selectButton.hidden = NO;
                HRDOData *data = self.doArray[indexPath.row];
                [self.doSaveArray addObject:data];
                DDLogInfo(@"doSaveArray1-%@", self.doSaveArray);
                
            }else{
                cell.selectButton.hidden = YES;
                HRDOData *data = self.doArray[indexPath.row];
                
                //把保存数据的数组都取出来,放到一个新数组里
                NSMutableArray *mb = [NSMutableArray array];
                for (HRDOData *saveData in self.doSaveArray) {
                    if ([saveData.did isEqualToString:data.did] && [saveData.parameter[1] isEqualToString:data.parameter[1]]) {
                        continue;
                    }
                    [mb addObject:saveData];
                }
                self.doSaveArray = mb;
                DDLogInfo(@"doSaveArray2-%@", self.doSaveArray);
            }
        }
            break;
        case 1:
        {
            if (cell.selectButton.isHidden) {
                cell.selectButton.hidden = NO;
                IrgmData *data = self.currencyArray[indexPath.row];
                [self.currencySaveArray addObject:data];
                DDLogInfo(@"doSaveArray1-%@", self.doSaveArray);
                
            }else
            {
                cell.selectButton.hidden = YES;
                IrgmData *data = self.currencyArray[indexPath.row];
                //把保存数据的数组都取出来,放到一个新数组里
                NSMutableArray *mb = [NSMutableArray array];
                for (IrgmData *saveData in self.currencySaveArray) {
                    if ([saveData.did isEqualToString:data.did]) {
                        continue;
                    }
                    [mb addObject:saveData];
                }
                self.currencySaveArray = mb;
                
            }
        }
            
            break;
        case 2:
        {
            if (cell.selectButton.isHidden) {
                cell.selectButton.hidden = NO;
                IracData *data = self.airArray[indexPath.row];
                [self.airSaveArray addObject:data];
                
                
            }else
            {
                cell.selectButton.hidden = YES;
               
                IracData *data = self.airArray[indexPath.row];
                //把保存数据的数组都取出来,放到一个新数组里
                NSMutableArray *mb = [NSMutableArray array];
                for (IracData *saveData in self.airSaveArray) {
                    if ([saveData.did isEqualToString:data.did]) {
                        continue;
                    }
                    
                    [mb addObject:saveData];
                }
                self.airSaveArray = mb;
            }
        }
        
            break;
        case 3:
        {
            if (cell.selectButton.isHidden) {
                cell.selectButton.hidden = NO;
                IrgmData *data = self.tvArray[indexPath.row];
                [self.tvSaveArray addObject:data];
                
            }else
            {
                cell.selectButton.hidden = YES;
                IrgmData *data = self.tvArray[indexPath.row];
                //把保存数据的数组都取出来,放到一个新数组里
                NSMutableArray *mb = [NSMutableArray array];
                for (IrgmData *saveData in self.tvSaveArray) {
                    if ([saveData.did isEqualToString:data.did]) {
                        continue;
                    }
                    [mb addObject:saveData];
                }
                self.tvSaveArray = mb;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 10) {
        
        NSInteger index = scrollView.contentOffset.x / scrollView.hr_width;
        
        switch (index) {
            case 0:
                [self buttonClick:self.fistButton];
                break;
            case 1:
                [self buttonClick:self.secondButton];
                break;
            case 2:
                [self buttonClick:self.threeButton];
                break;
            case 3:
                [self buttonClick:self.fourButton];
                break;
                
            default:
                break;
        }
        
    }
}



@end
