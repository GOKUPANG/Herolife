//
//  SceneSwitchPicker.m
//  xiaorui
//
//  Created by sswukang on 16/7/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneSwitchPicker.h"
#import "IrgmData.h"

@interface SceneSwitchPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *determineButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewMaxY;
/** 存放已学习的按键名称数组 */
@property(nonatomic, strong) NSMutableArray *nameArray;
/** 存放已学习的按键号的数组 */
@property(nonatomic, strong) NSMutableArray *numberArray;
/** 已学习的按键名称 */
@property(nonatomic, copy) NSString *nameKey;
/** 已学习的按键号 */
@property(nonatomic, copy) NSString *numberKey;

@end
@implementation SceneSwitchPicker
#pragma mark -  set方法
//- (void)setTvData:(IrgmData *)tvData
//{
//	_tvData = tvData;
//	self.titleLabel.text = tvData.title;
//}
- (void)setGmData:(IrgmData *)gmData
{
	_gmData = gmData;
	self.titleLabel.text = gmData.title;
	//清空数组
	[self.nameArray removeAllObjects];
	[self.numberArray removeAllObjects];
	
	//添加元素
	for (int i = 0; i < 10; i++) {
		NSString *numberKey = gmData.param01[i];
		if (![numberKey isEqualToString:@"None"] && numberKey.length > 0) {
			[self.numberArray addObject:numberKey];
			NSString *nameKey =  gmData.name01[i];
			[self.nameArray addObject:nameKey];
		}
	}
	
	for (int i = 0; i < 10; i++) {
		NSString *numberKey = gmData.param02[i];
		if (![numberKey isEqualToString:@"None"] && numberKey.length > 0) {
			[self.numberArray addObject:numberKey];
			NSString *nameKey =  gmData.name02[i];
			[self.nameArray addObject:nameKey];
		}
	}
	
	for (int i = 0; i < 10; i++) {
		NSString *numberKey = gmData.param03[i];
		if (![numberKey isEqualToString:@"None"] && numberKey.length > 0) {
			[self.numberArray addObject:numberKey];
			NSString *nameKey =  gmData.name03[i];
			[self.nameArray addObject:nameKey];
		}
	}
}
#pragma mark - 懒加载
- (NSMutableArray *)nameArray
{
	if (!_nameArray) {
		_nameArray = [NSMutableArray array];
	}
	return  _nameArray;
}
- (NSMutableArray *)numberArray
{
	if (!_numberArray) {
		_numberArray = [NSMutableArray array];
	}
	return  _numberArray;
}
+ (instancetype)sceneSwitchPickerView
{
	return [[NSBundle mainBundle] loadNibNamed:@"SceneSwitchPicker" owner:nil options:nil].lastObject;
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
//	self.nameKey = @"0";
//	self.numberKey = @"-1";
	
	self.determineButton.layer.cornerRadius = 10;
	self.determineButton.layer.masksToBounds = YES;
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.showsSelectionIndicator = NO;
	self.containerViewMaxY.constant = -250;
	
	//给数组初始化
	for (int i = 0; i < 256; i++) {
		NSString *str = [NSString stringWithFormat:@"%d", i];
		[self.nameArray addObject:str];
	}
	for (int i = 0; i < 10; i++) {
		NSString *str = [NSString stringWithFormat:@"%d", i];
		[self.numberArray addObject:str];
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
	
	if (self.pickerBlock){
//        if (self.nameKey.length > 0 && self.numberKey.length > 0) {
//            
//            self.pickerBlock(self.nameKey,self.numberKey);
//        }else if (self.nameKey.length < 0.5 && self.numberKey.length > 0)
//        {
//            
//        }
        
		if (self.nameKey == nil || self.numberKey == nil) {
			if (self.numberArray.count > 0 ) {
    
				self.pickerBlock(self.nameArray.firstObject,self.numberArray.firstObject);
			}else
			{
				self.pickerBlock(@"",@"");
			}
            
            
			
		}else
		{
			self.pickerBlock(self.nameKey,self.numberKey);
			
		}
	}
	
	//动画消失
	[self animateWithDuration:0.5 containerViewMaxY:-250];
	
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	//动画消失
	[self animateWithDuration:0.5 containerViewMaxY:-250];
}
#pragma mark - 动画
- (void)animateWithDuration:(NSTimeInterval)duration containerViewMaxY:(CGFloat)containerViewMaxY
{
	[UIView animateWithDuration:duration animations:^{
		self.containerViewMaxY.constant = containerViewMaxY;
		self.backgroundColor = [UIColor clearColor];
		[self layoutIfNeeded];
	}completion:^(BOOL finished) {
		
		[self.layer removeAllAnimations];
		for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
			if ([view isKindOfClass:[self class]]) {
				[view removeFromSuperview];
			}
		}
	}];
}
#pragma mark - pickerView 代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return  self.nameArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 100;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *str;
	if (component == 0) {
		str = self.nameArray[row];
	}else{
		str = self.numberArray[row];
	}
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    /////////////这里有问题???????
	//保存值
	if (component == 0) {
        if (self.nameArray.count > 0) {
            
            self.nameKey = self.nameArray[row];
        }else
        {
            return;
        }
        
		// 让pickerView第1列选中第n行
		[pickerView selectRow:row inComponent:1 animated:YES];
		self.numberKey = self.numberArray[row];
	}
	
	if (component == 1) {
        if (self.numberArray.count > 0) {
            
            self.numberKey = self.numberArray[row];
        }else
        {
            return;
        }
		
		// 让pickerView第1列选中第n行
		[pickerView selectRow:row inComponent:0 animated:YES];
		self.nameKey = self.nameArray[row];
	}
}

#pragma mark - block传值
- (void)scenePickerViewWithpickerBlock:(pickerViewBlock)pickerBlock
{
	self.pickerBlock = pickerBlock;
}
@end




