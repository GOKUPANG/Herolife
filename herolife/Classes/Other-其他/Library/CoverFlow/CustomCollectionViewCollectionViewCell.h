//
//  DeviceListController.h
//  herolife
//
//  Created by sswukang on 16/8/18.
//  Copyright © 2016年 huarui. All rights reserved.
//
@import UIKit;

extern NSString *const kCustomCellIdentifier;

@class PhotoModel;


@interface CustomCollectionViewCollectionViewCell : UICollectionViewCell

@property (nonatomic) PhotoModel *photoModel;

@end
