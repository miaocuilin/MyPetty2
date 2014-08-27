//
//  AttentionCell.h
//  MyPetty
//
//  Created by Aidi on 14-5-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface AttentionCell : UITableViewCell <UIAlertViewDelegate>
{
    UIImageView * headImageView;
    UIImageView * sexImageView;
    UILabel * nameLabel;
    UILabel * cateAndNameLabel;
    UIButton * attentionButton;
    BOOL isAttention;
//    BOOL sex;
}
//@property(nonatomic,copy)NSString * usr_id;
-(void)configUI:(InfoModel *)model;
@end
