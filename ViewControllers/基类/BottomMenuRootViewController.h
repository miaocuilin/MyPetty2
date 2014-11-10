//
//  BottomMenuRootViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMenuRootViewController : UIViewController
{
    BOOL isOpen;
    UIImageView * headCircle;
    
    //我的萌星正在活动的顺序
//    int actIndex;
}
@property(nonatomic,retain)UIButton *menuBgBtn;
@property(nonatomic,retain)UIView *menuBgView;
@property(nonatomic,retain)UIButton *btn1;
@property(nonatomic,retain)UIButton *btn2;
@property(nonatomic,retain)UIButton *btn3;
@property(nonatomic,retain)UIButton *btn4;
@property(nonatomic,retain)UIButton *headButton;
@property(nonatomic,retain)UILabel *label1;
@property(nonatomic,retain)UILabel *label2;
@property(nonatomic,retain)UILabel *label3;
@property(nonatomic,retain)UILabel *label4;
@property(nonatomic,retain)NSDictionary *animalInfoDict;
@property(nonatomic,retain)NSDictionary *shakeInfoDict;
@property(nonatomic,copy)NSString *masterID;

@property(nonatomic,copy)NSString * currentName;
//动作对象的aid和name
@property(nonatomic,copy)NSString * pet_aid;
@property(nonatomic,copy)NSString * pet_name;
@property(nonatomic,copy)NSString * pet_tx;

//@property(nonatomic)void (^unShakeNum)(int, int);
//-(void)unShakeNum:(int)num index:(int)index;
-(void)isRegister;
-(void)hideAll;
- (void)loadAnimalInfoData;

-(void)btn1Click;
-(void)btn2Click;
-(void)btn3Click;
-(void)btn4Click;

//-(void)changeActIndex:(int)a;
@end
