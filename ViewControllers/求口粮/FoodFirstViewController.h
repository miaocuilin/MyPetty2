//
//  FoodFirstViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodFirstViewController : UIViewController
{
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
}
@property(nonatomic,retain)UIImage * preImage;

-(void)modifyUI;
@end
