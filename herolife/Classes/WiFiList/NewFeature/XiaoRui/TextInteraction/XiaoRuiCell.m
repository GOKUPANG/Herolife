//
//  XiaoRuiCell.m
//  xiaorui
//
//  Created by sswukang on 16/5/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "XiaoRuiCell.h"
#import "HRMessageData.h"

@interface XiaoRuiCell ()
@property (weak, nonatomic) IBOutlet UILabel *eptLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiaoRuiText;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XiaoRuiCell

- (void)setData:(HRMessageData *)data
{
	_data = data;
	self.titleLabel.text = data.title;
	self.xiaoRuiText.text = data.mess;
}
- (void)awakeFromNib {
	[super awakeFromNib];
	self.eptLabel.layer.cornerRadius = self.eptLabel.hr_height *0.5;
	self.eptLabel.layer.masksToBounds = YES;
	
	self.xiaoRuiText.layer.cornerRadius = 10;
	self.xiaoRuiText.layer.masksToBounds = YES;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor =[UIColor colorWithR:234 G:234 B:234 alpha:1];
	self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
}

@end
