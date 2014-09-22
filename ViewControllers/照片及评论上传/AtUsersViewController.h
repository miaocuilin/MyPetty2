//
//  AtUsersViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtUsersViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView * navView;
    UITableView * tv;
    UITextField * tf;
    UIView * headerView;
}
@property (nonatomic,retain)UIImageView * bgImageView;
@property (nonatomic,retain)NSMutableArray * selectArray;

@property (nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSMutableArray * dataArrayTemp;
@property (nonatomic,retain)NSMutableString * userIdsString;
@property (nonatomic,copy)NSString * selectName;

@property (nonatomic,copy)void (^sendNameAndIds)(NSString *,NSString *);
@end
