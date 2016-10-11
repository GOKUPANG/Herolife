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

+(NSString *)hr_CheckLock_base64String:(NSString*)baseString
{
    //组帧
    NSString *str = baseString;
    
    
    
    DDLogWarn(@"str--%@",str);
    
    char license[14];
    hrdecode(license,(char *)[str UTF8String]);
    printf("decode:%s,len:%ld\n",license,strlen(license));
    
    
    NSString * yuanlai  = @(license);
    
    
    
    return yuanlai;
    
    
//    NSString *string = @(result);
    
    //	NSString *string = nil;
//    DDLogWarn(@"最后组合出来的字符串%@",string);
//    return string;
    
}




//解码

const char enlic3[]="437frhsRE5TW4Gfgki56y54yh64T5tHY65YRHTT45y45ygtaR4W64YUHE54YGR54Y45rfhy6u57hger8567ygvf43tftg44regft547get4345TGREY7587EGTDA5tg5";
const char base[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

int base64_decode(const char *data,char *ret, int data_len)
{
    int ret_len = (data_len / 4) * 3;
    int equal_count = 0;
    char *f = NULL;
    int tmp = 0;
    int temp = 0;
    char need[3];
    int prepare = 0;
    int i = 0;
    if (*(data + data_len - 1) == '=')
    {
        equal_count += 1;
    }
    if (*(data + data_len - 2) == '=')
    {
        equal_count += 1;
    }
    if (*(data + data_len - 3) == '=')
    {
        equal_count += 1;
    }
    int length= ret_len-equal_count;
    switch (equal_count)
    {
        case 0:
            ret_len += 4;//3 + 1 [1 for NULL]
            break;
        case 1:
            ret_len += 4;//Ceil((6*3)/8)+1
            break;
        case 2:
            ret_len += 3;//Ceil((6*2)/8)+1
            break;
        case 3:
            ret_len += 2;//Ceil((6*1)/8)+1
            break;
    }
    if (ret == NULL)
    {
        printf("No enough memory.\n");
        exit(0);
    }
    memset(ret, 0, ret_len);
    f = ret;
    while (tmp < (data_len - equal_count))
    {
        temp = 0;
        prepare = 0;
        while (temp < 4)
        {
            if (tmp >= (data_len - equal_count))
            {
                break;
            }
            prepare = (prepare << 6) | (find_pos(data[tmp]));
            temp++; 
            tmp++; 
        } 
        prepare = prepare << ((4-temp) * 6); 
        for (i=0; i<3 ;i++ ) 
        { 
            if (i == temp) 
            { 
                break; 
            } 
            *f = (char)((prepare>>((2-i)*8)) & 0xFF); 
            f++; 
        } 
    } 
    *f = '\0'; 
    return length; 
}


static char find_pos(char ch)
{
    char *ptr = (char*)strrchr(base, ch);//the last position (the only) in base[]
    return (ptr - base);
}




int hrdecode(char * result,char * src)
{
    char ret[250];
    int ret_len= base64_decode(src,ret,strlen(src));
    
  //  int ret_len= base64_encode(src,ret,strlen(src));

    int i=0;
    for (i=0; i < ret_len; i++) {
        char temp = (char)ret[i]^enlic3[i];
        result[i]=temp;
        
    }
    result[i] = '\0';
    int len= strlen(result);
    return len;
}








@end
