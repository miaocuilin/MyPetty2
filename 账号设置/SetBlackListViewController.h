//
//  SetBlackListViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetBlackListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * bgImageView;
    UIView * navView;
    UITableView * tv;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
