//
//  NewFeatureController.m
//  herolife
//
//  Created by sswukang on 16/10/9.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "NewFeatureController.h"
#import "NewFeatureCell.h"

@interface NewFeatureController ()

// 记录上一次的x轴的偏移量
@property (nonatomic, assign) CGFloat lastOffsetX;

@property (nonatomic, weak) UIImageView *guide;

@property (nonatomic, weak) UIImageView *smallText;

@property (nonatomic, weak) UIImageView *largerText;

@end

@implementation NewFeatureController
- (instancetype)init
{
	// 流水布局
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	
	// 设置cell的尺寸
	layout.itemSize = [UIScreen mainScreen].bounds.size;
	
	// 设置每一行的间距
	layout.minimumLineSpacing = 0;
	
	// 设置每个cell的间距
	layout.minimumInteritemSpacing = 0;
	
	// 设置滚动方向
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	//
	//    // 设置每组的内边距
	//    layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
	
	return [self initWithCollectionViewLayout:layout];
}

static NSString *ID = @"cell";
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// 注意:  self.collectionView != self.view
	
	// 初始化CollectionView
	[self setUpCollectionView];
	
	// 给CollectionView添加子控件
	[self setUpChildView];
	
	// 初始化值
	_lastOffsetX = 0;
	
}

// 给CollectionView添加子控件
- (void)setUpChildView
{
	
}

// 初始化CollectionView
- (void)setUpCollectionView
{
	// 注册cell
	[self.collectionView registerClass:[
	NewFeatureCell class] forCellWithReuseIdentifier:ID];
	
	// 取消弹簧效果
	self.collectionView.bounces = NO;
	
	// 取消显示指示器
	self.collectionView.showsHorizontalScrollIndicator = NO;
	
	// 开启分页模式
	self.collectionView.pagingEnabled = YES;
	
}

#pragma mark - UICollectionView数据源
// 返回有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 4;
}

// 返回每个cell长什么样子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
	
	NSString *imageName = [NSString stringWithFormat:@"引导页-%ld",indexPath.item + 1];
	
	cell.image = [UIImage imageNamed:imageName];
	
	// 告诉cell是否是当前cell
	[cell setIndexPath:indexPath count:4];
	
	return cell;
}

// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// 获取当前最新的偏移量
	CGFloat offsetX = scrollView.contentOffset.x;
	
	// 计算下相对于上一次的偏移差
	CGFloat delta = offsetX - _lastOffsetX;
	
	// guide
	_guide.hr_x += 2 * delta;
	
	// largerText
	_largerText.hr_x += 2 * delta;
	
	// smallText
	_smallText.hr_x += 2 * delta;
	
	[UIView animateWithDuration:0.25 animations:^{
		// guide
		_guide.hr_x -= delta;
		
		// largerText
		_largerText.hr_x -= delta;
		
		// smallText
		_smallText.hr_x -= delta;
		
	}];
	
	// 记录下上一次的偏移量
	_lastOffsetX = offsetX;
	
}



@end
