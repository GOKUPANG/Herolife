//
//  HerolifeViewController.m
//  xiaorui
//
//  Created by sswukang on 16/5/27.
//  Copyright © 2016年 huarui. All rights reserved.
//
#define XMGHeadH 200
#define XMGTabBarH 44
#define XMGHeadMinH 64
#import "HerolifeViewController.h"
#import "HerolifeImageCell.h"
#import "HerolifeLabelCell.h"

@interface HerolifeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logLabelX;
@property (nonatomic, assign) CGFloat oriOffsetY;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *containtLabel;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewBottom;

@end

@implementation HerolifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化
	[self setUp];
	self.emailBtn.layer.cornerRadius = self.emailBtn.hr_height * 0.5;
}

static NSString *const imageCellID = @"imageCell";
static NSString *const labelCellID = @"labelCell";
- (void)setUp
{
//	[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];  这句代码  坑爹
	
	// 清空导航条阴影线
	[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
	 _oriOffsetY = -(XMGHeadH);
	
	// 设置tableView数据源
	self.tableView.dataSource = self;
	
	// 设置代理
	self.tableView.delegate = self;
	// 设置tableView顶部额外滚动区域
	self.tableView.contentInset = UIEdgeInsetsMake(XMGHeadH , 0, 0, 0);
	
	
	// 不需要添加额外的滚动区域
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.tableView.showsVerticalScrollIndicator = NO;
	self.tableView.showsHorizontalScrollIndicator = NO;
	self.tableView.allowsSelection = NO;
	
	[self.tableView registerNib:[UINib nibWithNibName:@"HerolifeImageCell" bundle:nil] forCellReuseIdentifier:imageCellID];
	[self.tableView registerNib:[UINib nibWithNibName:@"HerolifeLabelCell" bundle:nil] forCellReuseIdentifier:labelCellID];
	//自动布局
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 800;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (IBAction)backBtn:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self IsTabBarHidden:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self IsTabBarHidden:NO];
}
#pragma mark - 隐藏底部条
- (void)IsTabBarHidden:(BOOL)hidden
{
	for (UIView *view  in self.tabBarController.view.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"HRTabBar"]) {
			view.hidden = hidden;
		}
	}
}
#pragma mark - UI点击
- (IBAction)emailBtnClick:(UIButton *)sender {
	[UIView animateWithDuration:0.5 animations:^{
		self.titleLabel.text = @"公司网址";
		self.containtLabel.text = @"http://www.gzhuarui.cn";
		self.labelViewBottom.constant = 0;
	} completion:^(BOOL finished) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.5 animations:^{
				self.labelViewBottom.constant = - 50;
			}];
		});
	}];
}
- (IBAction)phoneBtnClick:(UIButton *)sender {
	
	[UIView animateWithDuration:0.5 animations:^{
		self.titleLabel.text = @"联系我们";
		self.containtLabel.text = @"TEL:020-39026922";
		self.labelViewBottom.constant = 0;
	} completion:^(BOOL finished) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.5 animations:^{
				self.labelViewBottom.constant = - 50;
			}];
		});
	}];
}

#pragma mark -数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
  switch (indexPath.row) {
  case 0:
		{
			
			HerolifeLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:labelCellID];
			cell = labelCell;
			cell.textLabel.text = @"\t\t\t\t\t\t\t\t广州华睿电子科技有限公司是从事物联网云数据、智能家居、智慧城市方案解决、集成、应用、服务于一体的高科技股份制企业。\n\t\t\t\t\t\t\t\t下设工业电源、舞台灯光音响、LED照明及电子制造四大产业链子公司。\n\n\t\t\t\t\t\t\t\t公司总部位于广州番禺节能科技园总部1号楼。\n\t\t\t\t\t\t\t\t华睿科技拥有一支专业、年轻的、富有创新精神的管理、研发、营销团队。\n\t\t\t\t\t\t\t\t为人们提供丰富的智能终端以及革命性的交互平台和应用，给世界带来高效、绿色、创新的智能化应用和体验。\n\n\t\t\t\t\t\t\t\t同时，华睿科技携手浙江大学合作研发新一代智慧生活平台，并致力于与合作伙伴共同成长，从而实现共赢目标。\n\t\t\t\t\t\t\t\t实现个人价值、公司价值、社会价值的高度统一！实现安居乐业中国梦!";
		}
			break;
  case 1:
		{
			
			HerolifeImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
			cell = imageCell;

		}
			break;
  case 2:
		{
			HerolifeLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:labelCellID];
			cell = labelCell;
			cell.textLabel.text = @"\t\t\t\t\t\t\t\t伴随科技的发展，华睿品牌营运而生，为人们提供舒适、健康的智慧生活，是我们一贯坚持的追求。\n\t\t\t\t\t\t\t\t在高效务实的应用最新科技的基础上，研发出华睿云智能家居系统，如今已广泛应用于个人家庭、精装公寓、豪宅别墅、高级会所、商业空间、星级酒灯众多领域。\n\n\t\t\t\t\t\t\t\t我们奉行“化繁为简、睿智付出、科技创新、互信共赢、智慧生活”的核心价值观，不断开拓进取，竭诚为您提供高效、稳定、完全可靠的住能家居产品，高质量的工程工艺设计及无微不至的售后服务。\n\n";
		}
			break;
			
			
  default:
			break;
	}
	
	return cell;
	
}

// 只要滚动tableView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	// 获取当前偏移量
	CGFloat offsetY = scrollView.contentOffset.y;
	
	// 计算下tableView相对于最原始的时候滚动多少
	CGFloat delta = offsetY - _oriOffsetY;
	
	// 视觉差
	CGFloat h = XMGHeadH - delta;

	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[NSFontAttributeName] = [UIFont systemFontOfSize:25];
	CGSize size = [self.logLabel.text sizeWithAttributes:dict];
	
	CGFloat logX = 200 - h +10;
	if (h < XMGHeadMinH) {
		[UIView animateWithDuration:0.25 animations:^{
			self.backBtn.alpha = 0.0;
		}];
	}else
	{
		[UIView animateWithDuration:0.25 animations:^{
			self.backBtn.alpha = 1.0;
		}];
	}
	
	if (logX > UIScreenW * 0.5 - size.width*0.5) {
		logX = UIScreenW * 0.5 - size.width*0.5;
	}
	
	
	int labelFont = 25 - delta /10;
	if (labelFont < 18) {
		labelFont = 18;
	}else if (labelFont > 25) {
		labelFont = 25;
	}
	
	self.logLabel.font = [UIFont systemFontOfSize: labelFont ];
	
	_logLabelX.constant = logX ;
	
	_imageH.constant = h;
	
}

@end
