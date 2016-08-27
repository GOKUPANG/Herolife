//
//  DeviceListController.h
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//
// Cell
#import "CustomCollectionViewCollectionViewCell.h"

// Model
#import "PhotoModel.h"

NSString *const kCustomCellIdentifier = @"CustomCell";

@interface CustomCollectionViewCollectionViewCell ()
/** <#name#> */
@property(nonatomic, weak) UIImageView *photoImageView;
/** <#name#> */
@property(nonatomic, weak) UIView *dotLineView;
@end

@implementation CustomCollectionViewCollectionViewCell

#pragma mark - Dynamic Properties

- (void)setPhotoModel:(PhotoModel *)photoModel {
    _photoModel = photoModel;
    _photoImageView.image = photoModel.image;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		UIView *dotLineView = [[UIView alloc] init];
		dotLineView.backgroundColor = [UIColor clearColor];
		[self addSubview:dotLineView];
		self.dotLineView = dotLineView;
		
		UIImageView *photoImageView = [[UIImageView alloc] init];
		[self addSubview:photoImageView];
		self.photoImageView = photoImageView;
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.dotLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.top.equalTo(self);
	}];
	
	[self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(HRCommonScreenW *12);
		make.right.equalTo(self).offset(- HRCommonScreenW *12);
		make.top.equalTo(self).offset(HRCommonScreenH *12);
		make.right.equalTo(self).offset(- HRCommonScreenH *12);
	}];
	
//	
//	self.dotLineView.layer.cornerRadius = 10;
//	self.dotLineView.layer.masksToBounds = YES;
//	
//	CAShapeLayer *border = [CAShapeLayer layer];
//	
//	border.strokeColor = [UIColor whiteColor].CGColor;
//	
//	border.fillColor = nil;
//	
//	CGRect rect = self.dotLineView.frame;
//	
//	border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
//	
//	border.frame = rect;
//	
//	border.lineWidth = 1.f;
//	
//	border.lineCap = @"square";
//	
//	border.lineDashPattern = @[@8, @4];
//	border.cornerRadius = 10;
//	border.masksToBounds = YES;
//	[self.dotLineView.layer addSublayer:border];
}











@end
