//
//  SVProgressTool.m
//  xiaorui
//
//  Created by sswukang on 16/7/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SVProgressTool.h"

@implementation SVProgressTool
+ (void)hr_showErrorWithStatus:(NSString *)status
{
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showErrorWithStatus:status];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
	});
}
+ (void)hr_showErrorWithLongTimeStatus:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showErrorWithStatus:status];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
+ (void)hr_showWithStatus:(NSString *)status
{
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showWithStatus:status];
}

+ (void)hr_showSuccessWithStatus:(NSString *)status
{
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD showSuccessWithStatus:status];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
	});
}
+ (void)hr_dismiss
{
	[SVProgressHUD dismiss];
}
@end
