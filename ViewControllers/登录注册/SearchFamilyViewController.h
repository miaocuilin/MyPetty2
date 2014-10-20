//
//  SearchFamilyViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GREEN [UIColor colorWithRed:147/255.0 green:203/255.0 blue:172/255.0 alpha:1]
@interface SearchFamilyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIImageView * bgImageView;
    UIView * navView;
    UITableView * tv;
    UITextField * tf;
    UIButton * cancelBtn;
    
    int didSelected;
}
@property(nonatomic,retain)NSString * tfString;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * tempDataArray;

@property(nonatomic,retain)NSMutableDictionary * detailDict;
@property(nonatomic,retain)NSDictionary * cardDict;

@property(nonatomic,retain)NSMutableArray * userPetsListArray;
@end
