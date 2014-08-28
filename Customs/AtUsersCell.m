//
//  AtUsersCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AtUsersCell.h"

@implementation AtUsersCell

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
    head = [MyControl createImageViewWithFrame:CGRectMake(15, 6, 32, 32) ImageName:@""];
    head.layer.cornerRadius = head.frame.size.width/2;
    head.layer.masksToBounds = YES;
    [self.contentView addSubview:head];
    
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(57, 12, 150, 20) Font:14 Text:nil];
    nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameLabel];
    
    btn = [MyControl createButtonWithFrame:CGRectMake(320-40, 12, 20, 20) ImageName:@"atUsers_unSelected.png" Target:self Action:@selector(btnClick:) Title:nil];
    [btn setBackgroundImage:[UIImage imageNamed:@"atUsers_selected.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:btn];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 43, 320, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
}
-(void)modifyWith:(NSString *)name row:(int)row selected:(BOOL)isSelected
{
    head.image = [UIImage imageNamed:@"cat1.jpg"];
    nameLabel.text = name;
    btn.tag = 100+row;
    if (isSelected) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
}
-(void)btnClick:(UIButton *)button
{
    button.selected = !button.selected;
//    NSLog(@"点击了第%d个", btn.tag-100);
    if (button.selected) {
        self.click(btn.tag-100, YES);
    }else{
        self.click(btn.tag-100, NO);
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
