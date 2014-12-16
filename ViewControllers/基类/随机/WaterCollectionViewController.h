//
//  WaterCollectionViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/14.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowLayout.h"
@interface WaterCollectionViewController : UICollectionViewController <UICollectionViewDelegate,UICollectionViewDataSourceWaterFlowLayout,UICollectionViewDataSource,UICollecitonViewDelegateWaterFlowLayout>

//@property(nonatomic,retain)NSMutableArray * images;
@property(nonatomic,retain)NSMutableArray * dataArray;
@end
