//
//  ModifyPetOrUserInfoViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-10-13.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetInfoModel.h"
@interface ModifyPetOrUserInfoViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView * bgBlurImageView;
    UIView * navView;
    UIScrollView * sv;
    //
    UIView * bgView;
    UIView * bgView2;
    UIView * bgView3;
    UIButton * photoButton;
    UIButton * photoButton2;
    UIButton * girl;
    UIButton * boy;
    UIView * pickerBgView;
    UIPickerView * picker;
    UIView * pickerBgView2;
    UIPickerView * picker2;
    UIView * pickerBgView3;
    UIPickerView * picker3;
    
    UILabel * fromLabel;
    UIButton * fromButton;
    UIButton * finishButton;
    UIButton * finishButton2;
    
    UITextField * tf;
    UITextField * tfUserName;
    UITextField * tfCity;
    UITextField * fromTF;
    UITextField * ageTextField;
    
    //
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
    
    int count;
    int age;
    int year;
    int month;
    
    int gender;
    int type;
    //记录每一次滑到的个数
    int num;
    
    BOOL isCamara;
    BOOL isMan;
    UIButton * woman;
    UIButton * man;
    BOOL isUserPhoto;
    
    int typeTag;
}
//是否是修改用户资料
@property (nonatomic)BOOL isModifyUser;

@property (nonatomic,retain)NSArray * cateArray;
@property (nonatomic,retain)NSMutableArray * catArray;
@property (nonatomic,retain)NSMutableArray * dogArray;
@property (nonatomic,retain)NSMutableArray * otherArray;
@property (nonatomic,retain)NSArray * tempArray;

@property (nonatomic,retain)UIImage * oriImage;
@property (nonatomic,retain)UIImage * oriUserImage;

@property (nonatomic,copy)NSString * cateName;
@property (nonatomic,copy)NSString * detailName;

@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * u_name;
@property (nonatomic)int u_gender;
@property (nonatomic)int u_city;

@property (nonatomic,retain)PetInfoModel * petInfoModel;

@property (nonatomic,copy)void (^refreshPetInfo)(void);
@property (nonatomic,copy)void (^refreshUserInfo)(void);
@end
