//
//  EditViewController.h
//  xiaorui
//
//  Created by sswukang on 16/5/4.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IracData;
@class EditViewController;
typedef void (^EditViewControllerblock)(IracData *data);

@protocol EditViewControllerDelegate <NSObject>

@optional
- (void)editViewController:(EditViewController *)editViewController iradata:(IracData *)iradata;

@end

@interface EditViewController : UIViewController
/** infrareVC 传过来的模型数据 */
@property(nonatomic, strong) IracData *iradata;
/** editViewControllerblock */
@property(nonatomic, copy) EditViewControllerblock block;
/** EditViewControllerDelegate */
@property(nonatomic, weak) id<EditViewControllerDelegate> delegate;

@end
