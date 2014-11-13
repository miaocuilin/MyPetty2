//
//  WalkAndTeaseViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkAndTeaseViewController : UIViewController
{
    UIView * navView;
}
@property(nonatomic,retain)NSString * URL;
@property (nonatomic,strong)NSString *titleString;

@property(nonatomic,copy)NSString * aid;
@end
