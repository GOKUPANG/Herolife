//
//  NSString+PushSet.h
//  herolife
//
//  Created by PongBan on 16/9/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PushSet)

+ (NSString *)stringwithHRPushSetVersion:(NSString *)version
                                  status:(NSString *)status
                                   token:(NSString *)token
                                    type:(NSString *)type
                                    desc:(NSString *)desc
                             srcUserName:(NSString *)srcUserName
                              srcDevName:(NSString *)srcDevName
                             dstUserName:(NSString *)dstUserName
                              dstDevName:(NSString *)destDevName
                                msgTypes:(NSString *)msgTypes
                                   title:(NSString *)title
                                     uid:(NSString *)uid
                                     did:(NSString *)did
                                    uuid:(NSString *)uuid
                              msgVersion:(NSString *)msgVersion
                                   brand:(NSString *)brand
                                   level:(NSString *)level
                                   state:(NSString *)state
                                  online:(NSString *)online
                                      op:(NSArray *)op;


@end
