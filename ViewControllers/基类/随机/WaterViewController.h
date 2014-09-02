//
//  WaterViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-2.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UIView * navView;
    BOOL isMenuBgViewAppear;
    float Height[1000];
    BOOL didLoad[1000];
    //    BOOL isLike[300];
    //    int limitedCount;
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)UIButton * menuBtn;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * likersArray;
@property(nonatomic,copy)NSString * lastImg_id;
@property (strong,nonatomic)UICollectionView *collectionView;

@end
