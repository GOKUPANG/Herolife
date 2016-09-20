//
//  AutherTimePickView.m
//  herolife
//
//  Created by sswukang on 16/9/20.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "AutherTimePickView.h"

@interface AutherTimePickView () <UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic, assign) NSInteger selProvinceIndex;

@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;

@property (nonatomic, weak) UIPickerView *pickerView;
@property(nonatomic, assign) BOOL isInital;
/** 记录当前选择的小时 */
@property(nonatomic, copy) NSString *hour;
/** 记录当前选择的分钟 */
@property(nonatomic, copy) NSString *minute;

@end

@implementation AutherTimePickView

// 初始化文字
- (void)initialText
{
	if (_isInital == NO) {
		
		[self pickerView:_pickerView didSelectRow:0 inComponent:0];
		_isInital = YES;
	}
}

- (NSMutableArray *)hourArray
{
	if (_hourArray == nil) {
		_hourArray = [NSMutableArray array];
	}
	return _hourArray;
}
- (NSMutableArray *)minuteArray
{
	if (_minuteArray == nil) {
		_minuteArray = [NSMutableArray array];
		
	}
	return _minuteArray;
}

- (void)awakeFromNib
{
	[self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	
	if (self = [super initWithFrame:frame]) {
		
		[self setUp];
	}
	return self;
}


// 初始化操作
- (void)setUp
{
	
	for (int i = 0; i < 100; i++) {
		NSString *index = [NSString stringWithFormat:@"%02d",i];
		[self.hourArray addObject:index];
	}
	
	for (int i = 0; i < 60; i++) {
		NSString *index = [NSString stringWithFormat:@"%02d",i];
		[self.minuteArray addObject:index];
	}
	
	self.minute = @"00";
	self.hour = @"00";
	
	UIPickerView *pickerView = [[UIPickerView alloc] init];
	
	_pickerView = pickerView;
	
	pickerView.delegate = self;
	
	pickerView.dataSource = self;
	
	// 自定义键盘
	self.inputView = pickerView;
}


#pragma mark - UIPickerViewDataSource
// 返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 4;
}

// 返回有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	
	if (component == 0) {
		
		return self.hourArray.count;
		
	}else if (component == 1) {
		
		return 1;
		
	}else if (component == 2) {
		
		return self.minuteArray.count;
		
	}else
	{
		return 1;
	}
	
}

#pragma mark - UIPickerViewDelegate
// 返回每一行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	if (component == 0) {
		
		return self.hourArray[row];
		
	}else if (component == 1) {
		
		return @"小时";
		
	}else if (component == 2) {
		
		return self.minuteArray[row];
		
	}else
	{
		return @"分钟";
	}
}

// 选中一行就会调用
// 给文本框赋值
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0) {
		self.hour = self.hourArray[row];
	}else if (component == 2) {
		self.minute = self.minuteArray[row];
	}
	if ([self.delegate respondsToSelector:@selector(autherTimePickView:hour:minute:)]) {
		[self.delegate autherTimePickView:self hour:self.hour minute:self.minute];
	}
	
}

@end
