//
//  AttentionCell.h
//  MyPetty
//
//  Created by Aidi on 14-5-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetInfoModel.h"
@interface AttentionCell : UITableViewCell <UIAlertViewDelegate>
{
    UIButton * headImageBtn;
    UIImageView * sexImageView;
    UILabel * nameLabel;
    UILabel * cateAndNameLabel;
    UIButton * attentionButton;
    BOOL isAttention;
//    BOOL sex;
    UIButton * attentionBtn;
}
@property(nonatomic,copy)void (^jumpToPetInfo)(NSString *);
@property(nonatomic,copy)void (^cellClick)(int);

@property(nonatomic,copy)NSString * aid;
-(void)configUI:(PetInfoModel *)model;
@end
