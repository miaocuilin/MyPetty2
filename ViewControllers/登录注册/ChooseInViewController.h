//
//  ChooseInViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseInViewController : UIViewController
{
    int num;
    NSString * tempString;
    UILabel * ambassadorMessage;
    NSTimer * Timer;
}
@property(nonatomic)BOOL isMi;
//@property(nonatomic,copy)NSString * ambString;
@end
