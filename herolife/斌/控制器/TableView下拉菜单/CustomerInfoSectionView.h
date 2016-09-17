//
//  CustomerInfoSectionView.h
//  GDSASYS
//
//  Created by windzhou on 15/3/30.
//  Copyright (c) 2015年 Smart-Array. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomerInfoSectionViewDelegate;

@interface CustomerInfoSectionView : UIView
/** 头像*/
@property(nonatomic,strong)UIImageView * iconImg;

/** 头像图片名字*/
@property(nonatomic,copy)     NSString * ImgName;


/** 用户名*/
@property(nonatomic,strong)UILabel * userNameLabel;
/** 时间 */
@property(nonatomic,strong)UILabel * timeLabel;



@property (assign, nonatomic) BOOL isOpen;
@property (nonatomic, assign) id <CustomerInfoSectionViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (strong, nonatomic) UIImageView *arrow;
-(void)toggleOpen:(id)sender;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)initWithImgName:(NSString*)ImgName userNameLabel:(NSString*)userName timeLabel:(NSString*)time   section:(NSInteger)sectionNumber delegate:(id <CustomerInfoSectionViewDelegate>)delegate;

@end

@protocol CustomerInfoSectionViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(CustomerInfoSectionView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end
