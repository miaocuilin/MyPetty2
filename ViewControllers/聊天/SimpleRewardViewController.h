//
//  SimpleRewardViewController.h
//  MyPetty
//
//  Created by miaocuilin on 15/1/22.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleRewardViewController : UIViewController
{
    UIButton * bgButton;
    UIImageView * rewardBg;
    
    UILabel * rewardNum;
    UIView * selectView;
    UIButton * heartBtn;
    
    UIView * whiteView;
    UILabel * leftTime;
    UIImageView * bigImageView;
    NSTimer * timer;
    UILabel * desLabel;
    UIView * line;
    UILabel * foodNum;
}

@property (nonatomic,copy)NSString * img_id;
//@property(nonatomic,retain)NSDictionary * picDict;
@property(nonatomic,retain)NSDictionary * imageDict;
@end
