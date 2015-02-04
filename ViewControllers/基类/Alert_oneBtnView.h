//
//  Alert_oneBtnView.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert_oneBtnView : UIView
//1.口粮不够  2.加入圈子提示 3.第三方为绑定 4.卖萌号
@property(nonatomic)BOOL type;
@property(nonatomic)BOOL sina;
//提示用户需要花费金币
@property(nonatomic)int petsNum;
@property(nonatomic,copy)void (^jump)();
//跳转淘宝
@property(nonatomic,copy)void (^jumpTB)();
-(void)makeUI;
@end
