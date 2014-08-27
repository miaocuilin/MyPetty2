//
//  MassWatchCell.m
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MassWatchCell.h"

@implementation MassWatchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.selected
//        self.contentView.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    UIView *cellBody = [[UIView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:cellBody];
    [cellBody release];
    self.headButton = [MyControl createButtonWithFrame:CGRectMake(15, 12, 50, 50) ImageName:@"cat1.jpg" Target:self Action:@selector(otherHome:) Title:nil];
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 25;
    [cellBody addSubview:self.headButton];
    
    
    UIView *giftBG = [[UIView alloc] initWithFrame:CGRectMake(50, 35, 22, 22)];
    giftBG.layer.cornerRadius = 11;
    giftBG.layer.masksToBounds = YES;
    giftBG.backgroundColor = BGCOLOR2;
    [cellBody addSubview:giftBG];
    [giftBG release];
    self.giftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bcat6_2.png"]];
    self.giftView.frame = CGRectMake(2, 2, 18, 18);
    [giftBG addSubview:self.giftView];
    [self.giftView release];
    
    self.sexView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 20, 14, 17)];
    self.sexView.image = [UIImage imageNamed:@"man.png"];
    [cellBody addSubview:self.sexView];
    
    self.watcherName = [MyControl createLabelWithFrame:CGRectMake(103, 15, 100, 30) Font:16 Text:@"羊驼"];
    self.watcherName.textColor = BGCOLOR;
    [cellBody addSubview:self.watcherName];
    
    self.ProvinceAndCity = [MyControl createLabelWithFrame:CGRectMake(80, 45, 120, 20) Font:14 Text:[NSString stringWithFormat:@"%@ | %@",@"北京市",@"朝阳区"]];
    self.ProvinceAndCity.textColor = [UIColor blackColor];
    [cellBody addSubview:self.ProvinceAndCity];
    
    UIView *mailView = [MyControl createViewWithFrame:CGRectMake(250, 23, 50, 30)];
    mailView.backgroundColor = [UIColor colorWithRed:147/255.0 green:204/255.0 blue:172/255.0 alpha:1];
    mailView.layer.cornerRadius = 5;
    mailView.layer.masksToBounds = YES;
    [cellBody addSubview:mailView];
    
    UIImageView * mail = [MyControl createImageViewWithFrame:CGRectMake(10, 5, 30, 20) ImageName:@"mail.png"];
    [mailView addSubview:mail];
    
    talkButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 50, 30) ImageName:@"" Target:self Action:@selector(TalkAction:) Title:nil];
    [mailView addSubview:talkButton];

}

- (void)otherHome:(UIButton *)sender
{
    NSLog(@"跳转到其他人的主页");
}

- (void)TalkAction:(UIButton *)sender
{
    NSLog(@"跳转到聊天");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)dealloc
{
    [super dealloc];
}

@end
