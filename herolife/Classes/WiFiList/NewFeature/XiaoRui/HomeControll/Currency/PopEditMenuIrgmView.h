//
//  PopEditMenuIrgmView.h
//  xiaorui
//
//  Created by sswukang on 16/5/13.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IrgmData;
@interface PopEditMenuIrgmView : UIView

typedef void(^KeyNameBlock)(IrgmData *data);

/** IrgmData */
@property(nonatomic, strong) IrgmData *irgmData;
/**  */
@property(nonatomic, assign) NSInteger tagBtn;

/**  */
@property(nonatomic, copy) KeyNameBlock keyNameBlock ;

- (void)getKeyNameWithBlock:(KeyNameBlock)keyNameBlock;

@end
