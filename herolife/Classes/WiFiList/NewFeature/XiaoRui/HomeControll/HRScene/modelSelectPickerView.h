//
//  modelSelectPickerView.h
//  herolife
//
//  Created by sswukang on 2016/12/31.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^pickerViewBlock)(NSString *seconds, NSString *everyMinute);
@interface modelSelectPickerView : UIView
//快速创建本对象
+ (instancetype)scenePickerView;
/** pickerViewBlock */
@property(nonatomic, copy) pickerViewBlock pickerBlock;

- (void)scenePickerViewWithpickerBlock:(pickerViewBlock)pickerBlock;
@end
