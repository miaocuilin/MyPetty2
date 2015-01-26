//
//  MsgViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRefreshView.h"

@interface MsgViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UIView * navView;
}
@property (strong, nonatomic) NSMutableArray * dataSource;
@property (nonatomic, strong) SRRefreshView * slimeView;
@property (strong, nonatomic) UITableView * tableView;
@end
