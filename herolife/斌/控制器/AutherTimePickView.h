//
//  AutherTimePickView.h
//  herolife
//
//  Created by sswukang on 16/9/20.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutherTimePickView;

@protocol AutherTimePickViewDelegate <NSObject>
@optional
- (void)autherTimePickView:(AutherTimePickView *)autherTimePickView hour:(NSString *)hour minute:(NSString *)minute;

@end


@interface AutherTimePickView : UITextField

/** name */
@property(nonatomic, weak) id<AutherTimePickViewDelegate> delegate;
- (void)initialText;

@end
