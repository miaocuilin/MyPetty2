//
//  MsgViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{

}
@property (strong, nonatomic) NSMutableArray * dataSource;

@property (strong, nonatomic) UITableView * tableView;
@end
