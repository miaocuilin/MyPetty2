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
@end
