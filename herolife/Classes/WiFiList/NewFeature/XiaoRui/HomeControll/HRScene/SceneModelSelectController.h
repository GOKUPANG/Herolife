//
//  SceneModelSelectController.h
//  herolife
//
//  Created by sswukang on 2016/12/31.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sceneModelSelectBlock) (NSString *selectString);
@interface SceneModelSelectController : UIViewController

/** <#name#> */
@property(nonatomic, copy) sceneModelSelectBlock selectBlock;
- (void)sceneModelSelectControllerWithBlock:(sceneModelSelectBlock)block;
@end
