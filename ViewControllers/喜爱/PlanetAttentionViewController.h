//
//  PlanetAttentionViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanetAttentionViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * bgImageView;
    UITableView * tv;

}
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
