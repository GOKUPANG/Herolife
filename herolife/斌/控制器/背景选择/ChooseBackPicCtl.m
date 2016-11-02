//
//  ChooseBackPicCtl.m
//  herolife
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 huarui. All rights reserved.
//



/** 视图的宽度*/
#define VIEW_W  [UIScreen mainScreen].bounds.size.width * 180.0/375.0
/** 视图的高度*/
#define VIEW_H   [UIScreen mainScreen].bounds.size.height  * 180.0/667.0
/** 总的个数*/
#define SIZE 4
/** 单行个数*/
#define NUM 2
/** 行距*/
#define MARGIN_Y 5
/** 状态栏高度[方便整体调整]*/
#define START_H 64

/** 屏幕高度*/
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width



 NSInteger showNum;



#import "ChooseBackPicCtl.h"
#import "UIView+SDAutoLayout.h"
#import <UserNotifications/UserNotifications.h>
@interface ChooseBackPicCtl ()
/** 顶部条 */
@property(nonatomic, weak) HRNavigationBar *navView;

/** 打勾的View */
@property(nonatomic,strong)UIView * YesView;

/** 正在显示勾的时第几张 */

@property(nonatomic,assign )NSInteger ShowNumber ;










@end

@implementation ChooseBackPicCtl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //	self.tabBarController.view.hidden = YES;
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
            
            view.hidden = YES;
        }
    }
    
    NSInteger  PicNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    
    switch (PicNum) {
        case 1:
        {
            UIButton * yesView =(UIButton *)[self.view viewWithTag:1+10];
            
            yesView.hidden = NO;
            
        }
            break;
            
            
            case 2:
        {
            
            UIButton * yesView =(UIButton *)[self.view viewWithTag:2+10];
            
            yesView.hidden = NO;

            
        }
            break;
            
            
          case 3:
        {
            UIButton * yesView =(UIButton *)[self.view viewWithTag:3+10];
            
            yesView.hidden = NO;

        }
            
            break;
            
            case 4:
        {
            UIButton * yesView =(UIButton *)[self.view viewWithTag:4+10];
            
            yesView.hidden = NO;

        }
        default:
            break;
    }
    
    
    
      NSLog(@"全局变量是%ld",showNum);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self registerNotification:1.0];
}

//-(void)registerNotification:(NSInteger )alerTime{
//    
//    // 使用 UNUserNotificationCenter 来管理通知
//    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//    
//    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
//    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
//    content.title = [NSString localizedUserNotificationStringForKey:@"" arguments:nil];
//    content.body = [NSString localizedUserNotificationStringForKey:@"连接成功,点我返回😄"
//                                                         arguments:nil];
//    content.sound = [UNNotificationSound defaultSound];
//    
//    // 在 alertTime 后推送本地推送
//    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
//                                                  triggerWithTimeInterval:alerTime repeats:NO];
//    
//    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"sampleRequest"
//                                                                          content:content trigger:trigger];
//    
//    //添加推送成功后的处理！
//    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//        //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
//        //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        //        [alert addAction:cancelAction];
//        //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//        
//        NSLog(@"---------------------本地推送1----------");
//    }];
//    NSLog(@"---------------------本地推送2----------");
//}
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
    
   
    
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    backgroundImage.image = [UIImage imageNamed:@"Snip20160825_3"];
//    [self.view addSubview:backgroundImage];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] init];
    navView.titleLabel.text = @"背景图选择";
       
    navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navView];
    self.navView = navView;
    
    
    
    [self makeView];
    
    
    
}




/** 九宫格*/
- (void)makeView{
    /** x的间距*/
    CGFloat margin_x = (SCREEN_W - NUM * VIEW_W) / (NUM + 1);
    /** y的间距*/
    CGFloat margin_y = MARGIN_Y;
    
    /** 图片数组*/
    //    NSArray *iamgeNameArr = @[@""];
    /** 名字*/
    
    
    for (int i=0; i<SIZE; i++) {
        // x的公式：公有部分(视图间距) + (视图宽度 + 视图间距) * 一行中第几个
        // 一行中第几个
        int row = i % NUM;
        CGFloat view_x = margin_x + (VIEW_W + margin_x) * row;
        
        // 第几行
        // y的公式：公有部分 + （视图高度 + 视图间距） * 第几行
        int low = i / NUM;
        CGFloat view_y = (START_H + margin_y) + (VIEW_H + margin_y) * low;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view_x, view_y, VIEW_W, VIEW_H)];
        
        NSString * imageStr = [NSString stringWithFormat:@"%d.jpg",i+1];
        
        imageView.image = [UIImage imageNamed:imageStr];
        
        imageView.backgroundColor = [UIColor greenColor];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        
        imageView.tag = i +1;
        
        //给imageView 添加手势事件
        
        imageView.userInteractionEnabled =YES;
        
        
        UITapGestureRecognizer  * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgSelected:)];
        
        [imageView addGestureRecognizer:tap];
        [self.view addSubview:imageView];
        
        UIButton * yesView = [[UIButton alloc]init];
        
        [imageView addSubview:yesView];
        
        yesView.sd_layout
        .bottomEqualToView(imageView)
        .leftEqualToView(imageView)
        .rightEqualToView(imageView)
        .heightRatioToView(imageView,0.15);
        
        yesView.backgroundColor =[[UIColor greenColor]colorWithAlphaComponent:0.5];
        
        
        yesView.userInteractionEnabled = NO;
        
        [yesView setTitle:@"√" forState:UIControlStateNormal];
        
        yesView.tag  = 11 + i;
        
        yesView.hidden = YES;
        
        
        
        
     
        
        
        
    
        
        /*
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(view_x, CGRectGetMaxY(imageView.frame), VIEW_W, 20);
        label.text = @"我的收藏";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:label];
         */
        
    }
}


-(void) setYesViewHidden
{
    
}
#pragma mark - 图片点击事件
-(void)ImgSelected:(UITapGestureRecognizer *)tap
{
    NSInteger ImgTag =   tap.view.tag;
    
    NSInteger yesTag = ImgTag + 10;
    
    
    NSInteger yushu =  ImgTag % 4;
    
    NSLog(@"图片的tag是%ld",ImgTag);
    NSLog(@"yestag是%ld",yesTag);
    NSLog(@"余数是%ld",yushu);
    
    
    //判断选中哪一张，让选中得View显示 其它的隐藏  只能有一个显示
    if (yushu == 1) {
        UIButton * yesView  = (UIButton *)[self.view viewWithTag:yesTag];
        UIButton  * yesView1 = (UIButton *)[self.view viewWithTag:yesTag +1];
        UIButton  * yesView2 = (UIButton *)[self.view viewWithTag:yesTag +2];
        UIButton  * yesView3 = (UIButton *)[self.view viewWithTag:yesTag +3];
        yesView1.hidden=YES;
        yesView2.hidden=YES;
        yesView3.hidden=YES;
        yesView.hidden =NO;
        
        showNum = 1;
        
        
        
    }
    
    
    else if (yushu ==2)
    {
        UIButton * yesView  = (UIButton *)[self.view viewWithTag:yesTag];
        UIButton  * yesView1 = (UIButton *)[self.view viewWithTag:yesTag -1];
        UIButton  * yesView2 = (UIButton *)[self.view viewWithTag:yesTag +1];
        UIButton  * yesView3 = (UIButton *)[self.view viewWithTag:yesTag +2];
        yesView1.hidden=YES;
        yesView2.hidden=YES;
        yesView3.hidden=YES;
        yesView.hidden =NO;
        
        showNum = 2;

    }
    
    
    
    
    else if (yushu == 3)
    {
        UIButton * yesView  = (UIButton *)[self.view viewWithTag:yesTag];
        UIButton  * yesView1 = (UIButton *)[self.view viewWithTag:yesTag -2];
        UIButton  * yesView2 = (UIButton *)[self.view viewWithTag:yesTag -1];
        UIButton  * yesView3 = (UIButton *)[self.view viewWithTag:yesTag +1];
        yesView1.hidden=YES;
        yesView2.hidden=YES;
        yesView3.hidden=YES;
        yesView.hidden =NO;
        
        showNum = 3;
        

    }

    else{
        UIButton * yesView  = (UIButton *)[self.view viewWithTag:yesTag];
        UIButton  * yesView1 = (UIButton *)[self.view viewWithTag:yesTag -3];
        UIButton  * yesView2 = (UIButton *)[self.view viewWithTag:yesTag -2];
        UIButton  * yesView3 = (UIButton *)[self.view viewWithTag:yesTag -1];
        yesView1.hidden=YES;
        yesView2.hidden=YES;
        yesView3.hidden=YES;
        yesView.hidden =NO;
        
        showNum =4;
        
        
        
    }
    
    
    if (self.finishBlock) {
        
        
        self.finishBlock(showNum);
        
        [self .navigationController popViewControllerAnimated:YES];
        
        
    }
    
    
    
    
     [[NSUserDefaults standardUserDefaults] setInteger:showNum forKey:@"PicNum"];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
