//
//  SceneAirController.h
//  xiaorui
//
//  Created by sswukang on 16/7/12.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IracData;
typedef void(^sceneAirControllerBlock) (NSString *str);
@interface SceneAirController : UIViewController
/**  */
@property(nonatomic, strong) IracData *data;
/**  */
@property(nonatomic, copy) sceneAirControllerBlock block;
- (void)sceneAirControllerWithBlock:(sceneAirControllerBlock)block;
@end
