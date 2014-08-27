//
//  UserInfoRankCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoRankCell : UITableViewCell
{
    NSString * cateName;
}
@property (retain, nonatomic) IBOutlet UIButton *headBtn;
@property (retain, nonatomic) UILabel *kingName;
@property (retain, nonatomic) UIImageView *sex;
@property (retain, nonatomic) IBOutlet UILabel *cateNameAndAge;
@property (retain, nonatomic) UILabel *position;
@property (retain, nonatomic) UILabel *userName;
@property (retain, nonatomic) IBOutlet UILabel *rankNum;
@property (retain, nonatomic) IBOutlet UILabel *planet;
@property (retain, nonatomic) IBOutlet UIButton *gotoKing;
@property (retain, nonatomic) IBOutlet UIButton *gotoOwner;

-(void)modifyWithName:(NSString *)name sex:(int)sex cate:(NSString *)cate age:(NSString *)age position:(NSString *)position userName:(NSString *)userName rank:(NSString *)rank;
@end
