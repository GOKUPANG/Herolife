//
//  SceneSwitchPicker.h
//  xiaorui
//
//  Created by sswukang on 16/7/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IrgmData;
typedef void(^pickerViewBlock)(NSString *nameKey, NSString *numberKey);
@interface SceneSwitchPicker : UIView
//快速创建本对象
+ (instancetype)sceneSwitchPickerView;
/** pickerViewBlock */
@property(nonatomic, copy) pickerViewBlock pickerBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** IrgmData */
@property(nonatomic, strong) IrgmData *gmData;
/** IrgmData */
@property(nonatomic, strong) IrgmData *tvData;
- (void)scenePickerViewWithpickerBlock:(pickerViewBlock)pickerBlock;
@end