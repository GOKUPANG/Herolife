//
//  WIFIListModel.h
//  herolife
//
//  Created by sswukang on 16/9/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIFIListModel : NSObject
/** set */
@property(nonatomic, copy) NSString *set;
/** ssidlist */
@property(nonatomic, strong) NSArray *ssidlist;
/** authlist */
@property(nonatomic, strong) NSArray *authlist;
/** rssilist */
@property(nonatomic, strong) NSArray *rssilist;
@end
