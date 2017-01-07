//
//  SceneModelSelectController.m
//  herolife
//
//  Created by sswukang on 2016/12/31.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "SceneModelSelectController.h"
#import "SceneModelSelectCell.h"
#import "modelSelectPickerView.h"

@interface SceneModelSelectController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** <#name#> */
@property(nonatomic, weak) UIImageView *backgroundImage;
/** <#name#> */
@property(nonatomic, weak) UIButton *completeButton;
/** <#name#> */
@property(nonatomic, weak) HRNavigationBar *navView;
/** <#name#> */
@property(nonatomic, weak) UICollectionView *collectionView;
/** <#name#> */
@property(nonatomic, weak) UIButton *cancleButton;
/** 记录当前的cell */
@property(nonatomic, weak) SceneModelSelectCell *currentCell;

//@property (strong, nonatomic) UILabel *speedBadgeLabel;
/** <#name#> */
@property(nonatomic, copy) NSString *status;
@end

@implementation SceneModelSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setUpViews];
    self.status = @"-1";
}

static NSString *cellID = @"cell";
- (void)setUpViews
{
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
    navView.titleLabel.text = @"模式选择";
    navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:25 /255.0];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.textColor = [UIColor whiteColor];
    [cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cancleButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    self.cancleButton = cancleButton;
    
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    completeButton.titleLabel.textColor = [UIColor whiteColor];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [completeButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    
    [completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.completeButton = completeButton;
    [self.view addSubview:navView];
    [self.view addSubview:cancleButton];
    [self.view addSubview:completeButton];
    self.navView = navView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((UIScreenW - 35) / 3 , (UIScreenW - 35) / 3 );
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout: layout];
    collectionView.backgroundColor = [UIColor clearColor
                                      ];
    collectionView.delegate = self;
    collectionView.dataSource  = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneModelSelectCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
    
//    self.speedBadgeLabel = [[UILabel alloc] init];
//    [self.view addSubview: self.speedBadgeLabel];
//    self.speedBadgeLabel.textColor       = [UIColor whiteColor];
//    self.speedBadgeLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
//    self.speedBadgeLabel.textAlignment   = NSTextAlignmentCenter;
//    self.speedBadgeLabel.clipsToBounds   = YES;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView);
        make.bottom.equalTo(self.navView);
        make.left.equalTo(self.navView).offset(10);
        make.width.equalTo(self.cancleButton.mas_height);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView);
        make.bottom.equalTo(self.navView);
        make.right.equalTo(self.navView).offset(-10);
        make.width.equalTo(self.completeButton.mas_height);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15 / 2);
        make.right.equalTo(self.view).offset(-15 / 2);
        make.bottom.equalTo(self.view);
        
    }];
    
    //风速Badge
//    [self.speedBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.speedImageView.mas_top).with.offset(8);
//        make.centerX.equalTo(self.speedImageView.mas_right).offset(-10);
//    }];
}
- (void)dealloc
{
    [kNotification removeObserver:self];
}
#pragma mark - UI事件
- (void)cancleButtonClick
{
    self.status = @"-1";
    if (self.selectBlock) {
        self.selectBlock(self.status);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)completeButtonClick
{
    
    if (self.selectBlock) {
        self.selectBlock(self.status);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理 和 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SceneModelSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row) {
        case 0://制冷
        {//模式
            cell.icomImageView.image = [UIImage imageNamed:@"模式冷白"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式冷蓝"];
            cell.icomLabel.text = @"制冷";
        }
            break;
        case 1://开关
        {
            cell.icomImageView.image = [UIImage imageNamed:@"模式开关白"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式开关蓝"];
            cell.icomLabel.text = @"开关";
            
        }
            break;
        case 2://温度
        {
            cell.icomImageView.image = [UIImage imageNamed:@"模式温度"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式温度蓝"];
            cell.icomLabel.text = @"温度";
            
        }
            break;
        case 3://制热
        {
            cell.icomImageView.image = [UIImage imageNamed:@"模式制热白"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式制热蓝"];
            cell.icomLabel.text = @"制热";
            
        }
            break;
        case 4://送风
        {
            cell.icomImageView.image = [UIImage imageNamed:@"模式送风白"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式送风蓝"];
            cell.icomLabel.text = @"送风";
            
        }
            break;
        case 5://风速
        {
            cell.icomImageView.image = [UIImage imageNamed:@"模式风速"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式风速蓝"];
            cell.icomLabel.text = @"风速";
            
        }
            break;
        case 6://自动风向
        {
            
            cell.icomImageView.image = [UIImage imageNamed:@"模式自动风向"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式自动风向蓝"];
            cell.icomLabel.text = @"自动风向";
        }
            break;
        case 7://手动风向
        {
            
            cell.icomImageView.image = [UIImage imageNamed:@"模式手动风向白"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式手动风向蓝"];
            cell.icomLabel.text = @"手动风向";
        }
            break;
        case 8://除湿
        {
            cell.icomImageView.image = [UIImage imageNamed:@"模式除湿"];
            cell.icomImageView.highlightedImage = [UIImage imageNamed:@"模式除湿蓝"];
            cell.icomLabel.text = @"除湿";
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

static int windspeed = -1;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.currentCell.icomImageView.highlighted = NO;
    SceneModelSelectCell *cell = (SceneModelSelectCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.icomImageView.highlighted = YES;
    
    
    switch (indexPath.row) {
        case 0://制冷
        {
            cell.icomImageView.highlighted = YES;
            //停止风速动画
            [self stopSpeedWithSceneCell:cell];
            self.status = @"4";
        
        }
            break;
        case 1:
        {
//            cell.icomImageView.highlighted = YES;
            //停止风速动画
            [self stopSpeedWithSceneCell:cell];
            if ([cell isEqual:self.currentCell]) {
                cell.icomImageView.highlighted = !cell.icomImageView.highlighted;
            }
            if (cell.icomImageView.highlighted) {//开
                
                self.status = @"1";
            }else//关
            {
                self.status = @"0";
            }
        }
            break;
            
        case 2://温度
        {
            
            cell.icomImageView.highlighted = YES;
            [self stopSpeedWithSceneCell:cell];
            modelSelectPickerView *picker = [modelSelectPickerView scenePickerView];
            
            picker.frame = [UIScreen mainScreen].bounds;
            [[UIApplication sharedApplication].keyWindow addSubview:picker];
            [picker scenePickerViewWithpickerBlock:^(NSString *nameKey, NSString *numberKey) {
                
                self.status = nameKey;
                [picker removeFromSuperview];
            }];

        }
            break;
            
        case 3://制热
        {
            
            cell.icomImageView.highlighted = YES;
            [self stopSpeedWithSceneCell:cell];
            self.status = @"7";
        }
            break;
            
        case 4:
        {
            
            cell.icomImageView.highlighted = YES;
            [self stopSpeedWithSceneCell:cell];
            self.status = @"6";
        }
            break;
            
        case 5:
        {
            cell.icomImageView.highlighted = YES;
            cell.speedLabel.hidden = NO;
            windspeed = windspeed == 3 ? 0:++windspeed;
            
            switch (windspeed) {
                case 0:
                    [self setSpeedBadgeLabelText: @"自动"];
                    cell.speedLabel.text = @"自动";
                    [self setSpeedImageViewSpeed:windspeed sceneCell:cell];
                    self.status = @"8";
                    [self postNotificationWithStatus:self.status];
                    break;
                case 1:
                {
                    [self setSpeedBadgeLabelText: @"低"];
                    cell.speedLabel.text = @"低";
                    [self setSpeedImageViewSpeed:windspeed sceneCell:cell];
                    
                    self.status = @"9";
                    [self postNotificationWithStatus:self.status];
                    
                }
                    break;
                case 2:
                    [self setSpeedBadgeLabelText: @"中"];
                    cell.speedLabel.text = @"中";
                    [self setSpeedImageViewSpeed:windspeed sceneCell:cell];
                    
                    self.status = @"10";
                    [self postNotificationWithStatus:self.status];
                    break;
                case 3:
                    [self setSpeedBadgeLabelText: @"高"];
                    cell.speedLabel.text = @"高";
                    [self setSpeedImageViewSpeed:windspeed sceneCell:cell];
                    
                    self.status = @"11";
                    [self postNotificationWithStatus:self.status];
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        case 6:
        {
            cell.icomImageView.highlighted = YES;
            [self stopSpeedWithSceneCell:cell];
            self.status = @"12";
            
        }
            break;
            
        case 7:
        {
            cell.icomImageView.highlighted = YES;
            [self stopSpeedWithSceneCell:cell];
            self.status = @"13";
            
        }
            break;
            
        case 8:
        {
            cell.icomImageView.highlighted = YES;
            [self stopSpeedWithSceneCell:cell];
            self.status = @"5";
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    //记录当前的cell
    self.currentCell = cell;
}
/**
 *  发送传值通知
 */
- (void)postNotificationWithStatus:(NSString *)status
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"status"] = status;
    [kNotification postNotificationName:kNotificationSceneAirData object:nil userInfo:dict];
}
//停止风速动画 - 点击除风速 之外的图片,要让"风速"停止动画
- (void)stopSpeedWithSceneCell:(SceneModelSelectCell *)sceneCell
{
    //初始化风速
    windspeed = -1;
    [self setSpeedImageViewSpeed:-1 sceneCell:self.currentCell];
    self.currentCell.speedLabel.backgroundColor = [UIColor clearColor];
    self.currentCell.speedLabel.text = @"";
//    [self setSpeedBadgeLabelText: @""];
}
-(void) setSpeedImageViewSpeed: (int)speed sceneCell:(SceneModelSelectCell *)sceneCell
{
    sceneCell.speedLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    [sceneCell.icomImageView.layer pop_removeAnimationForKey:@"rotationAnimation"];
    if(speed < 0) return ;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim.duration = 60;
    anim.toValue = [NSNumber numberWithFloat:speed == 0 ? (M_PI * 50):(M_PI * speed * 50)];
    anim.repeatCount = 1000000000;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [sceneCell.icomImageView.layer pop_addAnimation:anim forKey:@"rotationAnimation"];
}


-(void)setSpeedBadgeLabelText: (NSString *)text {
//    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13]forKey:NSFontAttributeName];
//    CGSize size               = [text sizeWithAttributes:attributes];
//    size = CGSizeMake(size.width + 10, size.height + 2);
//    [_speedBadgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(size);
//    }];
//    self.speedBadgeLabel.font               = [UIFont systemFontOfSize:13];
//    self.speedBadgeLabel.text               = text;
//    self.speedBadgeLabel.layer.cornerRadius = size.height/2.f;
}

#pragma mark - Block
- (void)sceneModelSelectControllerWithBlock:(sceneModelSelectBlock)block
{
    self.selectBlock = block;
}
@end
