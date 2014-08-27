//
//  UserInfoActivityCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoActivityCell : UITableViewCell
{
    UILabel * activityLabel;
    UIButton * activityBtn;
}

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIButton *imageBtn;
-(void)modifyWithString:(NSString *)str;
@end
