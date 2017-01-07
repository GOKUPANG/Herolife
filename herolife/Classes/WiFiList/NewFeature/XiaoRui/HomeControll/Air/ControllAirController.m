//
//  ControllAirController.m
//  herolife
//
//  Created by sswukang on 2016/12/17.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ControllAirController.h"

@interface ControllAirController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
///温度单位
@property (weak, nonatomic) IBOutlet UILabel *CompanyLabel;
///温度
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation ControllAirController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpBackGroungImage];
}

- (void)setUpBackGroungImage
{
    
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        
        
        self.backImageView.image = [UIImage imageNamed:@"1.jpg"];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backImageView.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backImageView.image =[UIImage imageNamed:imgName];
    }
    
}
#pragma mark - UI事件
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

@end
