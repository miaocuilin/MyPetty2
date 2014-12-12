//
//  ExchangeViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "UserPetListModel.h"

@interface ExchangeViewController : UIViewController<NIDropDownDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView * navView;
    UIButton * exBtn;
    UIView * bottomBg;
    UIImageView * bottomImage;
    UIButton * upButton;
    UIButton * headBtn;
    NIDropDown * dropDown;
    
    UIScrollView * sv;
    
    UICollectionView * collection;
    
    UIButton * leftArrowBtn;
    UIButton * rightArrowBtn;
    UILabel * foodNum;
    
    int index;
}

@property(nonatomic,retain)NSArray * itemsArray;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * userPetListArray;
@property(nonatomic,retain)UserPetListModel * tempModel;
@property(nonatomic,copy)NSString * tempAid;
@end
