//
//  AddDeivcecell.m
//  herolife
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 huarui. All rights reserved.
//


#define HRUIScreenW [UIScreen mainScreen].bounds.size.width
#define HRUIScreenH [UIScreen mainScreen].bounds.size.height
#define HRCommonScreenH (HRUIScreenH / 667 /2)
#define HRCommonScreenW (HRUIScreenW / 375 /2)


#import "AddDeivcecell.h"
#import "UIView+SDAutoLayout.h"

@implementation AddDeivcecell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        
    }
    
    return self;
    
}


-(void)initUI
{
    _phoneImage = [[UIImageView alloc]init];
    _DeviceNameLabel = [[UILabel alloc]init];
    _TurninImage = [[UIImageView alloc]init];
    [self addSubview:_phoneImage];
    [self addSubview:_DeviceNameLabel];
    [self addSubview:_TurninImage];
    
    _DeviceNameLabel.textColor=[UIColor whiteColor];
    _DeviceNameLabel.font= [UIFont systemFontOfSize:17];

    
    
    _phoneImage.sd_layout
    .leftSpaceToView(self,30.0 * HRCommonScreenW)
    .bottomSpaceToView(self,25.0 * HRCommonScreenH)
    .widthIs(32.0 * HRCommonScreenW)
    .heightIs(52.0* HRCommonScreenH);
    
    _DeviceNameLabel.sd_layout
    .leftSpaceToView(_phoneImage,50.0 * HRCommonScreenW)
    .bottomSpaceToView(self,34.0 *HRCommonScreenH)
    .heightIs(31.0 * HRCommonScreenH)
    .widthRatioToView(self,0.6);
    
//    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.frame.size.width , 0)];
//    
//    separator.backgroundColor = [UIColor whiteColor];
//    
//    self.FenGeXian = separator;
    
    _FenGeXian = [[UIView alloc]init];
    
    [self addSubview:_FenGeXian];
    
    _FenGeXian.sd_layout
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
    
    _FenGeXian.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    
}







@end
