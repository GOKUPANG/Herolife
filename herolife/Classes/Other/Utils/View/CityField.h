//
//  CityField.h
//  08-注册界面(了解)
//
//  Created by xiaomage on 15/9/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityField;

@protocol CityFieldDelegate <NSObject>
@optional
- (void)cityField:(CityField *)cityField brand:(NSString *)brand indexsType:(NSString *)indexsType;

@end


@interface CityField : UITextField

/** name */
@property(nonatomic, weak) id<CityFieldDelegate> delegate;
- (void)initialText;

@end
