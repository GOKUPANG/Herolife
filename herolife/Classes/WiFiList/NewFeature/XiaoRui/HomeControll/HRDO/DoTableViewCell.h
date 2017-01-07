//
//  DoTableViewCell.h
//  xiaorui
//
//  Created by sswukang on 16/5/16.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRDOData;

@interface DoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
/** HRDOData */
@property(nonatomic, strong) HRDOData *doData;
/** indexPath */
@property(nonatomic, assign) NSInteger indexPathRow;
@end
