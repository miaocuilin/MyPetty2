//
//  AlertView.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView
{
    
}
@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)UIButton * closeBtn;
@property(nonatomic,retain)UIButton * confirmBtn;
@property(nonatomic,retain)UIButton * confirmBtn2;

@property(nonatomic,retain)UIView * alphaView;
@property(nonatomic,copy)void (^jump)(void);

//1.注册 2.加入 3.加够10个了提示 4.取消关注 5.退出国家 6.邀请码时输入够了10个圈子
@property(nonatomic)int AlertType;
@property(nonatomic)int CountryNum;

-(void)makeUI;
@end
