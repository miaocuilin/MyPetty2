//
//  Alert_2ButtonView2.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert_2ButtonView2 : UIView
{
    UIImageView * selectImage;
}
@property(nonatomic,copy)NSString * rewardNum;
@property(nonatomic,copy)NSString * foodCost;
@property(nonatomic,copy)NSString * productName;
//1.打赏，有勾选的  2.提示去充值 3.提示是否确认兑换 4.退出圈子
@property(nonatomic)int type;

@property(nonatomic,copy)void (^reward)();
@property(nonatomic,copy)void (^jumpCharge)();
@property(nonatomic,copy)void (^exchange)();
@property(nonatomic,copy)void (^quit)();
-(void)makeUI;
@end
