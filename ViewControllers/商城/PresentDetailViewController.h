//
//  PresentDetailViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-8-24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAStepperControl;
@interface PresentDetailViewController : UIViewController<UIScrollViewDelegate>
{
    UIView * navView;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    BOOL isFromStart;
    NSMutableArray *imagesArray;
    UIScrollView *bgScrollView;
    SAStepperControl *sasStepper;
    
    NSString *presentTitle;
    NSString *presentPrice;
    NSString *presentPopular;
    NSString *presentLimits;
    NSString *presentWeight;
    NSString *presentLife;
    NSString *presentPost;

    MBProgressHUD *HUD;
}
@property (nonatomic,strong)UIImageView *bgImageView;
@end
