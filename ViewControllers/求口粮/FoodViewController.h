//
//  FoodViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/2.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UIButton * petHeadBtn;
    UIImageView * sex;
    UILabel * petName;
    UILabel * petType;
    UILabel * userName;
    UIImageView * userHeadImage;
    UIButton * jumpUserBtn;
    
    UIImageView * rewardBg;
    
    UILabel * rewardNum;
    UIView * selectView;
    UILabel * leftTime;
    
    NSTimer * timer;
    
    UITableView * tv;
    
    int page;
//    BOOL isLoaded;
//    UIImageView * heart;
    UIButton * heartBtn;
    NSTimer * timer2;
    
    UILabel * addLabel;
    
    BOOL isLoading;
    BOOL addAnimationSwitch;
}
-(void)loadData;
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
