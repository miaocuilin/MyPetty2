//
//  JDMenuViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JDMenuViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * sv;
    UIScrollView * sv2;
    
    UILabel * activityNumLabel;
    UILabel * noticeNumLabel;
    UIView * noticeBgView;
    
    int countryCount;
    
    //需要改变位置的序号
    int changeNum;
    //0代表左  1代表右
    BOOL direction;
    //选中国家的序号
    int selectedNum;
    UIImageView * crown;
    
    UITextField * tfSearch;
    UIButton * searchBtn;
    UITableView * tv;
}
@property (nonatomic,copy)NSString * tfString;

@property(nonatomic,retain)UIImageView * bgImageView;
//
@property(nonatomic,retain)NSMutableArray * countryArray;
@property(nonatomic,retain)NSMutableArray * searchArray;
@end
