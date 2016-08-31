//
//  ErrorCodeManager.h
//  xiaorui
//
//  Created by sswukang on 16/5/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorCodeManager : NSObject

+ (void)showError:(NSError *)error;

+ (void)showPostError:(NSError *)error;
@end
