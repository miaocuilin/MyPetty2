//
//  BackImageDetailViewCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface BackImageDetailViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UILabel * name;
}

-(void)configUI:(UserInfoModel *)model;
@end
