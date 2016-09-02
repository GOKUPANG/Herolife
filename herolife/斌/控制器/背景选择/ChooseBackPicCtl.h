//
//  ChooseBackPicCtl.h
//  herolife
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseBackPicCtl : UIViewController

/** 声明一个block */

@property(nonatomic,copy)void (^finishBlock)(NSInteger showNumber);

@end
