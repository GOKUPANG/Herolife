//
//  SceneIcomSelectController.h
//  herolife
//
//  Created by sswukang on 2017/1/3.
//  Copyright © 2017年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sceneIcomSelectControllerBlock) (NSInteger pictureIndex);
@interface SceneIcomSelectController : UIViewController
/**  */
@property(nonatomic, copy) sceneIcomSelectControllerBlock pictureIndexBlock;
- (void)sceneIcomSelectControllerBlock:(sceneIcomSelectControllerBlock)block;
@end
