//
//  SceneIcomSelectController.m
//  herolife
//
//  Created by sswukang on 2017/1/3.
//  Copyright © 2017年 huarui. All rights reserved.
//

#import "SceneIcomSelectController.h"
#import "SceneIcomSelectCell.h"


@interface SceneIcomSelectController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** <#name#> */
@property(nonatomic, weak) UICollectionView *collection;
/** <#name#> */
@property(nonatomic, strong) NSArray *iconArray;
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;
/** <#name#> */
@property(nonatomic, weak) HRNavigationBar *navView;

@end

@implementation SceneIcomSelectController

- (NSArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = @[
                       @"在家",
                       @"浪漫",
                       @"会议",
                       @"就餐",
                       @"睡觉",
                       @"空调开",
                       @"空调关",
                       @"离家",
                       @"起床",
                       @"工作",
                       @"放松",
                       @"音乐",
                       @"唱K",
                       @"阅读",
                       @"在家",
                       @"窗帘开",
                       @"窗帘关",
                       @"窗帘暂停",
                       @"运动"
                       ];
    }
    return _iconArray;
}
static NSString *cellID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImage.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:backgroundImage];
    self.backgroundImage = backgroundImage;
    
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:view];
    
    //导航条
    HRNavigationBar *navView = [[HRNavigationBar alloc] initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    navView.titleLabel.text = @"情景选择";
    [navView.leftButton setImage:[UIImage imageNamed:@"返回号"] forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    [navView.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    
//    self.saveButton = saveButton;
    [self.view addSubview:navView];
//    [self.view addSubview:saveButton];
    self.navView = navView;

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((UIScreenW - 35) / 3 , (UIScreenW - 35) / 3 );
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 74, UIScreenW - 15, UIScreenH - 74) collectionViewLayout: layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collection];
    self.collection = collection;
    
    [collection registerNib:[UINib nibWithNibName:@"SceneIcomSelectCell" bundle:nil] forCellWithReuseIdentifier:cellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger  PicNum =   [[NSUserDefaults standardUserDefaults] integerForKey:@"PicNum"];
    
    if (!PicNum) {
        
        self.backgroundImage.image = [UIImage imageNamed:Defalt_BackPic];
    }
    
    
    else if (PicNum == -1)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"image.png"];
        
        self.backgroundImage.image =[UIImage imageWithContentsOfFile:path];
    }
    
    else{
        
        NSString * imgName = [NSString stringWithFormat:@"%ld.jpg",PicNum];
        
        self.backgroundImage.image =[UIImage imageNamed:imgName];
    }
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 19;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SceneIcomSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

//记录图片下标
static NSInteger pictureIndex = 1;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //记录图片下标
    pictureIndex = indexPath.row + 1;
    if (self.pictureIndexBlock) {
        self.pictureIndexBlock(indexPath.row);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sceneIcomSelectControllerBlock:(sceneIcomSelectControllerBlock)block
{
    self.pictureIndexBlock = block;
}
@end
