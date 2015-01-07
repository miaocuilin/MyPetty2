//
//  RecommendViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "PhotoModel.h"
#import "MJRefresh.h"

@interface RecommendViewController : UIViewController <TMQuiltViewDataSource,TMQuiltViewDelegate>
{
    TMQuiltView *qtmquitView;
    float Height[1000];
//    BOOL didLoad[1000];
}

@property(nonatomic,retain)NSMutableArray * dataArray;

@property(nonatomic,copy)NSString * lastImg_id;

//-(void)headerRefresh;
@end
