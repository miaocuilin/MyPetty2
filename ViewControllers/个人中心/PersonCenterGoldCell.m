//
//  PersonCenterGoldCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/2.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "PersonCenterGoldCell.h"

@interface PersonCenterGoldCell ()
@property (retain, nonatomic) IBOutlet UIImageView *missionImage;
@property (retain, nonatomic) IBOutlet UILabel *missionDetail;
@property (retain, nonatomic) IBOutlet UILabel *missionReward;
@property (retain, nonatomic) IBOutlet UILabel *missionUnComplete;
@property (retain, nonatomic) IBOutlet UIButton *missionComplete;
@property (retain, nonatomic) IBOutlet UIImageView *rewardGetted;




@end
@implementation PersonCenterGoldCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *view = [MyControl createViewWithFrame:CGRectMake(0, 49, WIDTH, 1)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.contentView addSubview:view];
}

- (IBAction)getRewardClick:(UIButton *)sender {
    
}


- (void)dealloc {
    [_missionImage release];
    [_missionDetail release];
    [_missionReward release];
    [_missionUnComplete release];
    [_missionComplete release];
    [_missionUnComplete release];
    [_missionComplete release];
    [_rewardGetted release];
    [super dealloc];
}
@end
