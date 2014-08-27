//
//  UserInfoActivityCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserInfoActivityCell.h"

@implementation UserInfoActivityCell

- (void)awakeFromNib
{
    // Initialization code
    [self adjustUI];
}

-(void)adjustUI
{
    
    activityLabel = [MyControl createLabelWithFrame:CGRectMake(5, 10, 150, 20) Font:15 Text:nil];
    activityLabel.textColor = BGCOLOR;
    [self.contentView addSubview:activityLabel];
    
    activityBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 150, 20) ImageName:@"" Target:self Action:@selector(activityBtnClick:) Title:nil];
    [activityLabel addSubview:activityBtn];
    
    self.timeLabel.textColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString * str = [formatter stringFromDate:date];
    self.timeLabel.text = str;
    [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"cat2.jpg"] forState:UIControlStateNormal];
}
-(void)modifyWithString:(NSString *)str
{
    activityLabel.text = str;
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(150, 20) lineBreakMode:1];
    CGRect rect = activityLabel.frame;
    rect.size.width = size.width;
    activityLabel.frame = rect;
    
    activityBtn.frame = CGRectMake(0, 0, rect.size.width, 20);
}
- (void)activityBtnClick:(UIButton *)btn {
    NSLog(@"点击活动");
}

- (IBAction)imageBtnClick:(UIButton *)sender {
    NSLog(@"进入照片详情");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)dealloc {
    [_timeLabel release];
    [_imageBtn release];
    [super dealloc];
}
@end
