//
//  DiscoveryViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomViewController.h"
#import "PetRecommendViewController.h"
#import "NIDropDown.h"

@interface DiscoveryViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,UITextFieldDelegate>
{
    UIView * navView;
    UISegmentedControl * sc;
    UIScrollView * sv;
    
//    UIScrollView * sv2;
    UITableView * tv;
//    UITableView * tv2;
    
    RandomViewController * vc;
    PetRecommendViewController * vc2;
    
    //榜单是否加载过
    BOOL isListLoaded;
    
    //判断是搜宠物还是人
    BOOL isSearchUser;
    
    int page;
    
    NIDropDown *dropDown;
    UIView * searchBg;
    
    UITextField * tf;
    UIButton * cancel;
    UIButton * typeBtn;
    
    BOOL isLoaded;
    UIImageView * guide;
    
    UIButton * alphaBgBtn;
}
@property(nonatomic,copy)NSString * lastAid;
@property(nonatomic,copy)NSString * tfString;
@property(nonatomic,retain)NSMutableArray * searchArray;
@property(nonatomic,retain)NSMutableArray * searchUserArray;

-(void)refresh;
@end
