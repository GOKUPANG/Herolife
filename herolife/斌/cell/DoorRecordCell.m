//
//  DoorRecordCell.m
//  herolife
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "DoorRecordCell.h"
#import "UIView+SDAutoLayout.h"
#import "DoorLockModel.h"

@implementation DoorRecordCell

- (void)setLockModel:(DoorLockModel *)lockModel
{
	_lockModel = lockModel;
	NSString *title = lockModel.title;
	NSRange range = [title rangeOfString:@"|"];
	
	NSString *time = [title substringToIndex:range.location];
	
	range = [title rangeOfString:@"|" options:NSBackwardsSearch];
	NSString *message = [title substringFromIndex:range.location + 1];
	
	self.timeLabel.text = lockModel.person.firstObject;
	self.recordLabel.text = time;
	self.userNameLabel.text = message ;
	
	DDLogWarn(@"timeLabel%@recordLabel%@userNameLabel%@", self.timeLabel.text, self.recordLabel.text, self.userNameLabel.text);
	
}

//重写父类方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        
    }
    
    return self;
    
}



-(void)initUI
{

    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _timeLabel = [[UILabel alloc]init];
    
    _userNameLabel = [[UILabel alloc]init];
    
    _recordLabel = [[UILabel alloc]init];
    
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_userNameLabel];
    [self.contentView addSubview:_recordLabel];
    
    //布局
    
  /** 
   时间      90
   用户名    150
   开锁记录  100
   */
    
 
    //时间
 _timeLabel.sd_layout
    .leftSpaceToView(self.contentView,15.0/375.0 *self.contentView.frame.size.width)
    .widthIs(110.0/375.0 * self.contentView.frame.size.width)
    .bottomSpaceToView(self.contentView,10.0)
    .heightIs(20.0);
    
    _timeLabel.font = [UIFont systemFontOfSize:17];
    _timeLabel.textColor = [UIColor whiteColor];
   // _timeLabel.backgroundColor = [UIColor greenColor];
    
    
    // 开锁记录
   _recordLabel.sd_layout
    .rightSpaceToView(self.contentView,15.0)
    .bottomEqualToView(_timeLabel)
    .heightIs(20.0)
    .widthIs(120.0/375.0 * self.contentView.frame.size.width + 40);
    
   // NSLog(@"%f",120.0/375.0 *self.contentView.frame.size.width);
    
    
    _recordLabel.font = [UIFont systemFontOfSize:17];
    _recordLabel.textColor = [UIColor whiteColor];
    
    _recordLabel.textAlignment = NSTextAlignmentRight;
    
  //  _recordLabel.backgroundColor = [UIColor greenColor];
    
    //用户名
    _userNameLabel.sd_layout
    .topEqualToView(_timeLabel)
    .bottomEqualToView(_timeLabel)
    .leftSpaceToView(_timeLabel,0)
    .rightSpaceToView(_recordLabel,0);
    
    _userNameLabel.font = [UIFont systemFontOfSize:17];
    _userNameLabel.textColor = [UIColor whiteColor];
    
    _userNameLabel.textAlignment = NSTextAlignmentCenter;

    
    //_userNameLabel.backgroundColor = [UIColor blueColor];
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
