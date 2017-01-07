//
//  CityField.m
//  08-注册界面(了解)
//
//  Created by xiaomage on 15/9/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "CityField.h"

#import "Province.h"

@interface CityField () <UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic, assign) NSInteger selProvinceIndex;

@property (nonatomic, strong) NSMutableArray *provinces;

@property (nonatomic, weak) UIPickerView *pickerView;
@property(nonatomic, assign) BOOL isInital;
@end

@implementation CityField

// 初始化文字
- (void)initialText
{
    if (_isInital == NO) {
        
        [self pickerView:_pickerView didSelectRow:0 inComponent:0];
        _isInital = YES;
    }
}

- (NSMutableArray *)provinces
{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];
        
        // 1.解析plist文件
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"air_infrared_library.plist" ofType:nil];
        
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
        
        // 2.遍历字典数组
        for (NSDictionary *dict in dictArr) {
            id obj = [Province provinceWithDict:dict];
            [_provinces addObject:obj];
        }
        
    }
    return _provinces;
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
    return 2;
}

// 返回有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) { // 第0列:描述省,有多少省模型就有多少行
        
        return self.provinces.count;
        
    }else{ // 第1列:描述第0列选中省的城市
        // 获取第0列选中的省 selProvinceIndex:第0列选中的row
        Province *p = self.provinces[_selProvinceIndex];
        return p.cities.count;
    }
    
}

#pragma mark - UIPickerViewDelegate
// 返回每一行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) { // 描述省的名称
        
        Province *p = self.provinces[row];
        
        return p.name;
        
    }else{ // 描述第0列选中省的城市

        // 获取第0列选中的省 selProvinceIndex:第0列选中的row
        Province *p = self.provinces[_selProvinceIndex];
		NSString *str = [NSString stringWithFormat:@"%@", p.cities[row]];
        return str;
    }
}

// 选中一行就会调用
// 给文本框赋值
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) { // 滚动第0列,选择省会
        // 记录下选中的新的省会的角标
      _selProvinceIndex = row;
        
        // 刷新第1列
        [pickerView reloadComponent:1];
        
        // 让pickerView第1列选中第0行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }
    
    // 给文本框赋值
    
    // 获取选中的省
    // 获取第0列选中的省 selProvinceIndex:第0列选中的row
    Province *p = self.provinces[_selProvinceIndex];
    
    // 获取选中的城市
    // 获取第1列选中哪一行
   NSInteger cityIndex =  [pickerView selectedRowInComponent:1];
   NSString *str = [NSString stringWithFormat:@"%@", p.cities[cityIndex]];
   NSString *cityName = str;
	
	
    self.text = [NSString stringWithFormat:@"%@ %@",p.name,cityName];
	
	
	if ([self.delegate respondsToSelector:@selector(cityField:brand:indexsType:)]) {
		[self.delegate cityField:self brand:p.name indexsType:str];
	}
    
}

@end
