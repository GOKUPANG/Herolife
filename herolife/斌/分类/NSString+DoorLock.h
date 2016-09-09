//
//  NSString+DoorLock.h
//  herolife
//
//  Created by PongBan on 16/9/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DoorLock)

/*开锁控制帧 斌添加**/
+(NSString *)stringWithHROpenLockVersion:(NSString *)version
                                  status:(NSString *)status
                                   token:(NSString *)token
                                    type:(NSString *)type
                                    desc:(NSString *)desc
                             srcUserName:(NSString *)srcUserName
                              srcDevName:(NSString *)srcDevName
                             dstUserName:(NSString *)dstUserName
                              dstDevName:(NSString *)destDevName
                                msgTypes:(NSString *)msgTypes
                                     uid:(NSString *)uid
                                     did:(NSString *)did
                                    uuid:(NSString *)uuid
                                   state:(NSString *)state
                                  online:(NSString *)online
                                 control:(NSString *)control
                                  number:(NSString *)number
                                     key:(NSString *)key
                                    auth:(NSString *)auth;

@end
