//
//  PetRecommendViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetRecommendViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * bgImageView;
//    UITableView * tv;
    BOOL isLoaded;
}
@property(nonatomic,retain)UITableView * tv;
@property(nonatomic,retain)NSMutableArray * dataArray;

@property(nonatomic,retain)NSMutableArray * myCountryArray;
@end
