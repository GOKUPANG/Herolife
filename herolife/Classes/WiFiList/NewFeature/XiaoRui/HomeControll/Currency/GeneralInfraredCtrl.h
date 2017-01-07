//
//  GeneralInfraredCtrl.h
//  xiaorui
//
//  Created by sswukang on 15/12/23.
//  Copyright © 2015年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IrgmData;
@interface GeneralInfraredCtrl : UIView

@property (strong, nonatomic) UIButton * muteButton;
@property (strong, nonatomic) UIButton * powerButton;
@property (strong, nonatomic) UIButton * menuButton;
@property (strong, nonatomic) UIButton * num1Button;
@property (strong, nonatomic) UIButton * num2Button;
@property (strong, nonatomic) UIButton * num3Button;
@property (strong, nonatomic) UIButton * num4Button;
@property (strong, nonatomic) UIButton * num5Button;
@property (strong, nonatomic) UIButton * num6Button;
@property (strong, nonatomic) UIButton * num7Button;
@property (strong, nonatomic) UIButton * num8Button;
@property (strong, nonatomic) UIButton * num9Button;
@property (strong, nonatomic) UIButton * num0Button;
@property (strong, nonatomic) UIButton * backButton;
@property (strong, nonatomic) UIButton * selectButton;
@property (strong, nonatomic) UIButton * leftUpButton;
@property (strong, nonatomic) UIButton * leftDownButton;
@property (strong, nonatomic) UIButton * rightUpButton;
@property (strong, nonatomic) UIButton * rightDownButton;
//频道上下左右按钮
@property (strong, nonatomic) UIButton * dirLeftButton;
@property (strong, nonatomic) UIButton * dirRightButton;
@property (strong, nonatomic) UIButton * dirUpButton;
@property (strong, nonatomic) UIButton * dirDownButton;
//ok btn 
@property (strong, nonatomic) UIButton * okButton;

//左上imgView
@property (strong, nonatomic) UIImageView  * LeftUPImgView;
@property (strong, nonatomic) UIImageView  * LeftDownImgView;
@property (strong, nonatomic) UIImageView  * RightUPImgView;
@property (strong, nonatomic) UIImageView  * RightDownImgView;


//左边中间的频道

@property (strong, nonatomic) UILabel  * leftChannelLabel;


//右边中间的音量

@property (strong, nonatomic) UILabel  * rightVolumeLabel;



//右边中间的音量




//频道  上下左右  图片
@property (strong, nonatomic) UIImageView  * FuckUPImgView;
@property (strong, nonatomic) UIImageView  * FuckDownImgView;
@property (strong, nonatomic) UIImageView  * FuckLeftImgView;
@property (strong, nonatomic) UIImageView  * FuckRightImgView;








@property(nonatomic, strong) IrgmData *irgmData;
@end
