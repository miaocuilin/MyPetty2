//
//  NoCloseAlert.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoCloseAlert : UIView

@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)UILabel * titleLabel;
@property(nonatomic,retain)UIImageView * headImage;
@property(nonatomic,retain)UILabel * acceptLabel1;
@property(nonatomic,retain)UILabel * acceptLabel2;
@property(nonatomic,retain)UILabel * percentLabel1;
@property(nonatomic,retain)UILabel * percentLabel2;
@property(nonatomic,retain)UIButton * confirmBtn;

@property(nonatomic,copy)void (^confirm)(void);

-(void)configUIWithTx:(NSString *)tx Name:(NSString *)name Percent:(NSString *)percent;
@end
