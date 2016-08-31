//
//  HRServices.h
//  HuaruiAI
//
//  Created by sswukang on 15/11/25.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRUser.h"

@interface HRServicesManager : NSObject

@property (copy, nonatomic) NSString *sessid, *session_name, *token;


+ (instancetype) sharedManager;
+ (void) loginWithUsername: (NSString *)userName password:(NSString *)password result:(void(^)(NSError *error))result;
+ (void) logout: (void(^)(NSError*))result;
@end
