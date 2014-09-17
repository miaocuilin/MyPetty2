//
//  PetInfoViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BottomMenuRootViewController.h"
#import "ClickImage.h"
@interface PetInfoViewController : BottomMenuRootViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
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
    BOOL isCreated[4];
    UIImageView * bgImageView1;
    BOOL isPhotoDownload;
    
    BOOL isMoreCreated;
    UIView * moreView;
    UIButton * alphaBtn;
    MBProgressHUD *alertView;

    ClickImage * headerImageView;
}
@property (nonatomic,copy)NSString * lastImg_id;
@property (nonatomic,copy)NSString * lastUsr_id;
@property (nonatomic,copy)NSString * lastRank;

@property (nonatomic,retain)NSMutableArray * newsDataArray;
@property (nonatomic,retain)NSMutableArray * photosDataArray;
//@property (nonatomic,retain)NSMutableArray * userDataArray;
@property (nonatomic,retain)NSMutableArray * countryMembersDataArray;
@property (nonatomic,copy)NSString *aid;
@property (nonatomic,copy)NSString *master_id;
//@property (nonatomic,copy)NSString *usr_id;
@end
