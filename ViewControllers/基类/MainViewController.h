//
//  MainViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BottomMenuRootViewController.h"
#import "NIDropDown.h"

@interface MainViewController : BottomMenuRootViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,NIDropDownDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton * camara;
    UIView * navView;
    UIScrollView * sv;
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
}
@property(nonatomic,copy)NSString * tfString;
@property(nonatomic,retain)UIButton * alphaBtn;

@property(nonatomic,retain)UIButton * menuBtn;
@property(nonatomic,retain)UIImage * oriImage;

@property(nonatomic,retain)NSMutableArray * searchArray;
//用来记录当前头像名称，和本地存储的tx对比，如果不等则换头像，等则不换。
//@property(nonatomic,copy)NSString * currentTx;

@end
