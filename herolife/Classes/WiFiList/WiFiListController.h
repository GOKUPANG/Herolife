//
//  WiFiListController.h
//  herolife
//
//  Created by sswukang on 16/8/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectWifiBlock)(NSString *name, NSInteger index);

@interface WiFiListController : UIViewController

/** <#name#> */
@property(nonatomic, copy) selectWifiBlock wifiBlock;

- (void)selectWifiBlockWithBlock:(selectWifiBlock)block;

@end
