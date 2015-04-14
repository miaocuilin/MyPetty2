//
//  ChargeViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargeViewController : UIViewController
{
    UIView * navView;
}
//是否是周边
@property(nonatomic)BOOL isZB;
@property(nonatomic,copy)NSString * zbUrl;
@end
