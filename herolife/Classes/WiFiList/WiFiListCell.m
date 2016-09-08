
//
//  WiFiListCell.m
//  herolife
//
//  Created by sswukang on 16/8/29.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "WiFiListCell.h"


@interface WiFiListCell ()

/** wifi信号图片 */
@property(nonatomic, weak) UIImageView *wifiImage;
@end

@implementation WiFiListCell
- (void)setRssilistString:(NSString *)rssilistString
{
	_rssilistString = rssilistString;
	int index = [rssilistString intValue];
	switch (index) {
  case 0:
		{
			self.wifiImage.image = [UIImage imageNamed:@"没有"];
		}
			break;
  case 1:
		{
			self.wifiImage.image = [UIImage imageNamed:@"很弱"];
			
		}
			break;
  case 2:
		{
			self.wifiImage.image = [UIImage imageNamed:@"弱"];
			
		}
			break;
  case 3:
		{
			self.wifiImage.image = [UIImage imageNamed:@"微弱"];
			
		}
			break;
  case 4:
		{
			
			self.wifiImage.image = [UIImage imageNamed:@"满格"];
		}
			break;
			
  default:
			break;
	}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.backgroundColor = [UIColor clearColor];
		UIImageView *leftImage = [[UIImageView alloc] init];
		[self addSubview:leftImage];
		self.leftImage = leftImage;
		
		UILabel *leftLabel = [[UILabel alloc] init];
		leftLabel.font = [UIFont systemFontOfSize:17];
		leftLabel.textColor = [UIColor whiteColor];
		leftLabel.text = @"HUARUIKEJI";
		[self addSubview:leftLabel];
		self.leftLabel = leftLabel;
		
		UIButton *LockButton = [[UIButton alloc] init];
		[LockButton setBackgroundImage:[UIImage imageNamed:@"锁"] forState:UIControlStateNormal];
		LockButton.backgroundColor = [UIColor clearColor];
		[self addSubview:LockButton];
		self.LockButton = LockButton;
		
		UIImageView *wifiImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WIFI"]];
		[self addSubview:wifiImage];
		self.wifiImage = wifiImage;
		
		//线
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
	
	[self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(HRCommonScreenW * 5);
		make.bottom.equalTo(self).offset(- HRCommonScreenH * 20);
		make.width.mas_equalTo(HRCommonScreenW * 30);
	}];
	
	[self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.leftImage.mas_right).offset(HRCommonScreenW * 25);
		make.centerY.equalTo(self.leftImage);
	}];
	
	[self.wifiImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(- HRCommonScreenW * 10);
		make.centerY.equalTo(self.leftImage);
	}];
	
	[self.LockButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.wifiImage.mas_left).offset(- HRCommonScreenW * 15);
		make.centerY.equalTo(self.leftImage);
	}];
	
	[self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(HRCommonScreenW * 30);
		make.right.equalTo(self).offset(- HRCommonScreenW * 30);
		make.bottom.equalTo(self);
		make.height.mas_equalTo(1);
	}];
}

@end
