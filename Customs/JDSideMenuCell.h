//
//  JDSideMenuCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-10-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@interface JDSideMenuCell : UITableViewCell
{
    UIImageView * headImageView;
    UILabel * nameLabel;
}

-(void)configUI:(SearchResultModel *)model;
@end
