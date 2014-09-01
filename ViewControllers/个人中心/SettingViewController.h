//
//  SettingViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UITableView * tv;
    UISwitch * sinaBind;
    UISwitch * sina;
    UISwitch * weChat;
    float fileSize;
    UILabel * cacheLabel;
    
    UIButton * alphaBtn;
    UIButton * backBtn;
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,retain)NSArray * arr1;
@property(nonatomic,retain)NSArray * arr2;
@property(nonatomic,retain)NSArray * arr3;

@end
