//
//  HRPushMode.h
//  herolife
//
//  Created by sswukang on 16/9/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRPushMode : NSObject

/** version */
@property(nonatomic, copy) NSString *version;
/** status */
@property(nonatomic, copy) NSString *status;
/** time */
@property(nonatomic, copy) NSString *time;
/** token */
@property(nonatomic, copy) NSString *token;
/** type */
@property(nonatomic, copy) NSString *type;
/** desc */
@property(nonatomic, copy) NSString *desc;
/** src */
@property(nonatomic, strong) NSDictionary *src;
/** dst */
@property(nonatomic, strong) NSDictionary *dst;
@end
