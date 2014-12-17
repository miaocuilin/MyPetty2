//
//  FirstTabBarViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTabBarViewController : UITabBarController<UIScrollViewDelegate>
{
    //    UITabBarController * tbc;
    //    UISegmentedControl * sc;
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    
    UIScrollView * sv;
    
    BOOL isLoaded;
    UIView * bottomBg;
    
    UIImageView * msgNumBg;
    UILabel * msgNum;
    
    UIImageView * guide;
}
@property(nonatomic,assign)UIImage * preImage;

@property(nonatomic,copy)NSString * animalNum;
@property(nonatomic,copy)NSString * foodNum;

@property(nonatomic,retain)NSMutableArray * talkIDArray;
@property(nonatomic,retain)NSMutableArray * nwDataArray;
@property(nonatomic,retain)NSMutableArray * nwMsgDataArray;
@property(nonatomic)BOOL hasNewMsg;
@property(nonatomic,retain)NSMutableArray * keysArray;
@property(nonatomic,retain)NSMutableArray * valuesArray;

-(void)modifyUI;
-(void)refreshMessageNum;
@end
