//
//  MainViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIScrollViewDelegate>
{
    UIView * navView;
    UIScrollView * sv;
    BOOL isCreated[3];
    UISegmentedControl * sc;
}
@property(nonatomic,retain)UIButton * menuBtn;
@end
