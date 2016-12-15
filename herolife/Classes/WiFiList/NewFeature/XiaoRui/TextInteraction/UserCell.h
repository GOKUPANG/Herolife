//
//  UserCell.h
//  xiaorui
//
//  Created by sswukang on 16/5/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRMessageData;
@interface UserCell : UITableViewCell
/** HRMessageData */
@property(nonatomic, strong) HRMessageData *data;
/**  */
@property(nonatomic, assign) CGFloat cellHeight;
@end
