//
//  PopupView.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

@property(nonatomic,retain)UIView * bgView;
@property(nonatomic,retain)UIView * alphaView;

@property(nonatomic,retain)UILabel * desLabel;
-(void)modifyUIWithSize:(CGSize)viewSize msg:(NSString *)msg;
@end
