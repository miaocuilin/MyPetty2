//
//  PetMain_Food_ViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetMain_Food_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UITableView * tv;
}
@property(nonatomic,retain)PetInfoModel * model;
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
