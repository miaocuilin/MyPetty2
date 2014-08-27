//
//  FavoriteCell.h
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "InfoModel.h"
@interface FavoriteCell : UITableViewCell
{
    UIImageView * headImageView;
    UILabel * titleLabel;
    UILabel * detailLabel;
    UILabel * timeLabel;
//    UIImageView * bigImageView;
    UILabel * numLabel;
    UIImageView * heart;
    UILabel * desLabel;
    BOOL isLike;
    UIButton * heartButton;
}
@property(nonatomic,retain)UIImageView * bigImageView;
@property(nonatomic,retain)NSArray * likersArray;
@property(nonatomic,copy)NSString * img_id;

-(void)configUI:(PhotoModel *)model;
-(void)configUsrInfo:(InfoModel *)model;
@end
