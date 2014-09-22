//
//  TopicViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView * navView;
    UITableView * tv;
    UITextField * tf;
    UIView * headerView;
}
@property (nonatomic,retain)UIImageView * bgImageView;

@property (nonatomic,retain)NSMutableArray * topicNameArray;
@property (nonatomic,retain)NSMutableArray * topicIdArray;
@end
