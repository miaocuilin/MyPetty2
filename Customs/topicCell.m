//
//  topicCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "topicCell.h"

@implementation topicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    topicName = [MyControl createLabelWithFrame:CGRectMake(15, 12, 100, 20) Font:15 Text:nil];
    topicName.textColor = [UIColor blackColor];
    [self.contentView addSubview:topicName];
    
    flag = [MyControl createImageViewWithFrame:CGRectMake(0, 12, 20, 20) ImageName:@"topic_activity.png"];
    [self.contentView addSubview:flag];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 43, 320, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
}
-(void)modifyWithName:(NSString *)name isActivity:(BOOL)yesOrno
{
    flag.hidden = YES;
    
    topicName.text = name;
    CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:1];
    CGRect rect = topicName.frame;
    rect.size.width = size.width;
    topicName.frame = rect;
    
    CGRect rect2 = flag.frame;
    rect2.origin.x = rect.origin.x+rect.size.width+5;
    flag.frame = rect2;
    
    if (yesOrno) {
        flag.hidden = NO;
    }
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
