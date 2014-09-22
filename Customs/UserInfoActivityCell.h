//
//  UserInfoActivityCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserActivityListModel.h"
@interface UserInfoActivityCell : UITableViewCell
{
    UILabel * activityLabel;
    UIButton * activityBtn;
}

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIButton *imageBtn;
@property (nonatomic, copy)NSString * img_id;

@property (nonatomic,copy)void (^jumpToDetail)(NSString *);
//-(void)modifyWithString:(NSString *)str;

-(void)configUI:(UserActivityListModel *)model;
@end
