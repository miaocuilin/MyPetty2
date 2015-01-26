//
//  PetMainViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
#import "PetInfoModel.h"
#import "ASIFormDataRequest.h"
@interface PetMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    ASIFormDataRequest * _request;
    UITableView * tv;
    UIView * headerView;
    UIImageView * headBlurImage;
    UIImageView * headCircle;
    UIButton * pBtn;
    ClickImage * headImageView;
    UIButton * headBtn;
    UIButton * userHeadBtn;
    //
    UILabel * nameLabel;
    UIImageView * sex;
    UILabel * cateAndAgeLabel;
    
    UIActionSheet * sheet;
    BOOL isMyPet;
    
    UIButton * menuBgBtn;
    UIView * moreView;
    BOOL isMoreCreated;
    
    UIView * whiteBg;
    UILabel * msgLabel;
    UITextField * tf;
    UIImageView * editImage;
    
    BOOL isLoad;
    UIImageView * guide;
    
}
@property(nonatomic,copy)NSString * aid;

@property(nonatomic,copy)NSString * tempTFString;
@property(nonatomic,retain)PetInfoModel * model;
@property(nonatomic,retain)NSMutableArray * petsDataArray;

@property(nonatomic,copy)NSString * rq;

@property(nonatomic,copy)void (^updatePBtn)();
@property(nonatomic)BOOL isFromPetRecom;
@end
