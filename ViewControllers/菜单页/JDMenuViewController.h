//
//  JDMenuViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@interface JDMenuViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * sv;
    UIScrollView * sv2;
    //侧边栏底层sv上的sv3，用来解决关闭sv的滑动后的屏幕适配问题
    UIScrollView * sv3;
    
    UIImageView * actGreenBall;
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
    
    UIButton * headImageBtn;
    ClickImage * headClickImage;
    
    UILabel * goldLabel;
    UILabel * position;
    UILabel * exp;
    UILabel * name;
    UIImageView * sex;
    
    UIImageView * messageNumBg;
//    BOOL hasNewMsg;
}
@property (nonatomic,copy)NSString * tfString;

@property(nonatomic,retain)UIImageView * bgImageView;
//
@property(nonatomic,retain)NSMutableArray * countryArray;
@property(nonatomic,retain)NSMutableArray * searchArray;

@property(nonatomic,retain)NSMutableArray * receivedNewMsgArray;
@property(nonatomic,retain)NSMutableArray * valueArray;
@end
