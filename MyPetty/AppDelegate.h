//
//  AppDelegate.h
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController * tbc;
    UISegmentedControl * sc;
    Reachability * hostReach;
    //不再提示流量问题
//    BOOL notAlert;
}
@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic,retain) Reachability * hostReachability;
@end
