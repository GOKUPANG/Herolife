//
//  AddCurrencyView.h
//  xiaorui
//
//  Created by sswukang on 16/6/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IrgmData;
@class HRDOData;
typedef NS_ENUM(NSInteger, HRCurrencyDeviceType){
 
	HRCurrencyDeviceTypeTV = 1,
	HRCurrencyDeviceTypeCurrency = 2,
	HRCurrencyDeviceTypeDo = 3
};
@interface AddCurrencyView : UIView

/** HRTotalData */
@property(nonatomic, strong) IrgmData *data;
/** <#name#> */
@property(nonatomic, strong) HRDOData *doData;
/** HRCurrencyDeviceType */
@property(nonatomic, assign) HRCurrencyDeviceType deviceType;
/** NSString */
@property(nonatomic, copy) NSString *textLabel;
/** NSString */
@property(nonatomic, copy) NSString *titleButton;
@end
