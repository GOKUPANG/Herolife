//
//  HRTabBar.h
//  herolife
//
//  Created by sswukang on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRTabBar;
@protocol HRTabBarDelegate <NSObject>

@optional
- (void)hrTabBar:(HRTabBar *)tabBar didClickBtn:(NSInteger)index;

@end

@interface HRTabBar : UIView
@property (nonatomic, weak) id<HRTabBarDelegate> delegate;
@end
