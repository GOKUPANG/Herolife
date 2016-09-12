//
//  DeviceAutherModel.h
//  herolife
//
//  Created by sswukang on 16/9/12.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceAutherModel : NSObject
/** <#name#> */
@property(nonatomic, copy) NSString *uid;
/** <#name#> */
@property(nonatomic, copy) NSString *did;
/** <#name#> */
@property(nonatomic, copy) NSString *types;
/** <#name#> */
@property(nonatomic, copy) NSString *sy;
/** <#name#> */
@property(nonatomic, copy) NSString *uuid;
/** <#name#> */
@property(nonatomic, copy) NSString *admin;
/** <#name#> */
@property(nonatomic, strong) NSArray *person;
/** <#name#> */
@property(nonatomic, strong) NSArray *permit;
/** <#name#> */
@property(nonatomic, copy) NSString *time;
/** <#name#> */
@property(nonatomic, copy) NSString *title;

@end
