//
//  AirCtrlView.m
//  xiaorui
//
//  Created by sswukang on 15/12/21.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "AirCtrlView.h"
#import "TipsLabel.h"
#import "IracData.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import <SVProgressHUD.h>
@interface AirCtrlView()

@property (strong, nonatomic) UILabel *speedBadgeLabel;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *powerLabel;
@property (strong, nonatomic) UILabel *modeCoolLabel;
@property (strong, nonatomic) UILabel *modeHeatLabel;
@property (strong, nonatomic) UILabel *modeWindLabel;
@property (strong, nonatomic) UILabel *modeHumiLabel;
@property (strong, nonatomic) UILabel *swingHandLabel;
@property (strong, nonatomic) UILabel *swingAutoLabel;
/**第一排制冷图标  */
@property(nonatomic, weak) UIImageView *fistImageView;
/** 第一排制冷Label */
@property(nonatomic, weak) UILabel *fistLabel;
/** TipsLabel */
@property(nonatomic, strong) TipsLabel *tipsLabel;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** 减 按钮 */
@property(nonatomic, weak) UIButton *reduceButton;
/** 加按钮 */
@property(nonatomic, weak) UIButton *increaseButton;
/** 记录当前点击的图片 */
@property(nonatomic, weak) UIImageView *currentImageView;




@end


@implementation AirCtrlView

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
        //第一排制冷图标 和label
        UIImageView *fistImageView = [[UIImageView alloc] init];
        fistImageView.image = [UIImage imageNamed:@"制冷"];
        self.fistImageView = fistImageView;
        
        UILabel *fistLabel = [[UILabel alloc] init];
        fistLabel.text = @"制冷";
        fistLabel.textColor = [UIColor whiteColor];
        fistLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:17];
        self.fistLabel = fistLabel;
        [self addSubview:fistImageView];
        [self addSubview:fistLabel];
        
        //增减按钮
        UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reduceButton setImage:[UIImage imageNamed:@"小睿-白"] forState:UIControlStateNormal];
        [reduceButton addTarget:self action:@selector(reduceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: reduceButton];
        self.reduceButton = reduceButton;
        
        UIButton *increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [increaseButton addTarget:self action:@selector(increaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [increaseButton setImage:[UIImage imageNamed:@"小睿+-白"] forState:UIControlStateNormal];
        [self addSubview: increaseButton];
        self.increaseButton = increaseButton;
        
        
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        self.speedImageView     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"风速圈"] highlightedImage:[UIImage imageNamed:@"风速圈-蓝"]];
        self.powerImageView     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小睿开关白"] highlightedImage:[UIImage imageNamed:@"空调开关"]];
        self.modeCoolImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小睿冷白"] highlightedImage:[UIImage imageNamed:@"制冷圈"]];
        self.modeHeatImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小睿制热白"] highlightedImage:[UIImage imageNamed:@"制热圈"]];
        self.modeWindImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小睿送风白"] highlightedImage:[UIImage imageNamed:@"小睿送风蓝"]];
        self.modeDehumImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"除湿白"] highlightedImage:[UIImage imageNamed:@"除湿蓝"]];
        self.swingHandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小睿手动风向白"] highlightedImage:[UIImage imageNamed:@"小睿手动风向蓝"]];
        self.swingAutoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"风向圈"] highlightedImage:[UIImage imageNamed:@"风向圈蓝"]];
		self.tempSlider      = [[UISlider alloc] init];
		// 设置滑动条的监听事件
		[self.tempSlider addTarget:self action:@selector(sliderValueChanged:)
				forControlEvents:UIControlEventValueChanged];
		// 可能有时候你只想在用户手指放开 thumb 而且新 的值以及设置好以后得到通知。
		[self.tempSlider setContinuous:NO];
		
        self.speedBadgeLabel = [[UILabel alloc] init];
        self.tempLabel       = [[UILabel alloc] init];
        self.unitLabel       = [[UILabel alloc] init];
        self.speedLabel      = [[UILabel alloc] init];
        self.powerLabel      = [[UILabel alloc] init];
        self.modeCoolLabel   = [[UILabel alloc] init];
        self.modeHeatLabel   = [[UILabel alloc] init];
        self.modeWindLabel   = [[UILabel alloc] init];
        self.modeHumiLabel   = [[UILabel alloc] init];
        self.swingHandLabel  = [[UILabel alloc] init];
        self.swingAutoLabel  = [[UILabel alloc] init];
		
        self.tempLabel.text      = @"25";
        self.unitLabel.text      = @"℃";
        self.speedLabel.text     = @"风速";
        self.powerLabel.text     = @"开关";
        self.modeCoolLabel.text  = @"制冷";
        self.modeHeatLabel.text  = @"制热";
        self.modeWindLabel.text  = @"送风";
        self.modeHumiLabel.text  = @"除湿";
        self.swingHandLabel.text = @"手动方向";
		self.swingAutoLabel.text = @"自动方向";
		
        self.speedLabel.textAlignment     = NSTextAlignmentCenter;
        self.powerLabel.textAlignment     = NSTextAlignmentCenter;
        self.modeCoolLabel.textAlignment  = NSTextAlignmentCenter;
        self.modeHeatLabel.textAlignment  = NSTextAlignmentCenter;
        self.modeWindLabel.textAlignment  = NSTextAlignmentCenter;
        self.modeHumiLabel.textAlignment  = NSTextAlignmentCenter;
        self.swingHandLabel.textAlignment = NSTextAlignmentCenter;
        self.swingAutoLabel.textAlignment = NSTextAlignmentCenter;
		
        self.tempLabel.textColor      = [UIColor defaultTextColor];
        self.speedLabel.textColor     = [UIColor defaultTextColor];
        self.powerLabel.textColor     = [UIColor defaultTextColor];
        self.modeCoolLabel.textColor  = [UIColor defaultTextColor];
        self.modeHeatLabel.textColor  = [UIColor defaultTextColor];
        self.modeWindLabel.textColor  = [UIColor defaultTextColor];
        self.modeHumiLabel.textColor  = [UIColor defaultTextColor];
        self.swingHandLabel.textColor = [UIColor defaultTextColor];
        self.swingAutoLabel.textColor = [UIColor defaultTextColor];
		
		[self addSubview: self.speedImageView];
		[self addSubview: self.powerImageView];
		[self addSubview: self.modeCoolImageView];
		[self addSubview: self.modeHeatImageView];
		[self addSubview: self.modeWindImageView];
		[self addSubview: self.modeDehumImageView];
		[self addSubview: self.swingHandImageView];
		[self addSubview: self.swingAutoImageView];
		[self addSubview: self.speedBadgeLabel];
		[self addSubview: self.tempSlider];
		[self addSubview: self.tempLabel];
		[self addSubview: self.unitLabel];
		[self addSubview: self.speedLabel];
		[self addSubview: self.powerLabel];
		[self addSubview: self.modeCoolLabel];
		[self addSubview: self.modeHeatLabel];
		[self addSubview: self.modeWindLabel];
		[self addSubview: self.modeHumiLabel];
		[self addSubview: self.swingHandLabel];
		[self addSubview: self.swingAutoLabel];
		
		self.tempSlider.maximumValue = 1;
		self.tempSlider.minimumValue = 0;
//		[[self.tempSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *slider) {
//			float temp = AIRCTRL_TEMP_MIN + (AIRCTRL_TEMP_MAX - AIRCTRL_TEMP_MIN)*slider.value;
//			self.tempLabel.text = [NSString stringWithFormat:@"%d", (int)temp];
//		}];
//		float temp = ([self.tempLabel.text floatValue] - AIRCTRL_TEMP_MIN) / 14 ;
//		self.tempSlider.value = temp;
		
		
		
		self.speedImageView.tag     = 100;
		self.powerImageView.tag     = 101;
		self.modeCoolImageView.tag  = 102;
		self.swingHandImageView.tag = 103;
		self.swingAutoImageView.tag = 104;
		self.modeHeatImageView.tag  = 105;
		self.modeWindImageView.tag  = 106;
		self.modeDehumImageView.tag = 107;
		
        self.speedImageView.userInteractionEnabled     = YES;
        self.powerImageView.userInteractionEnabled     = YES;
        self.modeCoolImageView.userInteractionEnabled  = YES;
        self.modeHeatImageView.userInteractionEnabled  = YES;
        self.modeWindImageView.userInteractionEnabled  = YES;
        self.modeDehumImageView.userInteractionEnabled = YES;
        self.swingHandImageView.userInteractionEnabled = YES;
        self.swingAutoImageView.userInteractionEnabled = YES;
 
		[self.speedImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.powerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeCoolImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeHeatImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeWindImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeDehumImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.swingHandImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.swingAutoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		
		
		self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
		[self addSubview:self.tipsLabel];
		
		
		/// 建立socket连接 并组帧 发送请求数据
		[self postTokenWithTCPSocket];
		//添加监听通知
		[self addNotificationCenterObserver];
		
	}
	
	return self;
}

#pragma mark- 设置滑动条的监听事件
// 当滑动条值改变时，执行该方法
- (void) sliderValueChanged:(UISlider *)paramSender{
    
	if ([paramSender isEqual:self.tempSlider]){
		
		if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
			int speed = 0;
			[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:[NSString stringWithFormat:@"%.0f",paramSender.value *14 + 16] winddirection:@"00"];
			
		}else if ([self.iracData.switchOff isEqualToString:@"FF"])
		{
			// 如果刚进来 空调就开了
			int speed = 0;
			speed = [self.iracData.windspeed intValue];
			[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:self.iracData.mode temperature:[NSString stringWithFormat:@"%.0f",paramSender.value *14 + 16] winddirection:self.iracData.winddirection];
		}
	}
}
#pragma mark - 刚加载 该界面时 设置 按钮的状态
- (void)setUpBtnState
{
	if ([self.iracData.switchOff isEqualToString:@"FF"]){
        
        //设置风速高亮图片
        [self selectImageViewHighright:self.speedImageView];
        
		// 设置风速 按钮状态
		int windspeed = [self.iracData.windspeed intValue];
		switch (windspeed) {
			case 0:
				[self setSpeedBadgeLabelText: @"自动"];
				[self setSpeedImageViewSpeed:windspeed];
				break;
			case 1:
				[self setSpeedBadgeLabelText: @"低"];
				[self setSpeedImageViewSpeed:windspeed];
				break;
			case 2:
				[self setSpeedBadgeLabelText: @"中"];
				[self setSpeedImageViewSpeed:windspeed];
				break;
			case 3:
				[self setSpeedBadgeLabelText: @"高"];
				[self setSpeedImageViewSpeed:windspeed];
				break;
			default:
				break;
		}
		
		DDLogError(@"switchOff--%@", self.iracData.switchOff);
		// 设置空调 按钮状态
		if ([self.iracData.switchOff isEqualToString:@"FF"]) {
			self.powerImageView.highlighted = YES;
			
		}
		
		// 设置mode 按钮状态
		int mode = [self.iracData.mode intValue];
		switch (mode) {
			case 0:
				
				break;
			case 1://制冷
                self.modeCoolImageView.highlighted = YES;
                
                [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:2 G:207 B:93 alpha:1.0] imageString:@"制冷" title:@"制冷"];
                
				break;
			case 2://除湿
                self.modeDehumImageView.highlighted = YES;
                
                [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:55 G:157 B:255 alpha:1.0] imageString:@"除湿小" title:@"除湿"];
				break;
			case 3://送风
				self.modeWindImageView.highlighted = YES;
                
                [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:55 G:157 B:255 alpha:1.0] imageString:@"送风小" title:@"送风"];
                
				break;
			case 4://制热
                self.modeHeatImageView.highlighted = YES;
                
                [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:255 G:114 B:47 alpha:1.0] imageString:@"制热" title:@"制热"];
                
				break;
			default:
				break;
		}
		// 设置摆风模式 按钮状态
		int winddirection = [self.iracData.winddirection intValue];
		switch (winddirection) {
			case 0://自动摆风
				self.swingAutoImageView.highlighted = YES;
				break;
			case 1://手动摆风
				self.swingHandImageView.highlighted = YES;
				break;
				default:
				break;
		}
		//设置温度
		if ([self.iracData.temperature intValue] < 16) {
			self.tempLabel.text = @"16";
			self.tempSlider.value = 16;
		}else if ([self.iracData.temperature intValue] > 30)
		{
			self.tempLabel.text = @"30";
			self.tempSlider.value = 30;
		}else
		{
			
			self.tempLabel.text = self.iracData.temperature;
			//设置滑块位置
			self.tempSlider.value = ([self.iracData.temperature floatValue] - 16)/14.0;
		}
	}else
    {
        [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor whiteColor] imageString:@"" title:@""];
    }
	
}

// 给fistLabel textColor fistImageView赋值
- (void)setUpFirstImageViewAndFirstLabelWithColor:(UIColor *)color imageString:(NSString *)imageString title:(NSString *)title
{
    
    self.fistLabel.text = title;
    self.fistLabel.textColor = color;
    self.fistImageView.image = [UIImage imageNamed:imageString];
}
#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的控制帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlIrac:) name:kNotificationControlIrac object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
- (void)dealloc
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -  通知处理方法
static BOOL isOvertime = NO;
//监听空调的控制帧
- (void)receviedWithControlIrac:(NSNotification *)notification
{
	isOvertime = YES;
    [SVProgressTool hr_dismiss];
	// 判断 是不是自己发过去  返回的帧
	NSDictionary *dict = notification.userInfo;
   [self.tipsLabel showText:@"控制成功!" duration:3];

	self.iracData = [IracData mj_objectWithKeyValues:dict[@"msg"]];
	DDLogWarn(@"AirCtrlView-windspeed-2-%@", self.iracData.windspeed);
	[self layoutIfNeeded];
	[self reloadInputViews];
	[self setNeedsLayout];
	[self setNeedsDisplay];
	
	self.speedImageView.highlighted = NO;
	self.powerImageView.highlighted = NO;
	self.modeCoolImageView.highlighted  = NO;
	self.modeHeatImageView.highlighted  = NO;
	self.modeWindImageView.highlighted  = NO;
	self.modeDehumImageView.highlighted  = NO;
	self.swingHandImageView.highlighted  = NO;
	self.swingAutoImageView.highlighted  = NO;
	self.modeCoolImageView.highlighted  = NO;
	
	
	if ([self.iracData.switchOff isEqualToString:@"00"])//如果空调是关闭状态
	{
		[self.powerImageView doFlipAnimChangeHightlighted:NO];
		[self setSpeedBadgeLabelText: @""];
		self.speedBadgeLabel.backgroundColor = [UIColor clearColor];
		[self.modeCoolImageView doFlipAnimChangeHightlighted:NO];
		[self.modeHeatImageView doFlipAnimChangeHightlighted:NO];
		[self.modeWindImageView doFlipAnimChangeHightlighted:NO];
		[self.modeDehumImageView doFlipAnimChangeHightlighted:NO];
		[self.swingAutoImageView doFlipAnimChangeHightlighted:NO];
		[self.swingHandImageView doFlipAnimChangeHightlighted:NO];
        [self setSpeedImageViewSpeed: -1];
        
        
        [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor whiteColor] imageString:@"" title:@""];
		
	}else if ([self.iracData.switchOff isEqualToString:@"FF"]) {//打开状态
        //设置风速高亮图片
        [self selectImageViewHighright:self.speedImageView];
        
		[self.powerImageView doFlipAnimChangeHightlighted:YES];
		self.speedBadgeLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
		
		//调速
		int speed = [self.iracData.windspeed intValue];
        
		if ([self.iracData.windspeed isEqualToString:@"00"]) {
			[self setSpeedBadgeLabelText: @"自动"];
			[self setSpeedImageViewSpeed:speed];
		}else if ([self.iracData.windspeed isEqualToString:@"01"])
		{
			[self setSpeedBadgeLabelText: @"低"];
			[self setSpeedImageViewSpeed:speed];
		}else if ([self.iracData.windspeed isEqualToString:@"02"])
		{
			[self setSpeedBadgeLabelText: @"中"];
			[self setSpeedImageViewSpeed:speed];
		}else if ([self.iracData.windspeed isEqualToString:@"03"])
		{
			[self setSpeedBadgeLabelText: @"高"];
			[self setSpeedImageViewSpeed:speed];
		}
		
		//制冷
		if ([self.iracData.mode isEqualToString:@"01"]) {
            
            [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:2 G:207 B:93 alpha:1.0] imageString:@"制冷" title:@"制冷"];
            
			[self.modeCoolImageView doFlipAnimChangeHightlighted:YES];
			//其他模式关闭
			[self.modeHeatImageView doFlipAnimChangeHightlighted:NO];
			[self.modeWindImageView doFlipAnimChangeHightlighted:NO];
			[self.modeDehumImageView doFlipAnimChangeHightlighted:NO];
		}else if ([self.iracData.mode isEqualToString:@"02"])//02：除湿
		{
            
            [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:55 G:157 B:255 alpha:1.0] imageString:@"除湿小" title:@"除湿"];
            
			[self.modeCoolImageView doFlipAnimChangeHightlighted:NO];
			//其他模式关闭
			[self.modeHeatImageView doFlipAnimChangeHightlighted:NO];
			[self.modeWindImageView doFlipAnimChangeHightlighted:NO];
			[self.modeDehumImageView doFlipAnimChangeHightlighted:YES];
		}else if ([self.iracData.mode isEqualToString:@"03"])//03：送风
        {
            [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:55 G:157 B:255 alpha:1.0] imageString:@"送风小" title:@"送风"];
            
			[self.modeCoolImageView doFlipAnimChangeHightlighted:NO];
			//其他模式关闭
			[self.modeHeatImageView doFlipAnimChangeHightlighted:NO];
			[self.modeWindImageView doFlipAnimChangeHightlighted:YES];
			[self.modeDehumImageView doFlipAnimChangeHightlighted:NO];
		}else if ([self.iracData.mode isEqualToString:@"04"])//04：制暖
		{
            [self setUpFirstImageViewAndFirstLabelWithColor:[UIColor colorWithR:255 G:114 B:47 alpha:1.0] imageString:@"制热" title:@"制热"];
            
			[self.modeCoolImageView doFlipAnimChangeHightlighted:NO];
			//其他模式关闭
			[self.modeHeatImageView doFlipAnimChangeHightlighted:YES];
			[self.modeWindImageView doFlipAnimChangeHightlighted:NO];
			[self.modeDehumImageView doFlipAnimChangeHightlighted:NO];
		}
		
		//摆风模式
		if ([self.iracData.winddirection isEqualToString:@"00"]) {//00自动摆风
			
			[self.swingAutoImageView doFlipAnimChangeHightlighted:YES];
			//其他模式关闭
			[self.swingHandImageView doFlipAnimChangeHightlighted:NO];
		}else if ([self.iracData.winddirection isEqualToString:@"02"])//01手动摆风
		{
			[self.swingAutoImageView doFlipAnimChangeHightlighted:NO];
			//其他模式关闭
			[self.swingHandImageView doFlipAnimChangeHightlighted:YES];
		}
		
		//温度 label
		self.tempLabel.text = self.iracData.temperature;
		//设置滑块位置
		self.tempSlider.value = ([self.iracData.temperature floatValue] - 16)/14.0;
	}

    
}

#define IMAGE_TEXT_MARGIN 3

-(void)drawRect:(CGRect)rect {
	[self myLayoutSubviews];
    self.speedBadgeLabel.textColor       = [UIColor whiteColor];
    self.speedBadgeLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    self.speedBadgeLabel.textAlignment   = NSTextAlignmentCenter;
    self.speedBadgeLabel.clipsToBounds   = YES;
	//设置 按钮状态
	[self setUpBtnState];
}

-(void)setSpeedBadgeLabelText: (NSString *)text {
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13]forKey:NSFontAttributeName];
    CGSize size               = [text sizeWithAttributes:attributes];
	size = CGSizeMake(size.width + 10, size.height + 2);
	[_speedBadgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(size);
	}];
    self.speedBadgeLabel.font               = [UIFont systemFontOfSize:13];
    self.speedBadgeLabel.text               = text;
    self.speedBadgeLabel.layer.cornerRadius = size.height/2.f;
}
#pragma mark - 布局子控件
-(void) myLayoutSubviews {
	CGFloat width   = self.bounds.size.width *0.2f;
	CGFloat gapHroz = self.bounds.size.width *0.4f/4.f;
	CGFloat gapVert = 0.f;
	if(IS_3_5_INCH_SCREEN) {
		gapVert = gapHroz / 2 + 10;
	} else {
		gapVert = (self.bounds.size.height - width*4.f) / 6.f /2 + 10;
	}
	
	self.tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:width*1.2];
	self.unitLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
		//温度Label
    self.tempLabel.backgroundColor = [UIColor clearColor];
    self.tempLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:90];
    self.tempLabel.textColor = [UIColor whiteColor];
    
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        if (UIScreenW >= 375) {
            make.top.equalTo(self).offset(57.5);
        }else
        {
            make.top.equalTo(self).offset(25.5);
        }
//		make.size.mas_equalTo(CGSizeMake(width*1.5, width*1.5));
//		make.left.equalTo(self.powerImageView.mas_right).with.offset(10);
//		make.centerY.equalTo(self.powerImageView.mas_centerY);
    }];
    //温度单位label
    self.unitLabel.backgroundColor = [UIColor clearColor];
    self.unitLabel.textColor = [UIColor whiteColor];
    self.unitLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:60];
	[self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tempLabel).offset(-10);
        make.left.equalTo(self.tempLabel.mas_right);
    }];
	
    //温度类型图片
    [self.fistImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tempLabel.mas_right).offset(10);
        make.bottom.equalTo(self.tempLabel).offset(- 30);
    }];
    //温度类型文字
    [self.fistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fistImageView.mas_right).offset(2.5);
        make.bottom.equalTo(self.fistImageView);
    }];
    
    
    //温度调节Slider
    [self.tempSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(gapHroz + 35);
        if (UIScreenW >= 375) {
            make.top.equalTo(self.tempLabel.mas_bottom).offset(10);
        }else
        {
            make.top.equalTo(self.tempLabel.mas_bottom).offset(0);
        }
        make.right.equalTo(self).with.offset(-gapHroz - 35);
        make.height.mas_equalTo(@40);
    }];
    
    //增减按钮
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tempSlider.mas_left).offset(-25);
        make.centerY.equalTo(self.tempSlider);
    }];
    [self.increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tempSlider.mas_right).offset(25);
        make.centerY.equalTo(self.tempSlider);
    }];
	/*************第二行**************/
    
	//模式制冷
	[self.modeCoolImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.left.equalTo(self).with.offset(gapHroz);
		make.top.equalTo(self.tempSlider.mas_bottom).with.offset(gapVert);
	}];
	//模式制冷label
	[self.modeCoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.modeCoolImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.modeCoolImageView.mas_centerX);
	}];
    self.modeCoolLabel.textColor = [UIColor whiteColor];
    
    //电源
    [self.powerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.centerY.equalTo(self.modeCoolImageView.mas_centerY);
        make.left.equalTo(self.modeCoolImageView.mas_right).with.offset(gapHroz);
    }];
    //电源label
    [self.powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.powerImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
        make.centerX.equalTo(self.powerImageView.mas_centerX);
    }];
    self.powerLabel.textColor = [UIColor whiteColor];
    
    
    //模式除湿
    [self.modeDehumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.equalTo(self.powerImageView.mas_right).with.offset(gapHroz);
        make.centerY.equalTo(self.powerImageView.mas_centerY);
    }];
    //模式除湿Label
    [self.modeHumiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modeDehumImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
        make.centerX.equalTo(self.modeDehumImageView.mas_centerX);
    }];
    
    self.modeHumiLabel.textColor = [UIColor whiteColor];
    /*************第3行**************/
    //模式制热
    [self.modeHeatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.equalTo(self).with.offset(gapHroz);
        make.top.equalTo(self.modeCoolImageView.mas_bottom).with.offset(gapVert);
    }];
    //模式制热Label
    [self.modeHeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modeHeatImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
        make.centerX.equalTo(self.modeHeatImageView.mas_centerX);
    }];
    self.modeHeatLabel.textColor = [UIColor whiteColor];
    //模式送风
    [self.modeWindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.equalTo(self.modeHeatImageView.mas_right).with.offset(gapHroz);
        make.centerY.equalTo(self.modeHeatImageView.mas_centerY);
    }];
    //模式送风Label
    [self.modeWindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modeWindImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
        make.centerX.equalTo(self.modeWindImageView.mas_centerX);
    }];
    self.modeWindLabel.textColor = [UIColor whiteColor];
    
    
    //风速
    [self.speedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.equalTo(self.modeWindImageView.mas_right).with.offset(gapHroz);
        make.centerY.equalTo(self.modeHeatImageView.mas_centerY);
    }];
    self.speedImageView.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.speedImageView.layer.cornerRadius = width/2.f;
    //风速label
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
        make.centerX.equalTo(self.speedImageView.mas_centerX);
    }];
    self.speedLabel.textColor = [UIColor whiteColor];
    //风速Badge
    [self.speedBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedImageView.mas_top).with.offset(8);
        make.centerX.equalTo(self.speedImageView.mas_right).offset(-10);
    }];
    
    /****************** 最后一行 ******************/
	//手动摆风
    [self.swingHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.equalTo(self).with.offset(gapHroz);
        make.top.equalTo(self.modeHeatImageView.mas_bottom).with.offset(gapVert);
	}];
	//手动摆风Label
	[self.swingHandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.swingHandImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.swingHandImageView.mas_centerX);
    }];
    self.swingHandLabel.textColor = [UIColor whiteColor];
	//自动摆风
    [self.swingAutoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.equalTo(self.swingHandImageView.mas_right).with.offset(gapHroz);
        make.centerY.equalTo(self.swingHandImageView.mas_centerY);
	}];
	//手动摆风Label
	[self.swingAutoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.swingAutoImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.swingAutoImageView.mas_centerX);
    }];
    self.swingAutoLabel.textColor = [UIColor whiteColor];
	
}
#pragma mark - IracData 属性set方法
- (void)setIracData:(IracData *)iracData
{
	_iracData = iracData;
	
	DDLogWarn(@"AirCtrlView-windspeed-%@", iracData.windspeed);
}
#pragma mark - 增减按钮点击事件
- (void)reduceButtonClick:(UIButton *)button
{
    CGFloat value = 1/14.0;
    self.tempSlider.value -= value;
    DDLogWarn(@"self.tempSlider.value1-%f", self.tempSlider.value);
    if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
        int speed = 0;
        [self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:[NSString stringWithFormat:@"%.0f",self.tempSlider.value *14 + 16] winddirection:@"00"];
        
    }else if ([self.iracData.switchOff isEqualToString:@"FF"])
    {
        // 如果刚进来 空调就开了
        int speed = 0;
        speed = [self.iracData.windspeed intValue];
        [self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:self.iracData.mode temperature:[NSString stringWithFormat:@"%.0f",self.tempSlider.value *14 + 16] winddirection:self.iracData.winddirection];
    }
}
- (void)increaseButtonClick:(UIButton *)button
{
    CGFloat value = 1/14.0;
    self.tempSlider.value += value;
    DDLogWarn(@"self.tempSlider.value2-%f", self.tempSlider.value);
    if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
        int speed = 0;
        [self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:[NSString stringWithFormat:@"%.0f",self.tempSlider.value *14 + 16] winddirection:@"00"];
        
    }else if ([self.iracData.switchOff isEqualToString:@"FF"])
    {
        // 如果刚进来 空调就开了
        int speed = 0;
        speed = [self.iracData.windspeed intValue];
        [self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:self.iracData.mode temperature:[NSString stringWithFormat:@"%.0f",self.tempSlider.value *14 + 16] winddirection:self.iracData.winddirection];
    }
}
#pragma mark - 发送控制数据
-(void)tapImageView: (UITapGestureRecognizer *)gesture {
	UIImageView *imageView = (UIImageView *)gesture.view;
    self.currentImageView = imageView;
	switch (imageView.tag) {
		case 100:
		{
            
            
			static int speed = 0;
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				//设置默认风速
				DDLogError(@"%@",self.iracData.switchOff);
				speed = 0;
				[self setUpWindSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:self.tempLabel.text winddirection:@"00"];
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				speed = [self.iracData.windspeed intValue];//这里值如果是最新的话
				//设置风速
				[self setUpWindSpeed:speed OnSwitch:self.iracData.switchOff mode:self.iracData.mode temperature:self.iracData.temperature winddirection:self.iracData.winddirection];
			}
		}
			
		break;
		case 101:	//电源
		{
			
			if (!self.iracData.switchOff || self.iracData.windspeed == nil || [self.iracData.switchOff isEqualToString:@"00"])
			{
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:self.tempLabel.text winddirection:@"00"];
				
			}else if (self.iracData.switchOff &&  [self.iracData.switchOff isEqualToString:@"FF"]) {
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"00" mode:@"01" temperature:self.tempLabel.text winddirection:@"00"];
				
			}
		}
			break;
		case 102:	//制冷
		{
			
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:self.tempLabel.text winddirection:@"00"];
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				int speed = 0;
				speed = [self.iracData.windspeed intValue];
				if ([self.iracData.mode isEqualToString:@"01"]) {
					
					[self.tipsLabel showText:@"正在制冷..." duration:2.0];
				}else{
					//设置风速
					[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:@"01" temperature:self.iracData.temperature winddirection:self.iracData.winddirection];
				}
			}
			
		}
			break;
		case 103:	//手动摆风
		{
			//如果刚开始是手动摆风  再点击按键就什么都不做  如果刚开始不是手动摆风  就开启手动摆风模式
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:self.tempLabel.text winddirection:@"01"];
				
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				int speed = 0;
				speed = [self.iracData.windspeed intValue];
				if ([self.iracData.winddirection isEqualToString:@"01"]) {
					
					[self.tipsLabel showText:@"正在手动摆风..." duration:2.0];
				}else{
					//设置手动摆风
					[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:self.iracData.mode temperature:self.iracData.temperature winddirection:@"01"];
				}
			}
			
		}
			break;
		case 104:	//自动摆风
		{
			//如果刚开始是自动摆风  再点击按键就什么都不做  如果刚开始不是自动摆风  就开启自动摆风模式
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"01" temperature:self.tempLabel.text winddirection:@"00"];
				
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				int speed = 0;
				speed = [self.iracData.windspeed intValue];
				if ([self.iracData.winddirection isEqualToString:@"00"]) {
					
					[self.tipsLabel showText:@"正在自动摆风..." duration:2.0];
				}else{
					//设置手动摆风
					[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:self.iracData.mode temperature:self.iracData.temperature winddirection:@"00"];
				}
			}
			
		}
			break;
		case 105://制热
		{
			//如果刚开始是制热  再点击按键就什么都不做  如果刚开始不是制热  就开启制热模式
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"04" temperature:self.tempLabel.text winddirection:@"00"];
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				int speed = 0;
				speed = [self.iracData.windspeed intValue];
				if ([self.iracData.mode isEqualToString:@"04"]) {
					
					[self.tipsLabel showText:@"正在制暖..." duration:2.0];
				}else{
					//设置制暖
					[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:@"04" temperature:self.iracData.temperature winddirection:self.iracData.winddirection];
				}
			}
			
		}
			break;
		case 106://送风
		{
			//如果刚开始是送风 再点击按键就什么都不做  如果刚开始不是送风  就开启送风模式
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"03" temperature:self.tempLabel.text winddirection:@"00"];
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				int speed = 0;
				speed = [self.iracData.windspeed intValue];
				if ([self.iracData.mode isEqualToString:@"03"]) {
					
					[self.tipsLabel showText:@"正在送风..." duration:2.0];
				}else{
					//设置制暖
					[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:@"03" temperature:self.iracData.temperature winddirection:self.iracData.winddirection];
				}
			}
		}
			break;
		case 107://除湿
		{
			//如果刚开始是除湿 再点击按键就什么都不做  如果刚开始不是除湿  就开启除湿模式
			if (!self.iracData.switchOff || self.iracData.switchOff == nil || [self.iracData.switchOff isEqualToString:@"00"]) {//如果空调没开
				int speed = 0;
				[self setUpOtherBtnWithSpeed:speed OnSwitch:@"FF" mode:@"02" temperature:self.tempLabel.text winddirection:@"00"];
				
			}else if ([self.iracData.switchOff isEqualToString:@"FF"])
			{
				// 如果刚进来 空调就开了
				int speed = 0;
				speed = [self.iracData.windspeed intValue];
				if ([self.iracData.mode isEqualToString:@"02"]) {
					
					[self.tipsLabel showText:@"正在除湿..." duration:2.0];
				}else{
					//设置制暖
					[self setUpOtherBtnWithSpeed:speed OnSwitch:self.iracData.switchOff mode:@"02" temperature:self.iracData.temperature winddirection:self.iracData.winddirection];
				}
			}
		}
			break;
	default:
		break;
	}
}

//设置其他按键
- (void)setUpOtherBtnWithSpeed:(int)speed OnSwitch:(NSString *)onSwitch mode:(NSString *)mode temperature:(NSString *)temperature winddirection:(NSString *)winddirection
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	
	/// 发送控制空调 请求帧
	NSString *str = [NSString stringWithIRACVersion:@"0.0.1"
										   status:@"200"
											token:token
											 type:@"control"
											 desc:@"control desc message"
									  srcUserName:user
									  dstUserName:user
									   dstDevName:self.iracData.uuid
											  uid:self.iracData.uid
											  mid:self.iracData.mid
											  did:self.iracData.did
											 uuid:self.iracData.uuid
											types:self.iracData.types
									   newVersion:self.iracData.version
											title:self.iracData.title
											brand:self.iracData.brand
										  created:self.iracData.created
										   update:self.iracData.update
											state:self.iracData.state
										  picture:self.iracData.picture
										 regional:self.iracData.regional
											model:self.iracData.model
										 onSwitch:onSwitch
											 mode:mode
									  temperature:temperature
										windspeed:[NSString stringWithFormat:@"0%d", speed]
									winddirection:winddirection];
			
			DDLogWarn(@"-------发送空调其他按键-请求帧-------iracTest%@", str);
	
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	// 启动定时器
	
	isOvertime = NO;
	isShowOverMenu = NO;
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}


//设置风速
- (void)setUpWindSpeed:(int)speed OnSwitch:(NSString *)onSwitch mode:(NSString *)mode temperature:(NSString *)temperature winddirection:(NSString *)winddirection
{
	speed = speed == 3 ? 0:++speed;
	DDLogVerbose(@"speed: %d", speed);
	
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	NSString *str;
	switch (speed) {
		case 0:
		{
			/// 发送控制空调 请求帧
			str = [NSString stringWithIRACVersion:@"0.0.1"
													 status:@"200"
													  token:token
													   type:@"control"
													   desc:@"control desc message"
												srcUserName:user
												dstUserName:user
												 dstDevName:self.iracData.uuid
														uid:self.iracData.uid
														mid:self.iracData.mid
														did:self.iracData.did
													   uuid:self.iracData.uuid
													  types:self.iracData.types
												 newVersion:self.iracData.version
													  title:self.iracData.title
													  brand:self.iracData.brand
													created:self.iracData.created
													 update:self.iracData.update
													  state:self.iracData.state
													picture:self.iracData.picture
												   regional:self.iracData.regional
													  model:self.iracData.model
												   onSwitch:onSwitch
													   mode:mode
												temperature:temperature
												  windspeed:[NSString stringWithFormat:@"0%d", speed]
											  winddirection:winddirection];
			
			DDLogWarn(@"-------发送空调风速自动请求帧-------iracTest%@", str);
		}
			break;
		case 1:
		{
			
			/// 发送控制空调 请求帧
			DDLogError(@"self.iracData.uuid%@", self.iracData.uuid);
			str = [NSString stringWithIRACVersion:@"0.0.1"
										   status:@"200"
											token:token
											 type:@"control"
											 desc:@"control desc message"
									  srcUserName:user
									  dstUserName:user
									   dstDevName:self.iracData.uuid
											  uid:self.iracData.uid
											  mid:self.iracData.mid
											  did:self.iracData.did
											 uuid:self.iracData.uuid
											types:self.iracData.types
									   newVersion:self.iracData.version
											title:self.iracData.title
											brand:self.iracData.brand
										  created:self.iracData.created
										   update:self.iracData.update
											state:self.iracData.state
										  picture:self.iracData.picture
										 regional:self.iracData.regional
											model:self.iracData.model
										 onSwitch:onSwitch
											 mode:mode
									  temperature:temperature
										windspeed:[NSString stringWithFormat:@"0%d", speed]
									winddirection:winddirection];
			
			DDLogWarn(@"-------发送空调风速自动请求帧1-------iracTest%@", str);
			
		}
			break;
		case 2:
		{
			/// 发送控制空调 请求帧
			str = [NSString stringWithIRACVersion:@"0.0.1"
										   status:@"200"
											token:token
											 type:@"control"
											 desc:@"control desc message"
									  srcUserName:user
									  dstUserName:user
									   dstDevName:self.iracData.uuid
											  uid:self.iracData.uid
											  mid:self.iracData.mid
											  did:self.iracData.did
											 uuid:self.iracData.uuid
											types:self.iracData.types
									   newVersion:self.iracData.version
											title:self.iracData.title
											brand:self.iracData.brand
										  created:self.iracData.created
										   update:self.iracData.update
											state:self.iracData.state
										  picture:self.iracData.picture
										 regional:self.iracData.regional
											model:self.iracData.model
										 onSwitch:onSwitch
											 mode:mode
									  temperature:temperature
										windspeed:[NSString stringWithFormat:@"0%d", speed]
									winddirection:winddirection];
		
			DDLogWarn(@"-------发送空调风速自动请求帧2-------iracTest%@", str);
			
		}
			break;
		case 3:
		{
			
			/// 发送控制空调 请求帧
			str = [NSString stringWithIRACVersion:@"0.0.1"
										   status:@"200"
											token:token
											 type:@"control"
											 desc:@"control desc message"
									  srcUserName:user
									  dstUserName:user
									   dstDevName:self.iracData.uuid
											  uid:self.iracData.uid
											  mid:self.iracData.mid
											  did:self.iracData.did
											 uuid:self.iracData.uuid
											types:self.iracData.types
									   newVersion:self.iracData.version
											title:self.iracData.title
											brand:self.iracData.brand
										  created:self.iracData.created
										   update:self.iracData.update
											state:self.iracData.state
										  picture:self.iracData.picture
										 regional:self.iracData.regional
											model:self.iracData.model
										 onSwitch:onSwitch
											 mode:mode
									  temperature:temperature
										windspeed:[NSString stringWithFormat:@"0%d", speed]
									winddirection:winddirection];
		
			DDLogWarn(@"-------发送空调风速自动请求帧3-------iracTest%@", str);
			
		}
			break;
		default:
			break;
	}
	
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	
	isOvertime = NO;
	isShowOverMenu = NO;
	// 启动定时器
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
// 让点击的图片成高亮
- (void)selectImageViewHighright:(UIImageView *)imageView
{
    self.currentImageView.highlighted = NO;
    imageView.highlighted = YES;
    
    self.currentImageView = imageView;
}
-(void) setSpeedImageViewSpeed: (int)speed {
	[self.speedImageView.layer pop_removeAnimationForKey:@"rotationAnimation"];
	if(speed < 0) return ;
	POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
	anim.duration = 60;
	anim.toValue = [NSNumber numberWithFloat:speed == 0 ? (M_PI * 50):(M_PI * speed * 50)];
	anim.repeatCount = 10000000;
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[self.speedImageView.layer pop_addAnimation:anim forKey:@"rotationAnimation"];
}

@end
