//
//  RandomaViewController.h
//  MyPetty
//
//  Created by apple on 14/6/27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

//#import "RootViewController.h"
//#import "BottomMenuRootViewController.h"
#import <UIKit/UIKit.h>
@interface RandomViewController : UIViewController
{
    UIView * navView;
    BOOL isMenuBgViewAppear;
    float Height[2000];
//    BOOL didLoad[1000];
//    BOOL isLike[300];
//    int limitedCount;
    MBProgressHUD *HUD;
    
    NSOperationQueue * queue;
    
    int threadCount;
    int page;
    
    BOOL isLoaded;
}
@property(nonatomic,copy)NSString * tempUrl;

@property(nonatomic,retain)UIButton * menuBtn;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * likersArray;
@property(nonatomic,copy)NSString * lastImg_id;

//@property(nonatomic,retain)NSMutableDictionary * heightDict;

@property(nonatomic,copy)void (^reloadRandom)(void);

-(void)headerRefresh;
@end
