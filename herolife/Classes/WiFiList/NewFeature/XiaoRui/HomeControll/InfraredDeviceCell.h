//
//  InfraredDeviceCell.h
//  HuaruiAI
//
//  Created by sswukang on 15/11/24.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRInfraredDevice.h"

@interface InfraredDeviceCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) HRInfraredDevice *device;

-(void) updateUI;
@end
