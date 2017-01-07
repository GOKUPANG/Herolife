//
//  SceneModellView.h
//  xiaorui
//
//  Created by sswukang on 16/7/5.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^blockSceneTabelView)(NSArray *doArray, NSArray *currencyArray, NSArray *airArray, NSArray *tvArray);
@interface SceneModellView : UIView

/**  */
@property(nonatomic, copy) blockSceneTabelView tableViewBlock;

+ (SceneModellView *)shareSceneModellView;

- (void)sceneModellViewSendTableViewWithBlock:(blockSceneTabelView)block;
@end
