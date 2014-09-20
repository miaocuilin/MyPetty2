//
//  ActivityDetailViewController.h
//  MyPetty
//
//  Created by Aidi on 14-6-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"
@class PSCollectionView;
@interface ActivityDetailViewController : UIViewController
{
    UIScrollView * sv;
    PSCollectionView *cv;
    PSCollectionView *cv2;
    BOOL isCamara;
//    UITableView * tv;
    UIView * navView;
    UIImageView * bgImageView;
    float Height[1000];
    
    UIButton * newButton;
    UIButton * hotButton;
    
    //最新最热是否停靠
    BOOL isBerth;
    
    //是否当前是最热
    BOOL isHotest;
    
    //活动是否结束
    BOOL isEnd;
    
    UIView * lastLine;
}
@property(nonatomic,retain)NSMutableString * txs;
@property(nonatomic,retain)TopicListModel * listModel;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * userDataArray;

@property(nonatomic,retain)UIImage * tempImage;
@property(nonatomic,copy)NSString *lastImg_id;
@property(nonatomic,retain)NSMutableArray * randomDataArray;
@property(nonatomic,retain)NSMutableArray * newDataArray;
@property(nonatomic,retain)NSMutableArray * hotDataArray;
@property(nonatomic,retain)NSMutableArray * rankDataArray;
@end
