//
//  AtUsersCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "InfoModel.h"
#import "SingleTalkModel.h"
@interface AtUsersCell : UITableViewCell
{
    UIImageView * head;
    UILabel * nameLabel;
    UIButton * btn;
}
-(void)modifyWith:(SingleTalkModel *)model row:(int)row selected:(BOOL)isSelected;
@property(nonatomic,copy)void(^click)(int, BOOL);
@end
