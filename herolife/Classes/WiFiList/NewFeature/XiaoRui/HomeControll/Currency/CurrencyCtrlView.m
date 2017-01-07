//
//  CurrencyCtrlView.m
//  xiaorui
//
//  Created by sswukang on 16/6/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "CurrencyCtrlView.h"
#import "TipsLabel.h"
#import "IrgmData.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "PopEditMenuIrgmView.h"
#import "IrgmStudyBtn.h"

@interface CurrencyCtrlView()<UITextFieldDelegate>
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;
/** TipsLabel */
@property(nonatomic, strong)TipsLabel *tipsLabel;
/** AppDelegate */
@property(nonatomic, weak) AppDelegate *appDelegate;

/** blank */
@property(nonatomic, strong) UIView *blankView;
@property(nonatomic, weak) PopEditMenuIrgmView *popView;
/** 记录当前view */
@property(nonatomic, strong) UIView *currentView;

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
@end

@implementation CurrencyCtrlView

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
		[self initSubviews];
		//添加通知 监听
		[self addNotificationCenterObserver];
		//建立socket连接通道
		[self postTokenWithTCPSocket];
		self.num9ButtonImage.userInteractionEnabled = YES;
	}
	return self;
}
//添加弹框
- (void)addMenuView{
	
	UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.hr_width, self.hr_height)];
	blankView.backgroundColor = [UIColor clearColor];
	
	self.blankView = blankView;
	//	[self.view addSubview:blankView];
	
	self.popView = [[NSBundle mainBundle] loadNibNamed:@"PopEditMenuIrgmView" owner:self options:nil].firstObject;
	self.popView.frame = CGRectMake(30, UIScreenH *0.15, UIScreenW - 60, 195);
	self.popView.layer.cornerRadius = 10;
	self.popView.layer.masksToBounds = YES;
	self.popView.backgroundColor = [UIColor whiteColor];
	[self.blankView addSubview:self.popView];
	[self addSubview:self.blankView];
	self.blankView.hidden = YES;
	
	//添加手势
	[self addTapGesture];
}

#pragma mark - 通知
- (void)addNotificationCenterObserver
{
	//监听空调的测试帧
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithControlIrgm:) name:kNotificationControlIrgm object:nil];
	//监听设备是否在线
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receviedWithNotOnline) name:kNotificationNotOnline object:nil];
}
static BOOL isShowOverMenu = NO;
- (void)receviedWithNotOnline
{
	isShowOverMenu = YES;
	[self.tipsLabel dismiss];
	[SVProgressTool hr_showErrorWithStatus:@"目标设备不在线!"];
}

#pragma mark -  通知处理方法
//监听通用的测试帧
static BOOL isOvertime = NO;
- (void)receviedWithControlIrgm:(NSNotification *)notification
{
	isOvertime = YES;
	// 判断 是不是自己发过去  返回的帧
	[self.tipsLabel dismiss];
    [SVProgressTool hr_showSuccessWithStatus:@"控制成功!"];
//	[self layoutIfNeeded];
//	[self reloadInputViews];
//	[self setNeedsLayout];
//	[self setNeedsDisplay];
    
    //设置文字样式
    [self setUpViewsDraw];
	
}

#pragma mark - 建立socket连接 并组帧 发送请求数据
/// 建立socket连接 并组帧 发送请求数据
- (void)postTokenWithTCPSocket
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate connectToHost];
	self.appDelegate = appDelegate;
	
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
	self.bottomButton2.tag = 16;//方向-right
	self.bottomButton3.tag    = 17;//方向-up
	
}

-(void)layoutSubviews {
	
	[super layoutSubviews];
	[self setUpFrame];
}

- (void)setUpFrame{
	
	//提示框
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
	[self addSubview:self.tipsLabel];
    
    //第一排
    
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
	
	//静音
    CGFloat sizeWH = 78 *0.5 + 10;
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
    CGFloat magin;
    if (UIScreenW >= 375) {
        magin = 25;
    }else
    {
        
        magin = 20;
    }
    //第六排
    //tag 13
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginLabel);
        if (UIScreenW >= 375) {
            make.top.equalTo(self.num8Button).offset((174 + 157 - 20) *0.5);
            make.size.mas_equalTo(CGSizeMake(174 *0.5 , 174*0.5));
        }else
        {
            
            make.top.equalTo(self.num8Button).offset((174 + 157 - 75) *0.5);
            make.size.mas_equalTo(CGSizeMake(174 *0.5 -25 , 174*0.5 -25));
        }
    }];
    
    //12
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.okButton.mas_left).offset(- magin);
        make.centerY.equalTo(self.okButton);
    }];
    
    //14
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.okButton.mas_right).offset(magin);
        make.centerY.equalTo(self.okButton);
    }];
    
    //第五排
    //11
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.okButton.mas_top).offset(- magin);
        make.centerX.equalTo(self.okButton);
    }];
    //第七排
    //15
    [self.downtButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
#pragma mark - 设置 按钮状态图片
- (void)setUpBtnState
{
	//绿色按钮
	[self.greenButton setBackgroundImage:[UIImage imageNamed:@"小睿开关白"]
								forState:UIControlStateNormal];
	[self.greenButton setBackgroundImage:[UIImage imageNamed:@"小睿红外开"]
	 									forState:UIControlStateHighlighted];
	//红色
	[self.redButton setBackgroundImage:[UIImage imageNamed:@"小睿开关白"]
							  forState:UIControlStateNormal];
//
	[self.redButton setBackgroundImage:[UIImage imageNamed:@"小睿控制开关"]
							  forState:UIControlStateHighlighted];
    
    //1
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[2] nameString:self.irgmData.name01[2] button:self.num1Button];
    
    //num2Button
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[3] nameString:self.irgmData.name01[3] button:self.num2Button];
	
	
    //num3Button
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[4] nameString:self.irgmData.name01[4] button:self.num3Button];
    
    //num4Button
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[5] nameString:self.irgmData.name01[5] button:self.num4Button];
    
    //5
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[6] nameString:self.irgmData.name01[6] button:self.num5Button];
    
    //6
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[7] nameString:self.irgmData.name01[7] button:self.num6Button];
    
    //7
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[8] nameString:self.irgmData.name01[8] button:self.num7Button];
    
    //8
    [self setUpButtonWithIrgmParamString:self.irgmData.param01[9] nameString:self.irgmData.name01[9] button:self.num8Button];
    
    //9
    [self setUpButtonWithIrgmParamString:self.irgmData.param02[0] nameString:self.irgmData.name02[0] button:self.num9Button];
    
    //上
	[self.upButton setBackgroundImage:[UIImage imageNamed:@"小睿红外上"]
									  forState:UIControlStateNormal];
	[self.upButton setBackgroundImage:[UIImage imageNamed:@"小睿红外上-蓝"]
								   forState:UIControlStateHighlighted];
	
	//左
	[self.leftButton setBackgroundImage:[UIImage imageNamed:@"小睿红外左-蓝"]
								   forState:UIControlStateHighlighted];
	[self.leftButton setBackgroundImage:[UIImage imageNamed:@"小睿红外左"]
									  forState:UIControlStateNormal];
	
	//右
	[self.rightButton setBackgroundImage:[UIImage imageNamed:@"小睿红外右"]
									forState:UIControlStateNormal];
	[self.rightButton setBackgroundImage:[UIImage imageNamed:@"小睿红外右-蓝"]
									forState:UIControlStateHighlighted];
	
	
	//downtButton
	[self.downtButton setBackgroundImage:[UIImage imageNamed:@"小睿红外下"]
								  forState:UIControlStateNormal];
	[self.downtButton setBackgroundImage:[UIImage imageNamed:@"小睿红外下-蓝"]
								  forState:UIControlStateHighlighted];
	
		
}

//设置文字
- (void)setUpButtonWithIrgmParamString:(NSString *)paramString nameString:(NSString *)nameString button:(UIButton *)button
{
    
    if ([paramString isEqualToString:@"None"]) {
        [self setTitleWithButton:button title:@"未学习"];
        
    }else
    {
        //判断有没有命名
        if ([nameString isEqualToString:@"None"]) {
            [self setTitleWithButton:button title:@"未命名"];
        }else
        {
            [self setTitleWithButton:button title:nameString];
        }
    }
}
#pragma mark - 设置按钮文字
- (void)setTitleWithButton:(UIButton *)btn title:(NSString *)title
{
	[btn setTitle:title forState:UIControlStateNormal];
//	UILabel
	btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	btn.titleLabel.font = [UIFont systemFontOfSize:14];
	[btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
#pragma mark - set 方法
- (void)setIrgmData:(IrgmData *)irgmData
{
	_irgmData = irgmData;
	
	self.titleField.text = irgmData.title;
	[self setUpBtnState];
}

- (void)dealloc
{
	[SVProgressHUD dismiss];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.timer invalidate];
}

#pragma mark - 按钮点击事件
- (void)studyControlBtnClick:(UIButton *)btn
{
    
    
	NSString *tag = [NSString stringWithFormat:@"%lu", btn.tag];
	NSInteger value = btn.tag;
	
	DDLogError(@"%@",self.irgmData);
	DDLogError(@"value-%ld",(long)value);
	
	NSString *keyName;
	NSString *address;
	
	if (value >= 20) {
		NSInteger index = value - 20;
		if ([self.irgmData.param03[index] isEqualToString:@"None"])
		{
			[self.tipsLabel showText:@"该按钮未学习,请学习之后再控制" duration:4.0];
			return;
		}
		//		[(NSMutableArray *)self.irgmData.op replaceObjectAtIndex:2 withObject: self.irgmData.param03[index -1]];
		keyName = self.irgmData.name03[index];
		address = self.irgmData.param03[index];
		
	}else if (value >= 10) {
		
		NSInteger index = value -10;
		if ([self.irgmData.param02[index] isEqualToString:@"None"])
		{
			[self.tipsLabel showText:@"该按钮未学习,请学习之后再控制" duration:4.0];
			return;
		}
		keyName = self.irgmData.name02[index];
		address = self.irgmData.param02[index];
		
	}else if (value >= 0) {
		NSInteger index = value;
		if ([self.irgmData.param01[index] isEqualToString:@"None"])
		{
			[self.tipsLabel showText:@"该按钮未学习,请学习之后再控制" duration:4.0];
			return;
		}
		keyName = self.irgmData.name01[index];
		address = self.irgmData.param01[index];
	}
	
	
	NSArray *op = @[tag,keyName,address];
	[self sendDataToSocketWithOpArray:op];
    
    //设置文字样式
    [self setUpViewsDraw];
    
    
}



#pragma mark - 传参组帧
- (void)sendDataToSocketWithOpArray:(NSArray *)array
{
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:PushToken];
	NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUserName];
	NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kdefaultsIracUuid];
	NSArray *name01 = [NSArray array];
	NSArray *name02 = [NSArray array];
	NSArray *name03 = [NSArray array];
	NSArray *param01 = [NSArray array];
	NSArray *param02 = [NSArray array];
	NSArray *param03 = [NSArray array];
	NSString *str = [NSString stringWithIRGMVersion:@"0.0.1"
											 status:@"200"
											  token:token
											   type:@"control"
											   desc:@"control desc message"
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
											  state:self.irgmData.state
											picture:self.irgmData.picture
										   regional:self.irgmData.regional
												 op:array
											 name01:name01
											 name02:name02
											 name03:name03
											param01:param01
											param02:param02
											param03:param03];
	
	[self.appDelegate sendMessageWithString:str];
	[SVProgressTool hr_showWithStatus:@"正在控制设备..."];
	// 启动定时器
	[_timer invalidate];
	isOvertime = NO;
	isShowOverMenu = NO;
	_timer = [NSTimer scheduledTimerWithTimeInterval:HRTimeInterval target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}
- (void)startTimer
{
	if (!isOvertime && !isShowOverMenu) {
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
	}
}

#pragma mark - 添加提示框
- (void)addTipsLabel
{
	
	self.tipsLabel = [[TipsLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
	[self addSubview:self.tipsLabel];
}
- (void)drawRect:(CGRect)rect {
	
    [super drawRect:rect];
    
    
	//设置 按钮状态
	[self setUpBtnState];
	//添加长按手势
	for (int value = 0; value < 30; value++) {//211.223.228
		if (value >= 20) {
			NSInteger index = value - 20;
			if (![self.irgmData.param03[index] isEqualToString:@"None"])
			{
				UIButton *btn = [self viewWithTag:value];
				[self addLongGestureWithButton:btn];
			}
		}else if (value >= 10) {
			
			NSInteger index = value -10;
			if (![self.irgmData.param02[index] isEqualToString:@"None"])
			{
				UIButton *btn = [self viewWithTag:value];
				[self addLongGestureWithButton:btn];
			}
			
		}else if (value >= 0) {
			NSInteger index = value;
			if (value == 0) {
				if (![self.irgmData.param01[0] isEqualToString:@"None"])//这样根据tag = 0取出那个button不准
				{
					DDLogWarn(@"-----------------");
					[self addLongGestureWithButton:self.greenButton];
				}
			}else if (![self.irgmData.param01[index] isEqualToString:@"None"])
			{
				UIButton *btn = [self viewWithTag:value];
				DDLogInfo(@"btntag-%lu",btn.tag);
				[self addLongGestureWithButton:btn];
			}
		}
		
	}
    
    
    //设置文字样式
    [self setUpViewsDraw];
    
}
- (void)setUpViewsDraw
{
    
    
    //给占位的label画圆
    self.qrLabel.layer.cornerRadius = self.qrLabel.hr_height * 0.5;
    self.qrLabel.layer.borderWidth = 1.0;
    self.qrLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.qrLabel.layer.masksToBounds = YES;
    
    DDLogWarn(@"self.qrLabel.frame--%@--OK:%@ left:%@right:%@up:%@down:%@", NSStringFromCGRect(self.qrLabel.frame), NSStringFromCGRect(self.okButton.frame), NSStringFromCGRect(self.leftButton.frame), NSStringFromCGRect(self.rightButton.frame), NSStringFromCGRect(self.upButton.frame), NSStringFromCGRect(self.downtButton.frame));
    
    
    [self drawLayerToButton:self.num1Button cornerRadius:self.num1Button.hr_width *0.5];
    [self drawLayerToButton:self.num2Button cornerRadius:self.num2Button.hr_width *0.5];
    [self drawLayerToButton:self.num3Button cornerRadius:self.num3Button.hr_width *0.5];
    [self drawLayerToButton:self.num4Button cornerRadius:self.num4Button.hr_width *0.5];
    [self drawLayerToButton:self.num5Button cornerRadius:self.num5Button.hr_width *0.5];
    [self drawLayerToButton:self.leftButton cornerRadius:self.leftButton.hr_width *0.5];
    [self drawLayerToButton:self.num7Button cornerRadius:self.num7Button.hr_width *0.5];
    [self drawLayerToButton:self.rightButton cornerRadius:self.rightButton.hr_width *0.5];
    [self drawLayerToButton:self.downtButton cornerRadius:self.downtButton.hr_width *0.5];
    [self drawLayerToButton:self.bottomButton2 cornerRadius:self.bottomButton2.hr_width *0.5];
    [self drawLayerToButton:self.bottomButton3 cornerRadius:self.bottomButton3.hr_width *0.5];
    [self drawLayerToButton:self.num9Button cornerRadius:self.num9Button.hr_width *0.5];
    [self drawLayerToButton:self.num8Button cornerRadius:self.num8Button.hr_width *0.5];
    [self drawLayerToButton:self.upButton cornerRadius:self.upButton.hr_width *0.5];
    [self drawLayerToButton:self.num6Button cornerRadius:self.num6Button.hr_width *0.5];
    
    [self drawLayerToButton:self.okButton cornerRadius:self.okButton.hr_width *0.5];
}
#pragma mark - 添加点击手势  点击退出键盘
- (void)addTapGesture
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
	[self.blankView addGestureRecognizer:tap];
}
- (void)tapClick
{
	[self endEditing:YES];
}
#pragma mark - 添加长按手势
- (void)addLongGestureWithButton:(UIButton *)btn
{
	UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureClickWithButtonTag:)];
	[btn addGestureRecognizer:longGesture];
	
	NSLog(@"addLongGestureWithButtontag-%ld",btn.tag);
}

- (void)longGestureClickWithButtonTag:(UILongPressGestureRecognizer *)longGesture
{
	
	if (longGesture.state == UIGestureRecognizerStateBegan) {
		
		//添加弹框
		if (self.currentView) {
			[self.currentView removeFromSuperview];
		}
		
		[self addMenuView];
		self.currentView = self.blankView;
		
		self.blankView.hidden = NO;
		self.popView.irgmData = self.irgmData;
		self.popView.tagBtn = longGesture.view.tag;
		
		__weak typeof (self) weakSelf = self;
		[self.popView getKeyNameWithBlock:^(IrgmData *data) {
			
			__strong typeof (self) stongSelf = weakSelf;
            stongSelf.irgmData = data;
            //设置文字样式
            [self setUpViewsDraw];
			
		}];
		NSLog(@"longtag-%ld",longGesture.view.tag);
	}
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}
#pragma mark - 给按钮画圆
- (void)drawLayerToButton:(UIButton *)button cornerRadius:(CGFloat)cornerRadius
{
    if (button.tag == 11 || button.tag == 12 || button.tag == 14 || button.tag == 15) {//上
        return;
    }
    
    button.layer.cornerRadius = cornerRadius;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    if (button.isHighlighted) {
        button.layer.borderColor = [UIColor blueColor].CGColor;
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (button.tag == 13) {
        self.okButton.titleLabel.font = [UIFont systemFontOfSize:30.f];
    }
}
@end

