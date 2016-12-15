//
//  UserCell.m
//  xiaorui
//
//  Created by sswukang on 16/5/24.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "UserCell.h"
#import "HRMessageData.h"
#import "UIImageView+WebCache.h"
@interface UserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *eptLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation UserCell
- (CGFloat)cellHeight
{
	if (_cellHeight) return _cellHeight;
	
	// 1.头像
	_cellHeight = 200;
	
	// 2.文字
//	CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * XMGCommonMargin;
//	CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
//	CGFloat textH = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
//	_cellHeight += textH;
//	_cellHeight += XMGCommonMargin;

	return _cellHeight;
}
- (void)setData:(HRMessageData *)data
{
	_data = data;
	NSString *str = [kUserDefault objectForKey:kDefaultsIconURL];
	if (str) {
		NSURL *url = [NSURL URLWithString:str];
		[self.iconImage sd_setImageWithURL:url];
	}else
	{
		CGSize size = self.iconImage.hr_size;
		size.width = 20;
		self.iconImage.hr_size = size;
		//self.iconImage.image = [UIImage imageWithColor:[UIColor colorWithR:234 G:234 B:234 alpha:1.0] size:CGSizeMake(20, 20)];
        
        self.iconImage.image = [UIImage imageNamed:@"头像占位图片"];
        
	}
	
	self.title.text = data.title;
	self.userLabel.text = data.mess;
}
- (void)awakeFromNib {
    [super awakeFromNib];
	self.eptLabel.layer.cornerRadius = self.eptLabel.hr_height *0.5;
	self.eptLabel.layer.masksToBounds = YES;
	self.userLabel.layer.cornerRadius = 10;
	self.userLabel.layer.masksToBounds = YES;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor =[UIColor colorWithR:234 G:234 B:234 alpha:1];
//	self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
	
}


@end
