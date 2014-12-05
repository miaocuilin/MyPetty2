//
//  CenterViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterViewController : UIViewController
{
    UIView * navView;
    UIScrollView * sv;
    
    UIButton * headBtn;
    UILabel * name;
    UIImageView * sex;
    UILabel * location;
    
    UIImageView * msgNumBg;
    UILabel * msgNum;
    UILabel * goldNum;
    
    BOOL isLoaded;
}
/*************************************/
//@property(nonatomic,retain) UIImageView * msgNum;
//@property(nonatomic,retain) UILabel * numLabel;
@property(nonatomic,retain)NSMutableArray * talkIDArray;
@property(nonatomic,retain)NSMutableArray * nwDataArray;
@property(nonatomic,retain)NSMutableArray * nwMsgDataArray;
@property(nonatomic)BOOL hasNewMsg;
@property(nonatomic,retain)NSMutableArray * keysArray;
@property(nonatomic,retain)NSMutableArray * valuesArray;
@end
