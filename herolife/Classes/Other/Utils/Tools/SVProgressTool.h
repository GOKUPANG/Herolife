//
//  SVProgressTool.h
//  xiaorui
//
//  Created by sswukang on 16/7/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVProgressTool : NSObject
+ (void)hr_showErrorWithStatus:(NSString *)status;
+ (void)hr_showWithStatus:(NSString *)status;
+ (void)hr_showSuccessWithStatus:(NSString *)status;
+ (void)hr_dismiss;
@end
