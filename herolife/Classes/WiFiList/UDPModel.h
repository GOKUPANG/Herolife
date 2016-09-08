//
//  UDPModel.h
//  herolife
//
//  Created by sswukang on 16/9/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRPushMode.h"
#import "WIFIListModel.h"

@interface UDPModel : NSObject

/** wifiModel */
@property(nonatomic, strong) WIFIListModel *wifiModel;
/** HRPushMode */
@property(nonatomic, strong) HRPushMode *hrpush;


@end
