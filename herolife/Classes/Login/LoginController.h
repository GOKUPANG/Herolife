//
//  LoginController.h
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController
/** 从手势界面点击其他账号登陆 的属性值, 通过这个属性值来把登陆界面的 用户名清空 */
@property(nonatomic, assign) BOOL isClear;
@end
