//
//  SceneAddController.h
//  herolife
//
//  Created by sswukang on 2016/12/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockSceneTabelView)(NSArray *doArray, NSArray *currencyArray, NSArray *airArray, NSArray *tvArray);
@interface SceneAddController : UIViewController

/**  */
@property(nonatomic, copy) blockSceneTabelView tableViewBlock;

- (void)sceneModellViewSendTableViewWithBlock:(blockSceneTabelView)block;

@end
