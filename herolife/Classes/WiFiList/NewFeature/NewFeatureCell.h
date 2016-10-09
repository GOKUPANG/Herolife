//
//  NewFeatureCell.h
//  herolife
//
//  Created by sswukang on 16/10/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
