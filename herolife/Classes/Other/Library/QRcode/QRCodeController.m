//
//  QRCodeController.m
//  eCarry
//  依赖于AVFoundation
//  Created by whde on 15/8/14.
//  Copyright (c) 2015年 Joybon. All rights reserved.
//

#import "QRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#import "ManualController.h"

@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
}
@end

@implementation QRCodeController

/**
 *  @author Whde
 *
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self instanceDevice];
	
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}
- (void)setupViews
{
	self.navigationController.navigationBar.hidden = YES;
	HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, HRUIScreenW, HRNavH)];
	navView.titleLabel.text = @"设备列表";
	navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
	[self.view addSubview:navView];
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
}
/**
 *  @author Whde
 *
 *  配置相机属性
 */
- (void)instanceDevice{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        if (_didReceiveBlock) {
            _didReceiveBlock(data);
            [self selfRemoveFromSuperview];
        } else {
            if (IS_VAILABLE_IOS8) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫码" message:data preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [session startRunning];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码" message:data delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

/**
 *  @author Whde
 *
 *  未识别(其他)的二维码提示点击"好",继续扫码
 *
 *  @param alertView
 */
- (void)alertViewCancel:(UIAlertView *)alertView {
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
	[self setupViews];
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HRCommonScreenW * 194, self.view.frame.size.height)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width- HRCommonScreenW * 194, 0, HRCommonScreenW * 194, self.view.frame.size.height)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(HRCommonScreenW * 194, 0, self.view.frame.size.width- (HRCommonScreenW * 194) *2, (self.view.center.y-(self.view.frame.size.width- (HRCommonScreenW * 194) *2)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(HRCommonScreenW * 194, (self.view.center.y+(self.view.frame.size.width- (HRCommonScreenW * 194) *2)/2), (self.view.frame.size.width- (HRCommonScreenW * 194) *2), (self.view.frame.size.height-(self.view.center.y-(self.view.frame.size.width- (HRCommonScreenW * 194) *2)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width- (HRCommonScreenW * 194) *2, self.view.frame.size.width- (HRCommonScreenW * 194) *2)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"Scanning frame"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake((HRCommonScreenW * 194), CGRectGetMaxY(upView.frame), self.view.frame.size.width- (HRCommonScreenW * 194) *2, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"Scanning line"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
	//求字体长度
	NSMutableDictionary *dictFont = [NSMutableDictionary dictionary];
	dictFont[NSFontAttributeName] = [UIFont systemFontOfSize:12];
	CGSize size = [@"扫描二维码添加" sizeWithAttributes:dictFont];
	
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame) + HRCommonScreenH *10, size.width, size.height)];
	msg.hr_centerX = self.view.hr_centerX;
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:12];
    msg.text = @"扫描二维码添加";
    [self.view addSubview:msg];
	
	//求字体长度
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
	CGSize labelSize = [@"将设备进入激活模式并扫描屏幕二维码" sizeWithAttributes:dict];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(msg.frame) + HRCommonScreenH*28, labelSize.width, labelSize.height)];
	label.hr_centerX = self.view.hr_centerX;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"将设备进入激活模式并扫描屏幕二维码";
    [self.view addSubview:label];
	
	//二维码按钮
	CGFloat tabbarMinY = HRUIScreenH - 49;
	UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"发光圆"] forState:UIControlStateNormal];
	[leftButton setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
	leftButton.frame = CGRectMake(0, tabbarMinY - HRCommonScreenH *(104 +72), HRCommonScreenW * 72, HRCommonScreenW * 72);
	leftButton.hr_centerX = self.view.hr_centerX - HRCommonScreenW *134;
	[leftButton addTarget:self action:@selector(qrcodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:leftButton];
	
	CGSize leftSize = [@"扫描二维码" sizeWithAttributes:dict];
	
	
	UILabel *qrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftButton.frame) + HRCommonScreenH*10, leftSize.width, leftSize.height)];
	qrLabel.hr_centerX = leftButton.hr_centerX;
	qrLabel.backgroundColor = [UIColor clearColor];
	qrLabel.textColor = [UIColor whiteColor];
	qrLabel.textAlignment = NSTextAlignmentCenter;
	qrLabel.font = [UIFont systemFontOfSize:14];
	qrLabel.text = @"扫描二维码";
	
	[self.view addSubview:qrLabel];
	
	//手动添加按钮
	UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"发光圆"] forState:UIControlStateNormal];
	[rightButton setImage:[UIImage imageNamed:@"手指"] forState:UIControlStateNormal];
	rightButton.frame = CGRectMake(0, tabbarMinY - HRCommonScreenH *(104 +72), HRCommonScreenW * 72, HRCommonScreenW * 72);
	rightButton.hr_centerX = self.view.hr_centerX + HRCommonScreenW *134;
	[rightButton addTarget:self action:@selector(manualButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:rightButton];
	
	CGSize rightSize = [@"手动添加" sizeWithAttributes:dict];
	
	UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftButton.frame) + HRCommonScreenH*10, rightSize.width, rightSize.height)];
	rightLabel.hr_centerX = rightButton.hr_centerX;
	rightLabel.backgroundColor = [UIColor clearColor];
	rightLabel.textColor = [UIColor whiteColor];
	rightLabel.textAlignment = NSTextAlignmentCenter;
	rightLabel.font = [UIFont systemFontOfSize:14];
	rightLabel.text = @"手动添加";
	
	[self.view addSubview:rightLabel];
}
#pragma mark - UI事件
- (void)qrcodeButtonClick:(UIButton *)btn
{
	
}
- (void)manualButtonClick:(UIButton *)btn
{
	ManualController *manulVC = [[ManualController alloc] init];
	
	[self.navigationController pushViewController:manulVC animated:YES];
	
	
}
/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [QRCodeController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:self.view.frame.size.width-(HRCommonScreenW * 194) *2 - 2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

/**
 *  @author Whde
 *
 *  扫码取消button方法
 *
 *  @return
 */
- (void)dismissOverlayView:(id)sender{
    [self selfRemoveFromSuperview];
}

/**
 *  @author Whde
 *
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview{
    [session removeObserver:self forKeyPath:@"running" context:nil];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

/*!
 *  <#Description#>
 *  @param didReceiveBlock <#didReceiveBlock description#>
 */
- (void)setDidReceiveBlock:(QRCodeDidReceiveBlock)didReceiveBlock {
    _didReceiveBlock = [didReceiveBlock copy];
}

@end