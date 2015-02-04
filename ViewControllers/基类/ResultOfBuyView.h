//
//  ResultOfBuyView.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultOfBuyView : UIView
{
    //是否真的是点击了X
    BOOL isNotTrue;
    
    UIView * rollView;
    UIImageView * rollImageView;
    UIImageView * badLineImageView;
    NSTimer * timer;
    UIImageView * giftNameBg;
    UIImageView * txBg;
}
//@property(nonatomic,retain)UIView * alphaBgView;
@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)UILabel * titleLabel;
@property(nonatomic,retain)UIButton * closeBtn;
@property(nonatomic,retain)UILabel * giftNameLabel;
@property(nonatomic,retain)UIImageView * giftImage;
@property(nonatomic,retain)UILabel * rqLabel;
@property(nonatomic,retain)UIButton * pickMore;
@property(nonatomic,retain)UIButton * confirmBtn;
@property(nonatomic,retain)UIImageView * headImage;
@property(nonatomic,retain)UILabel * actLabel;

@property(nonatomic)BOOL isFromShake;
@property(nonatomic)int leftShakeTimes;

@property(nonatomic,copy)void (^confirm)(void);
@property(nonatomic,copy)void (^shakeMore)(void);
@property(nonatomic,copy)void (^sendThis)(void);
@property(nonatomic,copy)void (^closeBlock)(void);
-(void)configUIWithName:(NSString *)name ItemId:(NSString *)itemId Tx:(NSString *)tx;
@end
