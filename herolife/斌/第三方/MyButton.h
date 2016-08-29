//
//  MyButton.h
//  02-快速创建
//
//  Created by Jarvan on 16/3/7.
//  Copyright © 2016年 Jarvan. All rights reserved.
//

/** 
 使用代码块进行封装，即将点击按钮操作封装到代码快
 */

#import <UIKit/UIKit.h>
// 作声明
@class MyButton;

/** 代码块类型,没有参数*/
//typedef void(^MyButtonBlock)(void);

/** 代码块类型,带参数*/
typedef void(^MyButtonBlock)(MyButton *button);




@interface MyButton : UIButton

/** 快速创建按钮-代码块*/
+ (MyButton *)addBlockButtonWithFrame:(CGRect)frame
                                title:(NSString *)title
                          blockAction:(MyButtonBlock)action;

/** 代码块属性，即具体操作*/
@property (nonatomic,copy) MyButtonBlock buttonAction;

@end
