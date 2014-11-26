//
//  UserInfoViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryInfoCell.h"
#import "ClickImage.h"
//@class PetInfoViewController;

@interface UserInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CountryInfoCellDelegate>
{
    UILabel * titleLabel;
    
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
    
    int cellNum;
    
    BOOL isMoreCreated;
    UIView * moreView;
    
    UIButton * menuBgBtn;
    
    BOOL isOwner;
    
    ClickImage * headerImageView;
    UIButton * headBtn;
    
    BOOL isLoaded;
    
    //判断修改头像时是否是点击的头像进行的修改，来决定
    //是否要cancelClick
    BOOL isFromHeader;
    
    int Index;
    int Contri;
}

@property(nonatomic)int offset;
@property(nonatomic)BOOL isFromPetInfo;

//是否是通过侧边栏进入我自己的主页
@property(nonatomic)BOOL isFromSideMenu;

@property(nonatomic,retain)UIImage * petHeadImage;
@property(nonatomic,copy)NSString * usr_id;

@property(nonatomic,retain)NSMutableArray * userPetListArray;
@property(nonatomic,retain)NSMutableArray * userAttentionListArray;
@property(nonatomic,retain)NSMutableArray * userActivityListArray;
//
@property(nonatomic,retain)NSMutableArray * goodsArray;
@property(nonatomic,retain)NSMutableArray * goodsNumArray;
@end
