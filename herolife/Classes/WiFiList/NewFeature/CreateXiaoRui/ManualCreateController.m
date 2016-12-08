//
//  ManualCreateController.m
//  herolife
//
//  Created by sswukang on 2016/12/2.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ManualCreateController.h"
#import "HRTotalData.h"

@interface ManualCreateController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createDeviceButton;
//小睿图片距离顶部导航栏约束距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineViewY;
/**  */
@property(nonatomic, assign) CGFloat initialLineY;
@property (weak, nonatomic) IBOutlet UITextField *deviceUIDFiled;

@property (weak, nonatomic) IBOutlet UITextField *deviceNameFiled;
/** uid */
@property(nonatomic, copy) NSString *uid;
///背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;

@end

@implementation ManualCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    //通知
    [self addNotificationCenterObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:backView];
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
#pragma mark - 内部方法
- (void)setupViews
{
    self.initialLineY = self.LineViewY.constant;
    self.deviceNameFiled.delegate = self;
    NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
    self.uid = uid;
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
    [kNotification addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [kNotification addObserver:self selector:@selector(keyboardShowHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardShow:(NSNotification *)note
{
    NSDictionary *dict = note.userInfo;
    CGSize kbSize = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.5 animations:^{
        if (UIScreenW < 375) {
            
            self.LineViewY.constant = self.initialLineY - kbSize.height * 0.3 - 90;
        }else if (UIScreenW == 375)
        {
            self.LineViewY.constant = self.initialLineY - kbSize.height * 0.3 ;
            
        }else
        {
            
        }
        [self.view layoutIfNeeded];
    }];
    
}
- (void)keyboardShowHidden:(NSNotification *)note
{
    [UIView animateWithDuration:0.5 animations:^{
        self.LineViewY.constant = self.initialLineY ;
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.deviceUIDFiled.text.length > 0 && self.deviceNameFiled.text.length > 0) {
        [self getHttpRequset];
        
    }else
    {
        [SVProgressTool hr_showErrorWithStatus:@"设备ID或设备名不能为空!"];
    }
    
    [self.view endEditing:NO];
    return YES;
}


#pragma mark - UI事件
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.view endEditing: YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createDevice:(UIButton *)sender {
    if (self.deviceUIDFiled.text.length > 0 && self.deviceNameFiled.text.length > 0) {
        [self getHttpRequset];
        
    }else
    {
        [SVProgressTool hr_showErrorWithStatus:@"设备ID或设备名不能为空!"];
    }
    
}

#pragma mark - HTTP
// 更新小睿
- (void)httpWithUpdataXiaoRuiWithData:(HRTotalData *)data
{
    //组帧
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"xiaorui";
    parameters[@"title"] = self.deviceNameFiled.text;
    [HRHTTPTool hr_PutHttpWithURL:[NSString stringWithFormat:@"%@/%@", HRAPI_XiaoRuiNode_URL, data.mid] parameters:parameters responseDict:^(id array, NSError *error) {
        if (error) {
            
            [ErrorCodeManager showError:error];
            return ;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdataXiaoRui object:nil];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showSuccessWithStatus:@"更新小睿成功!"];
        [self goToHomeList];
    }];
}

- (void)goToHomeList
{
    for (UIView *view  in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            //            HRTabBar *tabBar = (HRTabBar *)view;
            view.hidden = NO;
            for (UIButton *btn in view.subviews) {
                if (btn.tag == 1) {
                    btn.selected = NO;
                }
                
                if (btn.tag == 2) {
                    btn.selected = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [kNotification postNotificationName:kNotificationInitializationSelecteButton object:nil];
                        //                        objc_msgSend(tabBar, @selector(btnClick:), btn);
                    });
                }
            }
        }
    }
    self.tabBarController.selectedIndex = 1;
    // 从AddLockController 界面发一个通知让首页去刷新数据 通知
    [kNotification postNotificationName:kNotificationPostRefresh object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//创建小睿
- (void)httpWithCreateXiaoRui
{
    NSString *muString = [NSString hr_stringWithBase64];
    DDLogInfo(@"muString--%@", muString);
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"field_uuid[und][0][value]"] = self.deviceUIDFiled.text;
    parameters[@"type"] = @"xiaorui";
    parameters[@"field_version[und][0][value]"] = @"0.0.1";
    parameters[@"title"] = self.deviceNameFiled.text;
    parameters[@"language"] = @"und";
    parameters[@"field_brand[und][0][value]"] = @"xiaorui brand";
    parameters[@"field_status[und][0][value]"] = @"1";
    parameters[@"field_status[und][0][value]"] = @"0";
    parameters[@"field_licence[und][0][value]"] = muString;
    
    int x = arc4random() % 8;
    int y = arc4random() % 255 +1;
    parameters[@"field_addr[und][0][value]"] = [NSString stringWithFormat:@"%d",x];
    parameters[@"field_addr[und][1][value]"] = [NSString stringWithFormat:@"%d",y];
    
    [HRHTTPTool hr_postHttpWithURL:HRAPI_XiaoRuiNode_URL parameters:parameters responseDict:^(id array, NSError *error) {
        if (error) {
            
            [ErrorCodeManager showError:error];
            
            return ;
        }
        
        NSDictionary *dict = (NSDictionary *)array;
        DDLogInfo(@"创建小睿%@",dict);
        [CreateXRHttpTools postHttpCreateIrdevWithMid:dict[@"nid"] title:self.deviceNameFiled.text responseDict:^(NSDictionary *dict) {
            DDLogInfo(@"创建irdev%@",dict);
            //创建单火地址表- singleswitch
            [CreateXRHttpTools postHttpCreateSingleswitchWithMid:dict[@"nid"] title:self.deviceNameFiled.text  responseDict:^(NSDictionary *dict) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateXiaoRui object:nil];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD showSuccessWithStatus:@"添加小睿成功..."];
                [self goToHomeList];
                
            } result:^(NSError *error) {
                [ErrorCodeManager showError:error];
            }];
            
        } result:^(NSError *error) {
            
            [ErrorCodeManager showError:error];
            
        }];

        
    }];
}
/// 发送HTTP搜索
- (void)getHttpRequset
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uuid"] = self.deviceUIDFiled.text;
    [SVProgressTool hr_showWithStatus:@"正在添加小睿..."];
    
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiInFo_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            return ;
        }
        
        
        //如果responseObject不是数组类型就不是我们想要的数据，应该过滤掉
        if (![responseObject isKindOfClass:[NSArray class]]) {
            DDLogDebug(@"responseObject不是NSArray");
            
            return;
        }
        //去除服务器发过来的数据里没有值的情况
        if (((NSArray*)responseObject).count < 1 ) {
            DDLogDebug(@"responseObject count == 0");
            //如果为空就去创建小睿
            [self httpWithCreateXiaoRui];
            return;
        }
        
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dict in responseArr) {
            DDLogError(@"dictuid--%@self.uid--%@",[dict valueForKeyPath:@"uid"],self.uid );
            HRTotalData *data = [HRTotalData mj_objectWithKeyValues:dict];
            if ([data.uid isEqualToString:self.uid]) {//如果用户ID是自己 就更新
                [self httpWithUpdataXiaoRuiWithData:data];
            }else
            {
                [SVProgressTool hr_showErrorWithStatus:@"该小睿在其他帐号上已经激活,请在其他帐号上删除该小睿,再重试!"];
            }
            
        }
        

    }];
}


@end
