//
//  Alert_HyperlinkView.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert_HyperlinkView : UIView

//1.没有设置密码，是否切换  2.兑换成功
@property(nonatomic)int type;
@property(nonatomic,copy)void (^jumpSetPwd)();
@property(nonatomic,copy)void (^jumpLogin)();
@property(nonatomic,copy)void (^jumpAddress)();
-(void)makeUI;
@end
