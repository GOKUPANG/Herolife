//
//  DoorPswModel.h
//  herolife
//
//  Created by PongBan on 16/9/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoorPswModel : NSObject


/** 门锁密码名字 */

@property(nonatomic,copy)NSString * PswName;

/** 门锁密码编号 */
@property(nonatomic,copy)NSString * PswNumber;

/** 门锁did*/

@property(nonatomic,copy)NSString * did ;



@end
