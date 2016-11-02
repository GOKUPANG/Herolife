//
//  InputText.m
//  动态输入框
//
//  Created by mxd on 14/12/4.
//  Copyright (c) 2014年 daizhe. All rights reserved.
//

#import "InputText.h"
#import "UIView+XD.h"

@implementation InputText
- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = HRUIScreenW - 40;
    textField.height = (HRUIScreenH - 64) *0.36 / 5;
    textField.centerX = centerX;
    textField.y = textY;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, textField.height - 0.5, HRUIScreenW - 40, 0.5)];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor grayColor];
//    [textField addSubview:view];
    textField.placeholder = point;
    textField.font = [UIFont systemFontOfSize:18];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    UIImage *bigIcon = [UIImage imageNamed:icon];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:bigIcon];
	iconView.hidden = YES;
	self.iconImage = iconView;
    if (icon) {
		iconView.height = textField.height;
        iconView.width = iconView.height;
    }
    iconView.contentMode = UIViewContentModeLeft;
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
@end

