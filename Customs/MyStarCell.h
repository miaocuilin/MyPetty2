//
//  MyStarCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyperlinksButton.h"
#import "MyStarModel.h"
#import "ASIFormDataRequest.h"
@interface MyStarCell : UITableViewCell <UITextFieldDelegate>
{
    ASIFormDataRequest * _request;
    UIView * bgView;
    UIView * bgAlphaView;
    UIView * headView;
    //
    UIImageView * position;
    UILabel * positionLabel;
//    UILabel * contributionLabel;
    UIButton * headBtn;
    UILabel * nameLabel;
    UITextField * tf;
    HyperlinksButton * hyperBtn;
    UIButton * modifyBtn;
//    UILabel * rqLabel;
//    UILabel * percentLabel;
    
    UIView * dataBgView;
    UILabel * lab1;
    UILabel * lab4;
    UILabel * lab2;
    UILabel * lab5;
    UILabel * lab3;
    
    UIButton * inviteBtn;
}
@property(nonatomic,retain)UILabel * contributionLabel;

@property(nonatomic,copy)NSString * tempTfString;

@property(nonatomic,retain)MyStarModel * model;
@property(nonatomic,copy)NSString * aid;
@property(nonatomic,retain)NSArray * imageArray;
@property(nonatomic,copy)void (^headClick)(NSString *);
@property(nonatomic,copy)void (^imageClick)(NSString *);
@property(nonatomic,copy)void (^actClick)(int);
@property(nonatomic,copy)void (^actClickSend)(NSString *,NSString *,NSString *);
//-(void)makeUIWithWidth:(float)width Height:(float)height;
@property(nonatomic,copy)void (^inviteClick)(void);
-(void)adjustCellHeight:(int)a;

-(void)configUI:(MyStarModel *)model;
@end
