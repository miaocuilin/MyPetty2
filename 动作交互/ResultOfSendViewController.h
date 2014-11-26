//
//  ResultOfSendViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultOfSendViewController : UIViewController
{
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    
    //剩余摇动次数，用于回传
    int count;
}
@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)UIImageView * headImageView;
@property(nonatomic,retain)UILabel * titleLabel;
@property(nonatomic,retain)UIButton * closeBtn;
@property(nonatomic,retain)UILabel * rqLabel;
@property(nonatomic,retain)UIButton * confirmBtn;
@property(nonatomic,retain)UIImageView * headImage;
@property(nonatomic,retain)UILabel * actLabel;

@property(nonatomic,copy)NSString * pet_aid;

@property(nonatomic,copy)NSString * giftName;
@property(nonatomic,copy)void (^closeBlock)(void);
@property(nonatomic,copy)void (^share)(int);
-(void)configUIWithName:(NSString *)name ItemId:(NSString *)itemId Tx:(NSString *)tx;
@end
