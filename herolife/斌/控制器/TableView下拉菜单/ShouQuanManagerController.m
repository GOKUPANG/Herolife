//
//  ShouQuanManagerController.m
//  herolife
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ShouQuanManagerController.h"
#import "ViewOfCustomerTableViewCell.h"
#import "CustomerInfoSectionView.h"
#import "FTPopOverMenu.h"
#import "YXCustomAlertView.h"
#import "SRActionSheet.h"



#define MENU_HEADER_VIEW_KEY    @"headerview"
#define MENU_OPENED_KEY         @"open"
#define FILTER_TITLE_KEY        @"title"
#define FILTER_ITEMS_KEY        @"values"
#define FILTER_IMAGES_KEY        @"image"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *ViewOfCustomerTableViewCellIdentifier = @"ViewOfCustomerTableViewCellIdentifier";

@interface ShouQuanManagerController ()<UITableViewDataSource,UITableViewDelegate,CustomerInfoSectionViewDelegate,SRActionSheetDelegate>

@property(nonatomic,strong)UITableView *listTableView;



#pragma mark -原来的数据源  决定有多少个section 要修改
/** 待修改  */
@property(nonatomic,strong)NSMutableArray *dataArray;


@property (assign, nonatomic) NSInteger openedSection;


@property(nonatomic,strong)NSArray *cellArray;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar * navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView * backImgView;

/**  增加密码名字输入框*/

@property(nonatomic,strong)UITextField *       AddPswNameField;

/**  家人分享用户名输入框*/
@property(nonatomic,strong)UITextField *       AddPswNumberField;


/** 家人分享弹窗*/
@property(nonatomic,strong)YXCustomAlertView * FamilyAlertView;


/** 临时分享弹窗*/
@property(nonatomic,strong)YXCustomAlertView * TemporaryAlertView;


/** 临时授权手机号码输入框*/

@property(nonatomic,strong)UITextField * PhoneTfield;



/** 临时授权时间输入框*/

@property(nonatomic,strong)UITextField * TimeTfield;




@end

@implementation ShouQuanManagerController

#pragma mark - tabbar 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //	self.tabBarController.view.hidden = YES;
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = YES;
        }
    }
    
    
    
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

}


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


#pragma mark - 导航条左边返回方法
-(void)popToLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.openedSection = NSNotFound;
    _dataArray = [[NSMutableArray alloc]init];
    //_listTableView要显示的section数目
    for (int i = 0; i < 5; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"55555" forKey:@"detail"];
        [_dataArray addObject:dic];
        
    }
    
    #pragma mark -这里决定下拉的cell的数目
    _cellArray = @[@"1",@"2"];//下拉显示的cell的数量
    
    
    #pragma mark -View背景颜色

    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    self.backImgView             = backgroundImage;
    
    [self.view addSubview:self.backImgView];
    
    UIView *view                 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor         = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];

    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"授权管理";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    
    
    navView.rightLabel.text = @"添加";
    
    navView.rightLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddShouQuan:)];
    
    [navView.rightLabel addGestureRecognizer:tap];

    self.navView = navView;

    
    
    
    
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10.f, 64.f,CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 20.f, [[UIScreen mainScreen] applicationFrame].size.height - 20.f)  style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerClass:[ViewOfCustomerTableViewCell class] forCellReuseIdentifier:ViewOfCustomerTableViewCellIdentifier];
    _listTableView.allowsSelection = YES;
    _listTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_listTableView];
	
	//通知
	[self addObserverNotification];
	
}



#pragma mark - 家人分享弹窗UI设置
-(void)makeFamilyAlerView
{
    /** FixAlertView;
     AddAlertView;
     FixField;
     AddPswNameField;
     AddPswNumberField;
     */
    CGFloat dilX = 25;
    CGFloat dilH = 230;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"家人分享";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = @"用户名";
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
    loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    
    loginPwdField.leftViewMode = UITextFieldViewModeAlways;
    loginPwdField.leftView = leftView;
    
    
    loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginPwdField.layer.borderWidth = 1;
    loginPwdField.layer.cornerRadius = 4;
    
    loginPwdField.placeholder = @"想要授权的用户";
    
    loginPwdField.textColor = [UIColor whiteColor];
    
    
    
    

    
    
/*************************************远程开锁开关**************************************/
    
    UISwitch * OpenLockSWitch = [[UISwitch alloc]initWithFrame:CGRectMake(alertV.frame.size.width -  70, 100, 0, 0)];
    
    
    
    
    
    UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
    
    [alertV addSubview:PswLabel];
    PswLabel.text = @"远程开锁";
    PswLabel.textColor = [UIColor whiteColor];
    
    PswLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    UILabel * recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, loginX, 32)];
    
    [alertV addSubview:recordLabel];
    recordLabel.text = @"记录查询";
    recordLabel.textColor = [UIColor whiteColor];
    
    recordLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
/*************************************记录查询开关**************************************/

    UISwitch * recordSWitch = [[UISwitch alloc]initWithFrame:CGRectMake(alertV.frame.size.width -  70, 150, 0, 0)];
    
    
    alertV.alpha=0;
    
    self.AddPswNumberField = loginPwdField;
    

    
    
    
    
    
    self.FamilyAlertView = alertV;
    
    [alertV addSubview:self.AddPswNumberField];
    
    [alertV addSubview: OpenLockSWitch];
    [alertV addSubview:recordSWitch];
    

    
    
//    [alertV addSubview:self.AddPswNameField];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.FamilyAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.FamilyAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        //  [customAlertView dissMiss];
        
        
    }];
    
}


#pragma mark - 临时分享弹窗

-(void)makeTemporaryAlertView
{
    CGFloat dilX = 25;
    CGFloat dilH = 200;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"临时授权";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = @"手机号码";
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
    loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    
    loginPwdField.leftViewMode = UITextFieldViewModeAlways;
    loginPwdField.leftView = leftView;
    
    
    loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginPwdField.layer.borderWidth = 1;
    loginPwdField.layer.cornerRadius = 4;
    
    loginPwdField.placeholder = @"授权对象的手机号码";
    
    loginPwdField.textColor = [UIColor whiteColor];
    
    
    
    
    UITextField * PSWNameField = [[UITextField alloc]initWithFrame:CGRectMake(loginX, 100, alertV.frame.size.width -  loginX*1.2, 32)];
    
    PSWNameField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    
    
    PSWNameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    PSWNameField.leftView = leftView1;
    
    
    PSWNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    PSWNameField.layer.borderWidth = 1;
    PSWNameField.layer.cornerRadius = 4;
    
    PSWNameField.placeholder = @"授权时长";
    
    PSWNameField.textColor = [UIColor whiteColor];
    
    
    
    
    
    
    UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
    
    [alertV addSubview:PswLabel];
    PswLabel.text = @"时间";
    PswLabel.textColor = [UIColor whiteColor];
    
    PswLabel.textAlignment = NSTextAlignmentCenter;
    
    
    alertV.alpha=0;
    
    self.PhoneTfield = loginPwdField;
    
    self.TimeTfield = PSWNameField;
    
    
    self.TemporaryAlertView = alertV;
    
    [alertV addSubview:self.PhoneTfield];
    
    [alertV addSubview:self.TimeTfield];
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.TemporaryAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.TemporaryAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        //  [customAlertView dissMiss];
        
        
    }];

}


#pragma mark - YXCustomAlertViewDelegate 家人分享与临时授权的弹窗选中 

- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{  if (buttonIndex==0) {
    
    
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        CGRect AlertViewFrame = customAlertView.frame;
        
        AlertViewFrame.origin.x = -50;
        
        customAlertView.alpha = 0;
        
        
        
        customAlertView.frame = AlertViewFrame;
        
        
        
        
        
    } completion:^(BOOL finished) {
        
        
        [customAlertView dissMiss];
        
        
    }];
    
    
    
    
    }
    
    
    if (buttonIndex == 1) {
        
        
        
        
        
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            CGRect AlertViewFrame = customAlertView.frame;
            
            AlertViewFrame.origin.x = HRUIScreenW;
            
            
            customAlertView.frame = AlertViewFrame;
            
            customAlertView.alpha = 0;
            
            
            
            
            
            
        } completion:^(BOOL finished) {
            
            
            [customAlertView dissMiss];
            
        }];
    }
    
    
    
   




}
#pragma mark -增加授权

-(void)AddShouQuan: (UITapGestureRecognizer*)tap

{

    [FTPopOverMenu showForSender:self.navView.rightLabel withMenu:@[@"家人分享",@"临时授权"]
                       doneBlock:^(NSInteger selectedIndex) {
                           
                       /** 在这里增加弹窗*/
                           
                           //选中第一个家人分享
                           if (selectedIndex ==0) {
                               [self makeFamilyAlerView];

                           }
                           
                           
                           //选中第二个临时授权
                           
                           else{
                               
                               [self makeTemporaryAlertView ];
                               
                           }
                           
                
                           
                       } dismissBlock:^{
                           
                       }];

}




#pragma mark - haibo
- (NSArray *)autherArray
{
	if (!_autherArray) {
		_autherArray = [NSArray array];
	}
	return _autherArray;
}
- (NSArray *)autherDeviceArray
{
	if (!_autherDeviceArray) {
		_autherDeviceArray = [NSArray array];
	}
	return _autherDeviceArray;
}
#pragma mark - haibo 通知相关
- (void)addObserverNotification
{
	[kNotification addObserver:self selector:@selector(receiveAutherInformation) name:kNotificationReceiveDeviceAutherInformation object:nil];
}
- (void)receiveAutherInformation
{
	AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication];
	self.autherArray = app.autherArray;
	self.autherDeviceArray = app.autherDeviceArray;
}
#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //根据字典里的MENU_OPENED_KEY的值来显示或者隐藏下拉的cell
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:section];
    return [[sectionInfo objectForKey:MENU_OPENED_KEY] boolValue] ? [_cellArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}



#pragma mark - 每组的头部视图的设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    CustomerInfoSectionView *view = [dic objectForKey:MENU_HEADER_VIEW_KEY];
    if (!view)
    {
        view = [[CustomerInfoSectionView alloc]init];

        
        //在这里写入头部视图的信息
        
        
        [view initWithImgName:@"邮箱" userNameLabel:@"test01" timeLabel:@"永久" section:section delegate:self];
        
        
        [dic setObject:view forKey:MENU_HEADER_VIEW_KEY];
        if (section % 2 == 0)
        {
            //view.backgroundColor = UIColorFromRGB(0xf8f8f8);
            
           // view.backgroundColor = [UIColor redColor];
            
            
        }
        
    }
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewOfCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ViewOfCustomerTableViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row ==0) {
        cell.nameLabel.text = @"远程开锁";
        cell.warnImgView.image = [UIImage imageNamed:@"未选择"] ;

    }
    
    else{
        cell.nameLabel.text = @"操作查询";
        cell.warnImgView.image = [UIImage imageNamed:@"授权选择"] ;

    }
  
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    return cell;
}
#pragma mark - 选中cell 出现底部弹出框;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 这里应该要把cell所在的组数传下去才能相应的修改 */
    
    [SRActionSheet sr_showActionSheetViewWithTitle:@""
                              cancelButtonTitle:@"取消"
                         destructiveButtonTitle:@""
                              otherButtonTitles:@[@"取消该授权", @"修改授权信息"]
                                       delegate:self];
}


#pragma mark -底部弹出sheet选中方法

-(void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index
{
    
    /** 0 是取消该授权
        1 是修改授权信息
       -1 是取消*/
    NSLog(@"%ld", index);
    
}





#pragma mark Section header delegate

-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
{
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:sectionHeaderView.section];
    [sectionInfo setObject:[NSNumber numberWithBool:YES] forKey:MENU_OPENED_KEY];//将当前打开的section标记为1
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_cellArray count]; i++)
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }//点击显示下拉的cell，将其加入到indexPathsToInsert数组中
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openedSection;
    if (previousOpenSectionIndex != NSNotFound)//有点开的section，这样打开新的section下拉菜单时要把先前的scetion关闭
    {
        NSMutableDictionary *previousOpenSectionInfo = [_dataArray objectAtIndex:previousOpenSectionIndex];
        CustomerInfoSectionView *previousOpenSection = [previousOpenSectionInfo objectForKey:MENU_HEADER_VIEW_KEY];
        [previousOpenSectionInfo setObject:[NSNumber numberWithBool:NO] forKey:MENU_OPENED_KEY];
        [previousOpenSection toggleOpenWithUserAction:NO];//箭头方向改变
        [UIView animateWithDuration:.3 animations:^{
            previousOpenSection.arrow.transform = CGAffineTransformIdentity;
        }];
        for (int i = 0; i < [_cellArray count]; i++)//将要关闭的cell写入indexPathsToDelete数组中
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;//系统提供的显示下拉cell菜单动画
    UITableViewRowAnimation deleteAnimation;//关闭下拉菜单动画
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.listTableView beginUpdates];
    [self.listTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];//将之前插入到indexPathsToInsert数组中的cell都插入显示出来
    [self.listTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];//将之前打开得下拉菜单关闭
    [self.listTableView endUpdates];
    self.openedSection = sectionOpened;
}

-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:sectionHeaderView.section];
    [sectionInfo setObject:[NSNumber numberWithBool:NO] forKey:MENU_OPENED_KEY];
    NSInteger countOfRowsToDelete = [self.listTableView numberOfRowsInSection:sectionClosed];
    if (countOfRowsToDelete > 0)
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.listTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openedSection = NSNotFound;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
