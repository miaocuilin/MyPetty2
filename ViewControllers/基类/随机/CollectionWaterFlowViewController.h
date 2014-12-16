//
//  CollectionWaterFlowViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/14.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PSCollectionViewCell.h"
@interface CollectionWaterFlowViewController : UIViewController<PSCollectionViewDataSource,PSCollectionViewDelegate,UIScrollViewDelegate>
{
    PSCollectionView * collection;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
