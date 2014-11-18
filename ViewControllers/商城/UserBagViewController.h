//
//  UserBagViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBagViewController : UIViewController
{
    UIView * navView;
    UIScrollView * sv;
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,retain)NSMutableArray * goodsArray;
@property(nonatomic,retain)NSMutableArray * goodsNumArray;
@end
