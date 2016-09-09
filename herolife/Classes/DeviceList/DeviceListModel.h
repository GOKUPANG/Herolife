//
//  DeviceListModel.h
//  herolife
//
//  Created by sswukang on 16/9/8.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceListModel : NSObject
/** type */
@property(nonatomic, copy) NSString *types;
/** uid */
@property(nonatomic, copy) NSString *uid;
/** <#name#> */
@property(nonatomic, copy) NSString *did;
/** <#name#> */
@property(nonatomic, copy) NSString *uuid;
/** <#name#> */
@property(nonatomic, copy) NSString *version;
/** <#name#> */
@property(nonatomic, copy) NSString *title;
/** <#name#> */
@property(nonatomic, copy) NSString *brand;
/** <#name#> */
@property(nonatomic, copy) NSString *online;
/** <#name#> */
@property(nonatomic, strong) NSArray *op;
/** <#name#> */
@property(nonatomic, copy) NSString *state;
/** <#name#> */
@property(nonatomic, copy) NSString *level;
@end
