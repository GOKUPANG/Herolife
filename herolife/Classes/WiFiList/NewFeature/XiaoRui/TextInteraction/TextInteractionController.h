//
//  TextInteractionController.h
//  xiaorui
//
//  Created by sswukang on 16/4/19.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DeviceListModel;
@class HRTotalData;
@protocol TextInteractionControllerDelegate <NSObject>

@optional
- (void)textInteractionControllerWithDict:(NSDictionary *)dict;

@end
@interface TextInteractionController : UIViewController
/** HRTotalData */
@property(nonatomic, strong) HRTotalData *totalData;
/** delegate */
@property(nonatomic, weak) id<TextInteractionControllerDelegate> delegate;
/** messageArray */
@property(nonatomic, strong) NSMutableArray *messageArray;

/** xiaoruiListViwe 传过来的模型数据 */
@property(nonatomic, strong) DeviceListModel *deviceModel;




@end
