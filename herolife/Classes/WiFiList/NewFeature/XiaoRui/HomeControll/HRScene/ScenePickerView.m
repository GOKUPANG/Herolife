
//
//  ScenePickerView.m
//  xiaorui
//
//  Created by sswukang on 16/7/8.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ScenePickerView.h"

@interface ScenePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *determineButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewMaxY;
/** 存放秒的数组 */
@property(nonatomic, strong) NSMutableArray *fistArray;
/** 存放分秒的数组 */
@property(nonatomic, strong) NSMutableArray *lastArray;
/** 秒 */
@property(nonatomic, copy) NSString *seconds;
/** 分 */
@property(nonatomic, copy) NSString *everyMinute;

@end
@implementation ScenePickerView
#pragma mark - 懒加载
- (NSMutableArray *)fistArray
{
	if (!_fistArray) {
		_fistArray = [NSMutableArray array];
	}
	return  _fistArray;
}
- (NSMutableArray *)lastArray
{
	if (!_lastArray) {
		_lastArray = [NSMutableArray array];
	}
	return  _lastArray;
}
+ (instancetype)scenePickerView
{
	return [[NSBundle mainBundle] loadNibNamed:@"ScenePickerView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	//初始化
	[self setupViews];
	
}
#pragma mark - 内部方法
- (void)setupViews
{
	//初始化数值
	self.seconds = @"0";
	self.everyMinute = @"0";
	
	self.determineButton.layer.cornerRadius = 10;
	self.determineButton.layer.masksToBounds = YES;
	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.showsSelectionIndicator = NO;
	
	self.containerViewMaxY.constant = -250;
	
	//给数组初始化
	for (int i = 0; i < 256; i++) {
		NSString *str = [NSString stringWithFormat:@"%d", i];
		[self.fistArray addObject:str];
	}
	for (int i = 0; i < 10; i++) {
		NSString *str = [NSString stringWithFormat:@"%d", i];
		[self.lastArray addObject:str];
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		//动画弹出
		[UIView animateWithDuration:0.5 animations:^{
			self.containerViewMaxY.constant = 0;
			[self layoutIfNeeded];
		}completion:^(BOOL finished) {
			
			[self.layer removeAllAnimations];
		}];
	});
	
	
	
}
- (void)layoutSubviews
{
	[super layoutSubviews];
	
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
}
#pragma mark - UI事件
- (IBAction)dismissPickerView:(UIButton *)sender {
	
	//动画消失
	[self animateWithDuration:0.5 containerViewMaxY:-250];
}

- (IBAction)determineButtonClick:(UIButton *)sender {
	
	//动画消失
	[self animateWithDuration:0.5 containerViewMaxY:-250];
	
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	//动画消失
	[self animateWithDuration:0.5 containerViewMaxY:-250];
}
#pragma mark - 动画 消失
- (void)animateWithDuration:(NSTimeInterval)duration containerViewMaxY:(CGFloat)containerViewMaxY
{
	[UIView animateWithDuration:duration animations:^{
		self.containerViewMaxY.constant = containerViewMaxY;
		self.backgroundColor = [UIColor clearColor];
		[self layoutIfNeeded];
	}completion:^(BOOL finished) {
		
		[self.layer removeAllAnimations];
        
		if (self.pickerBlock){
			self.pickerBlock(self.seconds,self.everyMinute);
		}
		[kNotification postNotificationName:kNotificationSceneTimeWindow object:nil];
	}];
	
}
#pragma mark - pickerView 代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0) {
		return self.fistArray.count;
	}else if (component == 1)
	{
		return 1;
	}else{
		return self.lastArray.count;
	}
	
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == 0) {
		
		return 60;
	}else if (component == 1) {
		
		return 50;
	}else{
		
		return 60;
	}
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *str;
	if (component == 0) {
		str = self.fistArray[row];
	}else if (component == 1) {
		str = @"秒";
	}else if (component == 2) {
		str = self.lastArray[row];
	}
	
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
	//保存值
	if (component == 0) {
		self.seconds = self.fistArray[row];
	}
	
    if (component == 2) {
		
		self.everyMinute = self.lastArray[row];
	}
}

#pragma mark - block传值
- (void)scenePickerViewWithpickerBlock:(pickerViewBlock)pickerBlock
{
	self.pickerBlock = pickerBlock;
}
@end




