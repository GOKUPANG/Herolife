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

#define MENU_HEADER_VIEW_KEY    @"headerview"
#define MENU_OPENED_KEY         @"open"
#define FILTER_TITLE_KEY        @"title"
#define FILTER_ITEMS_KEY        @"values"
#define FILTER_IMAGES_KEY        @"image"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *ViewOfCustomerTableViewCellIdentifier = @"ViewOfCustomerTableViewCellIdentifier";

@interface ShouQuanManagerController ()<UITableViewDataSource,UITableViewDelegate,CustomerInfoSectionViewDelegate>

@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger openedSection;
@property(nonatomic,strong)NSArray *cellArray;

/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;


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
    _cellArray = @[@"1",@"2",@"3"];//下拉显示的cell的数量
    
    
    #pragma mark -View背景颜色

    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    [self.view addSubview:backgroundImage];
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"智能开锁";
    [navView.leftButton addTarget:self action:@selector(popToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:navView];
    self.navView = navView;

    
    
    
    
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10.f, 64.f,CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 20.f, [[UIScreen mainScreen] applicationFrame].size.height - 20.f)  style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerClass:[ViewOfCustomerTableViewCell class] forCellReuseIdentifier:ViewOfCustomerTableViewCellIdentifier];
    _listTableView.allowsSelection = YES;
    _listTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_listTableView];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    CustomerInfoSectionView *view = [dic objectForKey:MENU_HEADER_VIEW_KEY];
    if (!view)
    {
        view = [[CustomerInfoSectionView alloc]init];
        [view initWithNameLabel:@"陈" ManagerNameLabel:@"周" DepartmentLabel:@"111" AddressLabel:@"222" section:section delegate:self];
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
    cell.nameLabel.text = @"周锋";
    cell.managerNameLabel.text = @"胡楠";
    cell.departmentLabel.text = @"CUC";
    cell.addressLabel.text = @"南京鼓楼";
  //  cell.backgroundColor = [UIColor whiteColor];
  //  cell.backgroundColor = [UIColor yellowColor];
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
