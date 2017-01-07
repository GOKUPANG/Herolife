//
//  SceneNameIconCell.m
//  herolife
//
//  Created by sswukang on 2016/12/26.
//  Copyright © 2016年 huarui. All rights reserved.
//
///情景名称和情景图标的cell
#import "SceneNameIconCell.h"

@interface SceneNameIconCell ()

@end

@implementation SceneNameIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        UILabel *sceneLabel = [[UILabel alloc] init];
        sceneLabel.text = @"";
        sceneLabel.textColor = [UIColor whiteColor];
        [self addSubview:sceneLabel];
        
        self.sceneLabel = sceneLabel;
        
        UITextField *sceneField = [[UITextField alloc] init];
        sceneField.textColor = [UIColor colorWithR:172 G:172 B:172 alpha:1.0];
        sceneField.placeholder = @"请输入情景名称";
        sceneField.borderStyle = UITextBorderStyleNone;
        sceneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.sceneField = sceneField;
        [self addSubview:sceneField];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        self.lineView = lineView;
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString *title = @"情景名称:";
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    CGSize size = [title sizeWithAttributes:muDict];
    [self.sceneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(size.width);
        
    }];
    [self.sceneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sceneLabel.mas_right).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.sceneLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        make.width.equalTo(self);
    }];
    
    
}
@end
