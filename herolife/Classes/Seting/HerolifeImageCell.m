//
//  HerolifeImageCell.m
//  xiaorui
//
//  Created by sswukang on 16/5/27.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HerolifeImageCell.h"

@interface HerolifeImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logImage;
@end
@implementation HerolifeImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.logImage.image = [UIImage imageNamed:@"LOGO"];
}

@end
