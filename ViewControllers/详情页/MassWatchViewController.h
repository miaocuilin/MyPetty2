//
//  MassWatchViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class ANBlurredImageView;
@interface MassWatchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UITableView * tv;
    
}
@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)NSArray * txTypesArray;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,copy)NSString * usr_ids;
@property(nonatomic)BOOL isMi;
@end
