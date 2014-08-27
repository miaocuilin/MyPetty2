//
//  PetInfoViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView * sv;
    UITableView * tv;
    UITableView * tv2;
    UITableView * tv3;
    UITableView * tv4;
    UITableView * tempTv;
    UIView * navView;
    UIView * toolBgView;
    UIView * bottom;
    UIView * bgView;
    BOOL isCreated[3];
    UIImageView * bgImageView1;
    BOOL isPhotoDownload;
}
@property (nonatomic,copy)NSString * lastImg_id;
@property (nonatomic,retain)NSMutableArray * photosDataArray;
@property (nonatomic,retain)NSMutableArray * userDataArray;
@end
