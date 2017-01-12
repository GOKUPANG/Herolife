//
//  CurrencyNewView.m
//  xiaorui
//
//  Created by sswukang on 16/6/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CurrencyNewView.h"
#import "TipsLabel.h"
#import "IrgmData.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "IrgmStudyBtn.h"

@interface CurrencyNewView()<UITextFieldDelegate>
/** TipsLabel */
@property(nonatomic, strong)TipsLabel *tipsLabel;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

@property (strong, nonatomic) UIButton * greenButton;
@property (strong, nonatomic) UIButton * redButton;
@property (strong, nonatomic) UIButton * num1Button;
@property (strong, nonatomic) UIButton * num2Button;
@property (strong, nonatomic) UIButton * num3Button;
@property (strong, nonatomic) UIButton * num4Button;
@property (strong, nonatomic) UIButton * num5Button;
@property (strong, nonatomic) UIButton * leftButton;
@property (strong, nonatomic) UIButton * num7Button;
@property (strong, nonatomic) UIButton * rightButton;
@property (strong, nonatomic) UIButton * downtButton;
@property (strong, nonatomic) UIButton * bottomButton2;
@property (strong, nonatomic) UIButton * bottomButton3;
@property (strong, nonatomic) UIImageView * num9ButtonImage;
@property (strong, nonatomic) UILabel * loginLabel;

@property (strong, nonatomic) UIButton * num8Button;
@property (strong, nonatomic) UIButton * upButton;
@property (strong, nonatomic) UIButton * num6Button;
@property (strong, nonatomic) UIButton * okButton;
@property (strong, nonatomic) UIButton * num9Button;

/** UITextField */
@property(nonatomic, strong) UITextField *titleField;
/** 添加方块label */
@property(nonatomic, weak) UILabel *qrLabel;
/** 结束学习 */
@property(nonatomic, strong) IrgmStudyBtn *studyEndButton;
/** 开始学习 */
@property(nonatomic, strong) IrgmStudyBtn *studyButton;

@end


@implementation CurrencyNewView

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
	// 设置按钮状态
	[self setUpBtnState];
	[self.timer invalidate];
	isOvertime = YES;
	
	[SVProgressHUD dismiss];
	
	// 判断 是不是自己发过去  返回的帧
	NSDictionary *dict = notification.userInfo;
	self.irgmData = [IrgmData mj_objectWithKeyValues:dict[@"msg"]];
		
	NSArray *opArr = self.irgmData.op;
	NSString *UUID = [kUserDefault objectForKey:kUserDefaultUUID];
	if (![opArr.lastObject isEqualToString:UUID]) {
		
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
	[self setNeedsDisplay];
	
  switch ([self.irgmData.state intValue]) {
  case 2:
			[self setEnableBtn];
			[self studyButtonHiddenYes];
			[self.tipsLabel showText:@"学习开始,请点击任意遥控器按键来学习红外码!" duration:6800000.0];
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
			[self.tipsLabel showText:@"成功退出学习模式..." duration:6666666.0];
          
			break;
  case 11:
			[self studyButtonHiddenYes];
			[self setNoEnableBtn];
			[self.tipsLabel showText:@"状态错误,请退出重试!" duration:6666666.0];
			break;
  default:
			break;
	}
	
}


#pragma mark - 内部  控件redButton
-(void) initSubviews {
    
    
    
    //设置背景颜色
    //添加方块label
    UILabel *qrLabel = [[UILabel alloc] init];
    qrLabel.backgroundColor = [UIColor clearColor];
    self.qrLabel = qrLabel;
    [self addSubview:qrLabel];
    
    self.greenButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.greenButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redButton    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num1Button     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num2Button     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num3Button     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num4Button     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num5Button     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num7Button    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.downtButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomButton3    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num9ButtonImage       = [[UIImageView alloc] init];
    self.loginLabel = [[UILabel alloc] init];
    self.titleField = [[UITextField alloc] init];
    
    self.num8Button  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num6Button    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.num9Button       = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //绑定tag
    [self setTagWithBtn];
    
    [self addSubview:self.greenButton];
    [self addSubview:self.redButton];
    [self addSubview:self.num1Button];
    [self addSubview:self.num2Button];
    [self addSubview:self.num3Button];
    [self addSubview:self.num4Button];
    [self addSubview:self.num5Button];
    [self addSubview:self.leftButton];
    [self addSubview:self.num7Button];
    [self addSubview:self.rightButton];
    [self addSubview:self.downtButton];
    [self addSubview:self.bottomButton2];
    [self addSubview:self.bottomButton3];
    [self addSubview:self.num9ButtonImage];
    [self addSubview:self.loginLabel];
    [self addSubview:self.titleField];
    
    [self addSubview:self.num8Button];
    [self addSubview:self.upButton];
    [self addSubview:self.num6Button];
    [self addSubview:self.okButton];
    [self addSubview:self.num9Button];
    
    
    //标题文本
    
    self.titleField.font = [UIFont systemFontOfSize:20];
    self.titleField.minimumFontSize = 15;
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.textAlignment = NSTextAlignmentLeft;
    self.titleField.layer.cornerRadius = 10;
    self.titleField.layer.masksToBounds = YES;
    self.titleField.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleField.layer.borderWidth = 1.5f;
    self.titleField.delegate = self;
    
    //OK键文字
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    //login
    self.loginLabel.text = @"HEROLIFE";
    self.loginLabel.font = [UIFont systemFontOfSize:17];
    self.loginLabel.textColor = [UIColor whiteColor];
    
    
    //添加点击事件
    [self.greenButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.redButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num1Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num2Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num3Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num4Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num5Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num7Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downtButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomButton2 addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomButton3 addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.num8Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.upButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num6Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.num9Button addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
	
	self.studyEndButton = [[IrgmStudyBtn alloc] init];
	self.studyButton = [[IrgmStudyBtn alloc] init];
	
	//绑定tag
	[self setTagWithBtn];
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
	[self.studyButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.studyEndButton addTarget:self action:@selector(studyControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
}
// tag
- (void)setTagWithBtn
{
    
    //第一排
    self.greenButton.tag     = 0;//静音
    self.redButton.tag    = 1;//待机
    
    //第二排
    self.num1Button.tag     = 2;//1
    self.num2Button.tag     = 3;//2
    self.num3Button.tag     = 4;//3
    
    //第三排
    self.num4Button.tag     = 5;//4
    self.num5Button.tag    =6;//5
    self.num6Button.tag    = 7;//6
    
    //第四排
    self.num7Button.tag    = 8;//7
    
    self.num8Button.tag  = 9;//8
    self.num9Button.tag       = 10;//9
    
    self.upButton.tag = 11;//方向-right
    //第三排
    self.leftButton.tag   = 12;//left-down
    self.okButton.tag  = 13;//方向-down
    self.rightButton.tag  = 14;//right-down
    
    
    self.downtButton.tag  = 15;//方向-left
	
	self.studyButton.tag = 24;//学习
	self.studyEndButton.tag = 25;//学习
	
}

//设置按钮可以点击
- (void)setEnableBtn
{
	self.greenButton.enabled     = YES;
	self.redButton.enabled    = YES;
	self.num1Button.enabled     = YES;
	self.num2Button.enabled     = YES;
	self.num3Button.enabled     = YES;
	self.num4Button.enabled     = YES;
	self.num5Button.enabled     = YES;
	self.num6Button.enabled   = YES;
	self.num7Button.enabled    = YES;
	self.num8Button.enabled  = YES;
	self.num9Button.enabled  = YES;
	self.upButton.enabled    = YES;
	self.downtButton.enabled  = YES;
	self.leftButton.enabled = YES;
	self.rightButton.enabled    = YES;
	self.okButton.enabled       = YES;
}
//设置按钮不可点击
- (void)setNoEnableBtn
{
    
    self.greenButton.enabled     = NO;
    self.redButton.enabled    = NO;
    self.num1Button.enabled     = NO;
    self.num2Button.enabled     = NO;
    self.num3Button.enabled     = NO;
    self.num4Button.enabled     = NO;
    self.num5Button.enabled     = NO;
    self.num6Button.enabled   = NO;
    self.num7Button.enabled    = NO;
    self.num8Button.enabled  = NO;
    self.num9Button.enabled  = NO;
    self.upButton.enabled    = NO;
    self.downtButton.enabled  = NO;
    self.leftButton.enabled = NO;
    self.rightButton.enabled    = NO;
    self.okButton.enabled       = NO;
}

static CGFloat gapVert;
-(void)layoutSubviews {
    [super layoutSubviews];
    //提示框
    self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
    [self addSubview:self.tipsLabel];
    
    //第一排
    
    CGFloat buttonH ;
    
    if (UIScreenW >= 375) {
        buttonH = (UIScreenH - 138 /2 - 35 - 25 *2 - 20 -10 - 40) / 8;
    }else
    {
        buttonH = (UIScreenH - 138 /2 /2 -10 - 35 - 25 *2 - 20 -10 -40) / 8;
    }
    
    
    //login
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        if (UIScreenW >= 375) {
            make.top.equalTo(self).offset(138 /2);
        }else
        {
            make.top.equalTo(self).offset(138 /2 /2 +10);
            
        }
    }];
    
    //学习按钮
    [self.studyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginLabel);
        make.bottom.equalTo(self.loginLabel);
        make.left.equalTo(self.loginLabel);
        make.right.equalTo(self.loginLabel);
    }];
    
    //学习按钮
    [self.studyEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginLabel);
        make.bottom.equalTo(self.loginLabel);
        make.left.equalTo(self.loginLabel);
        make.right.equalTo(self.loginLabel);
    }];
    
    //静音
    CGFloat sizeWH = buttonH;
    [self.greenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(sizeWH, sizeWH));
        make.right.equalTo(self.loginLabel.mas_left).offset(-67*0.5);
        make.centerY.equalTo(self.loginLabel);
    }];
    //待机
    [self.redButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.left.equalTo(self.loginLabel.mas_right).offset(67*0.5);
        make.centerY.equalTo(self.loginLabel);
    }];
    
    //第二排
    [self.num1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.greenButton);
        if (UIScreenW >= 375) {
            make.top.equalTo(self.greenButton.mas_bottom).offset(70 *0.5);
        }else
        {
            make.top.equalTo(self.greenButton.mas_bottom).offset(70 /2  - 10);
            
        }
    }];
    //2
    [self.num2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.loginLabel);
        make.centerY.equalTo(self.num1Button);
    }];
    //3
    [self.num3Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.redButton);
        make.centerY.equalTo(self.num1Button);
    }];
    
    //第三排
    //4
    [self.num4Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.greenButton);
        make.top.equalTo(self.num1Button.mas_bottom).offset(50 *0.5);
    }];
    
    
    //left-up 6
    [self.num5Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.loginLabel);
        make.centerY.equalTo(self.num4Button);
    }];
    //方向-up 7
    [self.num6Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.redButton);
        make.centerY.equalTo(self.num4Button);
    }];
    
    //第四排
    //right-up 8
    [self.num7Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.greenButton);
        make.top.equalTo(self.num4Button.mas_bottom).offset(50 *0.5);
    }];
    //方向-left 9
    [self.num8Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.loginLabel);
        make.centerY.equalTo(self.num7Button);
    }];
    
    
    //10
    [self.num9Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.greenButton);
        make.centerX.equalTo(self.redButton);
        make.centerY.equalTo(self.num7Button);
    }];
    
    
    CGFloat magin = 20;
    if (UIScreenW >= 375) {
        magin = 20;
    }else
    {
        
        magin = 18;
    }
    
    //第六排
    //tag 13
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginLabel);
        
        
        make.top.equalTo(self.num8Button).offset(2.0 * buttonH + magin *1.5);
        make.size.mas_equalTo(CGSizeMake(1.5 * buttonH , 1.5 * buttonH));
    }];
    
    //12
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.okButton.mas_left).offset(- magin);
        make.centerY.equalTo(self.okButton);
        make.size.mas_equalTo(CGSizeMake(24, 44));
    }];
    
    //14
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.leftButton);
        make.left.equalTo(self.okButton.mas_right).offset(magin);
        make.centerY.equalTo(self.okButton);
    }];
    
    //第五排
    //11
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.okButton.mas_top).offset(- magin);
        make.centerX.equalTo(self.okButton);
        make.size.mas_equalTo(CGSizeMake(44, 24));
    }];
    //第七排
    //15
    [self.downtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.upButton);
        make.top.equalTo(self.okButton.mas_bottom).offset(magin);
        make.centerX.equalTo(self.okButton);
    }];
    
    CGFloat qrMagin = 17.5;
    [self.qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upButton).offset(- qrMagin);
        make.left.equalTo(self.leftButton).offset(- qrMagin);
        make.bottom.equalTo(self.downtButton).offset(qrMagin);
        make.right.equalTo(self.rightButton).offset(qrMagin);
    }];
    
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
	//设置 按钮状态
	[self setUpBtnState];
    DDLogWarn(@"self.qrLabel.frame--%@--OK:%@ left:%@right:%@up:%@down:%@", NSStringFromCGRect(self.qrLabel.frame), NSStringFromCGRect(self.okButton.frame), NSStringFromCGRect(self.leftButton.frame), NSStringFromCGRect(self.rightButton.frame), NSStringFromCGRect(self.upButton.frame), NSStringFromCGRect(self.downtButton.frame));
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
    
    self.qrLabel.layer.cornerRadius = self.qrLabel.hr_height * 0.5;
    self.qrLabel.layer.borderWidth = 1.0;
    self.qrLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.qrLabel.layer.masksToBounds = YES;
    
    //绿色
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[0] button:self.greenButton normalImageView:@"小睿开关白" studyedImageView:@"小睿红外开"];
    
    //红色
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[1] button:self.redButton normalImageView:@"小睿开关白" studyedImageView:@"小睿控制开关"];
    
    //1
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[2] button:self.num1Button normalImageView:@"" studyedImageView:@""];
    
    //num2Button
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[3] button:self.num2Button normalImageView:@"" studyedImageView:@""];
    
    
    //num3Button
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[4] button:self.num3Button normalImageView:@"" studyedImageView:@""];
    
    //num4Button
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[5]button:self.num4Button normalImageView:@"" studyedImageView:@""];
    
    //5
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[6] button:self.num5Button normalImageView:@"" studyedImageView:@""];
    
    //6
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[7]  button:self.num6Button normalImageView:@"" studyedImageView:@""];
    
    //7
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[8] button:self.num7Button normalImageView:@"" studyedImageView:@""];
    
    //8
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[9]  button:self.num8Button normalImageView:@"" studyedImageView:@""];
    
    //9
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[0]  button:self.num9Button normalImageView:@"" studyedImageView:@""];
    
    //上
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[1]  button:self.upButton normalImageView:@"小睿红外上" studyedImageView:@"小睿红外上-蓝"];
    //左
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[2]  button:self.leftButton normalImageView:@"小睿红外左" studyedImageView:@"小睿红外左-蓝"];
    //OK
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[3]  button:self.okButton normalImageView:@"" studyedImageView:@""];
    //右
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[4]  button:self.rightButton normalImageView:@"小睿红外右" studyedImageView:@"小睿红外右-蓝"];
    
    //下
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[5]  button:self.downtButton normalImageView:@"小睿红外下" studyedImageView:@"小睿红外下-蓝"];
    
}
//设置文字
- (void)setUpButtonWithIrgmParamString:(NSString *)paramString button:(UIButton *)button normalImageView:(NSString *)normalImageView studyedImageView:(NSString *)studyedImageView
{
    if (button.tag == 0 || button.tag == 1 || button.tag == 15 || button.tag == 14 || button.tag == 12 || button.tag == 11) {
        //方向按钮和tag 0 1键
        if ([paramString isEqualToString:@"None"]) {
            [button setBackgroundImage:[UIImage imageNamed:normalImageView]
                                        forState:UIControlStateNormal];
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:studyedImageView]
                                        forState:UIControlStateNormal];
        }
        
    }else if (button.tag == 13)//OK键
    {
        
        
        if ([paramString isEqualToString:@"None"]) {
            
            [self setUpButtonLayerWithColor:[UIColor whiteColor] button:button];
        }else
        {
            [self setUpButtonLayerWithColor:[UIColor blueColor] button:button];
        }
        
    }else
    {
        if ([paramString isEqualToString:@"None"]) {
            [self setTitleWithButton:button title:@"未学习"];
            [self setUpButtonLayerWithColor:[UIColor whiteColor] button:button];
            
        }else
        {
            [self setTitleWithButton:button title:@"已学习"];
            [self setUpButtonLayerWithColor:[UIColor blueColor] button:button];
        }
    }
}
- (void)setUpButtonLayerWithColor:(UIColor *)color button:(UIButton *)button
{
    button.layer.cornerRadius = button.hr_width * 0.5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = color.CGColor;
    button.layer.masksToBounds = YES;
    [button setTitleColor:color forState:UIControlStateNormal];
}
#pragma mark - 设置按钮文字
- (void)setTitleWithButton:(UIButton *)btn title:(NSString *)title
{
	[btn setTitle:title forState:UIControlStateNormal];
	btn.titleLabel.font = [UIFont systemFontOfSize:14];
	[btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
#pragma mark - set 方法
- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
	
	self.titleField.text = irgmData.title;
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
	DDLogInfo(@"tag%@",tag);
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}
@end
