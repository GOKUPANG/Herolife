//
//  NSString+DoorLock.m
//  herolife
//
//  Created by PongBan on 16/9/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "NSString+DoorLock.h"

@implementation NSString (DoorLock)



/*开锁控制帧 斌添加**/
+(NSString*)stringWithHROpenLockVersion:(NSString *)version
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
                                   auth:(NSString *)auth
{
    
    NSMutableDictionary *srcDict = [NSMutableDictionary dictionary];
    
    srcDict[@"user"] = srcUserName;
    
    srcDict[@"dev"]  = srcDevName;
    
    NSMutableDictionary *dstDict = [NSMutableDictionary dictionary];
    
    dstDict[@"user"] = dstUserName;
    dstDict[@"dev"]  = destDevName;
    
    
    NSMutableDictionary *hrpushDict = [NSMutableDictionary dictionary];
    
    hrpushDict[@"version"] =version;
    
    hrpushDict[@"status"] =status;
    
   	hrpushDict[@"time"] = [self loadCurrentDate];
    
    hrpushDict[@"token"] =token;
    
    hrpushDict[@"type"] =type;
    
    hrpushDict[@"desc"] =desc;
    
    hrpushDict[@"src"] =srcDict;
    
    hrpushDict[@"dst"] =dstDict;
    
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    msgDict[@"types"] = msgTypes;
    
    msgDict[@"uid"] = uid;
    
    msgDict[@"did"] = did;
    msgDict[@"uuid"] = uuid;
    
    
    msgDict[@"state"] = state;
    
    msgDict[@"online"] = online;
    
    msgDict[@"control"] = control;
    
    msgDict[@"number"] = number;
    
    msgDict[@"key"] = key;
    
    msgDict[@"auth"] = auth;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"hrpush"] = hrpushDict;
    dict[@"msg"] = msgDict;
    
    NSData * jsonDataDict = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    
    
    
    
    
    NSString *dictStr = [[NSString alloc] initWithData:jsonDataDict encoding:NSUTF8StringEncoding];
    
    NSString *hrpush = @"hrpush\r\n";
    
    NSString *hrlength = [NSString stringWithFormat:@"length\r\n%lu\r\n", (unsigned long)dictStr.length];
    
    NSString *footerStr = @"\r\n\0";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", hrpush, hrlength, dictStr, footerStr];
    
    
    return urlString;
    
    
    
    
}


@end
