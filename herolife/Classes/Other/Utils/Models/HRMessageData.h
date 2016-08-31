//
//  HRMessageData.h
//  xiaorui
//
//  Created by sswukang on 16/5/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRMessageData : NSObject<NSCoding>
/** version */
@property(nonatomic, copy) NSString *version;
/** status */
@property(nonatomic, copy) NSString *status;
/** token */
@property(nonatomic, copy) NSString *token;
/** type */
@property(nonatomic, copy) NSString *type;
/** desc */
@property(nonatomic, copy) NSString *desc;
/** src */
@property(nonatomic, strong) NSDictionary *src;
@property(nonatomic, strong) NSDictionary *dst;
/** uid */
@property(nonatomic, copy) NSString *uid;
/** mid */
@property(nonatomic, copy) NSString *mid;
/** did */
@property(nonatomic, copy) NSString *did;
/** uuid */
@property(nonatomic, copy) NSString *uuid;
/** created */
@property(nonatomic, copy) NSString *created;
/** title */
@property(nonatomic, copy) NSString *title;
/** mess */
@property(nonatomic, copy) NSString *mess;
@end
