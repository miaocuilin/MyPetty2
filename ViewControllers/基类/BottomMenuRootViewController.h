//
//  BottomMenuRootViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMenuRootViewController : UIViewController
{
    BOOL isOpen;
    UIImageView * headCircle;
}
@property(nonatomic,retain)UIButton *menuBgBtn;
@property(nonatomic,retain)UIView *menuBgView;
@property(nonatomic,retain)UIButton *btn1;
@property(nonatomic,retain)UIButton *btn2;
@property(nonatomic,retain)UIButton *btn3;
@property(nonatomic,retain)UIButton *btn4;
@property(nonatomic,retain)UIButton *headButton;
@property(nonatomic,retain)UILabel *label1;
@property(nonatomic,retain)UILabel *label2;
@property(nonatomic,retain)UILabel *label3;
@property(nonatomic,retain)UILabel *label4;
@end
