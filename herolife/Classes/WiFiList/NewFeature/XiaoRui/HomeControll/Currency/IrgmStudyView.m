//
//  IrgmStudyView.m
//  xiaorui
//
//  Created by sswukang on 16/5/11.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "IrgmStudyView.h"
#import "TipsLabel.h"
#import "IrgmData.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "IrgmStudyBtn.h"

@interface IrgmStudyView()
/** TipsLabel */
@property(nonatomic, strong)TipsLabel *tipsLabel;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

@end


@implementation IrgmStudyView

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
		[self initSubviews];
		//添加通知 监听
		[self addNotificationCenterObserver];
		//建立socket连接通道
		[self postTokenWithTCPSocket];
		
		//设置按钮不可点击
		[self setNoEnableBtn];

	}
	return self;
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的测试帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithTestingIrgm:) name:kNotificationTestingIrgm object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[self.timer invalidate];
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}
#pragma mark -  通知处理方法
//是否是请求超时
static BOOL isOvertime = NO;
//监听通用的测试帧
- (void)receviedWithTestingIrgm:(NSNotification *)notification
{
    [SVProgressHUD dismiss];
	// 设置按钮状态
	[self setUpBtnState];
	[self.timer invalidate];
	isOvertime = YES;
	
	
	// 判断 是不是自己发过去  返回的帧
	NSDictionary *dict = notification.userInfo;
	self.irgmData = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
	NSArray *opArr = self.irgmData.op;
	//判断是否是自己推送的数据
	[self setOpWithArray:opArr];
	//
//		[self layoutIfNeeded];
//		[self reloadInputViews];
//		[self setNeedsLayout];
		[self setNeedsDisplay];
	
  switch ([self.irgmData.state intValue]) {
  case 2:
		    [self setEnableBtn];
		    [self studyButtonHiddenYes];
			[self.tipsLabel showText:@"学习开始,请点击任意遥控器按键来学习红外码!" duration:600000.0];
			break;
  case 3:
		    [self studyButtonHiddenNO];
		  [self setEnableBtn];
			[self.tipsLabel removeFromSuperview];
			self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, gapVert *2)];
			[self addSubview: self.tipsLabel];
			[self.tipsLabel showText:@"进入学习状态失败,请检查网络!" duration:5.0];
			break;
  case 5:
		    [self studyButtonHiddenYes];
		  [self setEnableBtn];
			[self.tipsLabel showText:@"学习成功!" duration:5.0];
			
			break;
  case 6:
			[self studyButtonHiddenYes];
		  [self setEnableBtn];
			[self.tipsLabel showText:@"学习失败!" duration:5.0];
			break;
  case 10:
			[self studyButtonHiddenNO];
			//设置按钮不可点击
			[self setNoEnableBtn];
			[self.tipsLabel showText:@"成功退出学习模式..." duration:66666.0];
			break;
  case 11:
			[self studyButtonHiddenYes];
			 [self setNoEnableBtn];
			[self.tipsLabel showText:@"状态错误,请退出重试!" duration:66666.0];
			break;
  default:
			break;
	}
	
}

#pragma mark - 判断是不是自己发送的帧
- (void)setOpWithArray:(NSArray *)opArr
{
	NSString *UUID = [kUserDefault objectForKey:kUserDefaultUUID];
	NSString *strUuid = opArr.lastObject;
	if (strUuid.length > 2) {
	
	if (![strUuid isEqualToString:UUID]) {
		
		int index = [self.irgmData.state intValue];
			if (index == 10) {//其他设备已 成功推出学习状态
			self.studyButton.enabled = YES;
			self.studyEndButton.enabled = YES;
			[self setEnableBtn];
			[self.tipsLabel showText:@"其他设备已成功退出学习模式,可以开始学习了!" duration:5.0];
			
		}else
		{
			self.studyButton.enabled = NO;
			self.studyEndButton.enabled = NO;
			[self setNoEnableBtn];
			[self.tipsLabel showText:@"有设备正在学习,请稍后重试..." duration:5.0];
			
			return;
		}
		
	}
		
	}
}
#pragma mark - 内部  控件
-(void) initSubviews {
    DDLogWarn(@"---------");
	self.muteButton     = [[UIButton alloc] init];
	self.powerButton    = [[UIButton alloc] init];
	self.menuButton     = [[UIButton alloc] init];
	self.num1Button     = [[UIButton alloc] init];
	self.num2Button     = [[UIButton alloc] init];
	self.num3Button     = [[UIButton alloc] init];
	self.num4Button     = [[UIButton alloc] init];
	self.num5Button     = [[UIButton alloc] init];
	self.num6Button     = [[UIButton alloc] init];
	self.num7Button     = [[UIButton alloc] init];
	self.num8Button     = [[UIButton alloc] init];
	self.num9Button     = [[UIButton alloc] init];
	self.num0Button     = [[UIButton alloc] init];
	self.backButton     = [[UIButton alloc] init];
	self.selectButton   = [[UIButton alloc] init];
	self.leftUpButton   = [[UIButton alloc] init];
	self.leftDownButton = [[UIButton alloc] init];
	self.rightUpButton  = [[UIButton alloc] init];
	self.rightDownButton= [[UIButton alloc] init];
	self.dirLeftButton  = [[UIButton alloc] init];
	self.dirRightButton = [[UIButton alloc] init];
	self.dirUpButton    = [[UIButton alloc] init];
	self.dirDownButton  = [[UIButton alloc] init];
	self.okButton       = [[UIButton alloc] init];
	self.studyEndButton = [[UIButton alloc] init];
	self.studyButton = [[UIButton alloc] init];
    
    
    //彬添加 左边的频道label   和右边的音量label
    
    [self addSubview:self.leftChannelLabel];
    [self addSubview:self.rightVolumeLabel];
    
    
    
    
    self.leftChannelLabel.text = @"频道";
    self.leftChannelLabel.font = [UIFont systemFontOfSize:20];
    self.leftChannelLabel.textColor = [UIColor whiteColor];
    self.leftChannelLabel.textAlignment= NSTextAlignmentCenter;
    
    self.rightVolumeLabel.text = @"音量";
    self.rightVolumeLabel.font = [UIFont systemFontOfSize:20];
    self.rightVolumeLabel.textColor = [UIColor whiteColor];
    self.rightVolumeLabel.textAlignment= NSTextAlignmentCenter;
    

	
	//绑定tag
	[self setTagWithBtn];
	
	[self addSubview:self.muteButton];
	[self addSubview:self.powerButton];
	[self addSubview:self.menuButton];
	[self addSubview:self.num1Button];
	[self addSubview:self.num2Button];
	[self addSubview:self.num3Button];
	[self addSubview:self.num4Button];
	[self addSubview:self.num5Button];
	[self addSubview:self.num6Button];
	[self addSubview:self.num7Button];
	[self addSubview:self.num8Button];
	[self addSubview:self.num9Button];
	[self addSubview:self.num0Button];
	[self addSubview:self.backButton];
	[self addSubview:self.selectButton];
	[self addSubview:self.leftUpButton];
	[self addSubview:self.leftDownButton];
	[self addSubview:self.rightUpButton];
	[self addSubview:self.rightDownButton];
	[self addSubview:self.dirLeftButton];
	[self addSubview:self.dirRightButton];
	[self addSubview:self.dirUpButton];
	[self addSubview:self.dirDownButton];
	[self addSubview:self.okButton];
	[self addSubview:self.studyEndButton];
	[self addSubview:self.studyButton];
	
		//开始学习
	self.studyButton.backgroundColor = [UIColor orangeColor];
	self.studyButton.layer.cornerRadius = 10;
	self.studyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.studyButton setTitle:@"开始学习" forState:UIControlStateNormal];
	self.studyButton.titleLabel.font = [UIFont systemFontOfSize:15];
	[self.studyButton.titleLabel sizeToFit];
	self.studyButton.tintColor = [UIColor whiteColor];
	//结束学习
	self.studyEndButton.backgroundColor = [UIColor orangeColor];
	self.studyEndButton.layer.cornerRadius = 10;
	self.studyEndButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.studyEndButton setTitle:@"结束学习" forState:UIControlStateNormal];
	
	self.studyEndButton.titleLabel.font = [UIFont systemFontOfSize:15];
	[self.studyEndButton.titleLabel sizeToFit];
	self.studyEndButton.tintColor = [UIColor whiteColor];
	
	//添加点击事件
	[self.muteButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.powerButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.menuButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num1Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num2Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num3Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num4Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num5Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num6Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num7Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num8Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num9Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.num0Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.backButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.selectButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.leftUpButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.leftDownButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.rightUpButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.rightDownButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirLeftButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirRightButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirUpButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.dirDownButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.okButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.studyButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.studyEndButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
// tag
- (void)setTagWithBtn
{
	self.muteButton.tag     = 0;//静音
	self.powerButton.tag    = 1;//待机
	self.menuButton.tag     = 2;//菜单
	self.num1Button.tag     = 3;//1
	self.num2Button.tag     = 4;//2
	self.num3Button.tag     = 5;//3
	self.num4Button.tag     = 6;//4
	self.num5Button.tag     = 7;//5
	self.num6Button.tag     = 8;//6
	self.num7Button.tag     = 9;//7
	self.num8Button.tag     = 10;//8
	self.num9Button.tag     = 11;//9
	self.num0Button.tag     = 13;//0
	self.backButton.tag     = 12;//返回
	self.selectButton.tag   = 14;//-/--
	self.leftUpButton.tag    =15;//left-up
	self.leftDownButton.tag   = 21;//left-down
	self.rightUpButton.tag    = 17;//right-up
	self.rightDownButton.tag  = 23;//right-down
	self.dirLeftButton.tag  = 18;//方向-left
	self.dirRightButton.tag = 20;//方向-right
	self.dirUpButton.tag    = 16;//方向-up
	self.dirDownButton.tag  = 22;//方向-down
	self.okButton.tag       = 19;//OK
	
	self.studyButton.tag = 24;//学习
	self.studyEndButton.tag = 25;//学习
	
    
}

//设置按钮可以点击
- (void)setuserInteractionEnabledYes
{
	self.muteButton.userInteractionEnabled     = YES;
	self.powerButton.userInteractionEnabled    = YES;
	self.menuButton.userInteractionEnabled     = YES;
	self.num1Button.userInteractionEnabled     = YES;
	self.num2Button.userInteractionEnabled     = YES;
	self.num3Button.userInteractionEnabled     = YES;
	self.num4Button.userInteractionEnabled     = YES;
	self.num5Button.userInteractionEnabled     = YES;
	self.num6Button.userInteractionEnabled     = YES;
	self.num7Button.userInteractionEnabled     = YES;
	self.num8Button.userInteractionEnabled     = YES;
	self.num9Button.userInteractionEnabled     = YES;
	self.num0Button.userInteractionEnabled     = YES;
	self.backButton.userInteractionEnabled     = YES;
	self.selectButton.userInteractionEnabled   = YES;
	self.leftUpButton.userInteractionEnabled     = YES;
	self.leftDownButton.userInteractionEnabled   = YES;
	self.rightUpButton.userInteractionEnabled    = YES;
	self.rightDownButton.userInteractionEnabled  = YES;
	self.dirLeftButton.userInteractionEnabled  = YES;
	self.dirRightButton.userInteractionEnabled = YES;
	self.dirUpButton.userInteractionEnabled    = YES;
	self.dirDownButton.userInteractionEnabled  = YES;
	self.okButton.userInteractionEnabled       = YES;
}
//设置按钮不可点击
- (void)setuserInteractionEnabledNo
{
	self.muteButton.userInteractionEnabled     = NO;
	self.powerButton.userInteractionEnabled    = NO;
	self.menuButton.userInteractionEnabled     = NO;
	self.num1Button.userInteractionEnabled     = NO;
	self.num2Button.userInteractionEnabled     = NO;
	self.num3Button.userInteractionEnabled     = NO;
	self.num4Button.userInteractionEnabled     = NO;
	self.num5Button.userInteractionEnabled     = NO;
	self.num6Button.userInteractionEnabled     = NO;
	self.num7Button.userInteractionEnabled     = NO;
	self.num8Button.userInteractionEnabled     = NO;
	self.num9Button.userInteractionEnabled     = NO;
	self.num0Button.userInteractionEnabled     = NO;
	self.backButton.userInteractionEnabled     = NO;
	self.selectButton.userInteractionEnabled   = NO;
	self.leftUpButton.userInteractionEnabled     = NO;
	self.leftDownButton.userInteractionEnabled   = NO;
	self.rightUpButton.userInteractionEnabled    = NO;
	self.rightDownButton.userInteractionEnabled  = NO;
	self.dirLeftButton.userInteractionEnabled  = NO;
	self.dirRightButton.userInteractionEnabled = NO;
	self.dirUpButton.userInteractionEnabled    = NO;
	self.dirDownButton.userInteractionEnabled  = NO;
	self.okButton.userInteractionEnabled       = NO;
	
	
}

//设置按钮可以点击
- (void)setEnableBtn
{
	self.muteButton.enabled     = YES;
	self.powerButton.enabled    = YES;
	self.menuButton.enabled     = YES;
	self.num1Button.enabled     = YES;
	self.num2Button.enabled     = YES;
	self.num3Button.enabled     = YES;
	self.num4Button.enabled     = YES;
	self.num5Button.enabled     = YES;
	self.num6Button.enabled     = YES;
	self.num7Button.enabled     = YES;
	self.num8Button.enabled     = YES;
	self.num9Button.enabled     = YES;
	self.num0Button.enabled     = YES;
	self.backButton.enabled     = YES;
	self.selectButton.enabled   = YES;
	self.leftUpButton.enabled     = YES;
	self.leftDownButton.enabled   = YES;
	self.rightUpButton.enabled    = YES;
	self.rightDownButton.enabled  = YES;
	self.dirLeftButton.enabled  = YES;
	self.dirRightButton.enabled = YES;
	self.dirUpButton.enabled    = YES;
	self.dirDownButton.enabled  = YES;
	self.okButton.enabled       = YES;
}
//设置按钮不可点击
- (void)setNoEnableBtn
{
	self.muteButton.enabled     = NO;
	self.powerButton.enabled    = NO;
	self.menuButton.enabled     = NO;
	self.num1Button.enabled     = NO;
	self.num2Button.enabled     = NO;
	self.num3Button.enabled     = NO;
	self.num4Button.enabled     = NO;
	self.num5Button.enabled     = NO;
	self.num6Button.enabled     = NO;
	self.num7Button.enabled     = NO;
	self.num8Button.enabled     = NO;
	self.num9Button.enabled     = NO;
	self.num0Button.enabled     = NO;
	self.backButton.enabled     = NO;
	self.selectButton.enabled   = NO;
	self.leftUpButton.enabled     = NO;
	self.leftDownButton.enabled   = NO;
	self.rightUpButton.enabled    = NO;
	self.rightDownButton.enabled  = NO;
	self.dirLeftButton.enabled  = NO;
	self.dirRightButton.enabled = NO;
	self.dirUpButton.enabled    = NO;
	self.dirDownButton.enabled  = NO;
	self.okButton.enabled       = NO;
	

}

static CGFloat gapVert;
-(void)layoutSubviews {
    
	CGFloat width = self.bounds.size.width / 6.f;
	CGFloat gapHorz = (self.bounds.size.width - width*3.f) / 4.f;
	gapVert = (self.bounds.size.height - width*8.f) / 11.f;
    if (gapVert <= 5 ) {
        gapVert = 5;
    }
    
    if (UIScreenW > 414) {
         width = self.bounds.size.width / 7.2f;
         gapHorz = (self.bounds.size.width - width*3.f) / 4.f;
         gapVert = (self.bounds.size.height - width*8.f) / 11.f;
        
         if (gapVert <= 9 ) {
            gapVert = 9;
         }
        
    }
	
    
	//提示框
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, gapVert * 3)];
	[self addSubview:self.tipsLabel];
	
	//开始学习
	CGSize textSize = [self.studyButton.titleLabel.text sizeWithAttributes:@{
																			 NSFontAttributeName :[UIFont systemFontOfSize:15],
	}];
    
    //结束学习
    
	[self.studyButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(textSize.width + 40, textSize.height + 15));
		make.width.mas_equalTo(textSize.width + 40);
		make.centerX.equalTo(self.mas_centerX);
		make.top.equalTo(self).offset(gapVert*2+ 10);
    }];
    
    [self.studyEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.studyButton);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(gapVert*2 +10);
    }];
    
	//静音
	[self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.left.equalTo(self).offset(gapHorz);
//		make.top.equalTo(self).offset(gapVert*7);
		make.top.equalTo(self.studyButton.mas_bottom).offset(13);
	}];
	//待机
	[self.powerButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width+gapVert, width+gapVert));
		make.centerX.equalTo(self.mas_centerX);
		make.bottom.equalTo(self.muteButton.mas_bottom);
	}];
	//菜单
	[self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerY.equalTo(self.muteButton.mas_centerY);
		make.right.equalTo(self.mas_right).offset(-gapHorz);
	}];
	//1
	[self.num1Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.muteButton.mas_bottom).offset(gapVert);
	}];
	//2
	[self.num2Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.num1Button);
	}];
	//3
	[self.num3Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.num1Button);
	}];
	//4
	[self.num4Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.num1Button.mas_bottom).offset(gapVert);
	}];
	//5
	[self.num5Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.num4Button);
	}];
	//6
	[self.num6Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.num5Button);
	}];
	//7
	[self.num7Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.num4Button.mas_bottom).offset(gapVert);
	}];
	//8
	[self.num8Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.num7Button);
	}];
	//9
	[self.num9Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.num7Button);
	}];
	//返回
	[self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.muteButton);
		make.top.equalTo(self.num7Button.mas_bottom).offset(gapVert);
	}];
	
	//0
	[self.num0Button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.powerButton);
		make.centerY.equalTo(self.backButton);
	}];
	//-/--
	[self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width, width));
		make.centerX.equalTo(self.menuButton);
		make.centerY.equalTo(self.backButton);
	}];
	//OK
	[self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerX.equalTo(self.powerButton);
        
        if (UIScreenW > 414) {
            
            make.top.equalTo(self.num0Button.mas_bottom).offset(gapVert  + width*0.7 + 5 + 20);
            
        }else
        {
            
            make.top.equalTo(self.num0Button.mas_bottom).offset(gapVert + width*0.7 + 5 + 10);
        }
	}];
	
	//left-up
	[self.leftUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width- 10, width-10));
		make.centerX.equalTo(self.backButton).offset(-width*0.3 + 10);
		make.bottom.equalTo(self.okButton.mas_top);
	}];
	//left-down
	[self.leftDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerX.equalTo(self.leftUpButton);
		make.top.equalTo(self.okButton.mas_bottom);
	}];
	//right-up
	[self.rightUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerX.equalTo(self.selectButton).offset(width*0.3 - 10);
		make.centerY.equalTo(self.leftUpButton);
	}];
	//right-down
	[self.rightDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerX.equalTo(self.rightUpButton);
		make.centerY.equalTo(self.leftDownButton);
	}];
	//方向-up
	[self.dirUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerX.equalTo(self.okButton);
		make.bottom.equalTo(self.okButton.mas_top);
	}];
	//方向-down
	[self.dirDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerX.equalTo(self.okButton);
		make.top.equalTo(self.okButton.mas_bottom);
	}];
	//方向-left
	[self.dirLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerY.equalTo(self.okButton);
		make.right.equalTo(self.okButton.mas_left);
	}];
	//方向-right
	[self.dirRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(width-10, width-10));
		make.centerY.equalTo(self.okButton);
		make.left.equalTo(self.okButton.mas_right);
	}];
	
	self.muteButton.layer.cornerRadius = self.muteButton.hr_width *0.5;
	self.muteButton.layer.masksToBounds = YES;
}


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    CAShapeLayer *leftLayer = [[CAShapeLayer alloc] init];
    leftLayer.frame = CGRectMake(
                                 CGRectGetMinX(self.leftUpButton.frame),
                                 CGRectGetMinY(self.leftUpButton.frame),
                                 CGRectGetWidth(self.leftDownButton.frame),
                                 CGRectGetMaxY(self.leftDownButton.frame)-CGRectGetMinY(self.leftUpButton.frame)
                                 );
    leftLayer.cornerRadius = leftLayer.frame.size.width/2;
    leftLayer.borderColor = [UIColor colorWithHex:0xB3B3B3].CGColor;
    leftLayer.borderWidth = 1;
    [self.layer addSublayer:leftLayer];
    
    CAShapeLayer *rightLayer = [[CAShapeLayer alloc] init];
    rightLayer.frame = CGRectMake(
                                  CGRectGetMinX(self.rightUpButton.frame),
                                  CGRectGetMinY(self.rightUpButton.frame),
                                  CGRectGetWidth(self.rightDownButton.frame),
                                  CGRectGetMaxY(self.rightDownButton.frame)-CGRectGetMinY(self.rightUpButton.frame)
                                  );
    rightLayer.cornerRadius = rightLayer.frame.size.width/2;
    rightLayer.borderColor = [UIColor colorWithHex:0xB3B3B3].CGColor;
    rightLayer.borderWidth = 1;
    [self.layer addSublayer:rightLayer];
    
    CAShapeLayer *centerLayer = [[CAShapeLayer alloc] init];
    centerLayer.frame = CGRectMake(
                                   0,
                                   0,
                                   CGRectGetWidth(self.okButton.frame)*3,
                                   CGRectGetWidth(self.okButton.frame)*3
                                   );
    centerLayer.position = self.okButton.center;
    centerLayer.cornerRadius = centerLayer.frame.size.width/2;
    centerLayer.borderColor = [UIColor colorWithHex:0xB3B3B3].CGColor;
    centerLayer.borderWidth = 1;
    [self.layer addSublayer:centerLayer];

	//设置 按钮状态
	[self setUpBtnState];
}
#pragma mark - 学习按钮的状态
- (void)studyButtonHiddenNO
{
	self.studyButton.hidden = NO;
	self.studyEndButton.hidden = YES;
}
- (void)studyButtonHiddenYes
{
	self.studyButton.hidden = YES;
	self.studyEndButton.hidden = NO;
}
#pragma mark - 设置 按钮状态图片
- (void)setUpBtnState
{
	//param01
	if ([self.irgmData.param01[0] isEqualToString:@"None"]) {
		[self.muteButton setBackgroundImage:[UIImage imageNamed:@"小睿控制静音"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.muteButton setBackgroundImage:[UIImage imageNamed:@"选中静音蓝"]
								   forState:UIControlStateNormal];
	}
	if ([self.irgmData.param01[1] isEqualToString:@"None"]) {
		[self.powerButton setBackgroundImage:[UIImage imageNamed:@"选中开关白"]
									forState:UIControlStateNormal];
	}else
	{
		[self.powerButton setBackgroundImage:[UIImage imageNamed:@"小睿控制开关"]
									forState:UIControlStateNormal];
	}
    
	if ([self.irgmData.param01[2] isEqualToString:@"None"]) {
		[self.menuButton setBackgroundImage:[UIImage imageNamed:@"小睿控制功能"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.menuButton setBackgroundImage:[UIImage imageNamed:@"选中功能蓝"]
								   forState:UIControlStateNormal];
	}
    
	if ([self.irgmData.param01[3] isEqualToString:@"None"]) {
		[self.num1Button setBackgroundImage:[UIImage imageNamed:@"小睿控制1"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num1Button setBackgroundImage:[UIImage imageNamed:@"选中1"]
								   forState:UIControlStateNormal];
	}
	if ([self.irgmData.param01[4] isEqualToString:@"None"]) {
		[self.num2Button setBackgroundImage:[UIImage imageNamed:@"小睿控制2"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num2Button setBackgroundImage:[UIImage imageNamed:@"选中2"]
								   forState:UIControlStateNormal];
	}
    
	if ([self.irgmData.param01[5] isEqualToString:@"None"]) {
		[self.num3Button setBackgroundImage:[UIImage imageNamed:@"小睿控制3"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num3Button setBackgroundImage:[UIImage imageNamed:@"选中3"]
								   forState:UIControlStateNormal];
	}
	if ([self.irgmData.param01[6] isEqualToString:@"None"]) {
		[self.num4Button setBackgroundImage:[UIImage imageNamed:@"小睿控制4"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num4Button setBackgroundImage:[UIImage imageNamed:@"选中4"]
								   forState:UIControlStateNormal];
	}
	if ([self.irgmData.param01[7] isEqualToString:@"None"]) {
		[self.num5Button setBackgroundImage:[UIImage imageNamed:@"小睿控制5"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num5Button setBackgroundImage:[UIImage imageNamed:@"选中5"]
								   forState:UIControlStateNormal];
	}
	if ([self.irgmData.param01[8] isEqualToString:@"None"]) {
		[self.num6Button setBackgroundImage:[UIImage imageNamed:@"小睿控制6"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num6Button setBackgroundImage:[UIImage imageNamed:@"选中6"]
								   forState:UIControlStateNormal];
	}
	if ([self.irgmData.param01[9] isEqualToString:@"None"]) {
		
		[self.num7Button setBackgroundImage:[UIImage imageNamed:@"小睿控制7"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num7Button setBackgroundImage:[UIImage imageNamed:@"选中7"]
								   forState:UIControlStateNormal];
	}
	
	//p02
	if ([self.irgmData.param02[0] isEqualToString:@"None"]) {//tag 10
		[self.num8Button setBackgroundImage:[UIImage imageNamed:@"小睿控制8"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num8Button setBackgroundImage:[UIImage imageNamed:@"选中8"]
								forState:UIControlStateNormal];
	}
	if ([self.irgmData.param02[1] isEqualToString:@"None"]) {//tag 11
		[self.num9Button setBackgroundImage:[UIImage imageNamed:@"小睿控制9"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num9Button setBackgroundImage:[UIImage imageNamed:@"选中9"]
								   forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param02[2] isEqualToString:@"None"]) {//tag 12
		
		[self.backButton setBackgroundImage:[UIImage imageNamed:@"小睿控制返回"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.backButton setBackgroundImage:[UIImage imageNamed:@"选中返回"]
								   forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param02[3] isEqualToString:@"None"]) {//tag 13
		
		[self.num0Button setBackgroundImage:[UIImage imageNamed:@"小睿控制0"]
								   forState:UIControlStateNormal];
	}else
	{
		[self.num0Button setBackgroundImage:[UIImage imageNamed:@"选中0"]
								   forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param02[4] isEqualToString:@"None"]) {//tag 14
		
		[self.selectButton setBackgroundImage:[UIImage imageNamed:@"小睿控制选节目"]
									 forState:UIControlStateNormal];
	}else
	{
		[self.selectButton setBackgroundImage:[UIImage imageNamed:@"选中选节目"]
									 forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param02[5] isEqualToString:@"None"]) {//tag 15
		
		[self.leftUpButton setImage:[UIImage imageNamed:@"小睿控制频道上"]
									 forState:UIControlStateNormal];
		
	}else
	{
		[self.leftUpButton setImage:[UIImage imageNamed:@"选中上频道蓝"]
									 forState:UIControlStateNormal];
	}
	if ([self.irgmData.param02[6] isEqualToString:@"None"]) {//tag 16
		
		[self.dirUpButton setImage:[UIImage imageNamed:@"小睿控制频道上"]
									   forState:UIControlStateNormal];
		
	}else
	{
		[self.dirUpButton setImage:[UIImage imageNamed:@"选中上频道蓝"]
									forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param02[7] isEqualToString:@"None"]) {//tag 17
		
		[self.rightUpButton setImage:[UIImage imageNamed:@"小睿控制频道上"]
									  forState:UIControlStateNormal];
		
	}else
	{
		[self.rightUpButton setImage:[UIImage imageNamed:@"选中上频道蓝"]
									  forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param02[8] isEqualToString:@"None"]) {//tag 18
		
		[self.dirLeftButton setImage:[UIImage imageNamed:@"小睿控制左"]
										forState:UIControlStateNormal];
		
	}else
	{
		[self.dirLeftButton setImage:[UIImage imageNamed:@"选中左"]
									  forState:UIControlStateNormal];
		
	}
	if ([self.irgmData.param02[9] isEqualToString:@"None"]) {//tag 19
		
		[self.okButton setBackgroundImage:[UIImage imageNamed:@"小睿OK"]
									  forState:UIControlStateNormal];
		
	}else
	{
		[self.okButton setBackgroundImage:[UIImage imageNamed:@"小睿OK蓝"]
									  forState:UIControlStateNormal];
		
	}
	
	//p3
	if ([self.irgmData.param03[0] isEqualToString:@"None"]) {//tag 20
		
		[self.dirRightButton setImage:[UIImage imageNamed:@"小睿控制右"]
									   forState:UIControlStateNormal];
		
	}else
	{
		[self.dirRightButton setImage:[UIImage imageNamed:@"选中右"]
									   forState:UIControlStateNormal];
		
	}
	if ([self.irgmData.param03[1] isEqualToString:@"None"]) {//tag 21
		
		[self.leftDownButton setImage:[UIImage imageNamed:@"小睿控制频道下"]
									forState:UIControlStateNormal];
		
	}else
	{
		[self.leftDownButton setImage:[UIImage imageNamed:@"选中下"]
									   forState:UIControlStateNormal];
	}
	
	if ([self.irgmData.param03[2] isEqualToString:@"None"]) {//tag 22
		[self.dirDownButton setImage:[UIImage imageNamed:@"小睿控制下"]
									  forState:UIControlStateNormal];
	}else
	{
		[self.dirDownButton setImage:[UIImage imageNamed:@"选中下"]
									  forState:UIControlStateNormal];
		
	}
	if ([self.irgmData.param03[3] isEqualToString:@"None"]) {//tag 23
		[self.rightDownButton setImage:[UIImage imageNamed:@"小睿控制频道下"]
								 forState:UIControlStateNormal];
	}else
	{
		[self.rightDownButton setImage:[UIImage imageNamed:@"选中下"]
										forState:UIControlStateNormal];
        
	}
	//判断是不是自己发送的帧
	[self setOpWithArray:self.irgmData.op];
}
#pragma mark - set 方法
- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
}

- (void)dealloc
{
	[SVProgressHUD dismiss];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.timer invalidate];
}
#pragma mark - 点击事件
- (void)studyControlBtnClick:(UIButton *)btn
{
	NSString *tag = [NSString stringWithFormat:@"%ld", (long)btn.tag];
	NSString *uuid = [kUserDefault objectForKey:kUserDefaultUUID];
	NSArray *op = @[tag,@"None",@"None", uuid];
	if (btn.tag == 24) {//开始学习
		op = @[@"None",@"None",@"None", uuid];
		[self sendDataToSocketWithArray:op state:@"1"];
		
		[SVProgressTool hr_showWithStatus:@"正在请求开始学习..."];
		
	}else if (btn.tag == 25)//结束学习
	{
		op = @[@"None",@"None",@"None", uuid];
	    [self sendDataToSocketWithArray:op state:@"9"];
		[SVProgressTool hr_showWithStatus:@"正在请求结束学习..."];
		
	}else
	{
		[self sendDataToSocketWithArray:op state:@"4"];
		[SVProgressTool hr_showWithStatus:@"正在学习..."];
	}
}

#pragma mark - 传参组帧
- (void)sendDataToSocketWithArray:(NSArray *)array state:(NSString *)state
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSArray *picture = [NSArray array];
	NSArray *regional = [NSArray array];
	NSArray *name01 = [NSArray array];
	NSArray *name02 = [NSArray array];
	NSArray *name03 = [NSArray array];
	NSArray *param01 = [NSArray array];
	NSArray *param02 = [NSArray array];
	NSArray *param03 = [NSArray array];
	NSString *str = [NSString stringWithIRGMVersion:@"0.0.1"
								   status:@"200"
									token:token
									 type:@"testing"
									 desc:@"testing desc message"
							  srcUserName:user
							  dstUserName:user
							   dstDevName:uuid
									  uid:self.irgmData.uid
									  mid:self.irgmData.mid
									  did:self.irgmData.did
									 uuid:self.irgmData.uuid
									types:self.irgmData.types
							   newVersion:self.irgmData.version
									title:self.irgmData.title
									brand:self.irgmData.brand
								  created:self.irgmData.created
								   update:self.irgmData.update
									state:state
								  picture:picture
								 regional:regional
									   op:array
								   name01:name01
								   name02:name02
								   name03:name03
								  param01:param01
								  param02:param02
								  param03:param03];
	DDLogInfo(@"str----红外学习%@",str);
	[self.appDelegate sendMessageWithString:str];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}

@end
