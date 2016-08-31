//
//  Login.h
//  xiaorui
//
//  Created by sswukang on 16/3/11.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HRUser;
@interface Login : NSObject

+(BOOL)isLogined;
+(void)doLogin: (NSDictionary *)loginData;
+(void)doLogout;
+(HRUser *)curLoginUser;

@end
