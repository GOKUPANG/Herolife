//
//  CustomerInfoSectionView.m
//  GDSASYS
//
//  Created by windzhou on 15/3/30.
//  Copyright (c) 2015年 Smart-Array. All rights reserved.
//

#import "CustomerInfoSectionView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation CustomerInfoSectionView
@synthesize nameLabel,managerNameLabel,departmentLabel,addressLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithNameLabel:(NSString*)name ManagerNameLabel:(NSString*)managerName DepartmentLabel:(NSString*)department AddressLabel:(NSString*)address section:(NSInteger)sectionNumber delegate:(id <CustomerInfoSectionViewDelegate>)delegate
{
    
    
    
    
    self.delegate = delegate;
    self.section = sectionNumber;
    
    self.backgroundColor = [UIColor clearColor];
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 15.f, 50.f, 20.f)];
    nameLabel.backgroundColor = [UIColor clearColor];
   // nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.textColor = [UIColor whiteColor];
    
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = name;
    [self addSubview:nameLabel];
    
    
    managerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f, CGRectGetMinY(nameLabel.frame), 50.f, CGRectGetHeight(nameLabel.frame))];
    managerNameLabel.backgroundColor = [UIColor clearColor];
   // managerNameLabel.textColor = UIColorFromRGB(0x333333);
    managerNameLabel.textColor = [UIColor whiteColor];
    

    managerNameLabel.textAlignment = NSTextAlignmentRight;
    managerNameLabel.font = [UIFont systemFontOfSize:16.f];
    managerNameLabel.text = managerName;
    [self addSubview:managerNameLabel];
    
    departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(120.f, CGRectGetMinY(nameLabel.frame), 50.f, CGRectGetHeight(nameLabel.frame))];
    departmentLabel.backgroundColor = [UIColor clearColor];
    departmentLabel.textAlignment = NSTextAlignmentLeft;
    departmentLabel.font = [UIFont systemFontOfSize:16.f];
   // departmentLabel.textColor = UIColorFromRGB(0x333333);
    departmentLabel.textColor = [UIColor whiteColor];
    

    departmentLabel.text = department;
    [self addSubview:departmentLabel];
    
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(200.f, CGRectGetMinY(nameLabel.frame), 50.f, CGRectGetHeight(nameLabel.frame))];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textAlignment = NSTextAlignmentLeft;
   // addressLabel.textColor = UIColorFromRGB(0x333333);
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:16.f];
    addressLabel.text = address;
    [self addSubview:addressLabel];
    
    _arrow = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 51, CGRectGetMinY(nameLabel.frame), 18, 9)];
    _arrow.backgroundColor = [UIColor clearColor];
    _arrow.image = [UIImage imageNamed:@"下拉符号"];
    [self addSubview:_arrow];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.f, CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 20, 1)];
   // lineView.backgroundColor = [UIColor blueColor];
    
    lineView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:lineView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, 320, 50);
    [btn addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}
- (void)awakeFromNib
{
    _isOpen = NO;
    
}

-(void)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    //判断所在sectionView是否打开来旋转箭头
    _isOpen = !_isOpen;
    if (userAction) {
        if (_isOpen) {
            [UIView animateWithDuration:.3 animations:^{
                self.arrow.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            [UIView animateWithDuration:.3 animations:^{
                self.arrow.transform = CGAffineTransformIdentity;
            }];
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}


@end
