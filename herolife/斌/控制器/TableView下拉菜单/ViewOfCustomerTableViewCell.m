//
//  ViewOfCustomerTableViewCell.m
//  GDSASYS
//
//  Created by windzhou on 15/3/27.
//  Copyright (c) 2015年 Smart-Array. All rights reserved.
//

#import "ViewOfCustomerTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ViewOfCustomerTableViewCell
@synthesize nameLabel,managerNameLabel,departmentLabel,addressLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 15.f, 50.f, 20.f)];
        nameLabel.backgroundColor = [UIColor clearColor];
     #pragma mark -cell的字体颜色设置

        nameLabel.textColor = [UIColor whiteColor];
        
        
        nameLabel.font = [UIFont systemFontOfSize:12.f];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        
        
        managerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, CGRectGetMinY(nameLabel.frame), 50.f, CGRectGetHeight(nameLabel.frame))];
        managerNameLabel.backgroundColor = [UIColor clearColor];
        managerNameLabel.textColor = [UIColor whiteColor];
        managerNameLabel.textAlignment = NSTextAlignmentRight;
        managerNameLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:managerNameLabel];
        
        departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(155.f, CGRectGetMinY(nameLabel.frame), 50.f, CGRectGetHeight(nameLabel.frame))];
        departmentLabel.backgroundColor = [UIColor clearColor];
        departmentLabel.textAlignment = NSTextAlignmentLeft;
        departmentLabel.font = [UIFont systemFontOfSize:12.f];
        departmentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:departmentLabel];
        
        addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(230.f, CGRectGetMinY(nameLabel.frame), 50.f, CGRectGetHeight(nameLabel.frame))];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.textColor = [UIColor whiteColor];
        addressLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:addressLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
