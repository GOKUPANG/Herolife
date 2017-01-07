

#define MAS_SHORTHAND

#define MAS_SHORTHAND_GLOBALS
#import "SwitchViewController.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "HRDOData.h"
#import "TipsLabel.h"
#import "InfraredDeviceCell.h"
#import "DoTableViewCell.h"
#import "DofooterView.h"

@interface SwitchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate>

/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** TipsLabel */
@property(nonatomic, strong) TipsLabel *tipsLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
/** btn */
@property(nonatomic, weak) UIButton *btn;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** tableview */
@property(nonatomic, strong) DofooterView *footerView;

@property(nonatomic, strong) UIView *popView;

/**  collectionCell  arr*/
@property(nonatomic, strong) NSMutableArray *iracArray;
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;

@end

@implementation SwitchViewController


- (NSMutableArray *)iracArray
{
	if (_iracArray == nil) {
		_iracArray = [NSMutableArray array];
	}
	return _iracArray;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
    
    
    self.navigationController.navigationBar.hidden = YES;
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:backgroundImage];
    self.backgroundImage = backgroundImage;
    
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    
	/// 初始化
	[self setUp];
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = @"搜索添加开关";
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    
    

	[self postTokenWithTCPSocket];
	[self addNotificationCenterObserver];
	
	//添加提示框
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 64, UIScreenW, 30)];
	[self.view addSubview:self.tipsLabel];
	
	//添加tableview
	DofooterView *tableV = [[NSBundle mainBundle] loadNibNamed:@"DofooterView" owner:self options:nil].firstObject;
	tableV.layer.cornerRadius = 5;
	tableV.frame = CGRectMake(UIScreenW *0.1, UIScreenH *0.2, UIScreenW - UIScreenW*0.2, UIScreenH *0.08 + 240);
	self.footerView = tableV;
    self.footerView.hidden = YES;
//    self.footerView.hidden = NO;
	self.footerView.backgroundColor = [UIColor whiteColor];
	
	self.popView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.popView.backgroundColor = [UIColor clearColor];
	[self.popView addSubview:tableV];
    self.popView.hidden = YES;
//    self.popView.hidden = NO;
	[self.view addSubview:self.popView];
	//手势
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	tap.delegate = self;
	[self.popView addGestureRecognizer:tap];
	
}

-(void)viewWillAppear:(BOOL)animated
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
    
    
    /// 添加按钮
    [self addButton];
    
    NSLog(@"设置页面ViewWillappear");
    
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tipsLabel showText:@"请先让设备进入注册状态,并点击搜索按钮..." duration:5.0];
	
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	DDLogWarn(@"------------dealloc-----------");
	
	
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的创建帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithCreateDo:) name:kNotificationCreateDo object:nil];
	//监听空调的测试帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingDo:) name:kNotificationTestingDo object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
    //注册开关界面创建成功之后跳转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithDofooterViewPop) name:kNotificationDofooterViewPop object:nil];
    
}
- (void)receviedWithDofooterViewPop
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        for (UIView *view in self.footerView.subviews) {
//            view.hidden = YES;
//        }
        
        [UIView animateWithDuration:0.5 animations:^{
//            self.footerView.frame = CGRectMake(UIScreenW *0.5, UIScreenH *0.2, 0, 0);
            self.footerView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
            
        } completion:^(BOOL finished) {
            
            [self.footerView removeFromSuperview];
            [self.popView removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
    });
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}

#pragma mark -  通知处理方法
// ---------------------------------------------空调 start----------------------------------------------

//监听空调的创建帧
- (void)receviedWithCreateDo:(NSNotification *)notification
{
	DDLogInfo(@"infer空调的创建帧 ---iracArray-%@", self.iracArray);
	[self.tipsLabel showText:@"添加设备成功..." duration:3.0];
	[self.collectionView reloadData];
	
}

//监听空调的测试帧
static BOOL isOvertime = NO;
- (void)receviedWithTestingDo:(NSNotification *)notification
{
	[SVProgressHUD dismiss];
    isOvertime = YES;
	NSDictionary *dict = notification.userInfo;
	HRDOData *data = [HRDOData mj_objectWithKeyValues:dict[@"msg"]];
	
	[self.iracArray removeAllObjects];
	[self.iracArray addObject:data];
	[self.tipsLabel showText:@"搜索到设备!" duration:3.0];
	
    
    NSInteger index = [data.parameter.firstObject integerValue];
    switch (index) {
        case 1:
        {
            
            _footerView.frame = CGRectMake(UIScreenW *0.1, UIScreenH *0.2, UIScreenW - UIScreenW*0.2, UIScreenH *0.08 + 220 - 40 *3);
        }
            break;
        case 2:
        {
            _footerView.frame = CGRectMake(UIScreenW *0.1, UIScreenH *0.2, UIScreenW - UIScreenW*0.2, UIScreenH *0.08 + 220 - 40 *2);
        }
            break;
        case 3:
        {
            _footerView.frame = CGRectMake(UIScreenW *0.1, UIScreenH *0.2, UIScreenW - UIScreenW*0.2, UIScreenH *0.08 + 220 - 40 *1);
        }
            break;
        case 4:
        {
            _footerView.frame = CGRectMake(UIScreenW *0.1, UIScreenH *0.2, UIScreenW - UIScreenW*0.2, UIScreenH *0.08 + 220 - 40 *0);
        }
            break;
            
        default:
            break;
    }
	//给footerV传值
	self.footerView.doData = data;
	
	[self.collectionView reloadData];
}

// 初始化
- (void)setUp
{
	self.view.backgroundColor = [UIColor clearColor];
	self.title = @"搜索添加开关";
	
	CGSize size = CGSizeMake(self.view.frame.size.width*0.4f, self.view.frame.size.width*0.4f * 3.f/2.f);
	UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
	layout.sectionInset = UIEdgeInsetsMake(10, size.width*0.15f, 0, size.width*0.15f);
	layout.itemSize = size;
	layout.minimumLineSpacing = 5.f;
	layout.minimumInteritemSpacing = 5.f;
	
	CGRect frame = CGRectMake(0, 0, self.view.hr_width, self.view.hr_height);
	_collectionView = [[UICollectionView alloc] initWithFrame:frame
										 collectionViewLayout:layout];
	_collectionView.delegate   = self;
	_collectionView.dataSource = self;
	_collectionView.backgroundColor = [UIColor clearColor];
	_collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0);
	UINib *cellNib = [UINib nibWithNibName:@"InfraredDeviceCell" bundle:nil];
	[_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
	
	[self.view addSubview:_collectionView];
	
	
}



#pragma mark - 添加按钮
- (void)addButton
{
	UIButton *reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	reBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -60, [UIScreen mainScreen].bounds.size.height - 60, 50, 50);
	reBtn.backgroundColor = [UIColor redColor];
	[reBtn setImage:[UIImage imageNamed:@"ic_action_refresh"] forState: UIControlStateNormal];
	reBtn.layer.cornerRadius = reBtn.frame.size.width * 0.5;
	[reBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:reBtn];
	self.btn = reBtn;
}

#pragma mark - UI事件
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addBtnClick
{
	DDLogDebug(@"------------addBtnClick");
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送搜索开关 请求帧
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUid];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracMid];
	
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	NSArray *parameter = [NSArray array];
	

	NSString *str = [NSString stringWithHRDOVersion:@"0.0.1" status:@"200" token:token type:@"search" desc:@"search desc message" srcUserName:user dstUserName:user dstDevName:uuid uid:uid mid:mid did:@"None" uuid:uuid types:@"hrdo" newVersion:@"0.0.1" title:@"None" brand:@"None" created:[NSString loadCurrentDate] update:[NSString loadCurrentDate] state:@"1" picture:picture regional:regional parameter:parameter];
	DDLogWarn(@
              "发送搜索开关 请求帧--%@",str);
	[SVProgressTool hr_showWithStatus:@"正在搜索设备..."];
	[self.appDelegate sendMessageWithString:str];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];

}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}
#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}
#pragma mark - CollectionViewSouse
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	DDLogInfo(@"self.iracArray.count%lu", (unsigned long)self.iracArray.count);
	return self.iracArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	InfraredDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	if (self.iracArray.count > 0) {
		DDLogInfo(@"iracArray%@", self.iracArray);
		HRDOData *dataDo = [HRDOData mj_objectWithKeyValues:self.iracArray[indexPath.row]];
		
		NSString * pictureStr = dataDo.picture.firstObject;
		if ([pictureStr isEqualToString:@"1"] || [pictureStr isEqualToString:@"2"] || [pictureStr isEqualToString:@"4"]) {
			cell.imageView.image = [UIImage imageNamed:@"灯泡关"];
			if ([pictureStr isEqualToString:@"1"]) {
				
				cell.titleLabel.text = @"智能开关";
			}else if ([pictureStr isEqualToString:@"2"]) {
				
				cell.titleLabel.text = @"智能开关";
			}else if ([pictureStr isEqualToString:@"4"]) {
				
				cell.titleLabel.text = @"智能开关盒";
			}
		}else if ([pictureStr isEqualToString:@"3"]) {
			cell.imageView.image = [UIImage imageNamed:@"插座关"];
			cell.titleLabel.text = @"智能插座";
		}else if ([pictureStr isEqualToString:@"5"]) {
			cell.imageView.image = [UIImage imageNamed:@"窗帘"];
			cell.titleLabel.text = @"智能窗帘控制器";
			cell.titleLabel.font = [UIFont systemFontOfSize:16];
		}
		
	}
	return cell;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	self.footerView.hidden = NO;
	self.popView.hidden = NO;
	DDLogWarn(@"footerView-%@", self.footerView);
}

#pragma mark - 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	DDLogWarn(@"footerView%@", [touch.view class]);
	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UICollectionView"]) {
		return NO;
	}
	return YES;
}

// UI事件
- (void)tapClick
{
	[self.view endEditing:YES];
}

@end
