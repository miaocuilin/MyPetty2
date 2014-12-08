//
//  PublishToViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishToViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tv;
    
}
@property (nonatomic,copy)NSString * aid;
@property (nonatomic)int index;
@property (nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSMutableArray * selectArray;
@property (nonatomic,retain)NSMutableArray * selectNameArray;

@property(nonatomic,copy)void (^selectedArray)(NSArray *,NSArray *);
@end
