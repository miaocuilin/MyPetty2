//
//  PetMain_Fans_ViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetInfoModel.h"

@interface PetMain_Fans_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UITableView * tv;
}

@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)PetInfoModel * model;

@property(nonatomic,copy)NSString * lastUsr_id;
@property(nonatomic,copy)NSString * lastRank;
@end
