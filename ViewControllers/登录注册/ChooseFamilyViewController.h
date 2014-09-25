//
//  ChooseFamilyViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPopupView.h"
#import "NIDropDown.h"
@interface ChooseFamilyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate>
{
    UIView * navView;
    UITableView * tv;
    UIView  * insertView;
    AFPopupView * afView;
    int didSelected;
    
    NIDropDown *dropDown;
    NIDropDown *dropDown2;
    UIButton * raceBtn;
    UIButton * systemBtn;
    UIView * headerView;
    
    BOOL isRaceShow;
    BOOL isSystemShow;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * limitDataArray;

@property (nonatomic,retain)NSMutableArray * catArray;
@property (nonatomic,retain)NSMutableArray * dogArray;
@property (nonatomic,retain)NSMutableArray * otherArray;
@property (nonatomic,retain)NSMutableArray * totalArray;
@property (nonatomic,retain)NSMutableArray * systemListArray;

@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,copy)NSString * limitTypeName;

@property(nonatomic,retain)NSMutableDictionary * detailDict;
@property(nonatomic,retain)NSDictionary * cardDict;

@property(nonatomic)BOOL isMi;
@end
