//
//  SceneModelSelectCell.m
//  herolife
//
//  Created by sswukang on 2016/12/31.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneModelSelectCell.h"

@interface SceneModelSelectCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstr;
/** <#是否连接#> */
@property(nonatomic, assign) CGFloat leftMaign;

@end
@implementation SceneModelSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftMaign = self.leftConstr.constant;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (UIScreenW >= 375) {
    }else
    {
        self.speedLabel.font = [UIFont systemFontOfSize:10];
        self.leftConstr.constant = self.leftMaign - 7;
    }
    self.speedLabel.layer.cornerRadius = self.speedLabel.hr_height *0.5;
    self.speedLabel.layer.masksToBounds = YES;
    
}
@end
