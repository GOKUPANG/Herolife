//
//  AppUntils.h
//  手机uuid
//
//  Created by sswukang on 2016/10/17.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUntils : NSObject
+(void)saveUUIDToKeyChain;

+(NSString *)readUUIDFromKeyChain;

+ (NSString *)getUUIDString;
@end
