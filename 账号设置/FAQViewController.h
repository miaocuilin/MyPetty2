//
//  FAQViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UIImageView * bgImageView;
    UITableView * tv;
    UITableView * tv2;
    
    BOOL isSecond;
    int rowNum;
}
@property(nonatomic,copy)NSString * str;
@property(nonatomic,retain)NSArray * array;
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
