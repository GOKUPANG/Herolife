//
//  APPPSWController.m
//  herolife
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "APPPSWController.h"
#import "HWPopTool.h"

@interface APPPSWController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;


/** 弹出框*/

@property(nonatomic,strong)UIView * popView;

/** 弹出框按钮*/

@property(nonatomic,strong)UIButton *popBtn;


@end

@implementation APPPSWController


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


#pragma mark - UI事件  -haibo
- (void)backButtonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
    // Do any additional setup after loading the view.
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
    self.backImgView = backgroundImage;
    
    
    [self.view addSubview:self.backImgView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];

    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"APP软件密码";
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;
    
    
    [self maketableViewUI];
    
    /** 弹出框的UI设置*/
  
    [self initPopView];
}

#pragma mark -popBtn点击事件
-(void)closeAndBack
{
    
    CGFloat viewWidth =  self.view.frame.size.width;
    NSLog(@"%f",viewWidth);
    
}

#pragma mark -  弹出框的设置
-(void)initPopView
{
    _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
    _popView.backgroundColor = [UIColor blueColor];
    
    _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _popBtn.frame = CGRectMake(0, 250, 200, 50);
    _popBtn.backgroundColor = [UIColor greenColor];
    [_popBtn addTarget:self action:@selector(closeAndBack) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_popBtn];
}

#pragma mark - tableView UI 设置 

-(void)maketableViewUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, self.view.bounds.size.width, self.view.bounds.size.height -64 - 50) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self ;
    
    _tableView.rowHeight = 50 ;
    
    _tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *footView = [UIView new];
    
    _tableView.tableFooterView = footView   ;
    
    

    [self.view addSubview:_tableView];
}

#pragma mark - tableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // if (indexPath.row == 0) {
        
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text =@"APP软件密码";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                //设置分割线的偏移

                cell.separatorInset =UIEdgeInsetsMake(0, -50, 0, 5);
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
            
            else{
                
                
                cell.textLabel.text =@"指纹密码";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                //设置分割线的偏移
                
                cell.separatorInset =UIEdgeInsetsMake(0, 50, 0, 5);
                
                
                cell.detailTextLabel.textColor = [UIColor whiteColor];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"00%ld",indexPath.row];
                
                
            }
            
            cell.backgroundColor = [UIColor clearColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    
        return cell  ;
    
}

#pragma mark - 选中cell

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView beginUpdates];
    
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeGradient;
    
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    
    [[HWPopTool sharedInstance] showWithPresentView:_popView animated:YES];
    
    NSLog(@"选中cell");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
