//
//  MainViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BottomMenuRootViewController.h"
#import "NIDropDown.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,NIDropDownDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton * camara;
    UIView * navView;
//    UIScrollView * sv;
    BOOL isCreated[3];
    UISegmentedControl * sc;
    
    BOOL isCamara;
    UIActionSheet * sheet;
    
    int segmentClickIndex;
    
    NIDropDown *dropDown;
    UIView * searchBg;
    
    UITextField * tf;
    UIButton * cancel;
    
    UITableView * tv;
    UIImageView * blurImageView;
    UIButton * typeBtn;
    
    BOOL isLoaded;
    
    //判断是搜宠物还是人
    BOOL isSearchUser;
    
    int page;
}
@property(nonatomic,copy)NSString * lastAid;
@property(nonatomic,retain)UIScrollView * sv;

@property(nonatomic,copy)NSString * tfString;
@property(nonatomic,retain)UIButton * alphaBtn;

@property(nonatomic,retain)UIButton * menuBtn;
@property(nonatomic,retain)UIImage * oriImage;

@property(nonatomic,retain)NSMutableArray * searchArray;
@property(nonatomic,retain)NSMutableArray * searchUserArray;
//用来记录当前头像名称，和本地存储的tx对比，如果不等则换头像，等则不换。
//@property(nonatomic,copy)NSString * currentTx;

/*************************************/
@property(nonatomic,retain) UIImageView * msgNum;
@property(nonatomic,retain) UILabel * numLabel;
@property(nonatomic,retain)NSMutableArray * talkIDArray;
@property(nonatomic,retain)NSMutableArray * nwDataArray;
@property(nonatomic,retain)NSMutableArray * nwMsgDataArray;
@property(nonatomic)BOOL hasNewMsg;
@property(nonatomic,retain)NSMutableArray * keysArray;
@property(nonatomic,retain)NSMutableArray * valuesArray;
@end
