//
//  QuickGiftViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+JDSideMenu.h"

@interface QuickGiftViewController : UIViewController
{
    UIPageControl *giftPageControl;
    
    
    
    UICollectionView *bodyView;
}
@property (nonatomic)int shopGiftCount;
@property (nonatomic,strong)NSArray *keyArray;
@property (nonatomic,strong)NSArray *valueArray;
@end
