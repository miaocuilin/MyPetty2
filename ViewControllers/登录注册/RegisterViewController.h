//
//  RegisterViewController.h
//  MyPetty
//
//  Created by Aidi on 14-6-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
@interface RegisterViewController : UIViewController
{
    UIScrollView * sv;
    
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
    
    UILabel * fromLabel;
    UIButton * fromButton;
    UIButton * finishButton;
    
    UITextField * tf;
    UITextField * tfUserName;
    UITextField * tfCity;
    UITextField * fromTF;
    UITextField * ageTextField;
    
    int count;
    
    int age;
    int gender;
    int type;
    
//    UIImage * oriImage;

    //记录每一次滑到的个数
    int num;
    
    BOOL isCamara;
    
    BOOL isMan;
    UIButton * woman;
    UIButton * man;
    BOOL isUserPhoto;
    //new
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    
//    UIButton * pageBtn;
    UIView * navView;
    
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property (nonatomic,retain)NSArray * cateArray;
@property (nonatomic,retain)NSMutableArray * catArray;
@property (nonatomic,retain)NSMutableArray * dogArray;
@property (nonatomic,retain)NSMutableArray * otherArray;
@property (nonatomic,retain)NSArray * tempArray;

@property (nonatomic,copy)NSString * cateName;
@property (nonatomic,copy)NSString * detailName;

@property (nonatomic,copy)NSString * name;

@property (nonatomic,copy)NSString * FileName;
@property (nonatomic,retain)UIImage * oriImage;

@property (nonatomic,copy)NSString * u_name;
@property (nonatomic)int u_gender;
@property (nonatomic)int u_city;
@end

