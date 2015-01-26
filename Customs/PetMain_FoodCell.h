//
//  PetMain_FoodCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BegFoodListModel.h"

@interface PetMain_FoodCell : UITableViewCell
{
    UIImageView * headImage;
    UILabel * desLabel;
    UILabel * foodNum;
    UILabel * timeLabel;
    UIView * rewardBg;
    UILabel * rewardNum;
    UIView * selectView;
    UIButton * heartBtn;
    NSTimer * timer;
    UIView * line;
}
//@property(nonatomic,copy)NSString * petName;
@property(nonatomic,copy)NSString * img_id;
@property(nonatomic,copy)void (^rewardClick)(UILabel *);

-(void)configUI:(BegFoodListModel *)model;
-(void)reward;
@end
