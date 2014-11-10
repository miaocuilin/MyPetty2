//
//  MyStarViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BottomMenuRootViewController.h"

@interface MyStarViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * bgImageView;
//    UITableView * tv;
    
    BOOL isLoaded;
}
@property(nonatomic,retain)UITableView * tv;

@property(nonatomic,copy)void (^actClickSend)(NSString *,NSString *,NSString *);
@property(nonatomic,copy)void (^actClick)(int, int);
//@property(nonatomic,copy)void (^unShakeNum)(int);
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * userPetListArray;
@property(nonatomic,copy)NSString * pet_aid;
@property(nonatomic,copy)NSString * pet_name;
@property(nonatomic,copy)NSString * pet_tx;
//-(void)refreshShakeNum:(int)shakeNum Index:(int)index;
@end
