//
//  SearchFamilyViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFamilyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView * navView;
    UITableView * tv;
    UITextField * tf;
    UIButton * cancelBtn;

}
@property(nonatomic,retain)NSString * tfString;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * tempDataArray;
@end
