//
//  SendGiftViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGiftViewController : UIViewController <UIScrollViewDelegate>
{
    UIPageControl *giftPageControl;
    UIScrollView * sv;
//    int flag;
    UIView *totalView;
}

@property(nonatomic,retain)NSMutableArray * bagItemIdArray;
@property(nonatomic,retain)NSMutableArray * bagItemNumArray;

@property(nonatomic,retain)NSMutableArray * giftArray;
@property(nonatomic,retain)NSMutableArray * tempGiftArray;
@end
