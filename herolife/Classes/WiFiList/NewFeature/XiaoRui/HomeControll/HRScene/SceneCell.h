//
//  SceneCell.h
//  xiaorui
//
//  Created by sswukang on 16/7/1.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRDOData.h"
@class IrgmData;
@class IracData;

typedef NS_ENUM(NSInteger, DVSwitchType) {
	DVSwitchTypeDoDevice,
	DVSwitchTypeWindowDevice,
	DVSwitchTypeCurrencyDeviceAndTvDevice,
	DVSwitchTypeAirDevice,
};
typedef void(^sceneCellBlock)(NSInteger index);
typedef void(^sceneCellPickerBlock)(NSString *nameKey, NSString *numberKey);
typedef void(^sceneCellModelSelectBlock) (NSString *selectString);

@interface SceneCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *leftImagView;
/// 左边view
@property (weak, nonatomic) IBOutlet UIView *rightView;
/// 客厅
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 延时
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
/** rightView的子控件 */
@property(nonatomic, weak) UILabel *label;

/** HRDOData */
@property(nonatomic, strong) HRDOData *doData;
/** IrgmData */
@property(nonatomic, strong) IrgmData *gmData;
/** IrgmData */
@property(nonatomic, strong) IrgmData *tvData;
/** IracData */
@property(nonatomic, strong) IracData *iracData;
/**  */
@property(nonatomic, assign) DVSwitchType switchType;
/** sceneCellBlock */
@property(nonatomic, copy) sceneCellBlock cellBlock;
@property(nonatomic, copy) sceneCellPickerBlock cellPickerBlock;
/** <#name#> */
@property(nonatomic, copy) sceneCellModelSelectBlock selectBlock;
- (void)sceneCellWithBlock:(sceneCellBlock)block;
- (void)sceneCellWithPickerBlock:(sceneCellPickerBlock)block;
- (void)sceneCellWithModelSelectBlock:(sceneCellModelSelectBlock)block;
- (void)setUpCellUIWithArray:(NSArray *)array;

@end
