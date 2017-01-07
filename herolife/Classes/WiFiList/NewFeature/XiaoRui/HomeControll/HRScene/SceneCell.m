//
//  SceneCell.m
//  xiaorui
//
//  Created by sswukang on 16/7/1.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneCell.h"
#import "DVSwitch.h"
#import "IrgmData.h"
#import "SceneSwitchPicker.h"
#import "IracData.h"
#import "SceneModelSelectController.h"

@interface SceneCell ()
/**
 *  翻转滑块
 */
@property (strong, nonatomic) DVSwitch *switcher;
/** 记录从picker 传过来的数据 */
@property(nonatomic, copy) NSString *nameKey, *numberKey;

@end

@implementation SceneCell

- (void)setDoData:(HRDOData *)doData
{
	_doData = doData;
	if ([self.doData.parameter.lastObject isEqualToString:@"0"]) {
		[self.switcher selectIndex:0 animated:YES];
		
	}else if ([self.doData.parameter.lastObject isEqualToString:@"1"]) {
		[self.switcher selectIndex:2 animated:YES];
		
	}else {
		[self.switcher selectIndex:1 animated:YES];
		
	}
}

- (void)setGmData:(IrgmData *)gmData
{
	_gmData = gmData;
}

- (void)setTvData:(IrgmData *)tvData
{
	_tvData = tvData;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	
}
- (void)sceneCellWithBlock:(sceneCellBlock)block
{
	self.cellBlock = block;
}
- (void)sceneCellWithPickerBlock:(sceneCellPickerBlock)block
{
	self.cellPickerBlock = block;
}
- (void)sceneCellWithModelSelectBlock:(sceneCellModelSelectBlock)block
{
    self.selectBlock = block;
}
- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.switcher mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.top.right.bottom.equalTo(self.rightView);
	}];
	self.switcher.cornerRadius = (self.hr_height  -5)*0.5;
	
	[self.label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.left.top.bottom.equalTo(self.rightView);
	}];
	
	_label.layer.cornerRadius = self.rightView.hr_height * 0.5;
	_label.layer.masksToBounds = YES;
}


- (void)setUpCellUIWithArray:(NSArray *)array
{
	switch (self.switchType) {
  case DVSwitchTypeDoDevice:
		{
			//DVSwitch 显示多层问题
			while ([self.rightView.subviews lastObject] != nil) {
    
				[(UIView *)[self.rightView.subviews lastObject] removeFromSuperview];
			}
			
			self.switcher = [[DVSwitch alloc] initWithStringsArray:array];
			[self.rightView addSubview:self.switcher];
			
			self.switcher.backgroundColor = [UIColor blackColor];
			__weak typeof (self) weakSelf = self;
			[self.switcher setPressedHandler:^(NSUInteger index) {
				__strong typeof (self) strongSelf = weakSelf;
				if (strongSelf.cellBlock) {
					if (index == 0) {
						strongSelf.cellBlock(index);
					}else if (index == 1) {
						strongSelf.cellBlock(index + 1);
					}else if (index == 2)
					{
						strongSelf.cellBlock(index - 1);
					}
				}
			}];
			
		}
			break;
  case DVSwitchTypeWindowDevice:
		{
			while ([self.rightView.subviews lastObject] != nil) {
    
				[(UIView *)[self.rightView.subviews lastObject] removeFromSuperview];
			}

			
			self.switcher = [[DVSwitch alloc] initWithStringsArray:array];
			[self.rightView addSubview:self.switcher];
			self.switcher.backgroundColor = [UIColor blackColor];
			__weak typeof (self) weakSelf = self;
			[self.switcher setPressedHandler:^(NSUInteger index) {
				__strong typeof (self) strongSelf = weakSelf;
				if (strongSelf.cellBlock) {
					if (index == 0) {
						strongSelf.cellBlock(index);
					}else if (index == 1) {
						strongSelf.cellBlock(index + 1);
					}else if (index == 2)
					{
						strongSelf.cellBlock(index - 1);
					}
				}
			}];
			
		}
			break;
  case DVSwitchTypeAirDevice:
		{
			for (UIGestureRecognizer *gest in self.contentView.gestureRecognizers ) {//删除手势
				if ([gest isKindOfClass:[UITapGestureRecognizer class]]) {
					[self.contentView removeGestureRecognizer:gest];
				}
			}
			while ([self.rightView.subviews lastObject] != nil) {
    
				[(UIView *)[self.rightView.subviews lastObject] removeFromSuperview];
			}
			self.switcher = [self setupDVSwitchWithArray: array];
            
			[self.rightView addSubview:self.switcher];
		}
			break;
  case DVSwitchTypeCurrencyDeviceAndTvDevice:
		{
			for (UIGestureRecognizer *gest in self.contentView.gestureRecognizers ) {//删除手势
				if ([gest isKindOfClass:[UITapGestureRecognizer class]]) {
					[self.contentView removeGestureRecognizer:gest];
				}
			}
			
			while ([self.rightView.subviews lastObject] != nil) {
    
				[(UIView *)[self.rightView.subviews lastObject] removeFromSuperview];
			}
			self.switcher = [self setupDVSwitchWithArray: array];
			[self.rightView addSubview:self.switcher];
		}
			break;
			
  default:
			break;
	}

}
- (void)switcherClick:(UITapGestureRecognizer *)tap
{
    __weak typeof (self) weakSelf = self;
	if (self.switchType == DVSwitchTypeCurrencyDeviceAndTvDevice) {
		if (self.gmData) {
			SceneSwitchPicker *picker = [SceneSwitchPicker sceneSwitchPickerView];
			picker.gmData = self.gmData;
			[picker scenePickerViewWithpickerBlock:^(NSString *nameKey, NSString *numberKey) {
				
				weakSelf.nameKey = nameKey;
				weakSelf.numberKey = numberKey;
				weakSelf.cellPickerBlock(nameKey,numberKey);
			}];
			picker.frame = [UIScreen mainScreen].bounds;
			[[UIApplication sharedApplication].keyWindow addSubview:picker];
		}

    }else if (self.switchType == DVSwitchTypeAirDevice) {
        UIViewController *VC = self.getCurrentViewController;
        SceneModelSelectController *selectVC = [[SceneModelSelectController alloc] init];
        [VC presentViewController:selectVC animated:YES completion:nil];
        [selectVC sceneModelSelectControllerWithBlock:^(NSString *selectString) {
            
            if (weakSelf.selectBlock) {
                
                weakSelf.selectBlock(selectString);
            }
            
        }];
    }

	
}

- (NSString *)setupStatusWithStatus:(NSString *)status
{
    NSString *str;
    switch ([status intValue]) {
        case 0:
            str = @"关";
            break;
        case 1:
            str = @"开";
            break;
        case 2:
            str = @"自动模式";
            break;
        case 3://无效
            
            break;
        case 4:
            str = @"制冷模式";
            break;
        case 5:
            str = @"除湿模式";
            break;
        case 6:
            str = @"送风模式";
            break;
        case 7:
            str = @"制暖模式";
            break;
        case 8:
            str = @"自动风速";
            break;
        case 9:
            str = @"风速1档";
            break;
        case 10:
            str = @"风速2档";
            break;
        case 11:
            str = @"风速3档";
            break;
        case 12:
            str = @"自动摆风";
            break;
        case 13:
            str = @"手动摆风";
            break;
        case 14://无效
            
            break;
        case 15://无效
            
            break;
        case 16:
            str = @"温度16℃";
            break;
        case 17:
            str = @"温度17℃";
            break;
        case 18:
            str = @"温度18℃";
            break;
        case 19:
            str = @"温度19℃";
            break;
        case 20:
            str = @"温度20℃";
            break;
        case 21:
            str = @"温度21℃";
            break;
        case 22:
            str = @"温度22℃";
            break;
        case 23:
            str = @"温度23℃";
            break;
        case 24:
            str = @"温度24℃";
            break;
        case 25:
            str = @"温度25℃";
            break;
        case 26:
            str = @"温度26℃";
            break;
        case 27:
            str = @"温度27℃";
            break;
        case 28:
            str = @"温度28℃";
            break;
        case 29:
            str = @"温度29℃";
            break;
        case 30:
            str = @"温度30℃";
            break;
        default:
            break;
    }
    return str;
}
- (DVSwitch *)setupDVSwitchWithArray:(NSArray *)array
{
	DVSwitch *dv = [[DVSwitch alloc] initWithStringsArray:array];
	dv.sliderColor = [UIColor blackColor];
	dv.backgroundColor = [UIColor blackColor];
	dv.labelTextColorInsideSlider = [UIColor whiteColor];
	dv.labelTextColorOutsideSlider = [UIColor whiteColor];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switcherClick:)];
	[dv addGestureRecognizer:tap];
	return dv;
}
- (UILabel *)addLabel{
	UILabel *label = [[UILabel alloc] init];
	label.backgroundColor = [UIColor grayColor];
	label.textColor = [UIColor whiteColor];
	label.text = @"未选择操作";
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:17];
	return label;
}

@end
