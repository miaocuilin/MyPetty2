//
//  PetMain_Gift_ViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetMain_Gift_ViewController : UIViewController
{
    UIView * navView;
    UIScrollView * sv;
}
@property(nonatomic,retain)PetInfoModel * model;
@property(nonatomic,retain)NSMutableArray * goodsArray;
@property(nonatomic,retain)NSMutableArray * goodsNumArray;
@end
