//
//  PlanetAttentionCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
@interface PlanetAttentionCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *cateNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIButton *bigImageBtn;
@property (retain, nonatomic) IBOutlet UILabel *commentLabel;

-(void)configUI:(PhotoModel *)model;
@end
