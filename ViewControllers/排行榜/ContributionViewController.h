//
//  ContributionViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface ContributionViewController : UIViewController <NIDropDownDelegate,UITableViewDataSource,UITableViewDelegate
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
    
    NIDropDown *dropDown2;
    
    UITableView * tv;
//    UITableView * tv2;
    
//    int myCurrentCountNum;
//    int count;
    //记录我的名次，从1开始
    int myRanking;
    //用来记录是否展示过我的名次
    
    //当我注册完之后回来点找我的时候重新loadData
    int showMyRank;
}
@property (nonatomic,copy)NSString * aid;

@property (nonatomic)int category;
@property (nonatomic,retain)NSMutableArray * titleArray;

//@property (nonatomic,retain)NSMutableArray * myCountryRankArray;
@property (nonatomic,retain)NSMutableArray * contributionDataArray;

//@property (nonatomic,retain)NSMutableArray * userPetListArray;
//@property (nonatomic,retain)NSMutableArray * usr_idsArray;
//@property (nonatomic,retain)NSMutableArray * myCountryArray;
@end
