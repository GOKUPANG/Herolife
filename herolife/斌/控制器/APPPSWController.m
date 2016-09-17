//
//  APPPSWController.m
//  herolife
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 huarui. All rights reserved.
//


/** 获取门锁密码编号请求网址*/
#define HRAPI_GetDoorPsw_URL @"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev-hrsc-ul&uuid=%@"

#define HRAPI_DeleteDoorPsw_URL @"http://www.gzhuarui.cn/?q=huaruiapi/node/%@"

#import "APPPSWController.h"
#import "HWPopTool.h"
#import "YXCustomAlertView.h"
#import "DoorPswModel.h"
#import <AFNetworking.h>
#import "DoorPswModel.h"



@interface APPPSWController ()<UITableViewDelegate,UITableViewDataSource,YXCustomAlertViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 背景图片*/

@property(nonatomic,strong)UIImageView *backImgView;


/** 弹出框*/

@property(nonatomic,strong)UIView * popView;

/** 弹出框按钮*/

@property(nonatomic,strong)UIButton *popBtn;


/** 数据源  **/

@property(nonatomic,strong)NSMutableArray *dataArray;

/** 修改密码弹窗*/

@property(nonatomic,strong)YXCustomAlertView * FixAlertView;

/** 添加密码弹窗*/

@property(nonatomic,strong)YXCustomAlertView * AddAlertView;
/** 修改密码输入框*/

@property(nonatomic,strong)UITextField *       FixField;

/**  增加密码名字输入框*/

@property(nonatomic,strong)UITextField *       AddPswNameField;

/**  增加密码编号输入框*/
@property(nonatomic,strong)UITextField *       AddPswNumberField;

@property(nonatomic,assign)int         MYRow ;






@end

@implementation APPPSWController


#pragma mark -懒加载
///** 懒加载*/
//-(NSMutableArray *)dataArray
//{
//    if (!_dataArray) {
//        self.dataArray = [NSMutableArray arrayWithObjects:@"指纹密码",@"软件密码",@"不知道什么鬼密码", nil];
//        
//    }
//    
//    DDLogInfo(@"懒加载----");
//    
//    
//    return  _dataArray;
//    
//}


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
    navView.titleLabel.text = @"密码管理";
    
    navView.rightLabel.text = @"添加";
    
    navView.rightLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddMess)];
    
    [navView.rightLabel addGestureRecognizer:tap];
    
    
    
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;
    
    
    self.dataArray = [NSMutableArray new];
    
    
    NSLog(@"数据源的长度%ld",_dataArray.count);
    
    /** 获取门锁密码信息*/
    [self GetDoorMessageWithHttp];
    
    
    [self maketableViewUI];
    
    
    
  
   }



#pragma mark -添加密码编号信息弹窗  

-(void)makePSWAlerView
{
    /** FixAlertView;
     AddAlertView;
     FixField;
     AddPswNameField;
     AddPswNumberField;
     */
    CGFloat dilX = 25;
    CGFloat dilH = 200;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"添加密码编号信息";
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = @"密码编号";
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
    
    loginPwdField.placeholder = @"请输入要添加的密码编号";
    
    loginPwdField.textColor = [UIColor whiteColor];
    
    
    
    
    UITextField * PSWNameField = [[UITextField alloc]initWithFrame:CGRectMake(loginX, 100, alertV.frame.size.width -  loginX*1.2, 32)];
    
    PSWNameField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];

    
    
    PSWNameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];

    PSWNameField.leftView = leftView1;
    
    
    PSWNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    PSWNameField.layer.borderWidth = 1;
    PSWNameField.layer.cornerRadius = 4;
    
    PSWNameField.placeholder = @"请给该编号的密码命名";
    
    PSWNameField.textColor = [UIColor whiteColor];
    
    
    
   
    
    
    UILabel * PswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, loginX, 32)];
    
    [alertV addSubview:PswLabel];
    PswLabel.text = @"密码命名";
    PswLabel.textColor = [UIColor whiteColor];
    
    PswLabel.textAlignment = NSTextAlignmentCenter;
    
    
    alertV.alpha=0;
    
    self.AddPswNumberField = loginPwdField;
    
    self.AddPswNameField = PSWNameField;
    
    
    self.AddAlertView = alertV;
    
     [alertV addSubview:self.AddPswNumberField];
    
    [alertV addSubview:self.AddPswNameField];

    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.AddAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.AddAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        //  [customAlertView dissMiss];
        
        
    }];

}

#pragma mark -导航栏右上角添加 事件

-(void)AddMess
{
   
    NSLog(@"添加");
    
    
    [self makePSWAlerView];
    
}



#pragma mark - 获取门锁密码


-(void)GetDoorMessageWithHttp
{
    
    AFHTTPSessionManager   *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSString *  DoorUUID  = self.listModel.uuid;
    
    
    
    NSString *urlStr=[NSString stringWithFormat:HRAPI_GetDoorPsw_URL,DoorUUID];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *Doordict in array) {
            
            DoorPswModel *model = [DoorPswModel new];
            NSArray *PersonArray = Doordict[@"person"];
            
            model.PswName = PersonArray[0];
            model.PswNumber = PersonArray[1];
            model.did = Doordict[@"did"];
            
            
            
            [_dataArray addObject:model];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSLog(@"获取数据失败");
        
    }];
    



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
    
    
    return _dataArray.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // if (indexPath.row == 0) {
        
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            
          
        }
    
    DoorPswModel * model  = _dataArray[indexPath.row];
    
    cell.textLabel.text =model.PswName;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.detailTextLabel.text = model.PswNumber;
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell  ;
    
}

#pragma mark - 选中cell 修改密码弹出框UI设置

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    
    _MYRow = (int)indexPath.row;
    
    
    CGFloat dilX = 25;
    CGFloat dilH = 150;
    YXCustomAlertView *alertV = [[YXCustomAlertView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, HRUIScreenW - 40, dilH) andSuperView:self.navigationController.view];
    
    
    alertV.delegate = self;
    alertV.titleStr = @"修改密码名称";
    
    DoorPswModel *model = _dataArray[indexPath.row];
    
    
    
    CGFloat loginX = 200 *HRCommonScreenH;
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, loginX, 32)];
    
    [alertV addSubview:numberLabel];
    numberLabel.text = model.PswNumber;
    
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    UITextField *loginPwdField = [[UITextField alloc] initWithFrame:CGRectMake(loginX, 55, alertV.frame.size.width -  loginX*1.2, 32)];
    loginPwdField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    //   UILabel *leftLabel = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, 8, 32)];
    
    loginPwdField.leftViewMode = UITextFieldViewModeAlways;
    loginPwdField.leftView = leftView;
    // loginPwdField.leftView = leftLabel;
    
    // leftLabel.text = @"111";
    
    loginPwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginPwdField.layer.borderWidth = 1;
    loginPwdField.layer.cornerRadius = 4;
    
    loginPwdField.textColor = [UIColor whiteColor];
    
    loginPwdField.placeholder = model.PswName;
    
    
    
    self.FixField = loginPwdField;
    
    [alertV addSubview:self.FixField];
    
    alertV.alpha=0;
    
    
    self.FixAlertView = alertV;
    
    
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        
        self.FixAlertView.center = CGPointMake(HRUIScreenW/2, HRUIScreenH/2-100);
        
        self.FixAlertView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
      //  [customAlertView dissMiss];
        
        
    }];

    
}


#pragma mark - YXCustomAlertViewDelegate 修改和添加密码
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

        
     
    }else
    {
        
        
        if (customAlertView == self.AddAlertView) {
            
            NSLog(@"我是增加密码弹窗");
            
            
            NSString * PswNumber  = self.AddPswNumberField.text;
            
            NSString * PswName    =  self.AddPswNameField.text;
            
            NSString * title      = [NSString stringWithFormat:@"%@%@",PswNumber,PswName];
            
            NSString *  DoorUUID  = self.listModel.uuid;

            
            
            if (PswNumber.length!=0 && PswName.length!=0) {
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager hrPostManager];
                
                
                /** 参数字典的设置 */
                
                NSMutableDictionary * ParametersDict = [NSMutableDictionary dictionary];
                [ParametersDict setValue:@"common" forKey:@"type"];
                
                [ParametersDict setValue:title forKey:@"title"];
                
                
                [ParametersDict setValue:@"hrsc-ul" forKey:@"field_sy[und][0][value]"];
                
                [ParametersDict setValue:DoorUUID forKey:@"field_uuid[und][0][value]"];
                
                [ParametersDict setValue:PswName forKey:@"field_person[und][0][value]"];
                
                [ParametersDict setValue:PswNumber forKey:@"field_person[und][1][value]"];
                
                
                
                NSString * AddPswURL = @"http://www.gzhuarui.cn/?q=huaruiapi/node";
                
                [  manager POST:AddPswURL parameters:ParametersDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"上传成功");
                    
                    NSLog(@"返回的数据是%@",responseObject);
                    
                    
                    DoorPswModel * model = [DoorPswModel new];
                    
                    model.PswName = self.AddPswNameField.text;
                    
                    model.PswNumber = self.AddPswNumberField.text;
                    
                    /** 在数组的第一个元素添加*/
                    [_dataArray insertObject:model atIndex:0  ];
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_tableView reloadData];
                        
                        
                        
                    });
                    
                    
                    
                    
                    
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    
                    NSLog(@"%@",error);
                    
                    NSLog(@"上传失败");
                    
                    
                    
                }
                 ];
                
                
            }
    
            
        }
        
        else
        {
            
            
            if (self.FixField.text.length!=0) {
                
            
            
            #pragma mark -修改密码弹窗 确定
            NSLog(@"我是修改密码弹窗");
            
            DoorPswModel * model = _dataArray[_MYRow];
            
            NSString *did = model.did;
            
            
            AFHTTPSessionManager *manager =[AFHTTPSessionManager hrManager];
            
            NSString *  Str =@"http://www.gzhuarui.cn/?q=huaruiapi/node/%@";
            
            NSString *urlStr = [NSString stringWithFormat:Str,did];
            
            
            NSMutableDictionary * paraDict = [NSMutableDictionary dictionary];
            
            
            paraDict[@"type"] = @"common"      ;
            paraDict[@"field_person[und][0][value]"] =self.FixField.text;
            
             paraDict[@"field_person[und][1][value]"] =model.PswNumber;
            
            
            [manager PUT:urlStr parameters:paraDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"修改密码成功");
                
                
                [model setPswName:self.FixField.text];
                
                
                [_dataArray removeObjectAtIndex:_MYRow];
                
                [_dataArray insertObject:model atIndex:_MYRow];
                
                [_tableView reloadData];
                
                
                
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"修改密码失败");
                
                
            }
             ];
            
            }
            
            
            
        }
        
        
        [UIView animateWithDuration:0.8 animations:^{
            
            
            CGRect AlertViewFrame = customAlertView.frame;
            
            AlertViewFrame.origin.y = HRUIScreenH ;
            
            
            customAlertView.frame = AlertViewFrame;
            
            customAlertView.alpha = 0;
            
            
            
            
            
            
        } completion:^(BOOL finished) {
            
            
            [customAlertView dissMiss];
            
        }];
        
        
        NSLog(@"确认");
    }
}




-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
        DoorPswModel *model = _dataArray[indexPath.row];
        
        NSLog(@"did是%@",model.did);
        
        NSString *urlStr = [NSString stringWithFormat:HRAPI_DeleteDoorPsw_URL,model.did];
        
        NSLog(@"删除密码的网址是%@",urlStr);
        
        
       [ manager DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
           NSLog(@"返回的东西%@",responseObject);
           
           
           NSLog(@"删除成功");
           
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
         
            NSLog(@"%@",error);
            
            NSLog(@"删除失败");
            
            
        }];
        

        
        
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];

        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
