//
//  SceneController.m
//  xiaorui
//
//  Created by sswukang on 16/6/28.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneController.h"
#import "SceneHeadCell.h"
#import "SceneNameIconCell.h"
#import "HRSceneData.h"
#import "SceneCell.h"
#import "IracData.h"
#import "IrgmData.h"
#import "ScenePickerView.h"
#import "SceneModellView.h"
#import "SceneAddController.h"
#import "SceneIcomSelectController.h"
#define MAS_SHORTHAND

#define tableViewRowHeight 50
#define tableViewSectionHeaderHeight 50

@interface SceneController ()<UITableViewDelegate,UITableViewDataSource>
/** 头部view */
@property(nonatomic, strong) UIView *headView;
/** UIView */
@property(nonatomic, strong) UIView *backView;
/** UIView */
@property(nonatomic, strong) UIView *shadowView;
/** UIView */
@property(nonatomic, weak) UITableView *sceneTableView;

/** UIImageView */
@property(nonatomic, strong) UIImageView *headImageView;
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;
/** 保存按钮 */
@property(nonatomic, weak) UIButton *saveButton;
/** <#name#> */
@property(nonatomic, weak) HRNavigationBar *navView;
/** 情景view */
@property(nonatomic, weak) UIView *scenceView;

/** 情景view 里的情景label */
@property(nonatomic, weak) UILabel *sceneLabel;
/** 情景view 里的情景sceneField */
@property(nonatomic, weak) UITextField *sceneField;
/** 情景view 里的情景lineView */
@property(nonatomic, weak) UIView *lineView;

/** 情景图标View  */
@property(nonatomic, weak) UIView *scenceIconView;
/** 情景图标View 里的情景label*/
@property(nonatomic, weak) UILabel *sceneIconLabel;
/** 情景图标View 里的情景箭头 */
@property(nonatomic, weak) UIImageView *arrowImageView;
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
/** 记录headView初始fram */
@property(nonatomic, assign) CGRect headViewFram;

/** 记录tableview初始偏移量 */
@property(nonatomic, assign) CGFloat offsetY;
/** 情景图片 */
@property(nonatomic, weak) UIImageView *iconImageView;



/**  */
@property(nonatomic, strong) NSMutableArray *doArray;
@property(nonatomic, strong) NSMutableArray *currencyArray;
@property(nonatomic, strong) NSMutableArray *airArray;
@property(nonatomic, strong) NSMutableArray *tvArray;
/** tablecell的滑块状态数组 */
@property(nonatomic, strong) NSMutableArray *doSwicherArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *doTextArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *currencyTextArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *airTextArray;
/** tablecell的延时时间数组 */
@property(nonatomic, strong) NSMutableArray *tvTextArray;

/** 存放通用picker文字 的数组 */
@property(nonatomic, strong) NSMutableArray *gmPickerArray;
/** 存放电视picker文字 的数组 */
@property(nonatomic, strong) NSMutableArray *tvPickerArray;
/** 存放通用按钮number 的数组 */
@property(nonatomic, strong) NSMutableArray *gmNumberArray;
/** 存放电视按钮number 的数组 */
@property(nonatomic, strong) NSMutableArray *tvNumberArray;
/** 底部窗口view */
@property(nonatomic, weak) UIView *picker;

/** 秒 */
@property(nonatomic, copy) NSString *seconds;
/** 分 */
@property(nonatomic, copy) NSString *everyMinute;


/** 底部条 */
@property(nonatomic, weak) UIView *tabBarView;
/** UIButton */
@property(nonatomic, weak) UIButton *editButton;
/** UIButton */
@property(nonatomic, weak) UIButton *addDeviceButton;
/** UIView */
@property(nonatomic, weak) UIView *lineBarView;
/** UIButton */
@property(nonatomic, weak) UIButton *completeButton;
/** <#name#> */
@property(nonatomic, strong) NSMutableArray *sceneArray;
/** <#是否连接#> */
@property(nonatomic, assign) CGRect completeFram;
/** <#name#> */
@property(nonatomic, strong) NSArray *iconArray;
/** 图片下标 */
@property(nonatomic, copy) NSString *pictureIndex;
/** <#name#> */
@property(nonatomic, strong) AppDelegate *appDelegate;
/**  */
@property(nonatomic, strong) NSTimer *timer;

/***************保存修改情景模式相关数据**************************/
/** 情景名称 */
@property(nonatomic, copy) NSString *sceneName;
/** 保存图片位置 */
@property(nonatomic, assign) NSInteger UpdatePictureIndex;
/** 存放每个section Y值的最大值 */
@property(nonatomic, strong) NSMutableArray *sectionMaxYArray;

/** <#name#> */
@property(nonatomic, weak) UITapGestureRecognizer *tap;
@end

@implementation SceneController
#pragma mark - 懒加载

/**
 *  tabelview 每行显示的内容
 */
- (NSMutableArray *)sectionMaxYArray
{
    if (!_sectionMaxYArray) {
        _sectionMaxYArray = [NSMutableArray array];
    }
    return _sectionMaxYArray;
}
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
- (NSMutableArray *)sceneArray
{
    if (_sceneArray == nil) {
        _sceneArray = [NSMutableArray array];
    }
    return _sceneArray;
}
- (NSMutableArray *)tvNumberArray
{
    if (_tvNumberArray == nil) {
        _tvNumberArray = [NSMutableArray array];
    }
    return _tvNumberArray;
}
- (NSMutableArray *)gmNumberArray
{
    if (_gmNumberArray == nil) {
        _gmNumberArray = [NSMutableArray array];
    }
    return _gmNumberArray;
}
- (NSMutableArray *)tvPickerArray
{
    if (_tvPickerArray == nil) {
        _tvPickerArray = [NSMutableArray array];
    }
    return _tvPickerArray;
}
- (NSMutableArray *)gmPickerArray
{
    if (_gmPickerArray == nil) {
        _gmPickerArray = [NSMutableArray array];
    }
    return _gmPickerArray;
}

- (NSMutableArray *)doTextArray
{
    if (_doTextArray == nil) {
        _doTextArray = [NSMutableArray array];
    }
    return _doTextArray;
}

- (NSMutableArray *)currencyTextArray
{
    if (_currencyTextArray == nil) {
        _currencyTextArray = [NSMutableArray array];
    }
    return _currencyTextArray;
}

- (NSMutableArray *)airTextArray
{
    if (_airTextArray == nil) {
        _airTextArray = [NSMutableArray array];
    }
    return _airTextArray;
}

- (NSMutableArray *)tvTextArray
{
    if (_tvTextArray == nil) {
        _tvTextArray = [NSMutableArray array];
    }
    return _tvTextArray;
}

- (NSMutableArray *)doSwicherArray
{
    if (_doSwicherArray == nil) {
        _doSwicherArray = [NSMutableArray array];
    }
    return _doSwicherArray;
}

- (NSMutableArray *)doArray
{
    if (_doArray == nil) {
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

#pragma mark - set 方法
- (void)setSceneData:(HRSceneData *)sceneData
{
    _sceneData = sceneData;
    if (sceneData) {
        self.sceneName = sceneData.title;
        
        NSString *picture = sceneData.picture.lastObject;
        NSInteger index = [picture integerValue] - 1;
        self.UpdatePictureIndex = index;
        
        
        //清空数组
        [self.doArray removeAllObjects];
        [self.currencyArray removeAllObjects];
        [self.tvArray removeAllObjects];
        [self.airArray removeAllObjects];
        [self.doSwicherArray removeAllObjects];
        //延时时间数组
        [self.doTextArray removeAllObjects];
        [self.tvTextArray removeAllObjects];
        [self.currencyTextArray removeAllObjects];
        [self.airTextArray removeAllObjects];
        
        
        [self.gmPickerArray removeAllObjects];
        [self.tvPickerArray removeAllObjects];
        [self.gmNumberArray removeAllObjects];
        [self.tvNumberArray removeAllObjects];
        
        NSMutableArray *scene = [NSMutableArray array];
        
        if (sceneData.data.length < 4) {
            [self.sceneTableView reloadData];
            return;
        }
        //把字符串分割成数组
        NSArray *sceneArray = [sceneData.data componentsSeparatedByString:@"],"];
        
        for (int i = 0; i < sceneArray.count; i++) {
            
            if (i == 0) {
                
                NSString *str = sceneArray[i];
                str = [str substringFromIndex:1];
                str = [NSString stringWithFormat:@"%@]",str];
                [scene addObject:str];
                
            }else if (i == sceneArray.count -1)
            {
                NSString *str = sceneArray[i];
                str = [str substringToIndex:str.length - 1];
                [scene addObject:str];
            }else
            {
                NSString *str = sceneArray[i];
                str = [NSString stringWithFormat:@"%@]",str];
                [scene addObject:str];
            };
        }
        
        // 又把数组中每个字符串,取出来分割成单独的数组元素
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.appDelegate = app;
        for (NSString *sceneStr in scene) {
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *tempArr = [sceneStr componentsSeparatedByString:@","];
            for (int i = 0; i < tempArr.count; i++) {
                if (i == 0) {
                    
                    NSString *fist = tempArr[i];
                    NSRange startLocation = [fist rangeOfString:@"[\""];
                    NSRange endLocation = [fist rangeOfString:@"\"" options:NSBackwardsSearch];
                    NSRange range = NSMakeRange(startLocation.location + startLocation.length, endLocation.location - startLocation.location - startLocation.length);
                    fist = [fist substringWithRange:range];
                    [arr addObject:fist];
                }else if (i == tempArr.count - 1)
                {
                    NSString *last = tempArr[i];
                    last = [last substringFromIndex:1];
                    NSRange range = [last rangeOfString:@"\"]"];
                    last = [last substringToIndex:range.location];
                    [arr addObject:last];
                }else
                {
                    NSString *magin = tempArr[i];
                    magin = [magin substringFromIndex:1];
                    NSRange range = [magin rangeOfString:@"\""];
                    magin = [magin substringToIndex:range.location];
                    [arr addObject:magin];
                    
                }
            }
            
            //取出did判断类型
            if ([arr[1] isEqualToString:@"hrdo"]) {
                
                //从单例里面遍历保存的数组
                for (HRDOData *data in self.appDelegate.doArray) {
                    //判断取出的did和data的did是否是一样 的
                    if ([data.did isEqualToString:arr.firstObject]) {
                        /**
                         *  第一个字节： 0/1/2/3  ---- 分别表示 第1 2 3  4 开关
                         第二个字节： 0: 关
                         1: 开
                         2: 暂停, 零火/单火类型选择暂停时设置为0（关）
                         3: 无效
                         */
                        //取出dada数组里第3个元素的第一个字节进行判断
                        if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                            //给模型重新赋值之后,保存在self.doArray数组中
                            [self addDoArray:arr data:data index:2 number:@"0"];
                        }else if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
                            
                            [self addDoArray:arr data:data index:4 number:@"1"];
                        }else if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"2"]) {
                            
                            [self addDoArray:arr data:data index:6 number:@"2"];
                        }else if ([[arr[2] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"3"]) {
                            
                            [self addDoArray:arr data:data index:8 number:@"3"];
                        }
                    }
                }
                
                
                //延时时间数组
                NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
                [self.doTextArray addObject:str];
                
                //滑块转态
                [self.doSwicherArray addObject:[arr[2] substringFromIndex:1]];
                
                
            }else if ([arr[1] isEqualToString:@"irac"]) {//空调
                //从单例里面遍历保存的数组
                for (IracData *data in self.appDelegate.iracArray) {
                    //判断取出的did和data的did是否是一样 的
                    if ([data.did isEqualToString:arr.firstObject]) {
                        [self addAirArray:arr data:data];
                    }
                    //延时时间数组
                    NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
                    [self.airTextArray addObject:str];
                    
                }
                
            }else if ([arr[1] isEqualToString:@"irgm"]) {// 通用 和电视
                //从单例里面遍历保存的数组
                for (IrgmData *data in self.appDelegate.irgmArray) {
                    //判断取出的did和data的did是否是一样 的
                    if ([data.did isEqualToString:arr.firstObject]) {
                        if ([data.picture.lastObject isEqualToString:@"1"]) {//电视
                            
                            [self addTvArray:arr data:data];
                            //延时时间数组
                            NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
                            [self.tvTextArray addObject:str];
                        }else if ([data.picture.lastObject isEqualToString:@"2"]) {//通用 红外
                            
                            [self addCurrencyArray:arr data:data];
                            //延时时间数组
                            NSString *str = [NSString stringWithFormat:@"延时%@秒",arr.lastObject];
                            [self.currencyTextArray addObject:str];
                            
                        }
                    }
                    
                    
                }
                
            }
        }
    }
    
    
    [self.sceneTableView reloadData];
}

#pragma mark - 添加cell数组
//开关
- (void)addDoArray:(NSArray *)arr data:(HRDOData *)data index:(NSInteger)index number:(NSString *)number
{
    NSDictionary *dict = [NSDictionary dictionary];
    HRDOData *doData = [HRDOData mj_objectWithKeyValues:dict];
    doData.did = arr.firstObject;
    doData.title =  data.parameter[index];
    NSString *str = [arr[2] substringFromIndex:1];
    doData.parameter = @[[NSString stringWithFormat:@"%ld", [number integerValue] + 1], data.parameter[index], str];
    doData.picture =  data.picture;
    doData.types = data.types;
    [self.doArray addObject:doData];
}
- (void)addAirArray:(NSArray *)arr data:(IracData *)data
{
    NSDictionary *dict = [NSDictionary dictionary];
    IracData *airData = [IracData mj_objectWithKeyValues:dict];
    airData.did = arr.firstObject;
    airData.title =  data.title;
    airData.types = data.types;
    airData.version =  arr[2];
    [self.airArray addObject:airData];
}
- (void)addCurrencyArray:(NSArray *)arr data:(IrgmData *)data
{
    NSDictionary *dict = [NSDictionary dictionary];
    IrgmData *currencyData = [IrgmData mj_objectWithKeyValues:dict];
    currencyData.did = arr.firstObject;
    currencyData.title =  data.title;
    currencyData.types = data.types;
    currencyData.param01 = data.param01;
    currencyData.param02 = data.param02;
    currencyData.param03 = data.param03;
    currencyData.name01 = data.name01;
    currencyData.name02 = data.name02;
    currencyData.name03 = data.name03;
    
    // 添加按钮文字 数组
    for (int i = 0; i < 10; i++) {
        if ([data.param01[i] isEqualToString:arr[2]]) {
            [self.gmPickerArray addObject:data.name01[i]];
        }else if ([data.param02[i] isEqualToString:arr[2]]) {
            [self.gmPickerArray addObject:data.name02[i]];
        }else if ([data.param03[i] isEqualToString:arr[2]]) {
            [self.gmPickerArray addObject:data.name03[i]];
        }
    }
    
    [self.gmNumberArray addObject:arr[2]];
    [self.currencyArray addObject:currencyData];
    
}
- (void)addTvArray:(NSArray *)arr data:(IrgmData *)data
{
    NSDictionary *dict = [NSDictionary dictionary];
    IrgmData *currencyData = [IrgmData mj_objectWithKeyValues:dict];
    currencyData.did = arr.firstObject;
    currencyData.title =  data.title;
    currencyData.types = data.types;
    currencyData.param01 = data.param01;
    currencyData.param02 = data.param02;
    currencyData.param03 = data.param03;
    currencyData.name01 = data.name01;
    currencyData.name02 = data.name02;
    currencyData.name03 = data.name03;
    [self.tvArray addObject:currencyData];
    [self.tvNumberArray addObject:arr[2]];
    // 添加按钮文字 数组
    for (int i = 0; i < 10; i++) {
        if ([data.param01[i] isEqualToString:arr[2]]) {
            [self.tvPickerArray addObject:data.name01[i]];
        }else if ([data.param02[i] isEqualToString:arr[2]]) {
            [self.tvPickerArray addObject:data.name02[i]];
        }else if ([data.param03[i] isEqualToString:arr[2]]) {
            [self.tvPickerArray addObject:data.name03[i]];
        }
    }
    
}

static NSString *const ID = @"cell";
static NSString *const scenceID = @"scenceID";
static NSString * const headCellID = @"headCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
	//初始化
    [self setUpViews];
    //socket连接
    [self connectionSocket];
    
    // 通知
    [self addNotificationCenterObserver];
    self.pictureIndex = @"1";
}
#pragma mark - 通知
- (void)addNotificationCenterObserver
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithSceneModellViewCanleButtonClick) name:kNotificationSceneIsNoSaveButtonClick object:nil];
    
    
    //接收到创建情景通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateScene:) name:kNotificationCreateScene object:nil];
    //接收到更新情景通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithUpDataScene:) name:kNotificationUpDataScene object:nil];
    //监听设备是否在线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
    
    
}

static BOOL isShowOverMenu = NO;
//监听设备是否在线
- (void)receviedWithNotOnline
{
    isShowOverMenu = YES;
    [SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
//接收到更新情景通知
- (void)receviedWithUpDataScene:(NSNotification *)note
{
    isOvertime = YES;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//接收到创建情景通知
static BOOL isOvertime = NO;
- (void)receviedWithCreateScene:(NSNotification *)note
{
    isOvertime = YES;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
//	//添加 表格
	UITableView *sceneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108 + 124, UIScreenW, UIScreenH - 108 - 49 - 124) style:UITableViewStyleGrouped];
	sceneTableView.delegate = self;
	sceneTableView.dataSource = self;
    sceneTableView.backgroundColor = [UIColor clearColor];
	sceneTableView.showsVerticalScrollIndicator = NO;
    sceneTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.001, 0.001, 0.001, 0.001)];
	sceneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sceneTableView.sectionFooterHeight = 0;
	sceneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.sceneTableView = sceneTableView;
	[self.view addSubview:self.sceneTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
	
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
//    [sceneTableView addGestureRecognizer:tap];

    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = @"添加情景";
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveButton = saveButton;
    [self.view addSubview:navView];
    [self.view addSubview:saveButton];
    self.navView = navView;
    
    //头部view
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headView];
    self.headView = headView;
    
    //情景view
    UIView *scenceView = [[UIView alloc] init];
    scenceView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.scenceView = scenceView;
    
    [headView addSubview:scenceView];
    
    
    //情景view 里的情景label
    UILabel *sceneLabel = [[UILabel alloc] init];
    sceneLabel.text = @"情景名称:";
    sceneLabel.textColor = [UIColor whiteColor];
    [scenceView addSubview:sceneLabel];
    self.sceneLabel = sceneLabel;
    
    //情景view 里的情景sceneField
    UITextField *sceneField = [[UITextField alloc] init];
    sceneField.textColor = [UIColor colorWithR:172 G:172 B:172 alpha:1.0];
    sceneField.placeholder = @"请输入情景名称";
    sceneField.borderStyle = UITextBorderStyleNone;
    sceneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (self.sceneName.length > 0) {
        sceneField.text = self.sceneName;
    }
    self.sceneField = sceneField;
    [scenceView addSubview:sceneField];
    
    //情景view 里的情景lineView
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [scenceView addSubview:lineView];
    self.lineView = lineView;
    
    
    //情景图标View
    UIView *scenceIconView = [[UIView alloc] init];
    scenceIconView.backgroundColor = scenceView.backgroundColor;
    self.scenceIconView = scenceIconView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scenceIconViewTapClick:)];
    [scenceIconView addGestureRecognizer:tap];
    
    [headView addSubview:scenceIconView];
    
    //情景图标View 里的情景label
    UILabel *sceneIconLabel = [[UILabel alloc] init];
    sceneIconLabel.text = @"情景图标";
    sceneIconLabel.textColor = [UIColor whiteColor];
    [scenceIconView addSubview:sceneIconLabel];
    
    
    self.sceneIconLabel = sceneIconLabel;
    
    //情景图片
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.image = [UIImage imageNamed:self.iconArray.firstObject];
    
    [scenceIconView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    if (self.UpdatePictureIndex) {
        
        self.iconImageView.image = [UIImage imageNamed:self.iconArray[self.UpdatePictureIndex]];
    }
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入"]];
    arrowImageView.userInteractionEnabled = YES;
    [scenceIconView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    //中间的条
    UIView *middleBar = [[UIView alloc] init];
    middleBar.backgroundColor = self.scenceView.backgroundColor;
    [headView addSubview:middleBar];
    self.middleBar = middleBar;
    
    UIButton *fistButton = [self addButtonWithTag:1 title:@"智能设备"];
    UIButton *secondButton = [self addButtonWithTag:2 title:@"通用红外"];
    UIButton *threeButton = [self addButtonWithTag:3 title:@"空调"];
    UIButton *fourButton = [self addButtonWithTag:4 title:@"电视"];
    self.fistButton = fistButton;
    self.secondButton = secondButton;
    self.threeButton = threeButton;
    self.fourButton = fourButton;
    
    // 下划线
    UIView *underLine = [[UIView alloc] init];
    underLine.backgroundColor = [UIColor orangeColor];
    [middleBar addSubview:underLine];
    self.underLine = underLine;
    
    //底部条
    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenH - 49, UIScreenW, 49)];
    tabBarView.backgroundColor = self.scenceView.backgroundColor;
    [self.view addSubview:tabBarView];
    self.tabBarView = tabBarView;
    
    // 添加导航条灰线
    UIView *lineBarView = [[UIView alloc] init];
    lineBarView.backgroundColor = [UIColor blackColor];
    [self.tabBarView addSubview:lineBarView];
    self.lineBarView = lineBarView;
    
    //往导航条添加编辑按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView addSubview:editButton];
    self.editButton = editButton;
    
    //往导航条添加添加按钮
    UIButton *addDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addDeviceButton setImage:[UIImage imageNamed:@"情景添加"] forState:UIControlStateNormal];
    [addDeviceButton addTarget:self action:@selector(addDeviceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView addSubview:addDeviceButton];
    self.addDeviceButton = addDeviceButton;
    
    //往导航条添加完成按钮
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.backgroundColor = [UIColor themeColor];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView addSubview:completeButton];
    self.completeButton = completeButton;
    self.completeButton.alpha = 0.0;
    
    //注册
    [self.sceneTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SceneCell class]) bundle:nil] forCellReuseIdentifier:scenceID];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.UpdatePictureIndex) {
        [self.sceneTableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self buttonClick:self.fistButton];
    
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	NSLog(@"viewWillDisappear");
}
- (void)dealloc
{
    [kNotification removeObserver:self];
    viewDidLayoutSubviewsCount = 0;
}

static NSInteger viewDidLayoutSubviewsCount = 0;
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
    
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.centerY.equalTo(self.navView);
        make.height.equalTo(self.navView);
        make.width.equalTo(self.saveButton.mas_height);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(120 + 44);
    }];
    
    //情景名称View
    [self.scenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.headView);
        make.height.mas_equalTo(40);
    }];
    
    
    NSString *title = @"情景名称:";
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    CGSize size = [title sizeWithAttributes:muDict];
    [self.sceneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scenceView).offset(15);
        make.centerY.equalTo(self.scenceView);
        make.width.mas_equalTo(size.width);
        
    }];
    [self.sceneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sceneLabel.mas_right).offset(15);
        make.right.equalTo(self.scenceView).offset(-15);
        make.centerY.equalTo(self.sceneLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scenceView);
        make.height.mas_equalTo(1);
        make.width.equalTo(self.scenceView);
    }];
    
    //情景图片View
    [self.scenceIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scenceView.mas_bottom);
        make.height.equalTo(self.scenceView);
        make.width.equalTo(self.scenceView);
    }];
    
    [self.sceneIconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scenceIconView).offset(15);
        make.centerY.equalTo(self.scenceIconView);
        make.width.mas_equalTo(size.width);
        
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sceneIconLabel.mas_right).offset(15);
        make.centerY.equalTo(self.scenceIconView);
        make.top.equalTo(self.scenceIconView).offset(5);
        make.width.equalTo(self.iconImageView.mas_height);
        
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.scenceIconView).offset(-15);
        make.centerY.equalTo(self.scenceIconView);
        
    }];
    
    //中间条
    [self.middleBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scenceIconView.mas_bottom).offset(40);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        
    }];
    //按钮
    [self.fistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.middleBar);
        make.left.equalTo(self.middleBar);
        make.width.mas_equalTo(self.view.bounds.size.width / 4);
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
    
//    self.sceneTableView.contentInset = UIEdgeInsetsMake(120 + 44 + 64 - 108 - 124  , 0, 0, 0);
    
    if (self.doArray.count > 0 || self.currencyArray.count > 0 || self.airArray.count > 0 || self.tvArray.count > 0) {
        
        [self.sceneTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            self.sceneTableView.contentInset = UIEdgeInsetsMake(120 + 44 + 64  - 108 - 124, 0, 0, 0);
//        });
    }
    
    
    self.headViewFram = self.headView.frame ;
    self.offsetY = self.sceneTableView.contentOffset.y;
    
    ////底部条
    // 导航条灰线
    [self.lineBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.hr_width, 1));
        make.top.equalTo(self.tabBarView);
        make.left.equalTo(self.tabBarView);
    }];
    
    // 编辑按钮
    CGFloat buttonW = UIScreenW / 2 ;
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(buttonW, 49));
        make.top.equalTo(self.tabBarView);
        make.centerY.equalTo(self.tabBarView);
        make.left.equalTo(self.tabBarView);
    }];
    
    // 添加设备按钮
    [self.addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(buttonW, 49));
        make.top.equalTo(self.tabBarView);
        make.right.equalTo(self.tabBarView);
    }];
    
    //完成按钮
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView).offset(5);
        make.left.equalTo(self.tabBarView).offset(self.view.hr_width *0.15);
        make.right.equalTo(self.tabBarView).offset(- self.view.hr_width *0.15);
        make.bottom.equalTo(self.tabBarView).offset(- 5);
    }];
    self.completeButton.layer.cornerRadius = (49 - 10) *0.5;
    self.completeButton.layer.masksToBounds = YES;
    

    if (viewDidLayoutSubviewsCount == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.completeFram = self.completeButton.frame;
        });
    }
    viewDidLayoutSubviewsCount++;
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
#pragma mark - UI点击
- (void)tableViewTapButtonClick
{
    [self.view endEditing:YES];
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)scenceIconViewTapClick:(UITapGestureRecognizer *)tap
{
    SceneIcomSelectController *VC = [[SceneIcomSelectController alloc] init];
    [VC sceneIcomSelectControllerBlock:^(NSInteger pictureIndex) {
        self.iconImageView.image = [UIImage imageNamed:self.iconArray[pictureIndex]];
        self.pictureIndex = [NSString stringWithFormat:@"%ld", pictureIndex + 1];
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)receviedWithSceneModellViewCanleButtonClick
{
    self.tabBarView.hidden = NO;
}
//- (void)tapGestureClick
//{
//    [self.view endEditing:YES];
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)completeButtonClick
{
    //让tableview退出编辑状态
    [self.sceneTableView setEditing:NO animated:YES];
    //显示view
    [self rightViewIsHidden:NO];
    
    self.completeButton.frame = self.completeFram;
    //设置按钮动画
    [UIView animateWithDuration:0.5 animations:^{
        [self.completeButton setTitle:@"..." forState:UIControlStateNormal];
        self.completeButton.layer.transform = CATransform3DMakeScale(0.0001, 1.0, 0.0001);
        
//        [self.view layoutIfNeeded];
        DDLogWarn(@"--------1--------");
    } completion:^(BOOL finished) {
        
        self.completeButton.frame = self.completeFram;
        self.completeButton.alpha = 0.0;
        
//        [self.view layoutIfNeeded];
        DDLogWarn(@"--------2--------");
        
    } ];
    DDLogWarn(@"completeButton--%@", NSStringFromCGRect(self.completeButton.frame));
}

/// 显示或隐藏view
- (void)rightViewIsHidden:(BOOL)hidden
{
    for (UIView *view in self.sceneTableView.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]) {
            
            for (UIView *cellView in view.subviews) {
                UIView *rightView = [cellView valueForKeyPath:@"rightView"];
                DDLogWarn(@"objc%@",rightView);
                rightView.hidden = hidden;
            }
        }
    }
}
- (void)addDeviceButtonClick
{
    self.tabBarView.hidden = YES;
    SceneAddController *addVC = [[SceneAddController alloc] init];
    [self presentViewController:addVC animated:YES completion:nil];
   
    //block回调
    __weak typeof (self) weakSelf = self;
    [addVC sceneModellViewSendTableViewWithBlock:^(NSArray *doArray, NSArray *currencyArray, NSArray *airArray, NSArray *tvArray) {
        
        __strong typeof (self) strongSelf = weakSelf;
        strongSelf.tabBarView.hidden = NO;
        //让tableview 回到顶部, moveView回到第一个按钮位置
        [strongSelf buttonClick:strongSelf.fistButton];
//        [strongSelf.sceneTableView setContentOffset:CGPointMake(0, 0)];
        for (id object in doArray) {
            [strongSelf.doArray addObject:object];
            [strongSelf.sceneArray addObject:object];
            //初始化延时时间数组
            NSString *str = @"延时0.0秒";
            [strongSelf.doTextArray addObject:str];
            HRDOData *data = [HRDOData mj_objectWithKeyValues:object];
            //初始化滑块状态数组
            NSString *swicherStr = data.parameter.lastObject;
            if ([swicherStr isEqualToString:@"255"]) {
                
                swicherStr = @"3";
            }
            [strongSelf.doSwicherArray addObject:swicherStr];
        }
        for (id object in currencyArray) {
            [strongSelf.currencyArray addObject:object];
            [strongSelf.sceneArray addObject:object];
            //初始化延时时间数组
            NSString *str = @"延时0.0秒";
            [strongSelf.currencyTextArray addObject:str];
            //初始化picker文字数组
            NSString *textPicker = @"未选择操作";
            [strongSelf.gmPickerArray addObject:textPicker];
            //初始化按键数字数组
            NSString *number = @"-1";
            [strongSelf.gmNumberArray addObject:number];
        }
        for (id object in airArray) {
            [strongSelf.airArray addObject:object];
            [strongSelf.sceneArray addObject:object];
            
            NSString *str = @"延时0.0秒";
            [strongSelf.airTextArray addObject:str];
        }
        for (id object in tvArray) {
            [strongSelf.tvArray addObject:object];
            [strongSelf.sceneArray addObject:object];
            
            NSString *str = @"延时0.0秒";
            [strongSelf.tvTextArray addObject:str];
            //初始化picker文字数组
            NSString *textPicker = @"未选择操作";
            [strongSelf.tvPickerArray addObject:textPicker];
            //初始化按键数字数组
            NSString *number = @"-1";
            [strongSelf.tvNumberArray addObject:number];
        }
        
        [strongSelf.sceneTableView reloadData];
    }];
    
}
- (void)editButtonClick
{
    [self.sceneTableView setEditing:NO animated:YES];
    
    //让tableview进入编辑状态
    [self.sceneTableView setEditing:!self.sceneTableView.isEditing animated:YES];
    
    //隐藏view
    [self rightViewIsHidden:YES];
    
    //设置按钮动画
    self.completeButton.alpha = 1.0;
    self.completeButton.frame = self.completeFram;
    [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
    self.completeButton.layer.transform = CATransform3DMakeScale(0.00001, 1.0, 0.0001);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.completeButton.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0001);
//        [self.view layoutIfNeeded];
        DDLogWarn(@"---------3----------");
    } completion:^(BOOL finished) {
//        [self.view layoutIfNeeded];
        DDLogWarn(@"---------4----------");
        [self.completeButton.layer removeAllAnimations];
    }];
    
    DDLogWarn(@"---------5----------");
}
- (void)buttonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    self.currentButton.selected = NO;
    sender.selected = !sender.selected;
    self.currentButton = sender;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underLine.hr_centerX = sender.centerX;
    }];
    
    [self.sectionMaxYArray removeAllObjects];
    [self.sectionMaxYArray addObject:@(0)];
    NSInteger section = [self.sceneTableView numberOfSections];
    for (NSInteger i = 0; i < section; i++) {
        NSInteger indexPathRow = [self.sceneTableView numberOfRowsInSection:i];
        CGFloat maxY = [self.sectionMaxYArray[i] floatValue] + tableViewRowHeight *indexPathRow + tableViewSectionHeaderHeight;
        [self.sectionMaxYArray addObject:@(maxY)];
    }
    
    
    switch (section) {
        case 0:
        {
            [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
        }
            break;
            
        case 1:
        {
            
            if (self.doArray.count > 0) {
                if (sender.tag == 1) {
                    
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
                }else
                {
                    
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                }
            }else if (self.currencyArray.count > 0)
            {
                if (sender.tag == 1 || sender.tag == 2) {
                
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
            }else
            {
                
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
            }
                
            }else if (self.airArray.count > 0)
            {
                if (sender.tag == 1 || sender.tag == 2 || sender.tag == 3) {
                    
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
                }else
                {
                    
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                }
                
            }else
            {
                
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
            }
            
            
        }
            break;
        case 2:
        {
            if (sender.tag == 1) {
                
            [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[0] floatValue]) animated:YES];
                
            }else if (sender.tag == 2) {
            {
               
                    
                if (self.doArray.count > 0 && self.currencyArray.count > 0) {
                    
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                }else if (self.doArray.count == 0 && self.currencyArray.count > 0)
                {
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
                }else if (self.doArray.count > 0 && self.currencyArray.count == 0)
                {
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                }else
                {
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
                    
                }
                

            }
        }else if (sender.tag == 3)
        {
            
            
            if (self.doArray.count > 0 && self.currencyArray.count > 0) {
                
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[2] floatValue]) animated:YES];
                
            }else if (self.airArray.count > 0 && self.tvArray.count > 0)
            {
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray.firstObject floatValue]) animated:YES];
            }else
            {
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                
            }
            
            
        }else
        {
            if (self.tvArray.count > 0) {
                
                
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                
            }else
            {
                [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[2] floatValue]) animated:YES];
                
            }
        }
            
        }
            break;

        case 3:
            {
                if (sender.tag == 1) {
                    
                    [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[0] floatValue]) animated:YES];
                    
                }else if (sender.tag == 2)
                {
                    if (self.doArray.count == 0) {
                        
                        [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[0] floatValue]) animated:YES];
                    }else
                    {
                        [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                    }
                    
                    
                    
                }else if (sender.tag == 3)
                {
                    if (self.airArray.count > 0) {//
                    
                        if (self.doArray.count > 0 && self.currencyArray.count > 0) {
                            
                            [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[2] floatValue]) animated:YES];
                        }else
                        {
                            
                            [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[1] floatValue]) animated:YES];
                        }
                        
                    }else//
                    {
                        
                        [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[2] floatValue]) animated:YES];
                    }
                    
                    
                }else //tag == 4
                {
                    if (self.tvArray.count > 0) {//
                        
                        
                        [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[2] floatValue]) animated:YES];
                        
                        
                    }else//
                    {
                        
                        [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[3] floatValue]) animated:YES];
                    }
                    
                    
                }
                break;
        case 4:
        {
            
            
            [self.sceneTableView setContentOffset:CGPointMake(0, [self.sectionMaxYArray[sender.tag - 1] floatValue]) animated:YES];
            
        }
            break;
        default:
            break;
    }

    
    }
}

/**
 *  但数组为空时的滚动偏移量
 */
- (CGFloat)setupEptTabelView
{
    CGFloat rowY = 0.0;
    if (self.doArray.count > 0)
    {
        rowY += self.doArray.count * tableViewRowHeight +tableViewSectionHeaderHeight;
        
    }
    if (self.currencyArray.count > 0) {
        rowY += self.currencyArray.count * tableViewRowHeight +tableViewSectionHeaderHeight;
    }
    
    if (self.airArray.count > 0) {
        rowY += self.airArray.count * tableViewRowHeight +tableViewSectionHeaderHeight;
    }
    if (self.tvArray.count > 0) {
        rowY += self.tvArray.count * tableViewRowHeight +tableViewSectionHeaderHeight;
    }
    return rowY;
}

- (void)backClick
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	DDLogInfo(@"%@",window.subviews);
	for (UIView *view in window.subviews) {
		if (view.frame.size.height == 46) {
			[view removeFromSuperview];
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

//存储
- (void)saveClick
{
    
    if (self.sceneField.text.length > 0) {
        
    }else
    {
        [SVProgressTool hr_showErrorWithStatus:@"情景名不能为空!"];
        return;
    }
    
    NSString *pictureStr = self.pictureIndex;
    NSArray *picture = @[pictureStr];
    NSMutableArray *data = [NSMutableArray array];
    
    for (int i = 0; i < self.doArray.count; i++) {//开关
        HRDOData *doData = [HRDOData mj_objectWithKeyValues:self.doArray[i]];
        //第一个字节： 0/1/2/3  ---- 分别表示 第1 2 3  4 开关
        //第二个字节： 0: 关1: 开2: 暂停, 零火/单火类型选择暂停时设置为0（关）3: 无效
        NSString *status = [NSString stringWithFormat:@"%ld%@",[doData.parameter.firstObject integerValue]- 1, self.doSwicherArray[i]];
        //第一次截取
        NSRange range = [self.doTextArray[i] rangeOfString:@"延时"];
        NSString *delay = [self.doTextArray[i] substringFromIndex:range.location + range.length];
        //第二次截取
        range = [delay rangeOfString:@"秒"];
        delay = [delay substringToIndex:range.location];
        NSArray *doArray = @[doData.did, doData.types,status, delay];
        
        [data addObject:doArray];
    }
    
    for (int i = 0; i < self.airArray.count; i++) {//空调
        IracData *iracData = [IracData mj_objectWithKeyValues:self.airArray[i]];
        
        //status存在version里面
        if ([iracData.version integerValue] < 0) {
            continue;
        }
        NSString *status = iracData.version;
        //第一次截取
        NSRange range = [self.airTextArray[i] rangeOfString:@"延时"];
        NSString *delay = [self.airTextArray[i] substringFromIndex:range.location + range.length];
        //第二次截取
        range = [delay rangeOfString:@"秒"];
        delay = [delay substringToIndex:range.location];
        NSArray *doArray = @[iracData.did, iracData.types,status, delay];
        
        [data addObject:doArray];
    }
    
    for (int i = 0; i < self.currencyArray.count; i++) {//通用红外
        IrgmData *irgmData = [IrgmData mj_objectWithKeyValues:self.currencyArray[i]];
        
        
        if ([self.gmNumberArray[i] integerValue] < 0) {
            continue;
        }
        NSString *status = self.gmNumberArray[i];
        
        //第一次截取
        NSRange range = [self.currencyTextArray[i] rangeOfString:@"延时"];
        NSString *delay = [self.currencyTextArray[i] substringFromIndex:range.location + range.length];
        //第二次截取
        range = [delay rangeOfString:@"秒"];
        delay = [delay substringToIndex:range.location];
        NSArray *doArray = @[irgmData.did, irgmData.types,status, delay];
        
        [data addObject:doArray];
    }
    
    for (int i = 0; i < self.tvArray.count; i++) {//电视
        IrgmData *tvData = [IrgmData mj_objectWithKeyValues:self.tvArray[i]];
        
        if ([self.tvNumberArray[i] integerValue] < 0) {
            continue;
        }
        NSString *status = self.tvNumberArray[i];
        
        //第一次截取
        NSRange range = [self.tvTextArray[i] rangeOfString:@"延时"];
        NSString *delay = [self.tvTextArray[i] substringFromIndex:range.location + range.length];
        //第二次截取
        range = [delay rangeOfString:@"秒"];
        delay = [delay substringToIndex:range.location];
        NSArray *doArray = @[tvData.did, tvData.types,status, delay];
        
        [data addObject:doArray];
    }
    
    NSString *str ;
    if (self.sceneData) {//更新情景
        str = [NSString stringWithSceneType:@"update" did:self.sceneData.did title:self.sceneField.text picture:picture data:data];
        [SVProgressTool hr_showWithStatus:@"正在更新情景模式..."];
        
    }else//创建情景
    {
        for (HRSceneData *data in self.appDelegate.sceneArray) {
            if ([data.title isEqualToString:self.sceneField.text]) {
                [SVProgressTool hr_showErrorWithStatus:@"有相同的情景,请修改情景名称!"];
                return;
            }
        }
        
        [SVProgressTool hr_showWithStatus:@"创建情景模式..."];
        str = [NSString stringWithSceneType:@"create" did:@"None" title:self.sceneField.text picture:picture data:data];
        
        DDLogInfo(@"发送创建情景%@", str);
    }
    [self.appDelegate sendMessageWithString:str];
    
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

#pragma mark - socket连接
- (void)connectionSocket
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate connectToHost];
    self.appDelegate = appDelegate;
}

#pragma mark - tableView代理  数据源
static NSInteger section = 0;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger irac = 0;
    NSInteger irgm1 = 0;
    NSInteger irgm2 = 0;
    NSInteger hrdo = 0;
    
    if (self.doArray.count > 0) {
        hrdo = 1;
    }
    if (self.currencyArray.count > 0)
    {
        irgm2 = 1;//通用
    }
    if (self.airArray.count > 0)
    {
        irac = 1;
    }
    if (self.tvArray.count > 0)
    {
        irgm1 = 1;
    }
    NSInteger total = (irac + irgm1 + irgm2 + hrdo);
    section = total;
    if (total == 0) {
        [self.sceneTableView removeGestureRecognizer:self.tap];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapButtonClick)];
        [self.sceneTableView addGestureRecognizer:tap];
        self.tap = tap;
    }else
    {
        [self.sceneTableView removeGestureRecognizer:self.tap];
    }
    return total;
//    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = 0;
    if (section == 0) {
        if (self.doArray.count > 0) {
            index = self.doArray.count;
        }else if (self.currencyArray.count > 0) {
            index = self.currencyArray.count;
        }else if (self.airArray.count > 0) {
            index = self.airArray.count;
        }else if (self.tvArray.count > 0) {
            index = self.tvArray.count;
        }
    }else if (section == 1) {
        
        if (self.doArray.count > 0 && self.currencyArray.count > 0) {//如果section == 0 section 的值是doArray.count>0的情况
            index = self.currencyArray.count;
        }else if (self.doArray.count > 0 && self.airArray.count > 0) {
            index = self.airArray.count;
        }else if (self.doArray.count > 0 && self.tvArray.count > 0) {
            index = self.tvArray.count;
        }else if (self.currencyArray.count > 0 && self.airArray.count > 0) {//如果section == 0 section 的值是currencyArray.count>0的情况
            index = self.airArray.count;
        }else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
            index = self.tvArray.count;
        }else if (self.airArray.count > 0 && self.tvArray.count > 0) {//如果section == 0 section 的值是airArray.count>0的情况
            index = self.tvArray.count;
        }
        
    }else if (section == 2) {
        // section=0 是doArray时的情况
        if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
            index = self.airArray.count;
        }else if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.tvArray.count > 0) {
            index = self.tvArray.count;
        }else if (self.doArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
            index = self.tvArray.count;
        }
        // section=0 是currencyArray时的情况
        else if (self.currencyArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
            index = self.tvArray.count;
        }
    }else if (section == 3) {
        index = self.tvArray.count;
    }
    
    return index;
//    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogInfo(@"section%ldrow%ld", indexPath.section,(long)indexPath.row);
    SceneCell *cell = [tableView dequeueReusableCellWithIdentifier:scenceID];
    for (UIGestureRecognizer *gest in cell.contentView.gestureRecognizers ) {//删除手势
        if ([gest isKindOfClass:[UITapGestureRecognizer class]]) {
            [cell.contentView removeGestureRecognizer:gest];
        }
    }
    
    
    if (indexPath.section == 0) {
        if (self.doArray.count > 0){
            //开关
            [self setDoCell:cell cellForRowAtIndexPath:indexPath];
            
            
        }else if (self.currencyArray.count > 0)
        {
            //通用
            [self setCurrencyTextCell: cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.airArray.count > 0)
        {
            //空调
            [self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.tvArray.count > 0)
        {
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 1)
    {
        if (self.doArray.count > 0 && self.currencyArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为currencyArray 的情况
            //通用
            [self setCurrencyTextCell: cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.airArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为airArray 的情况
            //空调
            [self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为tvArray 的情况
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
        }else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
            //如果section == 0 section 的值为currencyArray,section == 1为airArray 的情况
            //空调
            [self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为currencyArray,section == 1为tvArray 的情况
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.airArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为airArray,section == 1为tvArray 的情况
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }
        
    }else if (indexPath.section == 2)
    {
        if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为currencyArray,section == 2为airArray 的情况
            //空调
            [self setAirTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为airArray,section == 2为tvArray 的情
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为airArray,section == 2为tvArray 的情
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }
        // section=0 是currencyArray时的情况,section == 1为airArray,section == 2为tvArray 的情
        else if (self.currencyArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
            //电视
            [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
            
        }
        
    }else if (indexPath.section == 3)
    {
        //如果能来这里证明section 是tvArray
        //电视
        [self setTvTextCell:cell cellForRowAtIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return tableViewSectionHeaderHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}
///// 显示每一组的组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    if (section == 0) {
        
        if (self.doArray.count > 0) {
            str = [NSString stringWithFormat:@"智能设备: %lu", (unsigned long)self.doArray.count];
        }else if (self.currencyArray.count > 0) {
            str = [NSString stringWithFormat:@"通用红外: %lu", (unsigned long)self.currencyArray.count];
        }else if (self.airArray.count > 0) {
            
            str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
        }else if (self.tvArray.count > 0) {
            
            str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
        }
    }else if (section == 1) {
        
        if (self.doArray.count > 0 && self.currencyArray.count > 0) {//如果section == 0 section 的值是doArray.count>0的情况
            str = [NSString stringWithFormat:@"通用红外: %lu", (unsigned long)self.currencyArray.count];
            
        }else if (self.doArray.count > 0 && self.airArray.count > 0) {
            str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
        }else if (self.doArray.count > 0 && self.tvArray.count > 0) {
            str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
        }else if (self.currencyArray.count > 0 && self.airArray.count > 0) {//如果section == 0 section 的值是currencyArray.count>0的情况
            str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
        }else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
            str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
        }else if (self.airArray.count > 0 && self.tvArray.count > 0) {//如果section == 0 section 的值是airArray.count>0的情况
            str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
        }
        
    }else if (section == 2) {
        // section=0 是doArray时的情况
        if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
            str = [NSString stringWithFormat:@"空调: %lu", (unsigned long)self.airArray.count];
        }else {
            str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
        }
    }else if (section == 3) {
        str = [NSString stringWithFormat:@"电视: %lu", (unsigned long)self.tvArray.count];
    }
    
    return str;
}


/// 删除那一行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.doArray.count > 0) {
            
            [self.doArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.doArray forRowAtIndexPath:indexPath];
            
        }else if (self.currencyArray.count > 0)
        {
            [self.currencyArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.currencyArray forRowAtIndexPath:indexPath];
            
        }else if (self.airArray.count > 0)
        {
            [self.airArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
            
        }else if (self.tvArray.count > 0)
        {
            [self.tvArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 1)
    {
        if (self.doArray.count > 0 && self.currencyArray.count > 0) {
            
            //如果section == 0 section 的值为doArray,section == 1为currencyArray 的情况
            [self.currencyArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.currencyArray forRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.airArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为airArray 的情况
            [self.airArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为tvArray 的情况
            [self.tvArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
            
        }else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
            //如果section == 0 section 的值为currencyArray,section == 1为airArray 的情况
            [self.airArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
            
        }else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为currencyArray,section == 1为tvArray 的情况
            [self.tvArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
            
        }else if (self.airArray.count > 0 && self.tvArray.count > 0) {
            //如果section == 0 section 的值为airArray,section == 1为tvArray 的情况
            [self.tvArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 2)
    {
        if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
            //如果section == 0 section 的值为doArray,section == 1为currencyArray,section == 2为airArray 的情况
            [self.airArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.airArray forRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
            
            //如果section == 0 section 的值为doArray,section == 1为airArray,section == 2为tvArray 的情
            [self.tvArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
        }
        // section=0 是currencyArray时的情况,section == 1为airArray,section == 2为tvArray 的情
        else if (self.currencyArray.count > 0 && self.airArray.count > 0 && self.tvArray.count > 0) {
            [self.tvArray removeObjectAtIndex:indexPath.row];
            [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 3)
    {
        //如果能来这里证明section 是tvArray
        [self.tvArray removeObjectAtIndex:indexPath.row];
        [self tableView:tableView array:self.tvArray forRowAtIndexPath:indexPath];
    }
    
    
    [self.sceneTableView reloadData];
}
- (void)tableView:(UITableView *)tableView array:(NSArray *)array forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (array.count > 0) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }else
    {
        [tableView reloadData];
        //		NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
        //		[tableView reloadSections:set withRowAnimation:UITableViewRowAnimationLeft];
        //		NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
        //		[tableView deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
    }
}
/// 左滑显示删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger section = [self.sceneTableView numberOfSections];
    [self.sectionMaxYArray addObject:@(0)];
    for (NSInteger i = 0; i < section; i++) {
        
        NSInteger indexPathRow = [self.sceneTableView numberOfRowsInSection:i];
        NSLog(@"%ld", (long)indexPathRow);
        
        CGFloat cellMaxY = [self.sectionMaxYArray[i] floatValue] + tableViewRowHeight *indexPathRow + tableViewSectionHeaderHeight;
        [self.sectionMaxYArray addObject:@(cellMaxY)];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    switch (section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (self.doArray.count > 0) {
                
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }
                
                
            }else if (self.currencyArray.count > 0)
            {
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.secondButton];
                    
                }
                
                
            }else if (self.airArray.count > 0)
            {
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.threeButton];
                    
                }
                
                
            }else if (self.tvArray.count > 0)
            {
                
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fourButton];
                    
                }
                
            }
        }
            break;
            
        case 2:
        {
            if (self.doArray.count > 0 && self.currencyArray.count > 0) {
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.secondButton];
                    
                }
                

                
                
            }else if (self.doArray.count > 0 && self.airArray.count > 0) {
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.threeButton];
                    
                }
                

                
            }else if (self.doArray.count > 0 && self.tvArray.count > 0) {
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.fourButton];
                    
                }
                

                
            }else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.secondButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.threeButton];
                    
                }
                

                
            }else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
                
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.secondButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.fourButton];
                    
                }

                
            }else if (self.airArray.count > 0 && self.tvArray.count > 0) {
                
                
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.threeButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.fourButton];
                    
                }
                

                
            }
                
        }
            break;
            
        case 3:
        {
            if (self.doArray.count == 0) {
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.secondButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.threeButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[3] floatValue]) {
                    
                    [self setUpSelectButton: self.fourButton];
                    
                }

                
            }else if (self.currencyArray.count == 0)
            {
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.threeButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[3] floatValue]) {
                    
                    [self setUpSelectButton: self.fourButton];
                    
                }
                
                
            }else if (self.airArray.count == 0)
            {
                
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.secondButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[3] floatValue]) {
                    
                    [self setUpSelectButton: self.fourButton];
                    
                }
                
                
            }else if (self.tvArray.count == 0)
            {
                if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                    [self setUpSelectButton: self.fistButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                    
                    [self setUpSelectButton: self.secondButton];
                    
                }else if (offsetY < [self.sectionMaxYArray[3] floatValue]) {
                    
                    [self setUpSelectButton: self.threeButton];
                    
                }
                
                
            }
        }
            break;
            
        case 4:
        {
            if (offsetY < [self.sectionMaxYArray[1] floatValue]) {
                [self setUpSelectButton: self.fistButton];
                
            }else if (offsetY < [self.sectionMaxYArray[2] floatValue]) {
                
                [self setUpSelectButton: self.secondButton];
                
            }else if (offsetY < [self.sectionMaxYArray[3] floatValue]) {
                
                [self setUpSelectButton: self.threeButton];
                
            }else if (offsetY < [self.sectionMaxYArray[4] floatValue]) {
                
                [self setUpSelectButton: self.fourButton];
                
            }

            
        }
            break;
            
            
        default:
            break;
    }
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat h = offsetY - self.offsetY;
//    if (h >= 120) {
//        h = 120;
//    }
//    
//    CGRect rect = self.headViewFram;
//    rect.origin.y = rect.origin.y - h;
//    self.headView.frame = rect;
//    DDLogWarn(@"------h------|%f|", h);
    
}

//传一个需要选中的按钮
- (void)setUpSelectButton:(UIButton *)button
{
    self.currentButton.selected = NO;
    
    if (button.tag == 1) {
        self.fistButton.selected = YES;
        self.secondButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
    }else if (button.tag == 2)
    {
        self.fistButton.selected = NO;
        self.secondButton.selected = YES;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        
    }else if (button.tag == 3)
    {
        self.fistButton.selected = NO;
        self.secondButton.selected = NO;
        self.threeButton.selected = YES;
        self.fourButton.selected = NO;
        
    }else if (button.tag == 4)
    {
        self.fistButton.selected = NO;
        self.secondButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = YES;
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underLine.hr_centerX = button.hr_centerX;
    }];
    self.currentButton = button;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
    
    ScenePickerView *picker = [ScenePickerView scenePickerView];
    //给picker titlelabel传值
    if (indexPath.section == 0) {
        if (self.doArray.count > 0) {
            [self setDoPicker:picker cellForRowAtIndexPath:indexPath];
        }else if (self.currencyArray.count > 0)
        {
            [self setCurrencyPicker:picker cellForRowAtIndexPath:indexPath];
        }else if (self.airArray.count > 0)
        {
            [self setAirPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else if (self.tvArray.count > 0)
        {
            [self setTvPicker:picker cellForRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 1)
    {
        if (self.doArray.count > 0 && self.currencyArray.count > 0) {
            [self setCurrencyPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.airArray.count > 0) {
            [self setAirPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else if (self.doArray.count > 0 && self.tvArray.count > 0) {
            [self setTvPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else if (self.currencyArray.count > 0 && self.airArray.count > 0) {
            [self setAirPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else if (self.currencyArray.count > 0 && self.tvArray.count > 0) {
            [self setTvPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else if (self.airArray.count > 0 && self.tvArray.count > 0) {
            [self setTvPicker:picker cellForRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 2)
    {
        if (self.doArray.count > 0 && self.currencyArray.count > 0 && self.airArray.count > 0) {
            [self setAirPicker:picker cellForRowAtIndexPath:indexPath];
            
        }else {
            [self setTvPicker:picker cellForRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 3)
    {
        //如果能来这里证明section 是tvArray
        [self setTvPicker:picker cellForRowAtIndexPath:indexPath];
    }
    
    picker.frame = CGRectMake(0, 64, UIScreenW, UIScreenH - 64);
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    self.picker = picker;
}


#pragma mark - 设置picker titleLabel
/// 设置开关picker
- (void)setDoPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.doArray[indexPath.row];
    HRDOData *data = [HRDOData mj_objectWithKeyValues:dict];
    picker.titleLabel.text = data.parameter[1];
    [self setDoTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}
/// 设置空调picker
- (void)setAirPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.airArray[indexPath.row];
    IracData *data = [IracData mj_objectWithKeyValues:dict];
    picker.titleLabel.text = data.title;
    [self setAirTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}
/// 设置通用picker
- (void)setCurrencyPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.currencyArray[indexPath.row];
    IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
    picker.titleLabel.text = data.title;
    [self setCurrencyTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}

/// 设置TVpicker
- (void)setTvPicker:(ScenePickerView *)picker cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	NSDictionary *dict = self.tvArray[indexPath.row];
    IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
    picker.titleLabel.text = data.title;
    [self setTvTabelViewCell:picker didSelectRowAtIndexPath:indexPath];
}

/// 设置选中时cell的滑块转态
- (void)setDoTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    [picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
        __strong typeof (self) strongSelf = weakSelf;
        strongSelf.seconds = seconds;
        strongSelf.everyMinute = everyMinute;
        
        //判断
        
        strongSelf.doTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
        
        [picker removeFromSuperview];
        [strongSelf.sceneTableView reloadData];
    }];
}
- (void)setCurrencyTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    [picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
        __strong typeof (self) strongSelf = weakSelf;
        strongSelf.seconds = seconds;
        strongSelf.everyMinute = everyMinute;
        
        //判断
        
        strongSelf.currencyTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
        
        
        [picker removeFromSuperview];
        [strongSelf.sceneTableView reloadData];
    }];
}
- (void)setAirTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    [picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
        __strong typeof (self) strongSelf = weakSelf;
        strongSelf.seconds = seconds;
        strongSelf.everyMinute = everyMinute;
        
        //判断
        strongSelf.airTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
        
        
        [picker removeFromSuperview];
        [strongSelf.sceneTableView reloadData];
    }];
}
- (void)setTvTabelViewCell:(ScenePickerView *)picker didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    [picker scenePickerViewWithpickerBlock:^(NSString *seconds, NSString *everyMinute) {
        __strong typeof (self) strongSelf = weakSelf;
        strongSelf.seconds = seconds;
        strongSelf.everyMinute = everyMinute;
        
        //判断
        strongSelf.tvTextArray[indexPath.row] = [NSString stringWithFormat:@"延时%@.%@秒", seconds, everyMinute];
        
        [picker removeFromSuperview];
        [strongSelf.sceneTableView reloadData];
    }];
}
#pragma mark - 设置  tabelviewcell
/// 设置开关cell
- (void)setDoCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.doArray[indexPath.row];
    HRDOData *data = [HRDOData mj_objectWithKeyValues:dict];
    
    if ([data.picture.firstObject isEqualToString:@"1"] ||[data.picture.firstObject isEqualToString:@"2"] ||[data.picture.firstObject isEqualToString:@"4"] ||[data.picture.firstObject isEqualToString:@"3"]) {//插座,开关
        if ([data.picture.firstObject isEqualToString:@"3"]) {
            
            cell.leftImagView.image = [UIImage imageNamed:@"插座关"];
            
        }else
        {
            cell.leftImagView.image = [UIImage imageNamed:@"灯泡关"];
            
        }
        cell.switchType = DVSwitchTypeDoDevice;
        NSArray *array = @[@"关",@"翻转",@"开"];
        [cell setUpCellUIWithArray:array];
    }else if ([data.picture.firstObject isEqualToString:@"5"]) {//窗帘
        cell.switchType = DVSwitchTypeWindowDevice;
        cell.leftImagView.image = [UIImage imageNamed:@"窗帘"];
        NSArray *array = @[@"关",@"停止",@"开"];
        [cell setUpCellUIWithArray:array];
    }
    cell.doData = data;
    
    __weak typeof (self) weakSelf = self;
    [cell sceneCellWithBlock:^(NSInteger index) {
        __strong typeof (self) strongSelf = weakSelf;
        NSString *str = [NSString stringWithFormat:@"%ld", (long)index];
        NSLog(@"row-%ld",indexPath.row);
        strongSelf.doSwicherArray[indexPath.row] = str;
        
        HRDOData *data = [HRDOData mj_objectWithKeyValues:strongSelf.doArray[indexPath.row]];
        NSMutableArray *arr = (NSMutableArray *)data.parameter;
        arr[2] = str;
        data.parameter = arr;
        
        strongSelf.doArray[indexPath.row] = data;
        
    }];
    cell.titleLabel.text = data.parameter[1];
    cell.detailLabel.text = self.doTextArray[indexPath.row];
    
}
///设置空调cell
- (void)setAirTextCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.leftImagView.image = [UIImage imageNamed:@"空调"];
    cell.switchType = DVSwitchTypeAirDevice;
    NSDictionary *dict = self.airArray[indexPath.row];
    __block IracData *data = [IracData mj_objectWithKeyValues:dict];
    NSString *str ;
    if ([data.version integerValue] >= 0) {
        
        NSString *status = [self setupStatusWithStatus:data.version];
        str = [NSString stringWithFormat:@"%@", status];
    }else
    {
        str = @"未选择操作";
    }
    cell.titleLabel.text = data.title;
    cell.detailLabel.text = self.airTextArray[indexPath.row];
    
    NSArray *array = @[str];
    [cell setUpCellUIWithArray:array];
    
    __weak typeof (self) weakSelf = self;
    
    [cell sceneCellWithModelSelectBlock:^(NSString *selectString) {
        data.version = selectString;
        weakSelf.airArray[indexPath.row] = data;
        [weakSelf.sceneTableView reloadData];
    }];
    
    
    
}
///设置通用cell
- (void)setCurrencyTextCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.leftImagView.image = [UIImage imageNamed:@"小睿通用关"];
    __weak typeof (self) weakSelf = self;
    [cell sceneCellWithPickerBlock:^(NSString *nameKey, NSString *numberKey) {
        if (![nameKey isEqualToString:@""]) {//传过来的值有可能为空
            weakSelf.gmPickerArray[indexPath.row] = nameKey;
            weakSelf.gmNumberArray[indexPath.row] = numberKey;
        }
        [weakSelf.sceneTableView reloadData];
    }];
    cell.switchType = DVSwitchTypeCurrencyDeviceAndTvDevice;
    NSArray *array = @[self.gmPickerArray[indexPath.row]];
    [cell setUpCellUIWithArray:array];
    
    NSDictionary *dict = self.currencyArray[indexPath.row];
    IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
    cell.gmData  = data;
    cell.titleLabel.text = data.title;
    cell.detailLabel.text = self.currencyTextArray[indexPath.row];
}
///设置TV cell
- (void)setTvTextCell:(SceneCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.leftImagView.image = [UIImage imageNamed:@"电视关"];
    __weak typeof (self) weakSelf = self;
    [cell sceneCellWithPickerBlock:^(NSString *nameKey, NSString *numberKey) {
        if (![nameKey isEqualToString:@""]) {//传过来的值有可能为空
            weakSelf.tvPickerArray[indexPath.row] = nameKey;
            weakSelf.tvNumberArray[indexPath.row] = numberKey;
        }
        [weakSelf.sceneTableView reloadData];
    }];
    
    cell.switchType = DVSwitchTypeCurrencyDeviceAndTvDevice;
    NSArray *array = @[self.tvPickerArray[indexPath.row]];
    [cell setUpCellUIWithArray:array];
    
    NSDictionary *dict = self.tvArray[indexPath.row];
    IrgmData *data = [IrgmData mj_objectWithKeyValues:dict];
    cell.gmData = data;
    cell.titleLabel.text = data.title;
    cell.detailLabel.text = self.tvTextArray[indexPath.row];
}

- (NSString *)setupStatusWithStatus:(NSString *)status
{
    NSString *str;
    switch ([status intValue]) {
        case 0:
            str = @"关";
            break;
        case 1:
            str = @"开";
            break;
        case 2:
            str = @"自动模式";
            break;
        case 3://无效
            
            break;
        case 4:
            str = @"制冷模式";
            break;
        case 5:
            str = @"除湿模式";
            break;
        case 6:
            str = @"送风模式";
            break;
        case 7:
            str = @"制暖模式";
            break;
        case 8:
            str = @"自动风速";
            break;
        case 9:
            str = @"风速1档";
            break;
        case 10:
            str = @"风速2档";
            break;
        case 11:
            str = @"风速3档";
            break;
        case 12:
            str = @"自动摆风";
            break;
        case 13:
            str = @"手动摆风";
            break;
        case 14://无效
            
            break;
        case 15://无效
            
            break;
        case 16:
            str = @"温度16℃";
            break;
        case 17:
            str = @"温度17℃";
            break;
        case 18:
            str = @"温度18℃";
            break;
        case 19:
            str = @"温度19℃";
            break;
        case 20:
            str = @"温度20℃";
            break;
        case 21:
            str = @"温度21℃";
            break;
        case 22:
            str = @"温度22℃";
            break;
        case 23:
            str = @"温度23℃";
            break;
        case 24:
            str = @"温度24℃";
            break;
        case 25:
            str = @"温度25℃";
            break;
        case 26:
            str = @"温度26℃";
            break;
        case 27:
            str = @"温度27℃";
            break;
        case 28:
            str = @"温度28℃";
            break;
        case 29:
            str = @"温度29℃";
            break;
        case 30:
            str = @"温度30℃";
            break;
        default:
            break;
    }
    return str;
}
@end
