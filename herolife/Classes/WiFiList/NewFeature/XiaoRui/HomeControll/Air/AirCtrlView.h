//
//  AirCtrlView.h
//  xiaorui
//
//  Created by sswukang on 15/12/21.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IracData;
@interface AirCtrlView : UIView

@property (strong, nonatomic) UIImageView *speedImageView;
@property (strong, nonatomic) UIImageView *powerImageView;
@property (strong, nonatomic) UIImageView *modeCoolImageView;
@property (strong, nonatomic) UIImageView *modeHeatImageView;
@property (strong, nonatomic) UIImageView *modeWindImageView;
@property (strong, nonatomic) UIImageView *modeDehumImageView;
@property (strong, nonatomic) UIImageView *swingHandImageView;
@property (strong, nonatomic) UIImageView *swingAutoImageView;
@property (strong, nonatomic) UILabel *tempLabel;
@property (strong, nonatomic) UILabel *unitLabel;
@property (strong, nonatomic) UISlider *tempSlider;

/**  */
@property(nonatomic, strong) IracData *iracData;

@end
