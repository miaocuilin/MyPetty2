//
//  MyStarCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyperlinksButton.h"
@interface MyStarCell : UITableViewCell <UITextFieldDelegate>
{
    UIView * bgView;
    UIView * bgAlphaView;
    UIView * headView;
    //
    UILabel * positionLabel;
    UILabel * contributionLabel;
    UIButton * headBtn;
    UILabel * nameLabel;
    UITextField * tf;
    HyperlinksButton * hyperBtn;
    UILabel * rqLabel;
    UILabel * percentLabel;
    
//    UILabel * label1;
//    UILabel * label2;
//    UILabel * label3;
//    UILabel * label4;
//    UIButton * btn1;
//    UIButton * btn2;
//    UIButton * btn3;
//    UIButton * btn4;
}
@property(nonatomic,copy)void (^actClick)(int);
//-(void)makeUIWithWidth:(float)width Height:(float)height;
-(void)adjustCellHeight:(int)a;

-(void)configUI;
@end
