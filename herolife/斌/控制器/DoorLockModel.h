//
//  DoorLockModel.h
//  herolife
//
//  Created by sswukang on 16/9/14.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoorLockModel : NSObject
/** <#name#> */
@property(nonatomic, copy) NSString *sy;
/** <#name#> */
@property(nonatomic, copy) NSString *uid;
/** <#name#> */
@property(nonatomic, copy) NSString *title;
/** did */
@property(nonatomic, copy) NSString *did;
/** <#name#> */
@property(nonatomic, strong) NSArray *person;
/** <#name#> */
@property(nonatomic, copy) NSString *types;
/** <#name#> */
@property(nonatomic, copy) NSString *uuid;
/** <#name#> */
@property(nonatomic, copy) NSString *time;
/** <#name#> */
@property(nonatomic, copy) NSString *unread;

@end
