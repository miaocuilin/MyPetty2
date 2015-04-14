//
//  PersonCenterStarCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/2.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "PersonCenterStarCell.h"

@interface PersonCenterStarCell ()

@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *rankImage;


@end

@implementation PersonCenterStarCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.text = @"来钱儿啊来钱儿";
    
    UIView *view = [MyControl createViewWithFrame:CGRectMake(0, 49, WIDTH, 1)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.contentView addSubview:view];
}

-(void)modifyUI:(UserPetListModel *)model
{
    self.nameLabel.text = model.name;
    [MyControl setImageForImageView:self.headImage Tx:model.tx isPet:YES isRound:YES];
    self.rankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"title_%d.png", [model.rank intValue]+1]];
}

- (void)dealloc {
    [_headImage release];
    [_nameLabel release];
    [_rankImage release];
    [super dealloc];
}
@end
