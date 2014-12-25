//
//  UserCardViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
#import "UserInfoModel.h"

@interface UserCardViewController : UIViewController
{
    UIView * cardBg;
    ClickImage * headImageView;
    UIButton * headBtn;
    UIView * nameBg;
    UILabel * nameLabel;
    UIImageView * sex;
    UILabel * position;
    UIView * goldBg;
    UILabel * goldLabel;
    UIButton * msgBtn;
    UIImageView * petsBg;
    UIImageView * leftArrow;
    UIImageView * rightArrow;
    UIButton * leftBtn;
    UIButton * rightBtn;
    UIScrollView * sv;
    
    BOOL isMyself;
    BOOL hasHeadImage;
}
@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,retain)UserInfoModel * userModel;
@property(nonatomic,retain)NSMutableArray * petsDataArray;

@property(nonatomic,copy)void (^close)(void);

@end
