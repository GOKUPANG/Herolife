//
//  modelSelectPickerView.m
//  herolife
//
//  Created by sswukang on 2016/12/31.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "modelSelectPickerView.h"
@interface modelSelectPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *determineButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewMaxY;
/** 存放温度的数组 */
@property(nonatomic, strong) NSMutableArray *tempArray;
/** 秒 */
@property(nonatomic, copy) NSString *tempString;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation modelSelectPickerView

#pragma mark - 懒加载
- (NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return  _tempArray;
}

+ (instancetype)scenePickerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"modelSelectPickerView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //初始化
    [self setupViews];
    self.tempLabel.text = @"温度";
    
}
#pragma mark - 内部方法
- (void)setupViews
{
    //初始化数值
    self.tempString = @"16";
    
    self.determineButton.layer.cornerRadius = 10;
    self.determineButton.layer.masksToBounds = YES;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = NO;
    
    self.containerViewMaxY.constant = -250;
    
    //给数组初始化
    for (int i = 16; i < 31; i++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [self.tempArray addObject:str];
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
            self.pickerBlock(self.tempString,@"");
        }
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
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.tempArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *str = self.tempArray[row];
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    //保存值
    self.tempString = self.tempArray[row];
}

#pragma mark - block传值
- (void)scenePickerViewWithpickerBlock:(pickerViewBlock)pickerBlock
{
    self.pickerBlock = pickerBlock;
}

@end
