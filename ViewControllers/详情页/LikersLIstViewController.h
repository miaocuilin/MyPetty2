//
//  LikersLIstViewController.h
//  MyPetty
//
//  Created by Aidi on 14-6-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikersLIstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tv;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,copy)NSString * usr_ids;
@end
