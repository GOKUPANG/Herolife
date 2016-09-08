//
//  HRUDPSocketTool.h
//  herolife
//
//  Created by sswukang on 16/9/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRUDPSocketTool : NSObject
+ (instancetype)shareHRUDPSocketTool;
- (void)connectWithUDPSocket;
- (void)sendUDPSockeWithString:(NSString *)string;
@end
