//
//  PopularityListViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface PopularityListViewController : UIViewController <NIDropDownDelegate,UITableViewDataSource,UITableViewDelegate
>
{
    UIImageView * bgImageView;
    UIView * navView;
    UIView * headerView;
    UIButton * raceBtn;
    UIButton * titleBtn;
    UIButton * findMeBtn;
    UIButton * arrow;
    BOOL isRaceShow;
    
    NIDropDown *dropDown;
    NIDropDown *dropDown2;
    
    UITableView * tv;
    UITableView * tv2;
    
    int myCurrentCountNum;
    int count;
    
}
@property (nonatomic,retain)NSMutableArray * catArray;
@property (nonatomic,retain)NSMutableArray * dogArray;
@property (nonatomic,retain)NSMutableArray * otherArray;
@property (nonatomic,retain)NSMutableArray * totalArray;

@property (nonatomic,retain)NSMutableArray * titleArray;

@property (nonatomic,retain)NSMutableArray * myCountryRankArray;
@property (nonatomic,retain)NSMutableArray * rankDataArray;
@property (nonatomic,retain)NSMutableArray * limitRankDataArray;

@property (nonatomic,retain)NSMutableArray * aidsArray;
//记录我的国家在排行榜中的排名，只存储排名
@property (nonatomic,retain)NSMutableArray * myCountryArray;
@end
