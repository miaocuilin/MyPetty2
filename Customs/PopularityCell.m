//
//  PopularityCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PopularityCell.h"

@implementation PopularityCell

- (void)awakeFromNib
{
    // Initialization code
    [self modifyUI];
}
-(void)modifyUI
{
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
    self.headImageView.layer.masksToBounds = YES;
    
    self.rqNum.textColor = BGCOLOR;
    
    btn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 50) ImageName:@"" Target:self Action:@selector(click) Title:nil];
    [self.contentView addSubview:btn];
}
-(void)configUIWithName:(NSString *)Name rq:(NSString *)Rq rank:(int)rank upOrDown:(NSInteger)isUp shouldLarge:(BOOL)large
{
    num = rank;
    self.medal.hidden = YES;
    
    self.headImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
    self.name.text = Name;
    self.rqNum.text = Rq;
    
    if (rank == 1) {
        self.medal.hidden = NO;
        self.medal.image = [UIImage imageNamed:@"goldMedal.png"];
    }else if (rank == 2) {
        self.medal.hidden = NO;
        self.medal.image = [UIImage imageNamed:@"silverMedal.png"];
    }else if (rank == 3) {
        self.medal.hidden = NO;
        self.medal.image = [UIImage imageNamed:@"copperMedal.png"];
    }
    
    self.rank.text = [NSString stringWithFormat:@"%d", rank];
//    NSLog(@"isup:%d",isUp);
    if (isUp == 1) {
        self.upDown.image = [UIImage imageNamed:@"list_up.png"];
    }else if(isUp == -1){
        self.upDown.image = [UIImage imageNamed:@"list_down.png"];
    }else{
        self.upDown.image = [UIImage imageNamed:@"list_equal.png"];
    }
    
    if (large) {
        [UIView animateWithDuration:0.5 animations:^{
            self.headImageView.frame = CGRectMake(10, 2, 46, 46);
            self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
            self.name.frame = CGRectMake(64, 15, 130, 20);
        }];
//        self.headImageView.frame = CGRectMake(10, 2, 46, 46);
//        self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
//        self.name.frame = CGRectMake(64, 15, 130, 20);
    }else{
        self.headImageView.frame = CGRectMake(10, 9, 32, 32);
        self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
        self.name.frame = CGRectMake(50, 15, 130, 20);
    }
}
-(void)click
{
    //调用block
    self.cellClick(num);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImageView release];
    [_name release];
    [_rqNum release];
    [_medal release];
    [_upDown release];
    [_rank release];
    [super dealloc];
}
@end
