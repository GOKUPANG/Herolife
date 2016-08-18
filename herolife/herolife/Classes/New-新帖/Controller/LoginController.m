//
//  LoginController.m
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.backgroundImageView.image = [UIImage imageNamed:@"1 登录页.jpg"];
}




@end
