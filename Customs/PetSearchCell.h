//
//  PetSearchCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"
#import "UserInfoModel.h"
@interface PetSearchCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UIImageView *sex;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *cateAndAgeLabel;

-(void)configUI:(SearchResultModel *)model;
-(void)configUI2:(UserInfoModel *)model;
@end
