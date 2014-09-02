//
//  ActivityDetailViewController.h
//  MyPetty
//
//  Created by Aidi on 14-6-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"

@interface ActivityDetailViewController : UIViewController
{
    UIScrollView * sv;
    BOOL isCamara;
//    UITableView * tv;
    UIView * navView;
    UIImageView * bgImageView;
}
@property(nonatomic,retain)NSMutableString * txs;
@property(nonatomic,retain)TopicListModel * listModel;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * userDataArray;

@property(nonatomic,retain)UIImage * tempImage;
@end
