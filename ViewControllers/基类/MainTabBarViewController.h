//
//  MainTabBarViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarViewController : UITabBarController <UIScrollViewDelegate>
{
//    UITabBarController * tbc;
//    UISegmentedControl * sc;
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    
    UIScrollView * sv;
    
    BOOL isLoaded;
    UIView * bottomBg;
    
}
@property(nonatomic,assign)UIImage * preImage;

@property(nonatomic,copy)NSString * animalNum;
@property(nonatomic,copy)NSString * foodNum;

-(void)modifyUI;
@end
