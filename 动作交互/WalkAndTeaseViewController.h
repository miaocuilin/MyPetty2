//
//  WalkAndTeaseViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkAndTeaseViewController : UIViewController
{
    UIView * navView;
    UIButton * menuBgBtn;
    UIView * moreView;
    BOOL isMoreCreated;
}
@property(nonatomic,retain)NSString * URL;
@property (nonatomic,strong)NSString *titleString;

@property(nonatomic,copy)NSString * aid;

@property(nonatomic)BOOL isFromBanner;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * share_title;
@property(nonatomic,copy)NSString * share_des;
@end
