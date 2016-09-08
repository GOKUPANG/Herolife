//
//  DeviceListCell.m
//  herolife
//
//  Created by sswukang on 16/8/26.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		UIImageView *leftImage = [[UIImageView alloc] init];
		[self addSubview:leftImage];
		self.leftImage = leftImage;
		
		UILabel *leftLabel = [[UILabel alloc] init];
		leftLabel.font = [UIFont systemFontOfSize:17];
		leftLabel.textColor = [UIColor whiteColor];
		leftLabel.textAlignment = NSTextAlignmentLeft;
		[self addSubview:leftLabel];
		self.leftLabel = leftLabel;
		
		UILabel *rightLabel = [[UILabel alloc] init];
		rightLabel.font = [UIFont systemFontOfSize:17];
		rightLabel.textColor = [UIColor whiteColor];
		rightLabel.textAlignment = NSTextAlignmentRight;
		[self addSubview:rightLabel];
		self.rightLabel = rightLabel;
		
		
		UILabel *minLabel = [[UILabel alloc] init];
		minLabel.font = [UIFont systemFontOfSize:14];
		minLabel.textColor = [UIColor whiteColor];
		minLabel.textAlignment = NSTextAlignmentRight;
		[self addSubview:minLabel];
		self.minLabel = minLabel;
		
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(HRCommonScreenW * 73);
		make.centerY.equalTo(self);
	}];
	
	[self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.leftImage.mas_right).offset(HRCommonScreenW * 52);
		make.centerY.equalTo(self.leftImage);
	}];
	
	[self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(- HRCommonScreenW * 28);
		make.top.equalTo(self.leftImage);
	}];
	[self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.rightLabel.mas_bottom).offset(HRCommonScreenH *10);
		make.right.equalTo(self.rightLabel);
	}];
}


@end
