//
//  InfraredDeviceCell.m
//  HuaruiAI
//
//  Created by sswukang on 15/11/24.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import "InfraredDeviceCell.h"

@implementation InfraredDeviceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void) updateUI {
	if (_device) {
		switch (_device.deviceType) {
			case HRInfraredDeviceTypeGeneral:
				self.imageView.image = [UIImage imageNamed:@"小睿通用关"];
				self.titleLabel.text = _device.name;
				break;
			case HRInfraredDeviceTypeAir:
				self.imageView.image = [UIImage imageNamed:@"空调"];
				self.titleLabel.text = _device.name;
				
//			case HRInfraredDeviceTypeTV:
//				self.imageView.image = [UIImage imageNamed:@"ic_television"];
//				self.titleLabel.text = _device.name;
//				break;
				
			default:
				break;
		}
	}
}


@end
