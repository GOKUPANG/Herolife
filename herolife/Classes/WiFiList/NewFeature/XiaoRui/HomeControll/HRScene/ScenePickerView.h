//
//  ScenePickerView.h
//  xiaorui
//
//  Created by sswukang on 16/7/8.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^pickerViewBlock)(NSString *seconds, NSString *everyMinute);
@interface ScenePickerView : UIView
//快速创建本对象
+ (instancetype)scenePickerView;
/** pickerViewBlock */
@property(nonatomic, copy) pickerViewBlock pickerBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)scenePickerViewWithpickerBlock:(pickerViewBlock)pickerBlock;
@end
