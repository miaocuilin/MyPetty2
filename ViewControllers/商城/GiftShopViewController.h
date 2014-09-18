//
//  GiftShopViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface GiftShopViewController : UIViewController <NIDropDownDelegate>
{
    UIView * navView;
    NIDropDown *dropDown;
    NIDropDown *dropDown2;
    UIView * headerView;
    
    UIButton * cateBtn;
    UIButton * orderBtn;
    
    BOOL isCateShow;
    BOOL isOrderShow;
    
    UIScrollView * sv;
    UIScrollView * sv2;
    
    UIButton * alphaBtn;
    UIButton * backBtn;
    UILabel * BottomGold;
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,retain)NSMutableArray * cateArray;
@property(nonatomic,retain)NSMutableArray * cateArray2;
@property(nonatomic,retain)NSMutableArray * orderArray;
@end
