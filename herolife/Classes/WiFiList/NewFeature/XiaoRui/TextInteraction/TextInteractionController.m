//
//  TextInteractionController.m
//  xiaorui
//
//  Created by sswukang on 16/4/19.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "TextInteractionController.h"
#import "XiaoRuiCell.h"
#import "UserCell.h"
#import <MJExtension.h>
#import "HRMessageData.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import "XMGHeader.h"
#import "DeviceListModel.h"

@interface TextInteractionController ()< UITableViewDelegate,UITableViewDataSource,UITextViewDelegate, YXCustomAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UITextView *chartText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//chartText的父控件
@property (weak, nonatomic) IBOutlet UIView *chartView;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** 存放从数据库加载的所有数据 */
@property(nonatomic, strong) NSMutableArray *sqlArray;

/** mid */
@property(nonatomic, copy) NSString *mid;


/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property(nonatomic,strong) YXCustomAlertView *  modifyNameAlertView;
/** <#name#> */
@property(nonatomic, weak) UITextField *nameField;

@end

@implementation TextInteractionController
static NSString *xiaoruiID = @"xiaorui";
static NSString *userID = @"user";
- (NSMutableArray *)messageArray
{
	if (!_messageArray) {
		_messageArray = [NSMutableArray array];
	}
	return _messageArray;
}
- (NSMutableArray *)sqlArray
{
	if (!_sqlArray) {
		_sqlArray = [NSMutableArray array];
	}
	return _sqlArray;
}


- (void)setDeviceModel:(DeviceListModel *)deviceModel
{
    _deviceModel = deviceModel;
    self.mid = deviceModel.did;
    
    DDLogInfo(@"文本交互的mid是%@", self.mid);
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


- (void)viewDidLoad {
    [super viewDidLoad];
	
     //彬添加  加入导航条 和 tabbar
    [self addBar ];
    //初始化
	[self setUpView];
    
    
	//注册ID
	[self.tableView registerNib:[UINib nibWithNibName:@"XiaoRuiCell" bundle:nil] forCellReuseIdentifier:xiaoruiID];
	[self.tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:userID];
	
	// 告诉tableView所有cell的真实高度是自动计算（根据设置的约束来计算）
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	// 告诉tableView所有cell的估算高度
	self.tableView.estimatedRowHeight = 400;
	
	// 集成刷新控件
	[self addMjRefresh];
	//添加通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithMessage:) name:kNotificationMessage object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
	//连接
	[self postTokenWithTCPSocket];
    [self registerForKeyboardNotifications];
	
}


#pragma mark  - 添加bar


-(void)addBar
{
    
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HRUIScreenW, HRUIScreenH-40)];
//    
//    backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
//    self.backImgView = backgroundImage;
//    
//    
//    
//    [self.view addSubview:self.backImgView];
//    
//    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//    [self.view addSubview:view];
//    
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"文本交互";
    
   
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;
    
}



#pragma mark - 左键返回 


- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 刷新相关
- (void)addMjRefresh
{
	self.tableView.mj_header = [XMGHeader headerWithRefreshingTarget:self refreshingAction:@selector(getSqliteData)];
}

static int refreshCount = 1;
- (void)getSqliteData
{
	refreshCount++;
	[self.tableView.mj_header endRefreshing];
	DDLogInfo(@"sqlArray.count%lu", (unsigned long)self.sqlArray.count);
	if (self.sqlArray.count <= 30) {
		return;
	}
	[self.messageArray removeAllObjects];
	[self setupmessageArrayWithRefreshCount:refreshCount];
	[self.tableView reloadData];
	DDLogInfo(@"messageArray.count%lu", (unsigned long)self.messageArray.count);
}
/**
 *  下拉刷新时,加载数据
 *
 *  @param refreshCount 下拉的次数
 *  @param index        下标
 */
- (void)setupmessageArrayWithRefreshCount:(int)refreshCount
{
	if (self.sqlArray.count <= refreshCount *30) {
		for (id objec in self.sqlArray) {
			[self.messageArray addObject:objec];
		}
		
	}else
	{
		int count = (int)self.sqlArray.count;
		for (int i = refreshCount *30 -1; i >= 0; i--) {
			[self.messageArray addObject:self.sqlArray[count - i-1]];
		}
	}
}
//初始化

#pragma mark tableView 的视图设置
- (void)setUpView
{
	self.chartText.delegate = self;
    
    self.chartText.layoutManager.allowsNonContiguousLayout = NO;
	
    self.tableView.backgroundColor = [UIColor clearColor];

    
    //彬修改  
//    self.tableView.backgroundView =[[UIImageView alloc  ]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    
    
    
    
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.showsHorizontalScrollIndicator = NO;
//	self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 40, 0);
	
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    NSString *userName = [kUserDefault objectForKey:kUserDefaultTextVCUserName];
    if (!userName) {
        
        [self addModifyUserNameAlertView];
    }
    //从数据库加载保存的文本数据
    
    NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
    
    NSString *mid = self.mid;
    
    //NSString *mid = [kUserDefault objectForKey:kdefaultsIracMid];
    //NSMutableArray *messageArray = [NSMutabl eArray array];
    
    NSMutableArray *messageArray = [HRSqlite hrSqliteReceiveTextInteractionWithUid:uid mid:mid];
    
    
    [self.messageArray removeAllObjects];
    [self.sqlArray removeAllObjects];
    self.sqlArray = messageArray;
    for (int i = 0; i < messageArray.count; i++) {
        if (messageArray.count <= 30) {
            [self.messageArray addObject:messageArray[i]];
            
        }else
        {
            if (i > messageArray.count - 30 -1) {
                
                [self.messageArray addObject:messageArray[i]];
            }
            
        }
    }
    
    
    [self.tableView reloadData];
    if (self.messageArray.count > 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - UIScreenH + 50) animated:NO];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    }
    
    
    
    
    
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = YES;
        }
    }
    
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

    
    
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"view%@tableView---------%@",NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.tableView.frame));
    
//    [self.tableView reloadData];
//    if (self.messageArray.count > 0) {
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//
//        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - UIScreenH + 50) animated:NO];
////        NSLog(@"indexPath:%@", indexPath);
//    }
    
    NSLog(@"view.frame%@tableView%@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.tableView.frame));
}


- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	refreshCount = 1;
    
    
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = NO;
        }
    }
    
    [kNotification removeObserver:self];

}
#pragma mark - textFieldDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[self.addBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	[self.addBtn setTitle:@"发送" forState:UIControlStateNormal];
	self.addBtn.backgroundColor = [UIColor themeColor];
	return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		/// 调用你需要处理的事情  ///
		self.bottomView.constant = 0;
		return NO;
	}
	return YES;
}

#pragma mark - 接收数据 通知
- (void)receviedWithNotOnline
{
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showErrorWithStatus:@"目标不在线!" ];
}
- (void)receviedWithMessage:(NSNotification *)note
{
    
    
//	self.tableView.contentInset = UIEdgeInsetsZero;
	NSDictionary *dict = note.userInfo;
	HRMessageData *data = [HRMessageData mj_objectWithKeyValues:dict[@"msg"]];
	NSString *mid = [kUserDefault objectForKey:kdefaultsIracMid];
    mid = self.mid;
    
    
	if (![data.mid isEqualToString:mid]) {
		return;
	}
	
	NSString *title = [kUserDefault objectForKey:kUserDefaultTextVCUserName];
    
    
	if (![data.title isEqualToString:title]) {
		[self.messageArray addObject:data];
		DDLogWarn(@"%lu",(unsigned long)self.messageArray.count);
		[self.sqlArray addObject:data];
		[self.tableView reloadData];
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
		//保存到数据库
		[HRSqlite hrSqliteSaveTextInteractionWithObject:data];
		
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
#pragma mark - 发送数据
- (void)sendSocketData
{
	self.tableView.contentInset = UIEdgeInsetsZero;
	/// 发送开关 控制请求帧
	NSString *time = [NSString loadCurrentDate];
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *userFrom = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
    
    
    
	NSString *devFrom = [kUserDefault objectForKey:kUserDefaultUUID];
	NSString *userTo = userFrom;
    
    
	NSString *devTo = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
    

    
    devTo= self.deviceModel.uuid;
    
   
	
    NSString *uid = self.deviceModel.uid;
    
    
    NSString * mid = self.mid;
    
	
    NSString *did = self.mid;
    

    NSString *uuid = self.deviceModel.uuid;
    
	NSString *created = [NSString loadCurrentDate];
	NSString *title = [kUserDefault objectForKey:kUserDefaultTextVCUserName];
    
    
	NSString *mess = self.chartText.text;
    mess = [mess stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	
	NSString *str = [NSString stringWithFormat:@"{\"hrpush\":{\"version\":\"0.0.1\",\"status\":\"200\",\"time\":\"%@\",\"token\":\"%@\",\"type\": \"message\",\"desc\": \"msg\",\"src\":{\"user\": \"%@\", \"dev\":\"%@\"},\"dst\":{\"user\": \"%@\",\"dev\":\"%@\"}},\"msg\":{\"uid\":\"%@\",\"mid\":\"%@\",\"did\":\"%@\",\"uuid\":\"%@\",\"created\":\"%@\",\"title\":\"%@\",\"mess\":\"%@\"}}", time, token, userFrom,devFrom,userTo,devTo,uid,mid,did,uuid, created, title,mess];
	
	
	NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
	/// 把二进制数据 转成JSON字典
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
	
	
	NSString *hrpush = @"hrpush\r\n";
	
	NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)str.length];
	
	NSString *footerStr = @"\r\n\0";
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, str, footerStr];
	
	//清空文本
	self.chartText.text = @"";

	[self.messageArray addObject:jsonDict[@"msg"]];
	[self.sqlArray addObject:jsonDict[@"msg"]];
	[self.tableView reloadData];
		
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];

	
	//发送数据
	[self.appDelegate sendMessageWithString:urlString];
	
	NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
	DDLogWarn(@"path%@",path);
    
    
    NSLog(@"发送的json字典是%@",jsonDict[@"msg"]);
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
	//把发的数据存到数据库中
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		[HRSqlite hrSqliteSaveTextInteractionWithObject:jsonDict[@"msg"]];
	});
}

- (IBAction)addBtnClick:(UIButton *)sender {
	
	if ([self.addBtn.currentTitle isEqualToString:@"发送"]) {
		
		//发送
		if (self.chartText.text.length > 0 && ![self.chartText.text isEqualToString:@""]) {
			[self sendSocketData];
		}else
		{
			[SVProgressTool hr_showErrorWithStatus:@"发送的信息不能为空!"];
		}
	}else{
        [self addModifyUserNameAlertView];

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	HRMessageData *data = [HRMessageData mj_objectWithKeyValues:self.messageArray[indexPath.row]];
	NSString *title = [kUserDefault objectForKey:kUserDefaultTextVCUserName];
    
	if (![data.title isEqualToString:title]) {
		XiaoRuiCell *xiaoRuiCell = [tableView dequeueReusableCellWithIdentifier:xiaoruiID];
		xiaoRuiCell.data = data;
		cell = xiaoRuiCell;
	}else
	{
		UserCell *userCell = [tableView dequeueReusableCellWithIdentifier:userID];
		userCell.data = data;
		cell =  userCell;
	}
    cell.backgroundColor = [UIColor clearColor];
    
    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.chartText resignFirstResponder];
	[UIView animateWithDuration:0.5 animations:^{
		
		self.bottomView.constant = 0;
	}];
	DDLogInfo(@"%s", __func__);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.bottomView.constant = 0;
    }];
    
    [self.view endEditing:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		self.tableView.contentInset = UIEdgeInsetsZero;
		
	});
    
    
    //彬添加   tableView 开始滚动的时候 键盘下退
    
   // [self.view endEditing:YES];
    
}





#pragma mark - 监听键盘的事件
- (void)registerForKeyboardNotifications
{
	//使用NSNotificationCenter 鍵盤出現時
	[[NSNotificationCenter defaultCenter] addObserver:self
	 
											 selector:@selector(keyboardWasShown:)
	 
												 name:UIKeyboardDidShowNotification object:nil];
	
	//使用NSNotificationCenter 鍵盤隐藏時
	[[NSNotificationCenter defaultCenter] addObserver:self
	 
											 selector:@selector(keyboardWillBeHidden:)
	 
												 name:UIKeyboardWillHideNotification object:nil];
	
	
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	//kbSize即為鍵盤尺寸 (有width, height)
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
	NSLog(@"hight_hitht:%f",kbSize.height);
	
//    [UIView animateWithDuration:0.15 animations:^{
//        
//        self.bottomView.constant = kbSize.height;
//    }];
    // 获取键盘隐藏动画时间
//    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    [UIView animateWithDuration:animationDuration animations:^{
//
//        self.bottomView.constant = kbSize.height;
//    }];

    
    self.bottomView.constant = kbSize.height;
	self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
	//不加上这句会挡掉一部分cell
    
    
//    [self.tableView reloadData];
    if (self.messageArray.count != 0) {
     
        NSLog(@"view%@tableView---------%@",NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.tableView.frame));
        
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - UIScreenH + kbSize.height + 50) animated:NO];
        [self.tableView reloadData];
//        [self.tableView setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//        NSLog(@"%f", self.tableView.contentSize.height);
//        [self.view layoutIfNeeded];
//        NSIndexPath *path = [NSIndexPath indexPathForRow:self.messageArray.count -1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        [self.tableView reloadData];
    }
    
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//	self.tableView.contentInset = UIEdgeInsetsZero;
	self.bottomView.constant = 0;
}



#pragma mark -添加 YXCustomAlertView 弹窗 相关  第三方demo方法
-(void)addModifyUserNameAlertView
{
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    // alertV.tag = tag;
    alertV.delegate = self;
    alertV.titleStr = @"设置您的昵称";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:nameLabel];
    nameLabel.text = @"昵称";
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
    
    nameField.placeholder = @"请输入您的昵称";
    
    
    
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    nameField.textColor = [UIColor blackColor];
    
    
    
    
    self.nameField = nameField;
    
    
    [alertV addSubview:self.nameField];
    
    
    
    self.modifyNameAlertView = alertV;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.modifyNameAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.modifyNameAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
}

- (void) customAlertView:(YXCustomAlertView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        [SVProgressTool hr_showErrorWithStatus:@"用户昵称必须设置!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated: YES];
        });
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            CGRect AlertViewFrame = customAlertView.frame;
            
            AlertViewFrame.origin.y = 0;
            
            customAlertView.alpha = 0;
            
            
            
            customAlertView.frame = AlertViewFrame;
            
        } completion:^(BOOL finished) {
            
            
            [customAlertView dissMiss];
            
            
        }];
    }else{
        
        
        
        if (self.nameField.text.length == 0 ) {
            [customAlertView.layer shake];
            [SVProgressTool hr_showErrorWithStatus:@"用户昵称不能为空!"];
            return;
            
        }
        
        [kUserDefault setObject:self.nameField.text forKey:kUserDefaultTextVCUserName];
        
        [UIView animateWithDuration:0.8 animations:^{
            
            
            CGRect AlertViewFrame = customAlertView.frame;
            
            AlertViewFrame.origin.y = HRUIScreenH ;
            
            
            customAlertView.frame = AlertViewFrame;
            
            customAlertView.alpha = 0;
            
            
        } completion:^(BOOL finished) {
            
            
            [customAlertView dissMiss];
            
        }];
        
        
    }
}

- (void)dealloc
{
	 [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
