//
//  PlanetAttentionCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PlanetAttentionCell.h"

@implementation PlanetAttentionCell

- (void)awakeFromNib
{
    // Initialization code
    [self modifyUI];
}
-(void)modifyUI
{
    self.nameLabel.textColor = BGCOLOR;
    self.cateNameLabel.textColor = [UIColor grayColor];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.bigImageBtn setBackgroundImage:[UIImage imageNamed:@"20-1.png"] forState:UIControlStateNormal];
}
-(void)configUI:(PhotoModel *)model
{
    self.nameLabel.text = model.name;
//    self.cateNameLabel.text = [ControllerManager returnCateNameWithType:model.type];
    self.timeLabel.text = [MyControl timeFromTimeStamp:model.create_time];
    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 60) lineBreakMode:1];
    CGRect rect = self.commentLabel.frame;
    rect.size = size;
    self.commentLabel.frame = rect;
    
}
- (IBAction)bigImageBtnClick:(UIButton *)sender {
    //跳转照片详情页
    NSLog(@"跳转照片详情页");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImage release];
    [_nameLabel release];
    [_cateNameLabel release];
    [_timeLabel release];
    [_bigImageBtn release];
    [_commentLabel release];
    [super dealloc];
}
@end
