//
//  CreatXiaoRuiView.m
//  herolife
//
//  Created by sswukang on 2016/12/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CreatXiaoRuiView.h"
#import "HRTabBarViewController.h"
#import "HRNavigationViewController.h"
#import "HRTotalData.h"


@interface CreatXiaoRuiView ()<UITextFieldDelegate>
///背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
///设备名称
@property (weak, nonatomic) IBOutlet UITextField *deviceNameField;
///小睿图片离导航条的距离Y值
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconMixY;
///记录约束初始值
@property(nonatomic, assign) CGFloat initialLineY;
///返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/** uid */
@property(nonatomic, copy) NSString *uid;
@end
@implementation CreatXiaoRuiView
+ (instancetype)shareCreateXiaoRui
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupViews];
    //通知
    [self addNotificationCenterObserver];
}
#pragma mark - 内部方法
- (void)setupViews
{
    self.initialLineY = self.iconMixY.constant;
    self.deviceNameField.delegate = self;
    NSString *uid = [kUserDefault objectForKey:kDefaultsUid];
    DDLogError(@"uid%@", uid);
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
    
    if (UIScreenW < 375) {
        
        self.iconMixY.constant = self.initialLineY - kbSize.height * 0.5 - 5;
        
    }else if (UIScreenW == 375)
    {
        self.iconMixY.constant = self.initialLineY - kbSize.height * 0.2 - 10;
        
    }else
    {
        
    }
    [self layoutIfNeeded];
}
- (void)keyboardShowHidden:(NSNotification *)note
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.uuid.length > 0 > 0 && self.deviceNameField.text.length > 0) {
        [self getHttpRequset];
        
    }else
    {
        [SVProgressTool hr_showErrorWithStatus:@"设备名不能为空!"];
    }
    [self endEditing:NO];
    return YES;
}
#pragma mark - UI事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.iconMixY.constant = self.initialLineY;
    }];
}
///返回按钮
- (IBAction)backButtonClick:(UIButton *)sender {
    HRTabBarViewController *tabVC = (HRTabBarViewController *)[NSObject activityViewController];
    for (HRNavigationViewController *nav in tabVC.childViewControllers) {
        for (UIViewController *VC in nav.childViewControllers) {
            if ([NSStringFromClass([VC class]) isEqualToString:@"CreateXiaoRuiController"]) {
                [VC.navigationController popViewControllerAnimated:YES];
            }
        }
    }
//    [VC.navigationController popViewControllerAnimated:YES];
}
///创建设备按钮
- (IBAction)createButtonClick:(UIButton *)sender {
    
    [self getHttpRequset];
}

#pragma mark - HTTP
// 更新小睿
- (void)httpWithUpdataXiaoRuiWithData:(HRTotalData *)data
{
    //组帧
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"xiaorui";
    parameters[@"title"] = self.deviceNameField.text;
    HRWeakSelf;
    [HRHTTPTool hr_PutHttpWithURL:[NSString stringWithFormat:@"%@/%@", HRAPI_XiaoRuiNode_URL, data.mid] parameters:parameters responseDict:^(id array, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf backButtonClick:weakSelf.backButton];
            });
            return ;
        }
        
        [SVProgressTool hr_showSuccessWithStatus:@"更新小睿成功!"];
        
        HRTabBarViewController *tabVC = (HRTabBarViewController *)[NSObject activityViewController];
        for (HRNavigationViewController *nav in tabVC.childViewControllers) {
            for (UIViewController *VC in nav.childViewControllers) {
                if ([NSStringFromClass([VC class]) isEqualToString:@"CreateXiaoRuiController"]) {
                    [VC.navigationController popViewControllerAnimated:NO];
                }
            }
        }
        
        [weakSelf goToHomeList];
//        [self backButtonClick:self.backButton];
    }];
}

//创建小睿
- (void)httpWithCreateXiaoRui
{
    NSString *muString = [NSString hr_stringWithBase64];
    DDLogInfo(@"muString--%@", muString);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"field_uuid[und][0][value]"] = self.uuid;
    parameters[@"type"] = @"xiaorui";
    parameters[@"field_version[und][0][value]"] = @"0.0.1";
    parameters[@"title"] = self.deviceNameField.text;
    parameters[@"language"] = @"und";
    parameters[@"field_brand[und][0][value]"] = @"xiaorui brand";
    parameters[@"field_status[und][0][value]"] = @"1";
    parameters[@"field_status[und][0][value]"] = @"0";
    parameters[@"field_licence[und][0][value]"] = muString;
    
    int x = arc4random() % 8;
    int y = arc4random() % 255 +1;
    parameters[@"field_addr[und][0][value]"] = [NSString stringWithFormat:@"%d",x];
    parameters[@"field_addr[und][1][value]"] = [NSString stringWithFormat:@"%d",y];
    HRWeakSelf;
    [HRHTTPTool hr_postHttpWithURL:HRAPI_XiaoRuiNode_URL parameters:parameters
                      responseDict:^(id responseObject, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf backButtonClick:weakSelf.backButton];
            });
            return ;
        }
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        DDLogInfo(@"创建小睿%@",dict);
        
        ///创建小睿成功之后要增加创建小睿红外和单火地址表
        //创建红外地址表- irdev
        [CreateXRHttpTools postHttpCreateIrdevWithMid:dict[@"nid"] title:weakSelf.deviceNameField.text responseDict:^(NSDictionary *dict) {
            DDLogInfo(@"创建irdev%@",dict);
            //创建单火地址表- singleswitch
            [CreateXRHttpTools postHttpCreateSingleswitchWithMid:dict[@"nid"] title:weakSelf.deviceNameField.text  responseDict:^(NSDictionary *dict) {
                
                [SVProgressTool hr_showSuccessWithStatus:@"添加小睿成功..."];
                [weakSelf goToHomeList];
                
            } result:^(NSError *error) {
                
                [ErrorCodeManager showError:error];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [weakSelf backButtonClick:weakSelf.backButton];
                });
                
            }];
            
        } result:^(NSError *error) {
            
            
            [ErrorCodeManager showError:error];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf backButtonClick:weakSelf.backButton];
            });
            
        }];
    }];
}
/// 发送HTTP搜索
- (void)getHttpRequset
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uuid"] = self.uuid;
    [SVProgressTool hr_showWithStatus:@"正在添加小睿..."];
    HRWeakSelf
    [HRHTTPTool hr_getHttpWithURL:HRAPI_XiaoRuiInFo_URL parameters:parameters responseDict:^(id responseObject, NSError *error) {
        if (error) {
            [ErrorCodeManager showError:error];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf backButtonClick:weakSelf.backButton];
            });
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
            [weakSelf httpWithCreateXiaoRui];
            return;
        }
        
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dict in responseArr) {
            DDLogError(@"dictuid--%@weakSelf.uid--%@",[dict valueForKeyPath:@"uid"],weakSelf.uid );
            HRTotalData *data = [HRTotalData mj_objectWithKeyValues:dict];
            if ([data.uid isEqualToString:weakSelf.uid]) {//如果用户ID是自己 就更新
                [weakSelf httpWithUpdataXiaoRuiWithData:data];
                
            }else
            {
                //弹出提示框
                [weakSelf showAlertControllerWithUUID:data.uuid];
            }
            
        }
        
    }];
   
}
- (void)showAlertControllerWithUUID:(NSString *)UUID
{
    [self endEditing:YES];
    [SVProgressTool hr_dismiss];
    NSString *title = [NSString stringWithFormat:@"该设备%@已在其他用户上注册,请删除后再进行激活操作!", UUID];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HRTabBarViewController *tabVC = (HRTabBarViewController *)[NSObject activityViewController];
        for (HRNavigationViewController *nav in tabVC.childViewControllers) {
            for (UIViewController *VC in nav.childViewControllers) {
                if ([NSStringFromClass([VC class]) isEqualToString:@"CreateXiaoRuiController"]) {
                    [VC.navigationController popViewControllerAnimated:NO];
                }
            }
        }
        [self goToHomeList];
    }];
    
    [alertController addAction:cancelAction];
    
    HRTabBarViewController *tabVC = (HRTabBarViewController *)[NSObject activityViewController];
    for (HRNavigationViewController *nav in tabVC.childViewControllers) {
        for (UIViewController *VC in nav.childViewControllers) {
            if ([NSStringFromClass([VC class]) isEqualToString:@"CreateXiaoRuiController"]) {
                
                [VC presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self insertSubview:backView aboveSubview:self.backImageView];
    
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImageView.image = [UIImage imageNamed:@"1.jpg"];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImageView.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImageView.image =[UIImage imageNamed:imgName];
    }
    
}
- (void)goToHomeList
{
    HRTabBarViewController *tabVC = (HRTabBarViewController *)[NSObject activityViewController];
    for (UIView *view  in tabVC.view.subviews) {
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
                        
                    });
                }
            }
        }
    }
    tabVC.selectedIndex = 1;

    // 从AddLockController 界面发一个通知让首页去刷新数据 通知
    [kNotification postNotificationName:kNotificationPostRefresh object:nil];
}

- (void)dealloc
{
    [kNotification removeObserver:self];
}

@end
