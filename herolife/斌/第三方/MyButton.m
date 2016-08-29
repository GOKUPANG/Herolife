//
//  MyButton.m
//  02-快速创建
//
//  Created by Jarvan on 16/3/7.
//  Copyright © 2016年 Jarvan. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

+ (MyButton *)addBlockButtonWithFrame:(CGRect)frame title:(NSString *)title blockAction:(MyButtonBlock)action{
    // UIButton
    MyButton *button = [MyButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // 保存代码块
    button.buttonAction = action;
    
    // 添加点击操作
    // self是MyButton类
//    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:button action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

/** 类方法*/
+ (void)buttonClick{
    NSLog(@"---类方法---");
}


/** 对象方法*/
- (void)buttonClick:(MyButton *)button{
    NSLog(@"---对象方法---");
    
    // 调用代码块，即执行操作点击按钮事件
    if (button.buttonAction) {  // 如果有实现才调用
        // typedef void(^MyButtonBlock)(MyButton *button);
//        button.buttonAction();
        button.buttonAction(button);
    }
    
}

@end
