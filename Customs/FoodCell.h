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

    UIButton * bigBtn;
    UIImageView * foodAnimation;
    
    UIView * addBgView;
    UIImageView * foodImage;
    UILabel * addNum;
}
@property(nonatomic,copy)NSString * timeStamp;
@property(nonatomic)CGSize cellSize;

@property(nonatomic,copy)void (^bigClick)();

-(void)modifyUI:(BegFoodListModel *)model;
-(void)addAnimation:(int)num;
@end
