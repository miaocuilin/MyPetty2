//
//  FoodCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BegFoodListModel.h"
@interface FoodCell : UITableViewCell
{
    UIView * whiteView;
    UILabel * leftTime;
    UIImageView * bigImageView;
    NSTimer * timer;
    
    UILabel * desLabel;
    UIView * line;
    UILabel * foodNum;
}
@property(nonatomic,copy)NSString * timeStamp;
@property(nonatomic)CGSize cellSize;

-(void)modifyUI:(BegFoodListModel *)model;
@end
