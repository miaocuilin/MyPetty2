//
//  WaterFlowCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/10/31.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface WaterFlowCell : UITableViewCell
{
    UIImageView * bgView;
    UIButton * bigImageBtn;
    UILabel * desLabel;
}
@property(nonatomic,copy)void (^jumpToPicDetail)(void);
-(void)adjustOriginalXWithIsLeft:(BOOL)isLeft;
-(void)configUI:(PhotoModel *)model isLeft:(BOOL)isLeft;
@end
