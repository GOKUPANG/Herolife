//
//  SettingCell.m
//  herolife
//
//  Created by sswukang on 16/8/25.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()
@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		UIImageView *leftImage = [[UIImageView alloc] init];
		[self addSubview:leftImage];
		self.leftImage = leftImage;
		
		UILabel *leftLabel = [[UILabel alloc] init];
		leftLabel.font = [UIFont systemFontOfSize:17];
		leftLabel.textColor = [UIColor whiteColor];
		[self addSubview:leftLabel];
		self.leftLabel = leftLabel;
		
		UIButton *rightButton = [[UIButton alloc] init];
		rightButton.backgroundColor = [UIColor clearColor];
		rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self addSubview:rightButton];
		self.rightButton = rightButton;
		
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect rect = self.frame;
	rect.size.height = self.hr_height - HRCommonScreenH * 2.5;
	self.frame = rect;
	
	[self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(HRCommonScreenW * 30);
		make.top.equalTo(self).offset(HRCommonScreenH * 10);
		make.bottom.equalTo(self).offset(- HRCommonScreenH * 10);
		make.width.mas_equalTo(HRCommonScreenH * 57 );
	}];
	
	[self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.leftImage.mas_right).offset(HRCommonScreenW * 28);
		make.centerY.equalTo(self.leftImage);
	}];
	
	[self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(- HRCommonScreenW * 28);
		make.centerY.equalTo(self.leftImage);
	}];
}







@end
