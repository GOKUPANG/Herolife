
#import "SceneAirView.h"
#import "TipsLabel.h"
#import "IracData.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import <SVProgressHUD.h>
@interface SceneAirView()

@property (strong, nonatomic) UILabel *speedBadgeLabel;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *powerLabel;
@property (strong, nonatomic) UILabel *modeCoolLabel;
@property (strong, nonatomic) UILabel *modeHeatLabel;
@property (strong, nonatomic) UILabel *modeWindLabel;
@property (strong, nonatomic) UILabel *modeHumiLabel;
@property (strong, nonatomic) UILabel *swingHandLabel;
@property (strong, nonatomic) UILabel *swingAutoLabel;


@property (strong, nonatomic) UIImageView *speedImageView;
@property (strong, nonatomic) UIImageView *powerImageView;
@property (strong, nonatomic) UIImageView *modeCoolImageView;
@property (strong, nonatomic) UIImageView *modeHeatImageView;
@property (strong, nonatomic) UIImageView *modeWindImageView;
@property (strong, nonatomic) UIImageView *modeDehumImageView;
@property (strong, nonatomic) UIImageView *swingHandImageView;
@property (strong, nonatomic) UIImageView *swingAutoImageView;
@property (strong, nonatomic) UILabel *tempLabel;
@property (strong, nonatomic) UILabel *unitLabel;
@property (strong, nonatomic) UISlider *tempSlider;

@property (weak, nonatomic) UIImageView *currentImageView;
/** <#name#> */
@property(nonatomic, copy) NSString *status;

@end


@implementation SceneAirView

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		//初始化
		self.status = @"-1";
		self.opaque = NO;
		
		self.speedImageView     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_fan"] highlightedImage:[UIImage imageNamed:@"ico_air_fan"]];
		self.powerImageView     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_power_off"] highlightedImage:[UIImage imageNamed:@"ico_air_power_on"]];
		self.modeCoolImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_mode_cool_off"] highlightedImage:[UIImage imageNamed:@"ico_air_mode_cool_on"]];
		self.modeHeatImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_mode_heat_off"] highlightedImage:[UIImage imageNamed:@"ico_air_mode_heat_on"]];
		self.modeWindImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_mode_wind_off"] highlightedImage:[UIImage imageNamed:@"ico_air_mode_wind_on"]];
		self.modeDehumImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_mode_dehumid_off"] highlightedImage:[UIImage imageNamed:@"ico_air_mode_dehumid_on"]];
		self.swingHandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_swing_hand_off"] highlightedImage:[UIImage imageNamed:@"ico_air_swing_hand_pos_0"]];
		self.swingAutoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_air_swing_auto_off"] highlightedImage:[UIImage imageNamed:@"ico_air_swing_auto_on"]];
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
		
		self.tempLabel.text      = @"16";
		self.unitLabel.text      = @"℃";
		self.speedLabel.text     = @"风速";
		self.powerLabel.text     = @"电源";
		self.modeCoolLabel.text  = @"制冷";
		self.modeHeatLabel.text  = @"制热";
		self.modeWindLabel.text  = @"送风";
		self.modeHumiLabel.text  = @"除湿";
		self.swingHandLabel.text = @"手动摆风";
		self.swingAutoLabel.text = @"自动摆风";
		
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
		[self.speedImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.powerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeCoolImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeHeatImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeWindImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.modeDehumImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.swingHandImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
		[self.swingAutoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
	}
	
	return self;
}

#pragma mark- 设置滑动条的监听事件

// 当滑动条值改变时，执行该方法
- (void) sliderValueChanged:(UISlider *)paramSender{
	if ([paramSender isEqual:self.tempSlider]){
		[self stopSpeed];
		self.powerImageView.highlighted = NO;
		self.modeCoolImageView.highlighted = NO;
		self.modeHeatImageView.highlighted = NO;
		self.modeWindImageView.highlighted = NO;
		self.modeDehumImageView.highlighted = NO;
		self.swingHandImageView.highlighted = NO;
		self.swingAutoImageView.highlighted = NO;
		self.tempLabel.text = [NSString stringWithFormat:@"%d",(int)(paramSender.value *14 +16)];
		self.status = self.tempLabel.text;
		[self postNotificationWithStatus:self.status];
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
//	[self setUpBtnState];
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

-(void) myLayoutSubviews {
	CGFloat width   = self.bounds.size.width *0.2f;
	CGFloat gapHroz = self.bounds.size.width *0.4f/4.f;
	CGFloat gapVert = 0.f;
	if(IS_3_5_INCH_SCREEN) {
		gapVert = gapHroz;
	} else {
		gapVert = (self.bounds.size.height - width*4.f) / 6.f;
	}
	
	self.tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:width*1.2];
	self.unitLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
	
	//风速
	[self.speedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.top.equalTo(self).with.offset(gapVert);
		make.left.equalTo(self).with.offset(gapHroz);
	}];
	self.speedImageView.layer.backgroundColor = [UIColor colorWithRed:0.25 green:0.76 blue:0.92 alpha:1].CGColor;
	self.speedImageView.layer.cornerRadius = width/2.f;
	//风速label
	[self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.speedImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.speedImageView.mas_centerX);
	}];
	//风速Badge
	[self.speedBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.speedImageView.mas_top).with.offset(8);
		make.centerX.equalTo(self.speedImageView.mas_right).offset(-10);
	}];
	//电源
	[self.powerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerY.equalTo(self.speedImageView.mas_centerY);
		make.leftMargin.equalTo(self.speedImageView.mas_right).with.offset(gapHroz);
	}];
	//电源label
	[self.powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.powerImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.powerImageView.mas_centerX);
	}];
	//温度调节Slider
	[self.tempSlider mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).with.offset(gapHroz);
		make.top.equalTo(self.speedImageView.mas_bottom).with.offset(gapVert*2);
		make.right.equalTo(self).with.offset(-gapHroz);
		make.height.mas_equalTo(@40);
	}];
	//温度Label
	[self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width*1.5, width*1.5));
		make.left.equalTo(self.powerImageView.mas_right).with.offset(10);
		make.centerY.equalTo(self.powerImageView.mas_centerY);
	}];
	//温度单位label
	[self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(30, 30));
		make.left.equalTo(self.tempLabel.mas_right).with.offset(0);
		make.bottomMargin.equalTo(self.tempLabel.mas_bottom).with.offset(-20);
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
	//手动摆风
	[self.swingHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.left.equalTo(self.modeCoolImageView.mas_right).with.offset(gapHroz);
		make.centerY.equalTo(self.modeCoolImageView.mas_centerY);
	}];
	//手动摆风Label
	[self.swingHandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.swingHandImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.swingHandImageView.mas_centerX);
	}];
	//自动摆风
	[self.swingAutoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.left.equalTo(self.swingHandImageView.mas_right).with.offset(gapHroz);
		make.centerY.equalTo(self.modeCoolImageView.mas_centerY);
	}];
	//手动摆风Label
	[self.swingAutoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.swingAutoImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.swingAutoImageView.mas_centerX);
	}];
	
	/****************** 最后一行 ******************/
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
	//模式除湿
	[self.modeDehumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.left.equalTo(self.modeWindImageView.mas_right).with.offset(gapHroz);
		make.centerY.equalTo(self.modeHeatImageView.mas_centerY);
	}];
	//模式除湿Label
	[self.modeHumiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.modeDehumImageView.mas_bottom).with.offset(IMAGE_TEXT_MARGIN);
		make.centerX.equalTo(self.modeDehumImageView.mas_centerX);
	}];
}
#pragma mark - IracData 属性set方法
- (void)setIracData:(IracData *)iracData
{
	_iracData = iracData;
	
	DDLogWarn(@"AirCtrlView-windspeed-%@", iracData.windspeed);
}
#pragma mark - 发送控制数据
static int windspeed = 0;
-(void)tapImageView: (UITapGestureRecognizer *)gesture {
	UIImageView *imageView = (UIImageView *)gesture.view;
	
	DDLogInfo(@"highlighted1-%d",imageView.highlighted);
	
	switch (imageView.tag) {
		case 100://风速
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			_speedBadgeLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
			[self selectImageViewHighright:imageView];
			windspeed = windspeed == 3 ? 0:++windspeed;
			switch (windspeed) {
				case 0:
					[self setSpeedBadgeLabelText: @"自动"];
					[self setSpeedImageViewSpeed:windspeed];
					self.status = @"8";
					[self postNotificationWithStatus:self.status];
					break;
				case 1:
				{
					[self setSpeedBadgeLabelText: @"低"];
					[self setSpeedImageViewSpeed:windspeed];
					self.status = @"9";
					[self postNotificationWithStatus:self.status];
					
				}
					break;
				case 2:
					[self setSpeedBadgeLabelText: @"中"];
					[self setSpeedImageViewSpeed:windspeed];
					self.status = @"10";
					[self postNotificationWithStatus:self.status];
					break;
				case 3:
					[self setSpeedBadgeLabelText: @"高"];
					[self setSpeedImageViewSpeed:windspeed];
					self.status = @"11";
					[self postNotificationWithStatus:self.status];
					break;
				default:
					break;
			}
			
		}
			
			break;
		case 101:	//电源
		{
			//停止风速动画
			[self stopSpeed];
			// 只有点击了电源键,就让其他键回到默认转态
			
			self.modeCoolImageView.highlighted = NO;
			self.modeHeatImageView.highlighted = NO;
			self.modeWindImageView.highlighted = NO;
			self.modeDehumImageView.highlighted = NO;
			self.swingHandImageView.highlighted = NO;
			self.swingAutoImageView.highlighted = NO;
			imageView.highlighted = !imageView.highlighted;
			if (imageView.highlighted) {
				self.status = @"1";
				[self postNotificationWithStatus:self.status];
			}else
			{
				self.status = @"0";
				[self postNotificationWithStatus:self.status];
			}
		}
			break;
		case 102:	//制冷
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			//停止风速动画
			[self stopSpeed];
			[self selectImageViewHighright:imageView];
			self.status = @"4";
			[self postNotificationWithStatus:self.status];
		}
			break;
		case 103:	//手动摆风
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			//停止风速动画
			[self stopSpeed];
			[self selectImageViewHighright:imageView];
			self.status = @"13";
			[self postNotificationWithStatus:self.status];
		}
			break;
		case 104:	//自动摆风
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			//停止风速动画
			[self stopSpeed];
			[self selectImageViewHighright:imageView];
			self.status = @"12";
			[self postNotificationWithStatus:self.status];
		}
			break;
		case 105://制热
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			//停止风速动画
			[self stopSpeed];
			[self selectImageViewHighright:imageView];
			self.status = @"7";
			[self postNotificationWithStatus:self.status];
		}
			break;
		case 106://送风
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			//停止风速动画
			[self stopSpeed];
			[self selectImageViewHighright:imageView];
			self.status = @"6";
			[self postNotificationWithStatus:self.status];
		}
			break;
		case 107://除湿
		{
			//让电源键 回到默认转态
			self.powerImageView.highlighted = NO;
			//停止风速动画
			[self stopSpeed];
			[self selectImageViewHighright:imageView];
			self.status = @"5";
			[self postNotificationWithStatus:self.status];
		}
			break;
		default:
			break;
	}
}
/**
 *  发送传值通知
 */
- (void)postNotificationWithStatus:(NSString *)status
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"status"] = status;
	[kNotification postNotificationName:kNotificationSceneAirData object:nil userInfo:dict];
}
//停止风速动画 - 点击除风速 之外的图片,要让"风速"停止动画
- (void)stopSpeed
{
	//初始化风速
	windspeed = 0;
	[self setSpeedImageViewSpeed:-1];
	_speedBadgeLabel.backgroundColor = [UIColor clearColor];
	[self setSpeedBadgeLabelText: @""];
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
